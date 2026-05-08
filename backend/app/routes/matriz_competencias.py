from flask import Blueprint, request, jsonify
from ..supabase_client import get_supabase
import jwt
from collections import defaultdict

matriz_bp = Blueprint('matriz', __name__, url_prefix='/api/matriz')
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


def get_nivel(p):
    if p < 40: return 'incipiente'
    if p < 60: return 'basico'
    if p < 75: return 'satisfactorio'
    return 'avanzado'


def build_matriz(student_ids):
    """Returns (matriz_dict, comp_map) where matriz_dict[student_id][comp_id] = {porcentaje, nivel, evaluaciones}."""
    if not student_ids:
        return {}, {}

    ev_res = supabase.table('evaluations').select('student_id, criteria_id, grade').in_('student_id', student_ids).execute()
    evaluaciones = ev_res.data or []
    if not evaluaciones:
        return {}, {}

    crit_ids = list({e['criteria_id'] for e in evaluaciones if e.get('criteria_id')})
    crit_map = {}
    if crit_ids:
        cr = supabase.table('criteria').select('id, learning_outcome_id').in_('id', crit_ids).execute()
        for c in (cr.data or []):
            crit_map[c['id']] = c

    out_ids = list({c.get('learning_outcome_id') for c in crit_map.values() if c.get('learning_outcome_id')})
    out_map = {}
    if out_ids:
        or_r = supabase.table('learning_outcomes').select('id, competency_id').in_('id', out_ids).execute()
        for o in (or_r.data or []):
            out_map[o['id']] = o

    comp_ids = list({out_map.get(c.get('learning_outcome_id'), {}).get('competency_id')
                     for c in crit_map.values()
                     if c.get('learning_outcome_id') and out_map.get(c.get('learning_outcome_id'))})
    comp_ids = [x for x in comp_ids if x]
    comp_map = {}
    if comp_ids:
        comp_r = supabase.table('competencies').select('id, name').in_('id', comp_ids).execute()
        for c in (comp_r.data or []):
            comp_map[c['id']] = c

    # Aggregate grades
    agrupado = defaultdict(lambda: defaultdict(list))
    for ev in evaluaciones:
        crit = crit_map.get(ev.get('criteria_id'), {})
        out = out_map.get(crit.get('learning_outcome_id'), {})
        comp_id = out.get('competency_id')
        if comp_id:
            agrupado[ev['student_id']][comp_id].append(ev.get('grade', 0))

    matriz = {}
    for sid, comps in agrupado.items():
        matriz[sid] = {}
        for cid, grades in comps.items():
            p = round(sum(grades) / len(grades), 1) if grades else 0
            matriz[sid][cid] = {'porcentaje': p, 'nivel': get_nivel(p), 'evaluaciones': len(grades)}

    return matriz, comp_map


def _sort_students(student_ids):
    if not student_ids:
        return []
    st_r = supabase.table('users').select('id, name, email').in_('id', student_ids).execute()
    lst = [{'id': s['id'], 'nombre': s.get('name') or s.get('email') or s['id']} for s in (st_r.data or [])]
    return sorted(lst, key=lambda x: x['nombre'])


def _build_response(student_ids, matriz, comp_map, extra=None):
    student_list = _sort_students(student_ids)
    comp_list = sorted([{'id': cid, 'nombre': c.get('name', '')} for cid, c in comp_map.items()], key=lambda x: x['nombre'])
    filas = []
    for est in student_list:
        fila = []
        for comp in comp_list:
            celda = matriz.get(est['id'], {}).get(comp['id'])
            fila.append(celda or {'porcentaje': None, 'nivel': None, 'evaluaciones': 0})
        filas.append(fila)
    resp = {'estudiantes': student_list, 'competencias': comp_list, 'matriz': filas}
    if extra:
        resp.update(extra)
    return resp


@matriz_bp.route('/<docente_id>', methods=['GET'])
def matriz_docente(docente_id):
    try:
        if not get_user_id_from_token():
            return jsonify({'error': 'No autorizado'}), 401

        cursos_r = supabase.table('cursos').select('id').eq('docente_id', docente_id).execute()
        curso_ids = [c['id'] for c in (cursos_r.data or [])]
        student_ids = []
        if curso_ids:
            ec = supabase.table('estudiante_curso').select('estudiante_id').in_('curso_id', curso_ids).execute()
            student_ids = list({r['estudiante_id'] for r in (ec.data or []) if r.get('estudiante_id')})
        if not student_ids:
            ev_r = supabase.table('evaluations').select('student_id').eq('teacher_id', docente_id).execute()
            student_ids = list({r['student_id'] for r in (ev_r.data or []) if r.get('student_id')})
        if not student_ids:
            return jsonify({'estudiantes': [], 'competencias': [], 'matriz': []}), 200

        matriz, comp_map = build_matriz(student_ids)
        return jsonify(_build_response(student_ids, matriz, comp_map)), 200

    except Exception as e:
        import traceback; traceback.print_exc()
        return jsonify({'error': str(e)}), 500


@matriz_bp.route('/grado/<grado_id>', methods=['GET'])
def matriz_grado(grado_id):
    try:
        if not get_user_id_from_token():
            return jsonify({'error': 'No autorizado'}), 401

        # Asumir que grado_id es el id de un curso o nivel
        # Para simplificar, usar como curso_id
        ec = supabase.table('estudiante_curso').select('estudiante_id').eq('curso_id', grado_id).execute()
        student_ids = [r['estudiante_id'] for r in (ec.data or []) if r.get('estudiante_id')]
        if not student_ids:
            return jsonify({'estudiantes': [], 'competencias': [], 'matriz': [], 'grado_id': grado_id}), 200

        curso_r = supabase.table('cursos').select('nombre, codigo').eq('id', grado_id).execute()
        info = curso_r.data[0] if curso_r.data else {}
        matriz, comp_map = build_matriz(student_ids)
        extra = {'grado_id': grado_id, 'grado_nombre': info.get('nombre', ''), 'grado_codigo': info.get('codigo', '')}
        return jsonify(_build_response(student_ids, matriz, comp_map, extra)), 200

    except Exception as e:
        import traceback; traceback.print_exc()
        return jsonify({'error': str(e)}), 500
