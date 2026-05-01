from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import jwt
from datetime import datetime

auditoria_bp = Blueprint('audits', __name__, url_prefix='/api/auditoria')
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

# REGISTRAR AUDITORÍA (llamada después de cada evaluación)
@auditoria_bp.route('/registrar', methods=['POST'])
def registrar_auditoria():
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        data = request.get_json()
        
        # Registrar en base de datos
        auditoria_data = {
            'user_id': usuario_id,
            'action': data.get('action'),
            'tabla_afectada': data.get('tabla_afectada'),
            'record_id': data.get('record_id'),
            'student_id': data.get('student_id'),
            'criteria_id': data.get('criteria_id'),
            'calificacion_anterior': data.get('calificacion_anterior'),
            'calificacion_nueva': data.get('calificacion_nueva'),
            'observation': data.get('observation'),
            'action_date': datetime.now().isoformat()
        }
        
        # Crear tabla si no existe (en producción, debe crearse con migraciones)
        try:
            auditoria_response = supabase.table('audits').insert(auditoria_data).execute()
        except:
            # Si falla, ignorar - tabla puede no existir en algunas instancias
            pass

        return jsonify({'mensaje': 'Auditoría registrada'}), 201

    except Exception as e:
        print(f"ERROR REGISTRAR AUDITORIA: {str(e)}")
        return jsonify({'error': str(e)}), 500

# OBTENER LOG DE AUDITORÍA
@auditoria_bp.route('/log', methods=['GET'])
def obtener_log_auditoria():
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Parámetros opcionales para filtrar
        estudiante_id = request.args.get('student_id')
        limite = request.args.get('limite', default=100, type=int)
        
        try:
            query = supabase.table('audits').select('*').order('action_date', desc=True).limit(limite)
            
            if estudiante_id:
                query = query.eq('student_id', estudiante_id)
            
            auditoria_response = query.execute()
            registros = auditoria_response.data
        except:
            # Si tabla no existe, retornar vacío
            registros = []

        return jsonify(registros), 200

    except Exception as e:
        print(f"ERROR OBTENER AUDITORIA: {str(e)}")
        return jsonify({'error': str(e)}), 500

# OBTENER RESUMEN DE AUDITORÍA POR DOCENTE
@auditoria_bp.route('/resumen-docente/<docente_id>', methods=['GET'])
def obtener_resumen_docente(docente_id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        try:
            auditoria_response = supabase.table('audits').select('*').eq('user_id', docente_id).order('action_date', desc=True).execute()
            registros = auditoria_response.data
        except:
            registros = []

        # Contar acciones
        total_calificaciones = len([r for r in registros if r.get('tabla_afectada') == 'evaluations'])
        estudiantes_calificados = len(set(r.get('student_id') for r in registros if r.get('student_id')))
        
        return jsonify({
            'teacher_id': docente_id,
            'total_registros': len(registros),
            'total_calificaciones': total_calificaciones,
            'estudiantes_calificados': estudiantes_calificados,
            'registros_recientes': registros[:20]
        }), 200

    except Exception as e:
        print(f"ERROR RESUMEN AUDITORIA: {str(e)}")
        return jsonify({'error': str(e)}), 500




