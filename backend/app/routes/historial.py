from flask import Blueprint, request, jsonify
from ..supabase_client import get_supabase
import jwt
import uuid
from collections import defaultdict

historial_bp = Blueprint('historial', __name__, url_prefix='/api/historial')
supabase = get_supabase()


def get_user_id_from_token():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    if not token:
        return None
    try:
        payload = jwt.decode(token, options={"verify_signature": False})
        return payload.get('sub')
    except Exception:
        return None


def _build_chain(evaluaciones):
    criteria_ids = list({e['criteria_id'] for e in evaluaciones if e.get('criteria_id')})
    criteria_map, outcome_map, competency_map = {}, {}, {}

    if criteria_ids:
        cr = supabase.table('criteria').select('id, name, learning_outcome_id').in_('id', criteria_ids).execute()
        for c in (cr.data or []):
            criteria_map[c['id']] = c

    outcome_ids = list({c.get('learning_outcome_id') for c in criteria_map.values() if c.get('learning_outcome_id')})
    if outcome_ids:
        or_r = supabase.table('learning_outcomes').select('id, competency_id').in_('id', outcome_ids).execute()
        for o in (or_r.data or []):
            outcome_map[o['id']] = o

    comp_ids = list({o.get('competency_id') for o in outcome_map.values() if o.get('competency_id')})
    if comp_ids:
        comp_r = supabase.table('competencies').select('id, name').in_('id', comp_ids).execute()
        for c in (comp_r.data or []):
            competency_map[c['id']] = c

    return criteria_map, outcome_map, competency_map


@historial_bp.route('/<estudiante_id>', methods=['GET'])
def obtener_historial(estudiante_id):
    """
    Historial completo de un estudiante.
    Primero intenta la tabla progreso_snapshots; si no tiene datos
    calcula el historial directamente desde evaluations.
    """
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        # ── Intento 1: tabla progreso_snapshots ──
        try:
            snap_res = (
                supabase.table('progreso_snapshots')
                .select('id, competency_id, porcentaje_logro, fecha_snapshot, created_at')
                .eq('student_id', estudiante_id)
                .order('fecha_snapshot', desc=True)
                .execute()
            )
            snapshots_raw = snap_res.data or []
        except Exception:
            snapshots_raw = []

        if snapshots_raw:
            comp_ids = list({s['competency_id'] for s in snapshots_raw})
            comp_res = supabase.table('competencies').select('id, name').in_('id', comp_ids).execute()
            comp_map = {c['id']: c['name'] for c in (comp_res.data or [])}

            comp_snaps = defaultdict(list)
            for s in snapshots_raw:
                comp_snaps[s['competency_id']].append(s)

            historial = []
            for comp_id, snaps in comp_snaps.items():
                snaps.sort(key=lambda x: x['fecha_snapshot'] or x['created_at'] or '')
                comp_name = comp_map.get(comp_id, '')
                for i, s in enumerate(snaps):
                    antes = snaps[i - 1]['porcentaje_logro'] if i > 0 else None
                    despues = s['porcentaje_logro']
                    historial.append({
                        'fecha': s['fecha_snapshot'] or s['created_at'],
                        'competencia_id': comp_id,
                        'competencia_nombre': comp_name,
                        'porcentaje_antes': antes,
                        'porcentaje_despues': despues,
                        'cambio': round(despues - antes, 1) if antes is not None else None,
                        'evaluaciones_realizadas': i + 1,
                        'es_reevaluacion': False,
                    })

            historial.sort(key=lambda x: x['fecha'] or '', reverse=True)
            return jsonify(historial), 200

        # ── Intento 2: calcular desde evaluations (siempre funciona) ──
        ev_res = (
            supabase.table('evaluations')
            .select('id, criteria_id, grade, grading_date, created_at, observation')
            .eq('student_id', estudiante_id)
            .order('grading_date', desc=False)
            .execute()
        )
        evaluaciones = ev_res.data or []
        if not evaluaciones:
            return jsonify([]), 200

        criteria_map, outcome_map, competency_map = _build_chain(evaluaciones)

        comp_evals = defaultdict(list)
        for ev in evaluaciones:
            criteria = criteria_map.get(ev.get('criteria_id'), {})
            outcome = outcome_map.get(criteria.get('learning_outcome_id'), {})
            comp_id = outcome.get('competency_id')
            if comp_id:
                comp_evals[comp_id].append(ev)

        snapshots = []
        for comp_id, evals in comp_evals.items():
            comp_name = competency_map.get(comp_id, {}).get('name', '')
            for i, ev in enumerate(evals):
                antes = sum(e.get('grade', 0) for e in evals[:i]) / i if i > 0 else None
                despues = sum(e.get('grade', 0) for e in evals[:i + 1]) / (i + 1)
                snapshots.append({
                    'evaluation_id': ev.get('id'),
                    'fecha': ev.get('grading_date') or ev.get('created_at'),
                    'competencia_id': comp_id,
                    'competencia_nombre': comp_name,
                    'calificacion': ev.get('grade'),
                    'porcentaje_antes': round(antes, 1) if antes is not None else None,
                    'porcentaje_despues': round(despues, 1),
                    'cambio': round(despues - antes, 1) if antes is not None else None,
                    'evaluaciones_realizadas': i + 1,
                    'es_reevaluacion': 'Re-evaluación' in (ev.get('observation') or ''),
                })

        snapshots.sort(key=lambda x: x['fecha'] or '', reverse=True)
        return jsonify(snapshots), 200

    except Exception as e:
        import traceback; traceback.print_exc()
        return jsonify({'error': str(e)}), 500


