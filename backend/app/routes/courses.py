from flask import Blueprint, request, jsonify
from flask_cors import cross_origin
from ..supabase_client import get_supabase

cursos_bp = Blueprint("cursos", __name__, url_prefix="/api/cursos")
supabase = get_supabase()

@cursos_bp.route("/docente/<docente_id>", methods=["GET"])
@cross_origin()
def obtener_cursos_docente(docente_id):
    """Obtiene los cursos asignados a un docente"""
    print(f"🔍 PETICIÓN A CURSOS: docente_id = {docente_id}")
    try:
        response = supabase.table("cursos").select("*").eq("docente_id", docente_id).execute()
        cursos = response.data if response.data else []
        print(f"✅ Cursos encontrados: {len(cursos)}")
        return jsonify(cursos), 200
    except Exception as e:
        print(f"❌ ERROR CURSOS: {str(e)}")
        return jsonify({"error": str(e)}), 500
