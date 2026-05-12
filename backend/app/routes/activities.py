from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
from .notificaciones import crear_notificacion_estudiante
from .emails import enviar_mensaje, is_valid_email
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

def obtener_todos_estudiantes():
    """Devuelve los IDs de todos los usuarios con rol estudiante registrados en el sistema."""
    try:
        resp = supabase.table('users').select('id').eq('role', 'student').execute()
        return [u['id'] for u in (resp.data or []) if u.get('id')]
    except Exception as e:
        print(f"ERROR OBTENER TODOS ESTUDIANTES: {str(e)}")
        return []


def obtener_estudiantes_para_notificar(curso_id, docente_id):
    try:
        curso_ids = []
        if curso_id:
            curso_ids = [curso_id]
        elif docente_id:
            cursos_response = supabase.table('cursos').select('id').eq('docente_id', docente_id).execute()
            curso_ids = [curso['id'] for curso in (cursos_response.data or []) if curso.get('id')]

        inscritos = set()
        if curso_ids:
            query = supabase.table('estudiante_curso').select('estudiante_id')
            if len(curso_ids) == 1:
                estudiantes_response = query.eq('curso_id', curso_ids[0]).execute()
            else:
                estudiantes_response = query.in_('curso_id', curso_ids).execute()
            inscritos = {
                item['estudiante_id']
                for item in (estudiantes_response.data or [])
                if item.get('estudiante_id')
            }

        # Si hay inscritos en el curso úsalos; de lo contrario notifica a todos los estudiantes
        if inscritos:
            return list(inscritos)
        return obtener_todos_estudiantes()
    except Exception as e:
        print(f"ERROR OBTENER ESTUDIANTES PARA NOTIFICAR: {str(e)}")
        return []

# LISTAR TODAS LAS ACTIVIDADES
@actividades_bp.route('', methods=['GET'])
def listar_todas_actividades():
    try:
        response = supabase.table('activities').select('*').execute()
        actividades = []
        for actividad in response.data or []:
            actividades.append({
                **actividad,
                'name': actividad.get('name') or actividad.get('title'),
                'description': actividad.get('description') or ''
            })
        return jsonify(actividades), 200
    except Exception as e:
        print(f"ERROR LISTAR TODAS ACTIVIDADES: {str(e)}")
        return jsonify({'error': str(e)}), 500

# LISTAR ACTIVIDADES POR RESULTADO
@actividades_bp.route('/<resultado_id>', methods=['GET'])
def listar_actividades(resultado_id):
    try:
        response = supabase.table('activities').select('*').eq('learning_outcome_id', resultado_id).execute()
        actividades = []
        for actividad in response.data or []:
            actividades.append({
                **actividad,
                'name': actividad.get('name') or actividad.get('title'),
                'description': actividad.get('description') or ''
            })
        return jsonify(actividades), 200
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
        if data.get('curso_id'):
            nueva_actividad['curso_id'] = data.get('curso_id')

        response = supabase.table('activities').insert(nueva_actividad).execute()
        actividad_creada = response.data[0] if response.data else nueva_actividad

        estudiantes = obtener_estudiantes_para_notificar(
            data.get('curso_id'),
            nueva_actividad.get('docente_id')
        )
        for estudiante_id in estudiantes:
            try:
                crear_notificacion_estudiante(
                    estudiante_id=estudiante_id,
                    titulo=f"Nueva clase: {actividad_creada.get('title')}",
                    mensaje=actividad_creada.get('description') or '',
                    tipo="nueva_clase"
                )
            except Exception as e:
                print(f"ERROR CREAR NOTIFICACION DE ACTIVIDAD: {str(e)}")

        if estudiantes:
            try:
                usuarios_resp = supabase.table('users').select('id, email, name').in_('id', estudiantes).execute()
                for usuario in usuarios_resp.data or []:
                    email = usuario.get('email')
                    if not is_valid_email(email):
                        print(f"OMITIENDO EMAIL INVALIDO: {email}")
                        continue
                    try:
                        nombre = usuario.get('name') or 'estudiante'
                        cuerpo = (
                            f"Hola {nombre},\n\n"
                            f"Se ha publicado una nueva actividad: {actividad_creada.get('title')}.\n\n"
                            f"Descripción:\n{actividad_creada.get('description') or 'No hay descripción.'}\n\n"
                            "Revisa tu curso para más detalles.\n\n"
                            "Sistema de Evaluacion por Competencias"
                        )
                        enviar_mensaje(
                            email,
                            f"Nueva actividad: {actividad_creada.get('title')}",
                            cuerpo,
                        )
                    except Exception as e:
                        print(f"ERROR ENVIAR EMAIL ACTIVIDAD A {email}: {str(e)}")
            except Exception as e:
                print(f"ERROR OBTENER EMAILS ESTUDIANTES: {str(e)}")

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

