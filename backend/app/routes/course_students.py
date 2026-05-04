from flask import Blueprint, jsonify
from ..supabase_client import get_supabase
from ..utils.student_codes import generar_codigo_estudiante

estudiantes_curso_bp = Blueprint('estudiantes_curso', __name__, url_prefix='/api/estudiantes')
supabase = get_supabase()


def normalizar_estudiante(estudiante):
    student_id = estudiante.get('id') or estudiante.get('student_id') or estudiante.get('estudiante_id')
    codigo_estudiante = generar_codigo_estudiante(student_id, estudiante.get('email'))
    return {
        **estudiante,
        'id': student_id,
        'student_id': student_id,
        'codigo_estudiante': codigo_estudiante,
        'student_code': codigo_estudiante,
        'nombre': estudiante.get('nombre') or estudiante.get('name'),
    }


@estudiantes_curso_bp.route('/curso/<curso_id>', methods=['GET'])
def obtener_estudiantes_curso(curso_id):
    """Obtiene los estudiantes de un curso específico"""
    try:
        response = supabase.table('estudiante_curso').select('estudiante_id').eq('curso_id', curso_id).execute()

        if not response.data:
            return jsonify([]), 200

        estudiante_ids = [e['estudiante_id'] for e in response.data]
        estudiantes_response = supabase.table('users').select('id, email, name').in_('id', estudiante_ids).execute()
        estudiantes = [normalizar_estudiante(estudiante) for estudiante in (estudiantes_response.data or [])]

        return jsonify(estudiantes), 200
    except Exception as e:
        print(f"ERROR: {str(e)}")
        return jsonify({"error": str(e)}), 500
