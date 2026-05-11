from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import jwt
from datetime import datetime
from functools import wraps

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


def get_user_role_from_token():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    if not token:
        return None
    try:
        payload = jwt.decode(token, options={"verify_signature": False})
        user_id = payload.get('sub')
        if user_id:
            user_response = supabase.table('users').select('role').eq('id', user_id).limit(1).execute()
            if user_response.data:
                return (user_response.data[0].get('role') or '').lower()
    except Exception:
        return None
    return None


def requiere_admin_o_docente():
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            role = get_user_role_from_token()
            if role not in ['admin', 'docente', 'teacher']:
                return jsonify({'error': 'No autorizado'}), 403
            return f(*args, **kwargs)
        return decorated_function
    return decorator

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
@auditoria_bp.route('', methods=['GET'])
@auditoria_bp.route('/log', methods=['GET'])
@requiere_admin_o_docente()
def obtener_log_auditoria():
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Parámetros opcionales para filtrar
        estudiante_id = request.args.get('student_id')
        limite = request.args.get('limite', default=100, type=int)
        fecha_desde = request.args.get('fecha_desde')
        fecha_hasta = request.args.get('fecha_hasta')

        try:
            query = supabase.table('audits').select('*').order('action_date', desc=True).limit(limite)

            if estudiante_id:
                query = query.eq('student_id', estudiante_id)
            if fecha_desde:
                query = query.gte('action_date', fecha_desde)
            if fecha_hasta:
                # Incluir todo el día de la fecha límite
                query = query.lte('action_date', fecha_hasta + 'T23:59:59')

            auditoria_response = query.execute()
            registros = auditoria_response.data
        except:
            # Si tabla no existe, retornar vacío
            registros = []

        return jsonify(registros), 200

    except Exception as e:
        print(f"ERROR OBTENER AUDITORIA: {str(e)}")
        return jsonify({'error': str(e)}), 500

# BACKFILL: generar registros de auditoría desde evaluaciones existentes
@auditoria_bp.route('/backfill', methods=['POST'])
def backfill_auditoria():
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Verificar que sea admin
        role = get_user_role_from_token()
        if role not in ['admin']:
            return jsonify({'error': 'Solo el administrador puede ejecutar el backfill'}), 403

        # Leer todas las evaluaciones existentes
        evals_response = supabase.table('evaluations').select('*').execute()
        evaluaciones = evals_response.data or []

        # Verificar cuáles ya tienen registro en audits para no duplicar
        audits_response = supabase.table('audits').select('record_id').execute()
        ya_auditados = {r.get('record_id') for r in (audits_response.data or [])}

        insertados = 0
        for ev in evaluaciones:
            ev_id = ev.get('id')
            if ev_id in ya_auditados:
                continue

            auditoria_data = {
                'user_id': ev.get('teacher_id') or usuario_id,
                'action': 'crear',
                'tabla_afectada': 'evaluations',
                'record_id': ev_id,
                'student_id': ev.get('student_id'),
                'criteria_id': ev.get('criteria_id'),
                'calificacion_anterior': None,
                'calificacion_nueva': ev.get('grade'),
                'observation': ev.get('observation') or 'Registro histórico',
                'action_date': ev.get('grading_date') or ev.get('created_at') or datetime.now().isoformat()
            }

            try:
                supabase.table('audits').insert(auditoria_data).execute()
                insertados += 1
            except Exception as e:
                print(f"Error insertando audit para eval {ev_id}: {e}")

        return jsonify({
            'mensaje': f'Backfill completado: {insertados} registros de auditoría creados',
            'total_evaluaciones': len(evaluaciones),
            'insertados': insertados,
            'ya_existian': len(evaluaciones) - insertados
        }), 200

    except Exception as e:
        print(f"ERROR BACKFILL AUDITORIA: {str(e)}")
        return jsonify({'error': str(e)}), 500


# OBTENER RESUMEN DE AUDITORÍA POR DOCENTE
@auditoria_bp.route('/resumen-docente/<docente_id>', methods=['GET'])
@requiere_admin_o_docente()
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




