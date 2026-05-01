from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import uuid

actividades_bp = Blueprint('activities', __name__, url_prefix='/api/actividades')
supabase: Client = get_supabase()

def get_user_id_from_token():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    if not token:
        return None
    try:
        user = supabase.auth.get_user(token)
        return user.user.id
    except Exception as e:
        print(f"DEBUG: Error al validar token: {str(e)}")
        return None

# LISTAR TODAS LAS ACTIVIDADES
@actividades_bp.route('', methods=['GET'])
def listar_todas_actividades():
    try:
        response = supabase.table('activities').select('*').execute()
        return jsonify(response.data), 200
    except Exception as e:
        print(f"ERROR LISTAR TODAS ACTIVIDADES: {str(e)}")
        return jsonify({'error': str(e)}), 500

# LISTAR ACTIVIDADES POR RESULTADO
@actividades_bp.route('/<resultado_id>', methods=['GET'])
def listar_actividades(resultado_id):
    try:
        response = supabase.table('activities').select('*').eq('learning_outcome_id', resultado_id).execute()
        return jsonify(response.data), 200
    except Exception as e:
        print(f"ERROR LISTAR ACTIVIDADES: {str(e)}")
        return jsonify({'error': str(e)}), 500

# CREAR ACTIVIDAD
@actividades_bp.route('', methods=['POST'])
def crear_actividad():
    try:
        data = request.get_json()
        if not data.get('name'):
            return jsonify({'mensaje': 'El nombre es requerido'}), 400
        
        nueva_actividad = {
            'id': str(uuid.uuid4()),
            'learning_outcome_id': data.get('learning_outcome_id') or None,
            'title': data.get('name'),
            'description': data.get('description', ''),
            'start_date': data.get('start_date'),
            'close_date': data.get('close_date'),
            'type': data.get('tipo', 'tarea'),
            'max_score': data.get('max_score', 100),
            'status': 'active',
            'docente_id': get_user_id_from_token()
        }
        response = supabase.table('activities').insert(nueva_actividad).execute()
        return jsonify(response.data[0]), 201
    except Exception as e:
        print(f"ERROR CREAR ACTIVIDAD: {str(e)}")
        return jsonify({'error': str(e)}), 500

# ACTUALIZAR ACTIVIDAD
@actividades_bp.route('/<actividad_id>', methods=['PUT'])
def actualizar_actividad(actividad_id):
    try:
        data = request.get_json()
        actualizacion = {
            'title': data.get('name'),
            'description': data.get('description'),
            'start_date': data.get('start_date'),
            'close_date': data.get('close_date'),
            'type': data.get('tipo'),
            'max_score': data.get('max_score'),
            'status': data.get('status')
        }
        response = supabase.table('activities').update(actualizacion).eq('id', actividad_id).execute()
        return jsonify(response.data[0]), 200
    except Exception as e:
        print(f"ERROR ACTUALIZAR ACTIVIDAD: {str(e)}")
        return jsonify({'error': str(e)}), 500

# ELIMINAR ACTIVIDAD
@actividades_bp.route('/<actividad_id>', methods=['DELETE'])
def eliminar_actividad(actividad_id):
    try:
        supabase.table('activities').delete().eq('id', actividad_id).execute()
        return jsonify({'mensaje': 'Actividad eliminada'}), 200
    except Exception as e:
        print(f"ERROR ELIMINAR ACTIVIDAD: {str(e)}")
        return jsonify({'error': str(e)}), 500

