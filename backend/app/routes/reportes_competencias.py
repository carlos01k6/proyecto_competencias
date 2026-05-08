from flask import Blueprint, request, jsonify
from ..supabase_client import get_supabase
import jwt
from collections import defaultdict

reportes_comp_bp = Blueprint('reportes_competencias', __name__, url_prefix='/api/reportes')
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


def _get_umbral():
    try:
        r = supabase.table('configuration').select('value').eq('key', 'umbral_reevaluacion').execute()
        return float(r.data[0]['value']) if r.data else 65.0
    except Exception:
        return 65.0


def compute_stats(student_ids):
    """Returns {comp_id: {competencia_id, competencia_nombre, promedio, aprobados, en_riesgo, aprobados_pct, riesgo_pct, estudiantes_total}}"""
    if not student_ids:
        return {}

    ev_r = supabase.table('evaluations').select('student_id, criteria_id, grade').in_('student_id', student_ids).execute()
    evaluaciones = ev_r.data or []
    if not evaluaciones:
        return {}

    crit_ids = list({e['criteria_id'] for e in evaluaciones if e.get('criteria_id')})
    crit_map, out_map, comp_map = {}, {}, {}

    if crit_ids:
        cr = supabase.table('criteria').select('id, learning_outcome_id').in_('id', crit_ids).execute()
        for c in (cr.data or []):
            crit_map[c['id']] = c

    out_ids = list({c.get('learning_outcome_id') for c in crit_map.values() if c.get('learning_outcome_id')})
    if out_ids:
        or_r = supabase.table('learning_outcomes').select('id, competency_id').in_('id', out_ids).execute()
        for o in (or_r.data or []):
            out_map[o['id']] = o

    comp_ids = list({out_map.get(c.get('learning_outcome_id'), {}).get('competency_id')
                     for c in crit_map.values() if c.get('learning_outcome_id')})
    comp_ids = [x for x in comp_ids if x]
    if comp_ids:
        comp_r = supabase.table('competencies').select('id, name').in_('id', comp_ids).execute()
        for c in (comp_r.data or []):
            comp_map[c['id']] = c

    # student → competency → grades
    agrupado = defaultdict(lambda: defaultdict(list))
    for ev in evaluaciones:
        crit = crit_map.get(ev.get('criteria_id'), {})
        out = out_map.get(crit.get('learning_outcome_id'), {})
        cid = out.get('competency_id')
        if cid:
            agrupado[ev['student_id']][cid].append(ev.get('grade', 0))

    # Collapse to per-competency student averages
    comp_students = defaultdict(list)
    for sid, comps in agrupado.items():
        for cid, grades in comps.items():
            comp_students[cid].append(sum(grades) / len(grades) if grades else 0)

    umbral = _get_umbral()
    stats = {}
    for cid, promedios in comp_students.items():
        total = len(promedios)
        aprobados = sum(1 for p in promedios if p >= umbral)
        en_riesgo = total - aprobados
        stats[cid] = {
            'competencia_id': cid,
            'competencia_nombre': comp_map.get(cid, {}).get('name', ''),
            'promedio': round(sum(promedios) / total, 1) if total else 0,
            'estudiantes_total': total,
            'aprobados': aprobados,
            'en_riesgo': en_riesgo,
            'aprobados_pct': round(aprobados / total * 100, 1) if total else 0,
            'riesgo_pct': round(en_riesgo / total * 100, 1) if total else 0,
        }
    return stats


@reportes_comp_bp.route('/competencias-por-grado/<grado_id>', methods=['GET'])
def reporte_por_grado(grado_id):
    try:
        if not get_user_id_from_token():
            return jsonify({'error': 'No autorizado'}), 401

        ec = supabase.table('estudiante_curso').select('estudiante_id').eq('curso_id', grado_id).execute()
        sids = [r['estudiante_id'] for r in (ec.data or []) if r.get('estudiante_id')]

        curso_r = supabase.table('cursos').select('nombre, codigo').eq('id', grado_id).execute()
        info = curso_r.data[0] if curso_r.data else {}

        stats = compute_stats(sids)
        return jsonify({
            'grado_id': grado_id,
            'grado_nombre': info.get('nombre', ''),
            'total_estudiantes': len(sids),
            'competencias': sorted(stats.values(), key=lambda x: x['promedio'], reverse=True),
        }), 200

    except Exception as e:
        import traceback; traceback.print_exc()
        return jsonify({'error': str(e)}), 500


@reportes_comp_bp.route('/comparativa-grados', methods=['GET'])
def comparativa_grados():
    try:
        if not get_user_id_from_token():
            return jsonify({'error': 'No autorizado'}), 401

        cursos_r = supabase.table('cursos').select('id, nombre, codigo, estado').execute()
        cursos = cursos_r.data or []

        resultado = []
        for curso in cursos:
            ec = supabase.table('estudiante_curso').select('estudiante_id').eq('curso_id', curso['id']).execute()
            sids = [r['estudiante_id'] for r in (ec.data or []) if r.get('estudiante_id')]
            if not sids:
                continue
            stats = compute_stats(sids)
            if not stats:
                continue
            comps = sorted(stats.values(), key=lambda x: x['promedio'])
            promedio_gral = round(sum(c['promedio'] for c in comps) / len(comps), 1)
            resultado.append({
                'curso_id': curso['id'],
                'curso_nombre': curso.get('nombre', ''),
                'curso_codigo': curso.get('codigo', ''),
                'total_estudiantes': len(sids),
                'promedio_general': promedio_gral,
                'competencia_mejor': comps[-1] if comps else None,
                'competencia_peor': comps[0] if comps else None,
                'competencias': sorted(stats.values(), key=lambda x: x['promedio'], reverse=True),
            })

        resultado.sort(key=lambda x: x['promedio_general'], reverse=True)
        return jsonify(resultado), 200

    except Exception as e:
        import traceback; traceback.print_exc()
        return jsonify({'error': str(e)}), 500


@reportes_comp_bp.route('/competencias-criticas', methods=['GET'])
def competencias_criticas():
    try:
        if not get_user_id_from_token():
            return jsonify({'error': 'No autorizado'}), 401

        cursos_r = supabase.table('cursos').select('id, nombre').execute()
        criticas = []
        for curso in (cursos_r.data or []):
            ec = supabase.table('estudiante_curso').select('estudiante_id').eq('curso_id', curso['id']).execute()
            sids = [r['estudiante_id'] for r in (ec.data or []) if r.get('estudiante_id')]
            if not sids:
                continue
            for stat in compute_stats(sids).values():
                if stat['promedio'] < 60:
                    criticas.append({
                        **stat,
                        'curso_id': curso['id'],
                        'curso_nombre': curso.get('nombre', ''),
                        'accion_sugerida': 'Reforzar currículum urgente' if stat['promedio'] < 40 else 'Revisar metodología',
                    })

        criticas.sort(key=lambda x: x['promedio'])
        return jsonify(criticas), 200

    except Exception as e:
        import traceback; traceback.print_exc()
        return jsonify({'error': str(e)}), 500
