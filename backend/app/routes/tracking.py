from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import jwt

seguimiento_bp = Blueprint('seguimiento', __name__, url_prefix='/api/seguimiento')
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

# OBTENER PROGRESO DE COMPETENCIAS POR ESTUDIANTE
@seguimiento_bp.route('/competencias/<estudiante_id>', methods=['GET'])
def obtener_progreso_competencias(estudiante_id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        competencias_response = supabase.table('competencies').select('*').execute()
        resultado = []

        for competencia in competencias_response.data or []:
            outcomes_response = (
                supabase.table('learning_outcomes')
                .select('id, title')
                .eq('competency_id', competencia['id'])
                .execute()
            )

            outcomes = []
            grades_competencia = []

            for outcome in outcomes_response.data or []:
                criterios_response = (
                    supabase.table('criteria')
                    .select('id')
                    .eq('learning_outcome_id', outcome['id'])
                    .execute()
                )
                criterio_ids = [criterio['id'] for criterio in (criterios_response.data or [])]

                grades = []
                if criterio_ids:
                    evaluaciones_response = (
                        supabase.table('evaluations')
                        .select('grade')
                        .in_('criteria_id', criterio_ids)
                        .eq('student_id', estudiante_id)
                        .execute()
                    )
                    grades = [
                        float(evaluacion['grade'])
                        for evaluacion in (evaluaciones_response.data or [])
                        if evaluacion.get('grade') is not None
                    ]

                grades_competencia.extend(grades)
                grade_count = len(grades)
                promedio = sum(grades) / grade_count if grade_count else 0

                outcomes.append({
                    'outcome_name': outcome.get('title') or outcome['id'],
                    'promedio': round(promedio, 2),
                    'grade_count': grade_count
                })

            total_evaluaciones = len(grades_competencia)
            promedio_general = sum(grades_competencia) / total_evaluaciones if total_evaluaciones else 0

            if total_evaluaciones:
                resultado.append({
                    'competency_id': competencia['id'],
                    'competencia_name': competencia.get('name') or competencia.get('nombre') or competencia['id'],
                    'competencia_nombre': competencia.get('name') or competencia.get('nombre') or competencia['id'],
                    'promedio_general': round(promedio_general, 2),
                    'total_evaluaciones': total_evaluaciones,
                    'outcomes': outcomes
                })

        return jsonify(resultado), 200

    except Exception as e:
        print(f"ERROR OBTENER PROGRESO: {str(e)}")
        return jsonify({'error': str(e)}), 500