@historial_bp.route('/<estudiante_id>/<competencia_id>', methods=['GET'])
def obtener_historial_competencia(estudiante_id, competencia_id):
    """Timeline de una competencia específica. Usa snapshots si existen, sino evaluations."""
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        comp_r = supabase.table('competencies').select('name').eq('id', competencia_id).execute()
        comp_nombre = comp_r.data[0].get('name', '') if comp_r.data else ''

        # ── Intento 1: tabla progreso_snapshots ──
        try:
            snap_res = (
                supabase.table('progreso_snapshots')
                .select('porcentaje_logro, fecha_snapshot, created_at')
                .eq('student_id', estudiante_id)
                .eq('competency_id', competencia_id)
                .order('fecha_snapshot', desc=False)
                .execute()
            )
            snaps = snap_res.data or []
        except Exception:
            snaps = []

        if snaps:
            timeline = []
            porcentajes = [s['porcentaje_logro'] for s in snaps]
            for i, s in enumerate(snaps):
                antes = porcentajes[i - 1] if i > 0 else None
                cambio = round(porcentajes[i] - antes, 1) if antes is not None else None
                timeline.append({
                    'fecha': s['fecha_snapshot'] or s['created_at'],
                    'calificacion': s['porcentaje_logro'],
                    'promedio_acumulado': round(sum(porcentajes[:i + 1]) / (i + 1), 1),
                    'cambio': cambio,
                    'evaluacion_num': i + 1,
                    'es_reevaluacion': False,
                })
            return jsonify({
                'timeline': timeline,
                'estadisticas': {
                    'competencia_nombre': comp_nombre,
                    'intentos': len(snaps),
                    'mejora_total': round(porcentajes[-1] - porcentajes[0], 1) if len(porcentajes) >= 2 else 0,
                    'promedio': round(sum(porcentajes) / len(porcentajes), 1),
                    'calificacion_inicial': porcentajes[0],
                    'calificacion_final': porcentajes[-1],
                    'fecha_primera': snaps[0].get('fecha_snapshot') or snaps[0].get('created_at'),
                    'fecha_ultima': snaps[-1].get('fecha_snapshot') or snaps[-1].get('created_at'),
                },
            }), 200

        # ── Intento 2: desde evaluations ──
        outcomes_r = supabase.table('learning_outcomes').select('id').eq('competency_id', competencia_id).execute()
        outcome_ids = [o['id'] for o in (outcomes_r.data or [])]
        if not outcome_ids:
            return jsonify({'timeline': [], 'estadisticas': {'competencia_nombre': comp_nombre, 'intentos': 0}}), 200

        crit_r = supabase.table('criteria').select('id').in_('learning_outcome_id', outcome_ids).execute()
        crit_ids = [c['id'] for c in (crit_r.data or [])]
        if not crit_ids:
            return jsonify({'timeline': [], 'estadisticas': {'competencia_nombre': comp_nombre, 'intentos': 0}}), 200

        ev_res = (
            supabase.table('evaluations')
            .select('id, grade, grading_date, created_at, observation')
            .eq('student_id', estudiante_id)
            .in_('criteria_id', crit_ids)
            .order('grading_date', desc=False)
            .execute()
        )
        evals = ev_res.data or []
        if not evals:
            return jsonify({'timeline': [], 'estadisticas': {'competencia_nombre': comp_nombre, 'intentos': 0}}), 200

        grades = [e.get('grade', 0) for e in evals]
        timeline = []
        running = 0
        for i, ev in enumerate(evals):
            running += ev.get('grade', 0)
            promedio = running / (i + 1)
            anterior = (running - ev.get('grade', 0)) / i if i > 0 else None
            cambio = round(promedio - anterior, 1) if anterior is not None else None
            timeline.append({
                'evaluation_id': ev.get('id'),
                'fecha': ev.get('grading_date') or ev.get('created_at'),
                'calificacion': ev.get('grade'),
                'promedio_acumulado': round(promedio, 1),
                'cambio': cambio,
                'evaluacion_num': i + 1,
                'es_reevaluacion': 'Re-evaluación' in (ev.get('observation') or ''),
            })

        return jsonify({
            'timeline': timeline,
            'estadisticas': {
                'competencia_nombre': comp_nombre,
                'intentos': len(evals),
                'mejora_total': round(grades[-1] - grades[0], 1) if len(grades) >= 2 else 0,
                'promedio': round(sum(grades) / len(grades), 1),
                'calificacion_inicial': grades[0],
                'calificacion_final': grades[-1],
                'fecha_primera': evals[0].get('grading_date'),
                'fecha_ultima': evals[-1].get('grading_date'),
            },
        }), 200

    except Exception as e:
        import traceback; traceback.print_exc()
        return jsonify({'error': str(e)}), 500


