from flask import Blueprint, request, jsonify
from ..supabase_client import get_supabase

estudiantes_curso_bp = Blueprint('estudiantes_curso', __name__, url_prefix='/api/estudiantes')
supabase = get_supabase()

@estudiantes_curso_bp.route('/curso/<curso_id>', methods=['GET'])
def obtener_estudiantes_curso(curso_id):
    """Obtiene los estudiantes de un curso específico"""
    try:
        # Obtener IDs de estudiantes del curso
        response = supabase.table('estudiante_curso').select('estudiante_id').eq('curso_id', curso_id).execute()
        
        if not response.data:
            return jsonify([]), 200
        
        # Obtener datos de los estudiantes
        estudiante_ids = [e['estudiante_id'] for e in response.data]
        estudiantes_response = supabase.table('users').select('id, email, name').in_('id', estudiante_ids).execute()
        
        return jsonify(estudiantes_response.data or []), 200
    except Exception as e:
        print(f"❌ ERROR: {str(e)}")
        return jsonify({"error": str(e)}), 500
