from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import jwt
from datetime import datetime, timedelta

improvement_plans_bp = Blueprint('improvement_plans', __name__, url_prefix='/api/improvement-plans')
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

# GENERAR PLAN DE MEJORA PARA UN ESTUDIANTE
@improvement_plans_bp.route('/generar/<student_id>', methods=['POST'])
def generar_plan_mejora(student_id):
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Obtener todas las competencias con evaluaciones del estudiante
        competencies_response = supabase.table('competencies').select('id, name, description').execute()
        competencies = competencies_response.data if competencies_response.data else []

        weak_competencies = []

        for competency in competencies:
            # Obtener resultados de aprendizaje de esta competencia
            outcomes_resp = supabase.table('learning_outcomes').select('id').eq('competency_id', competency['id']).execute()
            outcome_ids = [o['id'] for o in (outcomes_resp.data or [])]
            if not outcome_ids:
                continue

            # Obtener criterios de esos resultados
            criteria_resp = supabase.table('criteria').select('id').in_('learning_outcome_id', outcome_ids).execute()
            criteria_ids = [c['id'] for c in (criteria_resp.data or [])]
            if not criteria_ids:
                continue

            # Obtener evaluaciones del estudiante para esos criterios
            evaluations_response = (
                supabase.table('evaluations')
                .select('grade')
                .eq('student_id', student_id)
                .in_('criteria_id', criteria_ids)
                .execute()
            )

            if evaluations_response.data:
                grades = [e.get('grade') for e in evaluations_response.data if e.get('grade') is not None]
                if grades:
                    average = sum(grades) / len(grades)
                    if average < 70:
                        weak_competencies.append({
                            'competency_id': competency['id'],
                            'competency_name': competency['name'],
                            'competency_description': competency.get('description', ''),
                            'average_grade': round(average, 2),
                            'evaluation_count': len(grades),
                            'nivel': 'Incipiente' if average < 40 else 'Básico' if average < 55 else 'En Desarrollo'
                        })

        # Actividades personalizadas por competencia débil
        actividades_base = {
            'default': [
                'Sesión de tutoría individual para reforzar fundamentos',
                'Ejercicios prácticos adicionales (mínimo 5 horas semanales)',
                'Participación activa en grupos de estudio (3 horas semanales)',
                'Revisión de material didáctico complementario provisto por el docente',
                'Evaluación formativa de seguimiento cada semana',
                'Entrevista de progreso con el docente cada 2 semanas',
            ]
        }

        improvement_activities = []
        if weak_competencies:
            for wc in weak_competencies:
                nombre = wc['competency_name']
                improvement_activities.append(f"Tutoría enfocada en «{nombre}» — 2 sesiones semanales")
                improvement_activities.append(f"Práctica guiada de ejercicios de «{nombre}» (4 h/semana)")
                improvement_activities.append(f"Autoevaluación semanal de avance en «{nombre}»")
        improvement_activities += actividades_base['default']

        start_date = datetime.now()
        plan_data = {
            'student_id': student_id,
            'teacher_id': user_id,
            'weak_competencies': weak_competencies,
            'improvement_activities': improvement_activities,
            'start_date': start_date.isoformat(),
            'end_date': (start_date + timedelta(weeks=4)).isoformat(),
            'status': 'active',
            'created_at': datetime.now().isoformat()
        }

        return jsonify({
            'plan': plan_data,
            'message': f'Plan generado para {len(weak_competencies)} competencias débiles',
            'weak_competencies_count': len(weak_competencies)
        }), 200

    except Exception as e:
        print(f"ERROR GENERAR PLAN: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

# OBTENER ESTUDIANTES QUE NECESITAN MEJORA (Promedio < 40)
@improvement_plans_bp.route('/estudiantes-en-riesgo', methods=['GET'])
def obtener_estudiantes_riesgo():
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Obtener todas las evaluaciones
        evaluations_response = supabase.table('evaluations').select('student_id, grade').execute()
        evaluations = evaluations_response.data if evaluations_response.data else []

        # Agrupar por estudiante y calcular promedio
        student_grades = {}
        for eval in evaluations:
            student_id = eval.get('student_id')
            grade = eval.get('grade')
            
            if student_id and grade:
                if student_id not in student_grades:
                    student_grades[student_id] = []
                student_grades[student_id].append(grade)

        # Identificar estudiantes en riesgo
        at_risk_students = []
        for student_id, grades in student_grades.items():
            average = sum(grades) / len(grades)
            if average < 40:
                at_risk_students.append({
                    'student_id': student_id,
                    'average_grade': round(average, 2),
                    'evaluation_count': len(grades),
                    'status': 'at_risk'
                })

        return jsonify({
            'at_risk_students': at_risk_students,
            'total_count': len(at_risk_students)
        }), 200

    except Exception as e:
        print(f"ERROR OBTENER ESTUDIANTES RIESGO: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500



