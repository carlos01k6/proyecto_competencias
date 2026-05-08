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
    """Historial completo agrupado por competencia, ordenado por fecha DESC."""
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Obtener snapshots
        snap_res = supabase.table('progreso_snapshots').select('id, competency_id, porcentaje_logro, fecha_snapshot, created_at').eq('student_id', estudiante_id).order('fecha_snapshot', desc=True).execute()
        snapshots_raw = snap_res.data or []

        if not snapshots_raw:
            return jsonify([]), 200

        # Obtener nombres de competencias
        comp_ids = list(set(s['competency_id'] for s in snapshots_raw))
        comp_res = supabase.table('competencies').select('id, name').in_('id', comp_ids).execute()
        comp_map = {c['id']: c['name'] for c in (comp_res.data or [])}

        # Agrupar por competencia
        comp_snapshots = defaultdict(list)
        for s in snapshots_raw:
            comp_snapshots[s['competency_id']].append(s)

        historial = []
        for comp_id, snaps in comp_snapshots.items():
            snaps.sort(key=lambda x: x['fecha_snapshot'] or x['created_at'], reverse=False)  # orden asc para calcular cambios
            comp_name = comp_map.get(comp_id, '')
            for i, s in enumerate(snaps):
                antes = snaps[i-1]['porcentaje_logro'] if i > 0 else None
                despues = s['porcentaje_logro']
                cambio = round(despues - antes, 1) if antes is not None else None
                historial.append({
                    'fecha': s['fecha_snapshot'] or s['created_at'],
                    'competencia_id': comp_id,
                    'competencia_nombre': comp_name,
                    'porcentaje_antes': antes,
                    'porcentaje_despues': despues,
                    'cambio': cambio,
                    'evaluaciones_realizadas': i + 1,  # aproximado
                    'es_reevaluacion': False  # no tenemos esta info en snapshots
                })

        historial.sort(key=lambda x: x['fecha'] or '', reverse=True)
        return jsonify(historial), 200

    except Exception as e:
        import traceback; traceback.print_exc()
        return jsonify({'error': str(e)}), 500


@historial_bp.route('/<estudiante_id>/<competencia_id>', methods=['GET'])
def obtener_historial_competencia(estudiante_id, competencia_id):
    """Timeline de una competencia específica para un estudiante."""
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        comp_r = supabase.table('competencies').select('name').eq('id', competencia_id).execute()
        comp_nombre = comp_r.data[0].get('name', '') if comp_r.data else ''

        snap_res = supabase.table('progreso_snapshots').select('id, porcentaje_logro, fecha_snapshot, created_at').eq('student_id', estudiante_id).eq('competency_id', competencia_id).order('fecha_snapshot', desc=False).execute()
        snaps = snap_res.data or []

        timeline = []
        for i, s in enumerate(snaps):
            antes = snaps[i-1]['porcentaje_logro'] if i > 0 else None
            cambio = round(s['porcentaje_logro'] - antes, 1) if antes is not None else None
            timeline.append({
                'fecha': s['fecha_snapshot'] or s['created_at'],
                'porcentaje_antes': antes,
                'porcentaje_despues': s['porcentaje_logro'],
                'cambio': cambio,
                'evaluacion_num': i + 1,
                'es_reevaluacion': False
            })

        if not snaps:
            return jsonify({'timeline': [], 'estadisticas': {'competencia_nombre': comp_nombre, 'intentos': 0}}), 200

        porcentajes = [s['porcentaje_logro'] for s in snaps]
        return jsonify({
            'timeline': timeline,
            'estadisticas': {
                'competencia_nombre': comp_nombre,
                'intentos': len(snaps),
                'mejora_total': round(porcentajes[-1] - porcentajes[0], 1) if len(porcentajes) >= 2 else 0,
                'fecha_primera': snaps[0]['fecha_snapshot'] or snaps[0]['created_at'],
                'fecha_ultima': snaps[-1]['fecha_snapshot'] or snaps[-1]['created_at'],
            },
        }), 200

    except Exception as e:
        import traceback; traceback.print_exc()
        return jsonify({'error': str(e)}), 500


@historial_bp.route('/crear-snapshot/<estudiante_id>/<competencia_id>', methods=['POST'])
def crear_snapshot(estudiante_id, competencia_id):
    """Crea un snapshot del progreso actual del estudiante en una competencia."""
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Calcular porcentaje actual
        outcomes_r = supabase.table('learning_outcomes').select('id').eq('competency_id', competencia_id).execute()
        outcome_ids = [o['id'] for o in (outcomes_r.data or [])]
        if not outcome_ids:
            return jsonify({'error': 'Competencia sin resultados de aprendizaje'}), 400

        crit_r = supabase.table('criteria').select('id').in_('learning_outcome_id', outcome_ids).execute()
        crit_ids = [c['id'] for c in (crit_r.data or [])]
        if not crit_ids:
            return jsonify({'error': 'Sin criterios asociados'}), 400

        ev_res = supabase.table('evaluations').select('grade').eq('student_id', estudiante_id).in_('criteria_id', crit_ids).execute()
        grades = [e['grade'] for e in (ev_res.data or []) if e.get('grade') is not None]
        if not grades:
            return jsonify({'error': 'Sin evaluaciones para calcular porcentaje'}), 400

        porcentaje_actual = round(sum(grades) / len(grades), 1)

        # Insertar snapshot
        snapshot = {
            'id': str(uuid.uuid4()),
            'student_id': estudiante_id,
            'competency_id': competencia_id,
            'porcentaje_logro': porcentaje_actual,
            'fecha_snapshot': request.get_json().get('fecha') or None,
            'created_at': None  # Supabase lo pone
        }
        supabase.table('progreso_snapshots').insert(snapshot).execute()

        return jsonify(snapshot), 201

    except Exception as e:
        import traceback; traceback.print_exc()
        return jsonify({'error': str(e)}), 500
