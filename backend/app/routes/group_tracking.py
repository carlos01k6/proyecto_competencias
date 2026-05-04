from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import jwt

group_tracking_bp = Blueprint('group_tracking', __name__, url_prefix='/api/group-tracking')
supabase: Client = get_supabase()

def get_user_id_from_token():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    if not token:
        return None
    try:
        payload = jwt.decode(token, options={"verify_signature": False})
        return payload.get('sub')
    except:
        return None

def obtener_nivel(grade):
    grade = float(grade)
    if grade >= 91:
        return 'Avanzado'
    if grade >= 71:
        return 'Satisfactorio'
    if grade >= 41:
        return 'Básico'
    return 'Incipiente'


def nivel_key(grade):
    nivel = obtener_nivel(grade).lower()
    return nivel.replace('á', 'a')

def obtener_estudiantes_docente(docente_id):
    cursos_response = supabase.table('cursos').select('id').eq('docente_id', docente_id).execute()
    curso_ids = [curso['id'] for curso in (cursos_response.data or [])]

    if not curso_ids:
        return []

    estudiantes_response = (
        supabase.table('estudiante_curso')
        .select('estudiante_id')
        .in_('curso_id', curso_ids)
        .execute()
    )
    return list({item['estudiante_id'] for item in (estudiantes_response.data or []) if item.get('estudiante_id')})

