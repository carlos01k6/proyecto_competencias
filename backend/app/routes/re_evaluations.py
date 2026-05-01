from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import jwt
from datetime import datetime
import uuid

re_evaluations_bp = Blueprint('re_evaluations', __name__, url_prefix='/api/re-evaluations')
supabase: Client = get_supabase()

def is_valid_uuid(value):
    try:
        uuid.UUID(str(value))
        return True
    except (TypeError, ValueError):
        return False

def get_user_id_from_token():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    if not token:
        return None
    try:
        payload = jwt.decode(token, options={"verify_signature": False})
        return payload.get('sub')
    except:
        return None

def resolve_user_id():
    token_user_id = get_user_id_from_token()
    if not token_user_id:
        return None

    user_response = supabase.table('users').select('id').eq('id', token_user_id).execute()
    if user_response.data:
        return token_user_id

    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    try:
        payload = jwt.decode(token, options={"verify_signature": False})
        email = payload.get('email')
        if email:
            user_response = supabase.table('users').select('id').eq('email', email).execute()
            if user_response.data:
                return user_response.data[0]['id']
    except Exception:
        pass

    return token_user_id

def get_student_name(student_id):
    response = supabase.table('users').select('name, email').eq('id', student_id).execute()
    if response.data:
        user = response.data[0]
        return user.get('name') or user.get('email') or student_id
    return student_id

def get_criteria_context(criteria_id):
    criteria_response = supabase.table('criteria').select('*').eq('id', criteria_id).execute()
    if not criteria_response.data:
        return {
            'criteria_name': criteria_id,
            'competency_name': ''
        }

    criteria = criteria_response.data[0]
    criteria_name = criteria.get('name') or criteria.get('nombre') or criteria_id
    competency_name = ''

    learning_outcome_id = criteria.get('learning_outcome_id')
    if learning_outcome_id:
        outcome_response = supabase.table('learning_outcomes').select('competency_id, title').eq('id', learning_outcome_id).execute()
        if outcome_response.data:
            competency_id = outcome_response.data[0].get('competency_id')
            if competency_id:
                competency_response = supabase.table('competencies').select('name').eq('id', competency_id).execute()
                if competency_response.data:
                    competency_name = competency_response.data[0].get('name') or ''

    return {
        'criteria_name': criteria_name,
        'competency_name': competency_name
    }

def normalize_history_row(evaluation):
    observation = evaluation.get('observation') or ''
    return {
        'fecha': evaluation.get('grading_date') or evaluation.get('created_at'),
        'grade': evaluation.get('grade'),
        'estado': 're-evaluación' if 'Re-evaluación' in observation else 'original'
    }

