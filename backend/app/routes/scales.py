from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import jwt

escalas_bp = Blueprint('escalas', __name__, url_prefix='/api/escalas')
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

# OBTENER ESCALA ACTUAL
@escalas_bp.route('/actual', methods=['GET'])
def obtener_escala_actual():
    try:
        config_response = supabase.table('configuration').select('value').eq('key', 'escala_calificacion').execute()
        if config_response.data:
            escala = config_response.data[0]['value']
        else:
            escala = '0-100'

        return jsonify({'escala': escala}), 200

    except Exception as e:
        print(f"ERROR OBTENER ESCALA: {str(e)}")
        return jsonify({'error': str(e)}), 500

# CONVERTIR CALIFICACIÓN A ESCALA
@escalas_bp.route('/convertir/<int:calificacion>', methods=['GET'])
def convertir_calificacion(calificacion):
    try:
        # Obtener escala actual
        config_response = supabase.table('configuration').select('value').eq('key', 'escala_calificacion').execute()
        escala = config_response.data[0]['value'] if config_response.data else '0-100'

        resultado = {
            'calificacion_original': calificacion,
            'escala': escala,
            'calificacion_convertida': None
        }

        if escala == '0-100':
            resultado['calificacion_convertida'] = round(calificacion, 2)

        elif escala == '0-4':
            resultado['calificacion_convertida'] = round((calificacion / 100) * 4, 2)

        elif escala == 'A-F':
            if calificacion >= 90:
                resultado['calificacion_convertida'] = 'A (Excelente)'
            elif calificacion >= 80:
                resultado['calificacion_convertida'] = 'B (Bueno)'
            elif calificacion >= 70:
                resultado['calificacion_convertida'] = 'C (Regular)'
            elif calificacion >= 60:
                resultado['calificacion_convertida'] = 'D (Deficiente)'
            else:
                resultado['calificacion_convertida'] = 'F (Insuficiente)'

        return jsonify(resultado), 200

    except Exception as e:
        print(f"ERROR CONVERTIR CALIFICACION: {str(e)}")
        return jsonify({'error': str(e)}), 500

# ACTUALIZAR ESCALA (SOLO ADMIN)
@escalas_bp.route('/actualizar', methods=['POST'])
def actualizar_escala():
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Obtener rol del usuario desde users.role
        user_response = supabase.table('users').select('role').eq('id', usuario_id).execute()
        
        if not user_response.data:
            return jsonify({'error': 'Usuario no encontrado'}), 403
        
        rol = user_response.data[0]['role'].lower() if user_response.data else None

        if rol != 'admin':
            return jsonify({'error': 'Solo administradores pueden cambiar la escala'}), 403

        data = request.get_json()
        nueva_escala = data.get('escala')

        if nueva_escala not in ['0-100', '0-4', 'A-F']:
            return jsonify({'error': 'Escala inválida. Use: 0-100, 0-4, A-F'}), 400

        # Actualizar o crear configuración
        config_response = supabase.table('configuration').select('id').eq('key', 'escala_calificacion').execute()

        if config_response.data:
            supabase.table('configuration').update({'value': nueva_escala}).eq('key', 'escala_calificacion').execute()
        else:
            supabase.table('configuration').insert({
                'key': 'escala_calificacion',
                'value': nueva_escala,
                'description': 'Escala de calificación del sistema'
            }).execute()

        return jsonify({'mensaje': f'Escala actualizada a {nueva_escala}'}), 200

    except Exception as e:
        print(f"ERROR ACTUALIZAR ESCALA: {str(e)}")
        return jsonify({'error': str(e)}), 500