# OBTENER RESUMEN DEL GRUPO DE UN DOCENTE POR COMPETENCIA
@group_tracking_bp.route('/resumen/<docente_id>', methods=['GET'])
def obtener_resumen_docente(docente_id):
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        student_ids = obtener_estudiantes_docente(docente_id)

        competencias_response = supabase.table('competencies').select('id, name').eq('teacher_id', docente_id).execute()
        competencias = competencias_response.data or []
        if not competencias:
            competencias_response = supabase.table('competencies').select('id, name').execute()
            competencias = competencias_response.data or []

        resumen = []

        for competencia in competencias:
            outcomes_response = (
                supabase.table('learning_outcomes')
                .select('id')
                .eq('competency_id', competencia['id'])
                .execute()
            )
            outcome_ids = [outcome['id'] for outcome in (outcomes_response.data or [])]
            if not outcome_ids:
                continue

            criterios_response = (
                supabase.table('criteria')
                .select('id')
                .in_('learning_outcome_id', outcome_ids)
                .execute()
            )
            criterio_ids = [criterio['id'] for criterio in (criterios_response.data or [])]
            if not criterio_ids:
                continue

            query = (
                supabase.table('evaluations')
                .select('student_id, criteria_id, grade, grading_date, created_at')
                .in_('criteria_id', criterio_ids)
            )
            if student_ids:
                query = query.in_('student_id', student_ids)
            else:
                query = query.eq('teacher_id', docente_id)

            evaluations_response = query.execute()
            ultimas_por_estudiante = {}
            for evaluation in (evaluations_response.data or []):
                student_id = evaluation.get('student_id')
                grade = evaluation.get('grade')
                if not student_id or grade is None:
                    continue

                fecha = evaluation.get('grading_date') or evaluation.get('created_at') or ''
                actual = ultimas_por_estudiante.get(student_id)
                if not actual or fecha >= (actual.get('grading_date') or actual.get('created_at') or ''):
                    ultimas_por_estudiante[student_id] = evaluation

            distribucion = {
                'incipiente': 0,
                'basico': 0,
                'satisfactorio': 0,
                'avanzado': 0
            }

            grades = []
            for evaluation in ultimas_por_estudiante.values():
                grade = float(evaluation['grade'])
                grades.append(grade)
                distribucion[nivel_key(grade)] += 1

            if not grades:
                continue

            resumen.append({
                'competencia_id': competencia.get('id'),
                'competencia_nombre': competencia.get('name') or competencia['id'],
                'competencia_name': competencia.get('name') or competencia['id'],
                'distribucion': distribucion,
                'promedio': round(sum(grades) / len(grades), 2),
                'total_evals': len(grades),
                'total_estudiantes': len(grades)
            })

        return jsonify(resumen), 200

    except Exception as e:
        print(f"ERROR OBTENER RESUMEN DOCENTE GRUPO: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

# OBTENER PROGRESO POR GRUPO
@group_tracking_bp.route('/grupo/<group_name>', methods=['GET'])
def obtener_progreso_grupo(group_name):
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Obtener todas las evaluaciones (simulamos grupo por nombre)
        evaluations_response = supabase.table('evaluations').select('student_id, grade').execute()
        evaluations = evaluations_response.data if evaluations_response.data else []

        # Agrupar por estudiante
        student_grades = {}
        for eval in evaluations:
            student_id = eval.get('student_id')
            grade = eval.get('grade')
            
            if student_id and grade:
                if student_id not in student_grades:
                    student_grades[student_id] = []
                student_grades[student_id].append(grade)

        # Calcular estadísticas del grupo
        grupo_data = {
            'group_name': group_name,
            'total_students': len(student_grades),
            'students': [],
            'group_statistics': {}
        }

        all_grades = []
        for student_id, grades in student_grades.items():
            average = sum(grades) / len(grades)
            all_grades.extend(grades)
            
            grupo_data['students'].append({
                'student_id': student_id,
                'average_grade': round(average, 2),
                'evaluation_count': len(grades),
                'status': 'advanced' if average >= 71 else 'developing' if average >= 41 else 'at_risk'
            })

        # Estadísticas generales del grupo
        if all_grades:
            grupo_data['group_statistics'] = {
                'group_average': round(sum(all_grades) / len(all_grades), 2),
                'highest_grade': max(all_grades),
                'lowest_grade': min(all_grades),
                'total_evaluations': len(all_grades)
            }

        return jsonify(grupo_data), 200

    except Exception as e:
        print(f"ERROR OBTENER PROGRESO GRUPO: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

# OBTENER COMPARATIVA POR COMPETENCIA (GRUPO)
@group_tracking_bp.route('/competencia-grupo/<competency_id>', methods=['GET'])
def obtener_competencia_grupo(competency_id):
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Obtener todas las evaluaciones
        evaluations_response = supabase.table('evaluations').select('student_id, grade, criteria_id').execute()
        evaluations = evaluations_response.data if evaluations_response.data else []

        # Agrupar por estudiante para esta competencia
        student_performance = {}
        for eval in evaluations:
            student_id = eval.get('student_id')
            grade = eval.get('grade')
            
            if student_id and grade:
                if student_id not in student_performance:
                    student_performance[student_id] = []
                student_performance[student_id].append(grade)

        # Calcular promedios
        competency_data = {
            'competency_id': competency_id,
            'students': [],
            'distribution': {
                'advanced': 0,
                'developing': 0,
                'at_risk': 0
            }
        }

        for student_id, grades in student_performance.items():
            average = sum(grades) / len(grades)
            status = 'advanced' if average >= 71 else 'developing' if average >= 41 else 'at_risk'
            
            competency_data['students'].append({
                'student_id': student_id,
                'average': round(average, 2),
                'status': status
            })
            
            competency_data['distribution'][status] += 1

        return jsonify(competency_data), 200

    except Exception as e:
        print(f"ERROR OBTENER COMPETENCIA GRUPO: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

# OBTENER RESUMEN DE TODOS LOS GRUPOS
@group_tracking_bp.route('/resumen', methods=['GET'])
def obtener_resumen_grupos():
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Obtener todas las evaluaciones
        evaluations_response = supabase.table('evaluations').select('student_id, grade').execute()
        evaluations = evaluations_response.data if evaluations_response.data else []

        # Agrupar por estudiante
        student_grades = {}
        for eval in evaluations:
            student_id = eval.get('student_id')
            grade = eval.get('grade')
            
            if student_id and grade:
                if student_id not in student_grades:
                    student_grades[student_id] = []
                student_grades[student_id].append(grade)

        # Crear resumen
        resumen = {
            'total_students': len(student_grades),
            'total_evaluations': len(evaluations),
            'performance_distribution': {
                'advanced': 0,
                'developing': 0,
                'at_risk': 0
            },
            'groups': []
        }

        # Simular 3 grupos
        grupos_simulados = ['Grupo A', 'Grupo B', 'Grupo C']
        students_list = list(student_grades.items())
        
        for i, grupo_name in enumerate(grupos_simulados):
            # Distribuir estudiantes entre grupos
            start_idx = (i * len(students_list)) // 3
            end_idx = ((i + 1) * len(students_list)) // 3
            grupo_students = students_list[start_idx:end_idx]
            
            if grupo_students:
                grupo_grades = []
                for student_id, grades in grupo_students:
                    average = sum(grades) / len(grades)
                    status = 'advanced' if average >= 71 else 'developing' if average >= 41 else 'at_risk'
                    resumen['performance_distribution'][status] += 1
                    grupo_grades.extend(grades)
                
                resumen['groups'].append({
                    'name': grupo_name,
                    'student_count': len(grupo_students),
                    'average_grade': round(sum(grupo_grades) / len(grupo_grades), 2) if grupo_grades else 0
                })

        return jsonify(resumen), 200

    except Exception as e:
        print(f"ERROR OBTENER RESUMEN GRUPOS: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500



