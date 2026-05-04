from flask import Blueprint, request, jsonify
from flask_cors import cross_origin
from ..supabase_client import get_supabase

estudiantes_bp = Blueprint("estudiantes", __name__, url_prefix="/api/estudiantes")
supabase = get_supabase()


def normalizar_estudiante(estudiante):
    user = estudiante.get("users") if isinstance(estudiante, dict) else None
    if user:
        return {
            **estudiante,
            "student_id": user.get("id") or estudiante.get("estudiante_id"),
            "id": user.get("id") or estudiante.get("estudiante_id"),
            "nombre": user.get("name") or user.get("nombre"),
            "name": user.get("name") or user.get("nombre"),
            "email": user.get("email")
        }

    return {
        **estudiante,
        "student_id": estudiante.get("student_id") or estudiante.get("id") or estudiante.get("estudiante_id"),
        "nombre": estudiante.get("nombre") or estudiante.get("name"),
        "email": estudiante.get("email")
    }

@estudiantes_bp.route("/<curso_id>", methods=["GET"])
@estudiantes_bp.route("/por-curso/<curso_id>", methods=["GET"])
@cross_origin()
def obtener_estudiantes_por_curso(curso_id):
    """Obtiene los estudiantes asignados a un curso"""
    try:
        response = supabase.table("estudiante_curso").select(
            "*, users(id, email, name)"
        ).eq("curso_id", curso_id).execute()
        
        estudiantes = [normalizar_estudiante(estudiante) for estudiante in (response.data or [])]
        return jsonify(estudiantes), 200
    except Exception as e:
        print(f"ERROR ESTUDIANTES: {str(e)}")
        return jsonify({"error": str(e)}), 500

@estudiantes_bp.route("/asignar", methods=["POST"])
@cross_origin()
def asignar_estudiante_curso():
    """Asigna un estudiante a un curso"""
    try:
        data = request.get_json()
        estudiante_id = data.get("estudiante_id")
        curso_id = data.get("curso_id")

        if not estudiante_id or not curso_id:
            return jsonify({"error": "estudiante_id y curso_id requeridos"}), 400

        response = supabase.table("estudiante_curso").insert({
            "estudiante_id": estudiante_id,
            "curso_id": curso_id
        }).execute()

        return jsonify({"mensaje": "Estudiante asignado correctamente"}), 201
    except Exception as e:
        print(f"ERROR ASIGNAR: {str(e)}")
        return jsonify({"error": str(e)}), 500

@estudiantes_bp.route("/desasignar", methods=["DELETE"])
@cross_origin()
def desasignar_estudiante_curso():
    """Desasigna un estudiante de un curso"""
    try:
        data = request.get_json()
        estudiante_id = data.get("estudiante_id")
        curso_id = data.get("curso_id")

        response = supabase.table("estudiante_curso").delete().eq(
            "estudiante_id", estudiante_id
        ).eq("curso_id", curso_id).execute()

        return jsonify({"mensaje": "Estudiante desasignado"}), 200
    except Exception as e:
        print(f"ERROR DESASIGNAR: {str(e)}")
        return jsonify({"error": str(e)}), 500

@estudiantes_bp.route("", methods=["GET"])
@cross_origin()
def obtener_todos_estudiantes():
    """Obtiene todos los estudiantes del sistema"""
    try:
        response = supabase.table("users").select("id, email, name").eq("role", "student").execute()
        estudiantes = [normalizar_estudiante(estudiante) for estudiante in (response.data or [])]
        return jsonify(estudiantes), 200
    except Exception as e:
        print(f"ERROR OBTENER ESTUDIANTES: {str(e)}")
        return jsonify({"error": str(e)}), 500
