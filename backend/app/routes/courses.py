from flask import Blueprint, request, jsonify
from flask_cors import cross_origin
from ..supabase_client import get_supabase
from .docentes import crear_docente_en_sistema
import jwt

cursos_bp = Blueprint("cursos", __name__, url_prefix="/api/cursos")
supabase = get_supabase()


def get_user_id_from_token():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    if not token:
        return None
    try:
        payload = jwt.decode(token, options={"verify_signature": False})
        return payload.get('sub')
    except Exception:
        return None


@cursos_bp.route("/docente/<docente_id>", methods=["GET"])
@cross_origin()
def obtener_cursos_docente(docente_id):
    try:
        response = supabase.table("cursos").select("*").eq("docente_id", docente_id).execute()
        return jsonify(response.data or []), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ADMIN: listar todos los cursos
@cursos_bp.route("", methods=["GET"])
@cross_origin()
def listar_todos_cursos():
    try:
        response = supabase.table("cursos").select("*").order("nombre").execute()
        cursos = response.data or []

        # Añadir conteo de estudiantes inscritos por curso
        for curso in cursos:
            try:
                inscritos = supabase.table("estudiante_curso").select("estudiante_id").eq("curso_id", curso["id"]).execute()
                curso["total_estudiantes"] = len(inscritos.data or [])
            except Exception:
                curso["total_estudiantes"] = 0

        return jsonify(cursos), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ADMIN: cambiar estado activo/inactivo
@cursos_bp.route("/<curso_id>/estado", methods=["PUT"])
@cross_origin()
def cambiar_estado_curso(curso_id):
    try:
        data = request.get_json() or {}
        nuevo_estado = data.get("estado")
        if nuevo_estado not in ("activo", "inactivo"):
            return jsonify({"error": "estado debe ser 'activo' o 'inactivo'"}), 400

        response = supabase.table("cursos").update({"estado": nuevo_estado}).eq("id", curso_id).execute()
        if not response.data:
            return jsonify({"error": "Curso no encontrado"}), 404
        return jsonify(response.data[0]), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ADMIN: obtener estudiantes inscritos en un curso
@cursos_bp.route("/<curso_id>/estudiantes", methods=["GET"])
@cross_origin()
def obtener_estudiantes_curso(curso_id):
    try:
        inscritos = supabase.table("estudiante_curso").select("estudiante_id").eq("curso_id", curso_id).execute()
        ids = [r["estudiante_id"] for r in (inscritos.data or []) if r.get("estudiante_id")]

        if not ids:
            return jsonify([]), 200

        users = supabase.table("users").select("id, name, email, role").in_("id", ids).execute()
        return jsonify(users.data or []), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ADMIN: inscribir estudiante en curso
@cursos_bp.route("/<curso_id>/inscribir", methods=["POST"])
@cross_origin()
def inscribir_estudiante(curso_id):
    try:
        data = request.get_json() or {}
        student_id = data.get("student_id", "").strip()
        if not student_id:
            return jsonify({"error": "student_id es requerido"}), 400

        # Verificar que el estudiante existe
        user = supabase.table("users").select("id").eq("id", student_id).execute()
        if not user.data:
            return jsonify({"error": "Estudiante no encontrado"}), 404

        # Verificar que no esté ya inscrito
        existente = supabase.table("estudiante_curso").select("curso_id").eq("curso_id", curso_id).eq("estudiante_id", student_id).execute()
        if existente.data:
            return jsonify({"error": "El estudiante ya está inscrito en este curso"}), 409

        supabase.table("estudiante_curso").insert({"curso_id": curso_id, "estudiante_id": student_id}).execute()
        return jsonify({"mensaje": "Estudiante inscrito correctamente"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ADMIN: desinscribir estudiante de curso
@cursos_bp.route("/<curso_id>/desinscribir/<student_id>", methods=["DELETE"])
@cross_origin()
def desinscribir_estudiante(curso_id, student_id):
    try:
        supabase.table("estudiante_curso").delete().eq("curso_id", curso_id).eq("estudiante_id", student_id).execute()
        return jsonify({"mensaje": "Estudiante desinscrito correctamente"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ADMIN: obtener un curso
@cursos_bp.route("/<curso_id>", methods=["GET"])
@cross_origin()
def obtener_curso(curso_id):
    try:
        res = supabase.table("cursos").select("*").eq("id", curso_id).execute()
        if not res.data:
            return jsonify({"error": "Curso no encontrado"}), 404
        return jsonify(res.data[0]), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ADMIN: crear curso
@cursos_bp.route("", methods=["POST"])
@cross_origin()
def crear_curso():
    try:
        data = request.get_json() or {}
        nombre = (data.get("nombre") or "").strip()
        if not nombre:
            return jsonify({"error": "El nombre es requerido"}), 400

        docente_id = data.get("docente_id") or None
        docente_creado = None

        if data.get("crear_docente"):
            docente_data = data.get("docente") or {}
            email = (docente_data.get("email") or "").strip()
            password = (docente_data.get("password") or "").strip()
            name = (docente_data.get("name") or "").strip()
            if not email or not password or not name:
                return jsonify({
                    "error": "docente.email, docente.password y docente.name son requeridos cuando crear_docente es true"
                }), 400
            docente_creado = crear_docente_en_sistema(email, password, name)
            docente_id = docente_creado["id"]

        import uuid as _uuid
        nuevo = {
            "id": str(_uuid.uuid4()),
            "nombre": nombre,
            "codigo": (data.get("codigo") or "").strip() or None,
            "descripcion": (data.get("descripcion") or "").strip() or None,
            "docente_id": docente_id,
            "estado": "activo",
        }
        res = supabase.table("cursos").insert(nuevo).execute()
        respuesta = res.data[0] if res.data else nuevo
        if docente_creado:
            respuesta["docente_creado"] = docente_creado
        return jsonify(respuesta), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ADMIN: actualizar curso (nombre, código, descripción, docente, estado)
@cursos_bp.route("/<curso_id>", methods=["PUT"])
@cross_origin()
def actualizar_curso(curso_id):
    try:
        data = request.get_json() or {}
        campos = {}
        for key in ("nombre", "codigo", "descripcion"):
            if key in data:
                campos[key] = (data[key] or "").strip() or None
        if "docente_id" in data:
            campos["docente_id"] = data["docente_id"] or None
        if "estado" in data:
            if data["estado"] not in ("activo", "inactivo"):
                return jsonify({"error": "estado inválido"}), 400
            campos["estado"] = data["estado"]
        if not campos:
            return jsonify({"error": "No hay campos para actualizar"}), 400

        res = supabase.table("cursos").update(campos).eq("id", curso_id).execute()
        if not res.data:
            return jsonify({"error": "Curso no encontrado"}), 404
        return jsonify(res.data[0]), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
