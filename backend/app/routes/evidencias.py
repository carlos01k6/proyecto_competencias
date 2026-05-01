from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import uuid
import jwt

evidencias_bp = Blueprint('evidence', __name__, url_prefix='/api/evidencias')

def get_user_id_from_token():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    if not token:
        return None
    try:
        payload = jwt.decode(token, options={"verify_signature": False})
        return payload.get('sub')
    except:
        return None
supabase: Client = get_supabase()


def is_valid_uuid(value):
    try:
        uuid.UUID(str(value))
        return True
    except (TypeError, ValueError):
        return False


def user_exists(user_id):
    if not user_id or not is_valid_uuid(user_id):
        return False
    response = supabase.table('users').select('id').eq('id', user_id).limit(1).execute()
    return bool(response.data)


def resolve_user_id(candidate_id):
    if user_exists(candidate_id):
        return candidate_id

    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    if not token:
        return None

    try:
        payload = jwt.decode(token, options={"verify_signature": False})
        token_user_id = payload.get('sub')
        if user_exists(token_user_id):
            return token_user_id

        email = payload.get('email')
        if email:
            response = supabase.table('users').select('id').eq('email', email).limit(1).execute()
            if response.data:
                return response.data[0]['id']
    except Exception as e:
        print(f"DEBUG RESOLVE USER: {str(e)}")

    return None


def activity_exists(activity_id):
    if not activity_id or not is_valid_uuid(activity_id):
        return False
    response = supabase.table('activities').select('id').eq('id', activity_id).limit(1).execute()
    return bool(response.data)


# OBTENER TODAS LAS EVIDENCIAS
@evidencias_bp.route('', methods=['GET'])
def obtener_todas_evidencias():
    try:
        response = supabase.table('evidence').select('*').execute()
        return jsonify(response.data), 200
    except Exception as e:
        print(f"ERROR OBTENER EVIDENCIAS: {str(e)}")
        return jsonify({'error': str(e)}), 500

# LISTAR EVIDENCIAS POR ACTIVIDAD
@evidencias_bp.route('/<actividad_id>', methods=['GET'])
def listar_evidencias(actividad_id):
    try:
        response = supabase.table('evidence').select('*').eq('activity_id', actividad_id).execute()
        return jsonify(response.data), 200
    except Exception as e:
        print(f"ERROR LISTAR EVIDENCIAS: {str(e)}")
        return jsonify({'error': str(e)}), 500

# CREAR EVIDENCIA
@evidencias_bp.route('', methods=['POST'])
def crear_evidencia():
    try:
        data = request.form
        archivo = request.files.get('archivo')
        
        if not data.get('activity_id') or not data.get('student_id'):
            return jsonify({'mensaje': 'activity_id y student_id son requeridos'}), 400

        activity_id = data.get('activity_id')
        if not activity_exists(activity_id):
            return jsonify({'mensaje': 'Selecciona una actividad valida'}), 400

        student_id = resolve_user_id(data.get('student_id'))
        if not student_id:
            return jsonify({'mensaje': 'El estudiante no existe en la tabla users'}), 400
        
        nueva_evidencia = {
            'id': str(uuid.uuid4()),
            'activity_id': activity_id,
            'student_id': student_id,
            'file_url': archivo.filename if archivo and archivo.filename else data.get('nombre'),
            'status': 'pendiente'
        }
        
        response = supabase.table('evidence').insert(nueva_evidencia).execute()
        return jsonify(response.data), 201
    except Exception as e:
        print(f"ERROR CREAR EVIDENCIA: {str(e)}")
        return jsonify({'error': str(e)}), 500

# ACTUALIZAR EVIDENCIA
@evidencias_bp.route('/<evidencia_id>', methods=['PUT'])
def actualizar_evidencia(evidencia_id):
    try:
        data = request.get_json()
        
        actualizacion = {
            'file_url': data.get('file_url'),
            'status': data.get('status')
        }
        
        response = supabase.table('evidence').update(actualizacion).eq('id', evidencia_id).execute()
        return jsonify(response.data[0]), 200
    except Exception as e:
        print(f"ERROR ACTUALIZAR EVIDENCIA: {str(e)}")
        return jsonify({'error': str(e)}), 500

# ELIMINAR EVIDENCIA
@evidencias_bp.route('/<evidencia_id>', methods=['DELETE'])
def eliminar_evidencia(evidencia_id):
    try:
        supabase.table('evidence').delete().eq('id', evidencia_id).execute()
        return jsonify({'mensaje': 'Evidencia eliminada'}), 200
    except Exception as e:
        print(f"ERROR ELIMINAR EVIDENCIA: {str(e)}")
        return jsonify({'error': str(e)}), 500






