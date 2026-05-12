from flask import Blueprint, request, jsonify
from flask_cors import cross_origin
from ..supabase_client import get_supabase
import jwt

docentes_bp = Blueprint("docentes", __name__, url_prefix="/api/docentes")
supabase = get_supabase()


def _get_admin_user_id():
    """Returns user_id if token belongs to an admin, else None."""
    token = request.headers.get("Authorization", "").replace("Bearer ", "")
    if not token:
        return None
    try:
        payload = jwt.decode(token, options={"verify_signature": False})
        user_id = payload.get("sub")
        if not user_id:
            return None
        user_resp = supabase.table("users").select("role").eq("id", user_id).execute()
        if not user_resp.data or user_resp.data[0].get("role") != "admin":
            return None
        return user_id
    except Exception:
        return None


def crear_docente_en_sistema(email: str, password: str, name: str) -> dict:
    """Creates a teacher in Supabase Auth and assigns the 'teacher' role. Returns the user dict."""
    auth_response = supabase.auth.sign_up({
        "email": email,
        "password": password,
        "options": {"data": {"name": name}},
    })
    if not auth_response.user:
        raise ValueError("No se pudo crear el usuario en Supabase Auth")

    usuario_id = auth_response.user.id

    rol_response = supabase.table("roles").select("id").eq("name", "teacher").execute()
    if not rol_response.data:
        raise ValueError('Rol "teacher" no encontrado en la base de datos')

    rol_id = rol_response.data[0]["id"]
    supabase.table("user_roles").insert({"user_id": usuario_id, "role_id": rol_id}).execute()

    return {"id": usuario_id, "email": email, "nombre": name, "role": "teacher"}


@docentes_bp.route("", methods=["POST"])
@cross_origin()
def crear_docente():
    if not _get_admin_user_id():
        return jsonify({"error": "Solo el administrador puede crear docentes"}), 403

    data = request.get_json() or {}
    email = (data.get("email") or "").strip()
    password = (data.get("password") or "").strip()
    name = (data.get("name") or "").strip()

    if not email or not password or not name:
        return jsonify({"error": "email, password y name son requeridos"}), 400

    if data.get("role") and data["role"] != "teacher":
        return jsonify({"error": "Este endpoint solo crea docentes (role: teacher)"}), 400

    try:
        docente = crear_docente_en_sistema(email, password, name)
        return jsonify({"mensaje": "Docente creado exitosamente", "docente": docente}), 201
    except Exception as e:
        print(f"ERROR CREAR DOCENTE: {str(e)}")
        return jsonify({"error": str(e)}), 400


@docentes_bp.route("", methods=["GET"])
@cross_origin()
def listar_docentes():
    if not _get_admin_user_id():
        return jsonify({"error": "Solo el administrador puede ver los docentes"}), 403

    try:
        response = supabase.table("users").select("id, email, name, role").eq("role", "teacher").execute()
        docentes = [
            {"id": u["id"], "email": u["email"], "nombre": u.get("name") or "", "role": u["role"]}
            for u in (response.data or [])
        ]
        return jsonify(docentes), 200
    except Exception as e:
        print(f"ERROR LISTAR DOCENTES: {str(e)}")
        return jsonify({"error": str(e)}), 500
