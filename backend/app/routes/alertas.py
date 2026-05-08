from flask import Blueprint, request, jsonify
from ..supabase_client import get_supabase
import jwt
import uuid
from datetime import datetime
from collections import defaultdict

alertas_bp = Blueprint('alertas', __name__, url_prefix='/api/alertas')
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


def get_umbral_reevaluacion():
    """Lee el umbral desde configuration. Default 65."""
    try:
        res = supabase.table('configuration').select('value').eq('key', 'umbral_reevaluacion').execute()
        if res.data:
            return float(res.data[0]['value'])
    except Exception:
        pass
    return 65.0


def get_nivel(promedio, umbral=65.0):
    """
    Clasifica el nivel de riesgo usando el umbral de re-evaluación como frontera superior.
    - crítico : < 40
    - alto    : 40 ≤ promedio < 60
    - medio   : 60 ≤ promedio < umbral  (estudiante apto para re-evaluación pero no crítico)
    """
    if promedio < 40:
        return 'critico'
    if promedio < 60:
        return 'alto'
    if promedio < umbral:
        return 'medio'
    return None


def make_alerta_id(docente_id, student_id, competency_id):
    return f"{docente_id[:8]}_{student_id[:8]}_{competency_id[:8]}"


def get_leidas(docente_id):
    try:
        res = supabase.table('alertas_leidas').select('alerta_ref').eq('docente_id', docente_id).execute()
        return {r['alerta_ref'] for r in (res.data or [])}
    except Exception:
        return set()


def build_maps(evaluaciones):
    """Batch-fetch criteria → outcome → competency chain and return maps."""
    criteria_ids = list({e['criteria_id'] for e in evaluaciones if e.get('criteria_id')})
    criteria_map = {}
    outcome_map = {}
    competency_map = {}

    if criteria_ids:
        cr = supabase.table('criteria').select('id, name, learning_outcome_id').in_('id', criteria_ids).execute()
        for c in (cr.data or []):
            criteria_map[c['id']] = c

    outcome_ids = list({c.get('learning_outcome_id') for c in criteria_map.values() if c.get('learning_outcome_id')})
    if outcome_ids:
        or_res = supabase.table('learning_outcomes').select('id, competency_id, title').in_('id', outcome_ids).execute()
        for o in (or_res.data or []):
            outcome_map[o['id']] = o

    competency_ids = list({o.get('competency_id') for o in outcome_map.values() if o.get('competency_id')})
    if competency_ids:
        comp_res = supabase.table('competencies').select('id, name, description').in_('id', competency_ids).execute()
        for c in (comp_res.data or []):
            competency_map[c['id']] = c

    return criteria_map, outcome_map, competency_map


def build_student_map(evaluaciones):
    student_ids = list({e['student_id'] for e in evaluaciones if e.get('student_id')})
    student_map = {}
    if student_ids:
        st_res = supabase.table('users').select('id, name, email').in_('id', student_ids).execute()
        for s in (st_res.data or []):
            student_map[s['id']] = s
    return student_map


def agrupar_por_student_competency(evaluaciones, criteria_map, outcome_map):
    grupos = defaultdict(list)
    meta = {}
    for ev in evaluaciones:
        criteria = criteria_map.get(ev.get('criteria_id'), {})
        outcome = outcome_map.get(criteria.get('learning_outcome_id'), {})
        competency_id = outcome.get('competency_id')
        student_id = ev.get('student_id')
        if not competency_id or not student_id:
            continue
        key = (student_id, competency_id)
        grupos[key].append(ev.get('grade', 0))
        if key not in meta:
            meta[key] = {'student_id': student_id, 'competency_id': competency_id,
                         'evaluaciones': []}
        meta[key]['evaluaciones'].append(ev)
    return grupos, meta


NIVEL_ORDER = {'critico': 0, 'alto': 1, 'medio': 2, 'bajo': 3}


