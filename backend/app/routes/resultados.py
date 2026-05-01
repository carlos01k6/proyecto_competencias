from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import uuid
import jwt

resultados_bp = Blueprint('resultados', __name__, url_prefix='/api/resultados')
supabase: Client = get_supabase()

# Secret key de Supabase (puedes obtenerla de las variables de ambiente)
SUPABASE_JWT_SECRET = 'super-secret-jwt-token-with-at-least-32-characters-long'

def get_user_id_from_token():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    if not token:
        return None
    try:
        # Decodificar JWT sin verificación (ya que Supabase verifica)
        payload = jwt.decode(token, options={"verify_signature": False})
        usuario_id = payload.get('sub')
        return usuario_id
    except Exception as e:
        print(f"ERROR DECODIFICAR TOKEN: {str(e)}")
        return None

@resultados_bp.route('', methods=['GET'])
def get_todos_resultados():
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'mensaje': 'No autorizado'}), 401

        competencias = supabase.table('competencies').select('id').eq('teacher_id', usuario_id).execute()
        competencia_ids = [c['id'] for c in competencias.data]

        if not competencia_ids:
            return jsonify([]), 200

        response = supabase.table('learning_outcomes').select('*').in_('competency_id', competencia_ids).execute()
        return jsonify(response.data), 200
    except Exception as e:
        print(f"ERROR GET TODOS RESULTADOS: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400

@resultados_bp.route('/<resultado_id>', methods=['GET'])
def obtener_resultado(resultado_id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        resultado_response = supabase.table('learning_outcomes').select('*').eq('id', resultado_id).execute()
        if not resultado_response.data:
            return jsonify({'error': 'Resultado no encontrado'}), 404
        
        return jsonify(resultado_response.data[0]), 200

    except Exception as e:
        print(f"ERROR OBTENER RESULTADO: {str(e)}")
        return jsonify({'error': str(e)}), 500

@resultados_bp.route('/competencia/<competencia_id>', methods=['GET'])
def get_resultados_by_competencia(competencia_id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'mensaje': 'No autorizado'}), 401
        response = supabase.table('learning_outcomes').select('*').eq('competency_id', competencia_id).execute()
        return jsonify(response.data), 200
    except Exception as e:
        print(f"ERROR GET RESULTADOS: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400

@resultados_bp.route('', methods=['POST'])
def create_resultado():
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'mensaje': 'No autorizado'}), 401
        data = request.get_json()
        if not data or not data.get('competency_id') or not data.get('title'):
            return jsonify({'mensaje': 'competencia_id y titulo son requeridos'}), 400
        resultado = {
            'id': str(uuid.uuid4()),
            'competency_id': data['competency_id'],
            'title': data['title'],
            'description': data.get('description', '')
        }
        response = supabase.table('learning_outcomes').insert(resultado).execute()
        return jsonify(response.data[0]), 201
    except Exception as e:
        print(f"ERROR CREATE RESULTADO: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400

@resultados_bp.route('/<id>', methods=['PUT'])
def update_resultado(id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'mensaje': 'No autorizado'}), 401
        data = request.get_json()
        update_data = {}
        if 'title' in data:
            update_data['title'] = data['title']
        if 'description' in data:
            update_data['description'] = data['description']
        response = supabase.table('learning_outcomes').update(update_data).eq('id', id).execute()
        if not response.data:
            return jsonify({'mensaje': 'Resultado no encontrado'}), 404
        return jsonify(response.data[0]), 200
    except Exception as e:
        print(f"ERROR UPDATE RESULTADO: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400

@resultados_bp.route('/<id>', methods=['DELETE'])
def delete_resultado(id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'mensaje': 'No autorizado'}), 401
        supabase.table('learning_outcomes').delete().eq('id', id).execute()
        return jsonify({'mensaje': 'Resultado eliminado'}), 200
    except Exception as e:
        print(f"ERROR DELETE RESULTADO: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400



