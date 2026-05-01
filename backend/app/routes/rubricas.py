from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import jwt
import uuid
import traceback

rubricas_bp = Blueprint('rubricas', __name__, url_prefix='/api/rubricas')
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

# CREAR RÚBRICA
@rubricas_bp.route('/crear', methods=['POST'])
def crear_rubrica():
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        data = request.get_json()

        rubrica_data = {
            'nombre': data.get('nombre'),
            'descripcion': data.get('descripcion'),
            'docente_id': usuario_id,
            'niveles': data.get('niveles'),
            'competencia_id': data.get('competencia_id')
        }

        rubrica_response = supabase.table('rubricas').insert(rubrica_data).execute()
        return jsonify({
            'mensaje': 'Rúbrica creada exitosamente',
            'id': rubrica_response.data[0]['id'] if rubrica_response.data else None
        }), 201

    except Exception as e:
        print(f"ERROR CREAR RUBRICA: {str(e)}")
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

# OBTENER MIS RÚBRICAS
@rubricas_bp.route('/mis-rubricas', methods=['GET'])
def obtener_mis_rubricas():
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        rubricas_response = supabase.table('rubricas').select('*').eq('docente_id', usuario_id).order('created_at', desc=True).execute()
        rubricas = rubricas_response.data if rubricas_response.data else []

        return jsonify(rubricas), 200

    except Exception as e:
        print(f"ERROR OBTENER RUBRICAS: {str(e)}")
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

# OBTENER RÚBRICAS GLOBALES
@rubricas_bp.route('/globales', methods=['GET'])
def obtener_rubricas_globales():
    try:
        rubricas_response = supabase.table('rubricas').select('*').execute()

        rubricas = []
        for rubrica in rubricas_response.data or []:
            criterios = rubrica.get('criterios') or []
            niveles = rubrica.get('niveles') or []
            criterios_count = len(criterios) if isinstance(criterios, list) else len(niveles) if isinstance(niveles, list) else 0
            rubricas.append({
                'id': rubrica.get('id'),
                'nombre': rubrica.get('nombre') or '',
                'descripcion': rubrica.get('descripcion') or '',
                'criterios_count': criterios_count
            })

        return jsonify(rubricas), 200

    except Exception as e:
        print(f"ERROR OBTENER RUBRICAS GLOBALES: {str(e)}")
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

# OBTENER RÚBRICA ESPECÍFICA
@rubricas_bp.route('/<rubrica_id>', methods=['GET'])
def obtener_rubrica(rubrica_id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        rubrica_response = supabase.table('rubricas').select('*').eq('id', rubrica_id).execute()
        if not rubrica_response.data:
            return jsonify({'error': 'Rúbrica no encontrada'}), 404

        return jsonify(rubrica_response.data[0]), 200

    except Exception as e:
        print(f"ERROR OBTENER RUBRICA: {str(e)}")
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

# ACTUALIZAR RÚBRICA
@rubricas_bp.route('/<rubrica_id>', methods=['PUT'])
def actualizar_rubrica(rubrica_id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        rubrica_response = supabase.table('rubricas').select('docente_id').eq('id', rubrica_id).execute()
        if not rubrica_response.data:
            return jsonify({'error': 'Rúbrica no encontrada'}), 404

        if rubrica_response.data[0]['docente_id'] != usuario_id:
            return jsonify({'error': 'No autorizado'}), 403

        data = request.get_json()
        supabase.table('rubricas').update({
            'nombre': data.get('nombre'),
            'descripcion': data.get('descripcion'),
            'niveles': data.get('niveles')
        }).eq('id', rubrica_id).execute()

        return jsonify({'mensaje': 'Rúbrica actualizada'}), 200

    except Exception as e:
        print(f"ERROR ACTUALIZAR RUBRICA: {str(e)}")
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

# ELIMINAR RÚBRICA
@rubricas_bp.route('/<rubrica_id>', methods=['DELETE'])
def eliminar_rubrica(rubrica_id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        rubrica_response = supabase.table('rubricas').select('docente_id').eq('id', rubrica_id).execute()
        if not rubrica_response.data:
            return jsonify({'error': 'Rúbrica no encontrada'}), 404

        if rubrica_response.data[0]['docente_id'] != usuario_id:
            return jsonify({'error': 'No autorizado'}), 403

        supabase.table('rubricas').delete().eq('id', rubrica_id).execute()

        return jsonify({'mensaje': 'Rúbrica eliminada'}), 200

    except Exception as e:
        print(f"ERROR ELIMINAR RUBRICA: {str(e)}")
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500