# OBTENER EVALUACIONES SUSCEPTIBLES DE RE-EVALUACIÓN
@re_evaluations_bp.route('/disponibles-reevaluar', methods=['GET'])
def obtener_disponibles_reevaluar():
    try:
        user_id = resolve_user_id()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        evaluations_response = (
            supabase.table('evaluations')
            .select('student_id, criteria_id, grade')
            .lt('grade', 70)
            .order('student_id')
            .execute()
        )
        disponibles = []
        student_names = {}
        criteria_contexts = {}

        for evaluation in evaluations_response.data or []:
            student_id = evaluation.get('student_id')
            criteria_id = evaluation.get('criteria_id')

            if student_id not in student_names:
                student_names[student_id] = get_student_name(student_id)
            if criteria_id not in criteria_contexts:
                criteria_contexts[criteria_id] = get_criteria_context(criteria_id)

            context = criteria_contexts[criteria_id]
            disponibles.append({
                'student_id': student_id,
                'student_name': student_names[student_id],
                'criteria_name': context['criteria_name'],
                'old_grade': evaluation.get('grade'),
                'competency_name': context['competency_name']
            })

        return jsonify(disponibles), 200

    except Exception as e:
        print(f"ERROR OBTENER DISPONIBLES: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

# OBTENER HISTORIAL DE INTENTOS POR ESTUDIANTE Y CRITERIO
@re_evaluations_bp.route('/historial/<student_id>/<criteria_id>', methods=['GET'])
def obtener_historial_criterio(student_id, criteria_id):
    try:
        user_id = resolve_user_id()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        if not is_valid_uuid(student_id) or not is_valid_uuid(criteria_id):
            return jsonify({'error': 'student_id y criteria_id deben ser UUID validos'}), 400

        evaluations = (
            supabase.table('evaluations')
            .select('*')
            .eq('student_id', student_id)
            .eq('criteria_id', criteria_id)
            .order('grading_date', desc=False)
            .execute()
        )

        return jsonify([normalize_history_row(e) for e in (evaluations.data or [])]), 200

    except Exception as e:
        print(f"ERROR OBTENER HISTORIAL CRITERIO: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

# CREAR NUEVA RE-EVALUACIÓN
@re_evaluations_bp.route('/crear', methods=['POST'])
def crear_reevaluacion():
    try:
        user_id = resolve_user_id()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        data = request.get_json() or {}
        student_id = data.get('student_id')
        criteria_id = data.get('criteria_id')
        new_grade = data.get('new_grade')
        observation = data.get('observation', '')

        if not student_id or not criteria_id or new_grade is None:
            return jsonify({'error': 'student_id, criteria_id y new_grade son requeridos'}), 400

        if not is_valid_uuid(student_id) or not is_valid_uuid(criteria_id):
            return jsonify({'error': 'student_id y criteria_id deben ser UUID validos'}), 400

        try:
            grade = float(new_grade)
        except (TypeError, ValueError):
            return jsonify({'error': 'new_grade debe ser numérico'}), 400

        if grade < 0 or grade > 100:
            return jsonify({'error': 'new_grade debe estar entre 0 y 100'}), 400

        previous_response = (
            supabase.table('evaluations')
            .select('*')
            .eq('student_id', student_id)
            .eq('criteria_id', criteria_id)
            .order('grading_date', desc=True)
            .limit(1)
            .execute()
        )
        previous = previous_response.data[0] if previous_response.data else {}
        if not previous:
            return jsonify({'error': 'No existe una evaluación previa para este estudiante y criterio'}), 400

        if not previous.get('activity_id'):
            return jsonify({'error': 'La evaluación previa no tiene activity_id'}), 400

        reevaluation_observation = f"Re-evaluación: {observation}".strip()
        nueva_evaluacion = {
            'id': str(uuid.uuid4()),
            'criteria_id': criteria_id,
            'student_id': student_id,
            'activity_id': previous.get('activity_id'),
            'grade': grade,
            'observation': reevaluation_observation,
            'teacher_id': user_id,
            'grading_date': datetime.now().isoformat()
        }

        response = supabase.table('evaluations').insert(nueva_evaluacion).execute()

        return jsonify({
            'success': True,
            'nueva_calificacion': response.data[0] if response.data else nueva_evaluacion
        }), 201

    except Exception as e:
        print(f"ERROR CREAR RE-EVALUACIÓN: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

# OBTENER HISTORIAL DE EVALUACIONES
@re_evaluations_bp.route('/historial/<student_id>', methods=['GET'])
def obtener_historial(student_id):
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Obtener todas las evaluaciones del estudiante
        evaluations = supabase.table('evaluations').select('*').eq('student_id', student_id).order('grading_date', desc=True).execute()
        
        historial = {
            'student_id': student_id,
            'evaluations': evaluations.data if evaluations.data else [],
            'total_evaluations': len(evaluations.data) if evaluations.data else 0,
            'has_reevaluations': any('Re-evaluación' in (e.get('observation') or '') for e in (evaluations.data or []))
        }

        return jsonify(historial), 200

    except Exception as e:
        print(f"ERROR OBTENER HISTORIAL: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500
