from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import jwt

config_bp = Blueprint('config', __name__, url_prefix='/api/config')
supabase: Client = get_supabase()

def get_user_id_from_token():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    if not token:
        return None
    try:
        payload = jwt.decode(token, options={"verify_signature": False})
        usuario_id = payload.get('sub')
        return usuario_id
    except:
        return None

def es_admin(usuario_id):
    try:
        rol_response = supabase.table('user_roles').select('roles(name)').eq('user_id', usuario_id).execute()
        if rol_response.data:
            rol = rol_response.data[0]['roles']['name']
            return rol == 'admin'
        return False
    except:
        return False

@config_bp.route('', methods=['GET'])
def obtener_configuraciones():
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401
        
        response = supabase.table('configuration').select('*').execute()
        configuraciones = [
            {
                'key': item.get('key'),
                'value': item.get('value'),
                'description': item.get('description') or item.get('key'),
                'type': item.get('type') or 'text',
            }
            for item in (response.data or [])
            if not (item.get('key') or '').startswith('period_')
        ]

        return jsonify(configuraciones), 200
    except Exception as e:
        print(f"ERROR OBTENER CONFIGURACIONES: {str(e)}")
        return jsonify({'error': str(e)}), 500

# OBTENER UNA CONFIGURACIÓN ESPECÍFICA
@config_bp.route('/<clave>', methods=['GET'])
def obtener_configuracion(clave):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401
        
        response = supabase.table('configuration').select('*').eq('key', clave).execute()
        
        if response.data:
            return jsonify(response.data[0]), 200
        else:
            return jsonify({'error': 'Configuración no encontrada'}), 404
            
    except Exception as e:
        print(f"ERROR OBTENER CONFIGURACIÓN: {str(e)}")
        return jsonify({'error': str(e)}), 500

@config_bp.route('/<clave>', methods=['PUT'])
def actualizar_configuracion(clave):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        data = request.get_json()
        nuevo_valor = data.get('value')
        
        if nuevo_valor is None:
            return jsonify({'error': 'Se requiere el campo "value"'}), 400
        
        actualizacion = {
            'value': nuevo_valor
        }
        
        response = supabase.table('configuration').update(actualizacion).eq('key', clave).execute()
        
        if response.data:
            item = response.data[0]
            return jsonify({'key': item.get('key'), 'value': item.get('value')}), 200
        else:
            return jsonify({'error': 'Configuración no encontrada'}), 404
            
    except Exception as e:
        print(f"ERROR ACTUALIZAR CONFIGURACIÓN: {str(e)}")
        return jsonify({'error': str(e)}), 500