@alertas_bp.route('/<docente_id>', methods=['GET'])
def obtener_alertas(docente_id):
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        mostrar_leidas = request.args.get('mostrar_leidas', 'false').lower() == 'true'

        ev_res = (
            supabase.table('evaluations')
            .select('id, student_id, criteria_id, grade, grading_date, observation')
            .eq('teacher_id', docente_id)
            .execute()
        )
        evaluaciones = ev_res.data or []
        if not evaluaciones:
            return jsonify([]), 200

        criteria_map, outcome_map, competency_map = build_maps(evaluaciones)
        student_map = build_student_map(evaluaciones)
        leidas = get_leidas(docente_id)
        grupos, meta = agrupar_por_student_competency(evaluaciones, criteria_map, outcome_map)
        umbral = get_umbral_reevaluacion()

        alertas_por_competencia = defaultdict(list)
        for (student_id, competency_id), grades in grupos.items():
            promedio = sum(grades) / len(grades) if grades else 0
            nivel = get_nivel(promedio, umbral)
            if nivel is None:
                continue

            alerta_id = make_alerta_id(docente_id, student_id, competency_id)
            leida = alerta_id in leidas
            if not mostrar_leidas and leida:
                continue

            student = student_map.get(student_id, {})
            competencia = competency_map.get(competency_id, {})
            alertas_por_competencia[competency_id].append({
                'id': alerta_id,
                'student_id': student_id,
                'student_name': student.get('name') or student.get('email') or student_id,
                'competency_id': competency_id,
                'competency_name': competencia.get('name', ''),
                'porcentaje_logro': round(promedio, 1),
                'nivel_riesgo': nivel,
                'tipo_alerta': 'bajo_desempeño',
                'leida': leida,
                'total_evaluaciones': len(grades),
            })

        resultado = []
        for competency_id, alertas in alertas_por_competencia.items():
            alertas_sorted = sorted(alertas, key=lambda x: NIVEL_ORDER.get(x['nivel_riesgo'], 3))
            competencia = competency_map.get(competency_id, {})
            resultado.append({
                'competency_id': competency_id,
                'competency_name': competencia.get('name', ''),
                'competency_description': competencia.get('description', ''),
                'total_alertas': len(alertas_sorted),
                'alertas': alertas_sorted,
            })

        resultado.sort(
            key=lambda x: sum(1 for a in x['alertas'] if a['nivel_riesgo'] == 'critico'),
            reverse=True,
        )
        return jsonify(resultado), 200

    except Exception as e:
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500


@alertas_bp.route('/estadisticas/<docente_id>', methods=['GET'])
def obtener_estadisticas(docente_id):
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        ev_res = (
            supabase.table('evaluations')
            .select('student_id, criteria_id, grade')
            .eq('teacher_id', docente_id)
            .execute()
        )
        evaluaciones = ev_res.data or []

        criteria_map, outcome_map, _ = build_maps(evaluaciones)
        grupos, _ = agrupar_por_student_competency(evaluaciones, criteria_map, outcome_map)
        umbral = get_umbral_reevaluacion()

        stats = {'critico': 0, 'alto': 0, 'medio': 0, 'bajo': 0, 'total': 0}
        for grades in grupos.values():
            promedio = sum(grades) / len(grades) if grades else 0
            nivel = get_nivel(promedio, umbral)
            if nivel:
                stats[nivel] += 1
                stats['total'] += 1

        return jsonify(stats), 200

    except Exception as e:
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500


@alertas_bp.route('/<alerta_id>/marcar-leida', methods=['PUT'])
def marcar_leida(alerta_id):
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        data = request.get_json() or {}
        docente_id = data.get('docente_id', user_id)

        try:
            supabase.table('alertas_leidas').upsert({
                'id': str(uuid.uuid4()),
                'alerta_ref': alerta_id,
                'docente_id': docente_id,
                'fecha_lectura': datetime.now().isoformat(),
            }, on_conflict='alerta_ref,docente_id').execute()
        except Exception as warn:
            # Table may not exist yet — silently continue
            print(f"[alertas] WARNING marcar-leida: {warn}")

        return jsonify({'success': True}), 200

    except Exception as e:
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500


@alertas_bp.route('/estudiantes-en-riesgo/<docente_id>', methods=['GET'])
def estudiantes_en_riesgo(docente_id):
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        ev_res = (
            supabase.table('evaluations')
            .select('student_id, criteria_id, grade')
            .eq('teacher_id', docente_id)
            .execute()
        )
        evaluaciones = ev_res.data or []
        if not evaluaciones:
            return jsonify([]), 200

        criteria_map, outcome_map, competency_map = build_maps(evaluaciones)
        student_map = build_student_map(evaluaciones)
        grupos, _ = agrupar_por_student_competency(evaluaciones, criteria_map, outcome_map)
        umbral = get_umbral_reevaluacion()

        en_riesgo = {}
        for (student_id, competency_id), grades in grupos.items():
            promedio = sum(grades) / len(grades) if grades else 0
            nivel = get_nivel(promedio, umbral)
            if nivel is None:
                continue

            if student_id not in en_riesgo:
                student = student_map.get(student_id, {})
                en_riesgo[student_id] = {
                    'student_id': student_id,
                    'student_name': student.get('name') or student.get('email') or student_id,
                    'email': student.get('email', ''),
                    'competencias_debiles': [],
                }

            en_riesgo[student_id]['competencias_debiles'].append({
                'competency_id': competency_id,
                'competency_name': competency_map.get(competency_id, {}).get('name', ''),
                'porcentaje_logro': round(promedio, 1),
                'nivel_riesgo': nivel,
            })

        for est in en_riesgo.values():
            est['competencias_debiles'].sort(key=lambda x: NIVEL_ORDER.get(x['nivel_riesgo'], 3))

        result = sorted(
            list(en_riesgo.values()),
            key=lambda x: NIVEL_ORDER.get(
                x['competencias_debiles'][0]['nivel_riesgo'] if x['competencias_debiles'] else 'bajo', 3
            ),
        )
        return jsonify(result), 200

    except Exception as e:
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500
