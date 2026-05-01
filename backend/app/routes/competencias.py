from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import uuid

competencias_bp = Blueprint('competencies', __name__, url_prefix='/api/competencias')
supabase: Client = get_supabase()

def is_valid_uuid(value):
    try:
        uuid.UUID(str(value))
        return True
    except (TypeError, ValueError):
        return False

def get_user_id_from_token():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    print(f"DEBUG: Token recibido: {token[:20] if token else 'VACÍO'}...")
    
    if not token:
        print("DEBUG: No hay token")
        return None
    try:
        user = supabase.auth.get_user(token)
        print(f"DEBUG: Usuario obtenido: {user.user.id}")
        return user.user.id
    except Exception as e:
        print(f"DEBUG: Error al validar token: {str(e)}")
        return None

@competencias_bp.route('', methods=['GET'])
def get_competencias():
    try:
        # TODOS ven TODAS las competencias
        response = supabase.table('competencies').select('*').execute()
        competencias = []
        for competencia in response.data:
            if not is_valid_uuid(competencia.get('id')):
                continue

            competencias.append({
                **competencia,
                'nombre': competencia.get('nombre') or competencia.get('name')
            })
        return jsonify(competencias), 200
    except Exception as e:
        print(f"ERROR GET COMPETENCIAS: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400
    
@competencias_bp.route('', methods=['POST'])
def create_competencia():
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'mensaje': 'No autorizado'}), 401
        
        data = request.get_json()
        
        if not data or not data.get('name') or not data.get('descriptor'):
            return jsonify({'mensaje': 'Nombre y descriptor requeridos'}), 400
        
        competencia = {
            'id': str(uuid.uuid4()),
            'name': data['name'],
            'description': data.get('description', ''),
            'descriptor': data['descriptor'],
            'subject': data.get('subject', ''),
            'teacher_id': usuario_id
        }
        
        response = supabase.table('competencies').insert(competencia).execute()
        return jsonify(response.data[0]), 201
        
    except Exception as e:
        print(f"ERROR CREATE COMPETENCIA: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400

@competencias_bp.route('/<id>', methods=['GET'])
def get_competencia(id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'mensaje': 'No autorizado'}), 401
        
        response = supabase.table('competencies').select('*').eq('id', id).execute()
        if not response.data:
            return jsonify({'mensaje': 'Competencia no encontrada'}), 404
        return jsonify(response.data[0]), 200
    except Exception as e:
        print(f"ERROR GET COMPETENCIA: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400

@competencias_bp.route('/<id>', methods=['PUT'])
def update_competencia(id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'mensaje': 'No autorizado'}), 401
        
        data = request.get_json()
        
        update_data = {}
        if 'name' in data:
            update_data['name'] = data['name']
        if 'description' in data:
            update_data['description'] = data['description']
        if 'descriptor' in data:
            update_data['descriptor'] = data['descriptor']
        if 'subject' in data:
            update_data['subject'] = data['subject']
        
        response = supabase.table('competencies').update(update_data).eq('id', id).execute()
        
        if not response.data:
            return jsonify({'mensaje': 'Competencia no encontrada'}), 404
        
        return jsonify(response.data[0]), 200
        
    except Exception as e:
        print(f"ERROR UPDATE COMPETENCIA: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400

@competencias_bp.route('/<id>', methods=['DELETE'])
def delete_competencia(id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'mensaje': 'No autorizado'}), 401
        
        supabase.table('competencies').delete().eq('id', id).execute()
        return jsonify({'mensaje': 'Competencia eliminada'}), 200
    except Exception as e:
        print(f"ERROR DELETE COMPETENCIA: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400
