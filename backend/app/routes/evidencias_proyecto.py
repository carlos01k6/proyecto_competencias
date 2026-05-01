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
        evidencias = evidencias_response.data

        # Agrupar por estudiante
        estudiantes_dict = {}
        for evidencia in evidencias:
            estudiante_id = evidencia['student_id']
            if estudiante_id not in estudiantes_dict:
                estudiantes_dict[estudiante_id] = {
                    'student_id': estudiante_id,
                    'evidence': []
                }
            estudiantes_dict[estudiante_id]['evidence'].append({
                'id': evidencia['id'],
                'nombre_archivo': evidencia['nombre_archivo'],
                'ruta_archivo': evidencia['ruta_archivo'],
                'delivery_date': evidencia['delivery_date'],
                'estado': evidencia.get('estado', 'pendiente')
            })

        resultado = {
            'activity_id': actividad['id'],
            'actividad_nombre': actividad['nombre'],
            'actividad_descripcion': actividad.get('descripcion', ''),
            'fecha_limite': actividad.get('fecha_limite'),
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

        # Obtener todas las actividades
        actividades_response = supabase.table('activities').select('*').order('fecha_limite').execute()
        actividades = actividades_response.data

        resultado = []
        for actividad in actividades:
            # Contar evidencias por actividad
            evidencias_response = supabase.table('evidence').select('id', count='exact').eq('activity_id', actividad['id']).execute()
            total_evidencias = len(evidencias_response.data)

            # Contar estudiantes únicos
            estudiantes_response = supabase.table('evidence').select('student_id').eq('activity_id', actividad['id']).execute()
            estudiantes_unicos = len(set(e['student_id'] for e in estudiantes_response.data))

            resultado.append({
                'id': actividad['id'],
                'nombre': actividad['nombre'],
                'descripcion': actividad.get('descripcion', ''),
                'fecha_limite': actividad.get('fecha_limite'),
                'total_evidencias': total_evidencias,
                'total_estudiantes': estudiantes_unicos
            })

        return jsonify(resultado), 200

    except Exception as e:
        print(f"ERROR OBTENER ACTIVIDADES RESUMEN: {str(e)}")
        return jsonify({'error': str(e)}), 500