@historial_bp.route('/crear-snapshot/<estudiante_id>/<competencia_id>', methods=['POST'])
def crear_snapshot(estudiante_id, competencia_id):
    """Crea un snapshot del progreso actual. Requiere que exista la tabla progreso_snapshots."""
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        outcomes_r = supabase.table('learning_outcomes').select('id').eq('competency_id', competencia_id).execute()
        outcome_ids = [o['id'] for o in (outcomes_r.data or [])]
        if not outcome_ids:
            return jsonify({'error': 'Competencia sin resultados de aprendizaje'}), 400

        crit_r = supabase.table('criteria').select('id').in_('learning_outcome_id', outcome_ids).execute()
        crit_ids = [c['id'] for c in (crit_r.data or [])]

        ev_res = supabase.table('evaluations').select('grade').eq('student_id', estudiante_id).in_('criteria_id', crit_ids).execute()
        grades = [e['grade'] for e in (ev_res.data or []) if e.get('grade') is not None]
        if not grades:
            return jsonify({'error': 'Sin evaluaciones para calcular porcentaje'}), 400

        porcentaje = round(sum(grades) / len(grades), 1)
        data = request.get_json() or {}
        snapshot = {
            'id': str(uuid.uuid4()),
            'student_id': estudiante_id,
            'competency_id': competencia_id,
            'porcentaje_logro': porcentaje,
            'fecha_snapshot': data.get('fecha') or None,
        }
        supabase.table('progreso_snapshots').insert(snapshot).execute()
        return jsonify(snapshot), 201

    except Exception as e:
        import traceback; traceback.print_exc()
        return jsonify({'error': str(e)}), 500
