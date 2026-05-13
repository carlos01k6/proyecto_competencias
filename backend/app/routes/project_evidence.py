from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import jwt

evidencias_proyecto_bp = Blueprint('evidencias_proyecto', __name__, url_prefix='/api/evidencias-proyecto')
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


def normalizar_evidencia(evidencia):
    archivo = (
        evidencia.get('nombre_archivo')
        or evidencia.get('file_name')
        or evidencia.get('file_url')
        or evidencia.get('nombre')
        or 'Evidencia'
    )
    ruta = (
        evidencia.get('ruta_archivo')
        or evidencia.get('file_url')
        or evidencia.get('url')
        or ''
    )
    fecha = (
        evidencia.get('fecha_subida')
        or evidencia.get('delivery_date')
        or evidencia.get('send_date')
        or evidencia.get('created_at')
    )

    return {
        'id': evidencia.get('id'),
        'nombre_archivo': archivo,
        'ruta_archivo': ruta,
        'file_url': evidencia.get('file_url') or ruta,
        'delivery_date': fecha,
        'fecha_subida': fecha,
        'estado': evidencia.get('estado') or evidencia.get('status') or 'pendiente',
        'student_id': evidencia.get('student_id'),
        'description': evidencia.get('description') or evidencia.get('descripcion') or ''
    }

# OBTENER EVIDENCIAS AGRUPADAS POR ACTIVIDAD
@evidencias_proyecto_bp.route('/por-actividad/<actividad_id>', methods=['GET'])
def obtener_evidencias_por_actividad(actividad_id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Obtener información de la actividad
        actividad_response = supabase.table('activities').select('*').eq('id', actividad_id).execute()
        if not actividad_response.data:
            return jsonify({'error': 'Actividad no encontrada'}), 404
        
        actividad = actividad_response.data[0]

        # Obtener todas las evidencias de esta actividad agrupadas por estudiante
        evidencias_response = supabase.table('evidence').select('*').eq('activity_id', actividad_id).order('delivery_date', desc=True).execute()
        evidencias = evidencias_response.data or []

        # Agrupar por estudiante
        estudiantes_dict = {}
        for evidencia in evidencias:
            estudiante_id = evidencia['student_id']
            if estudiante_id not in estudiantes_dict:
                estudiantes_dict[estudiante_id] = {
                    'student_id': estudiante_id,
                    'evidence': []
                }
            estudiantes_dict[estudiante_id]['evidence'].append(normalizar_evidencia(evidencia))

        for estudiante in estudiantes_dict.values():
            estudiante['estudiante_id'] = estudiante['student_id']
            estudiante['evidencias'] = estudiante['evidence']

        fecha_limite = (
            actividad.get('fecha_limite')
            or actividad.get('close_date')
            or actividad.get('fecha_cierre')
            or actividad.get('due_date')
        )

        resultado = {
            'activity_id': actividad['id'],
            'actividad_nombre': actividad.get('nombre') or actividad.get('title') or actividad.get('name'),
            'actividad_descripcion': actividad.get('descripcion') or actividad.get('description') or '',
            'fecha_limite': fecha_limite,
            'estudiantes': list(estudiantes_dict.values()),
            'total_estudiantes': len(estudiantes_dict),
            'total_evidencias': len(evidencias)
        }

        return jsonify(resultado), 200

    except Exception as e:
        print(f"ERROR OBTENER EVIDENCIAS PROYECTO: {str(e)}")
        return jsonify({'error': str(e)}), 500

# OBTENER TODAS LAS ACTIVIDADES CON RESUMEN DE EVIDENCIAS
@evidencias_proyecto_bp.route('/actividades-resumen', methods=['GET'])
def obtener_actividades_resumen():
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Obtener todas las actividades. La tabla actual usa close_date; versiones
        # anteriores del modulo esperaban fecha_limite.
        actividades_response = supabase.table('activities').select('*').execute()
        actividades = actividades_response.data or []

        actividades.sort(
            key=lambda actividad: (
                actividad.get('fecha_limite')
                or actividad.get('close_date')
                or actividad.get('fecha_cierre')
                or actividad.get('due_date')
                or ''
            )
        )

        resultado = []
        for actividad in actividades:
            # Contar evidencias por actividad
            evidencias_response = supabase.table('evidence').select('id', count='exact').eq('activity_id', actividad['id']).execute()
            total_evidencias = len(evidencias_response.data or [])

            # Contar estudiantes únicos
            estudiantes_response = supabase.table('evidence').select('student_id').eq('activity_id', actividad['id']).execute()
            estudiantes_unicos = len(set(e['student_id'] for e in (estudiantes_response.data or []) if e.get('student_id')))

            fecha_limite = (
                actividad.get('fecha_limite')
                or actividad.get('close_date')
                or actividad.get('fecha_cierre')
                or actividad.get('due_date')
            )

            resultado.append({
                'id': actividad['id'],
                'nombre': actividad.get('nombre') or actividad.get('title') or actividad.get('name'),
                'descripcion': actividad.get('descripcion') or actividad.get('description') or '',
                'fecha_limite': fecha_limite,
                'total_evidencias': total_evidencias,
                'total_estudiantes': estudiantes_unicos
            })

        return jsonify(resultado), 200

    except Exception as e:
        print(f"ERROR OBTENER ACTIVIDADES RESUMEN: {str(e)}")
        return jsonify({'error': str(e)}), 500



