from datetime import datetime
import traceback
import uuid

from flask import Blueprint, jsonify, request
import jwt
from supabase import Client

from ..supabase_client import get_supabase

plantillas_bp = Blueprint("plantillas", __name__, url_prefix="/api/plantillas")
supabase: Client = get_supabase()


def get_user_id_from_token():
    token = request.headers.get("Authorization", "").replace("Bearer ", "")
    if not token:
        return None
    try:
        payload = jwt.decode(token, options={"verify_signature": False})
        return payload.get("sub")
    except Exception:
        return None


def normalizar_contenido(contenido):
    if contenido is None:
        return {}
    return contenido if isinstance(contenido, (dict, list)) else {}


@plantillas_bp.route("", methods=["GET"])
def obtener_plantillas():
    try:
        response = (
            supabase.table("plantillas")
            .select("*")
            .order("created_at", desc=True)
            .execute()
        )
        return jsonify(response.data or []), 200
    except Exception as e:
        print(f"ERROR OBTENER PLANTILLAS: {str(e)}")
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500


@plantillas_bp.route("", methods=["POST"])
def crear_plantilla():
    try:
        data = request.get_json() or {}
        nombre = data.get("nombre")

        if not nombre:
            return jsonify({"error": "nombre es requerido"}), 400

        plantilla = {
            "id": str(uuid.uuid4()),
            "nombre": nombre,
            "descripcion": data.get("descripcion") or "",
            "contenido": normalizar_contenido(data.get("contenido")),
            "created_at": datetime.now().isoformat(),
        }

        response = supabase.table("plantillas").insert(plantilla).execute()
        return jsonify(response.data[0] if response.data else plantilla), 201
    except Exception as e:
        print(f"ERROR CREAR PLANTILLA: {str(e)}")
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500


@plantillas_bp.route("/<plantilla_id>", methods=["GET"])
def obtener_plantilla(plantilla_id):
    try:
        response = (
            supabase.table("plantillas")
            .select("*")
            .eq("id", plantilla_id)
            .execute()
        )
        if not response.data:
            return jsonify({"error": "Plantilla no encontrada"}), 404

        return jsonify(response.data[0]), 200
    except Exception as e:
        print(f"ERROR OBTENER PLANTILLA: {str(e)}")
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500


@plantillas_bp.route("/<plantilla_id>", methods=["PUT"])
def actualizar_plantilla(plantilla_id):
    try:
        data = request.get_json() or {}
        update_data = {}

        if "nombre" in data:
            update_data["nombre"] = data.get("nombre")
        if "descripcion" in data:
            update_data["descripcion"] = data.get("descripcion") or ""
        if "contenido" in data:
            update_data["contenido"] = normalizar_contenido(data.get("contenido"))

        if not update_data:
            return jsonify({"error": "No hay datos para actualizar"}), 400
        if not update_data.get("nombre", "valor"):
            return jsonify({"error": "nombre no puede estar vacio"}), 400

        response = (
            supabase.table("plantillas")
            .update(update_data)
            .eq("id", plantilla_id)
            .execute()
        )
        if not response.data:
            return jsonify({"error": "Plantilla no encontrada"}), 404

        return jsonify(response.data[0]), 200
    except Exception as e:
        print(f"ERROR ACTUALIZAR PLANTILLA: {str(e)}")
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500


@plantillas_bp.route("/<plantilla_id>", methods=["DELETE"])
def eliminar_plantilla(plantilla_id):
    try:
        response = (
            supabase.table("plantillas")
            .delete()
            .eq("id", plantilla_id)
            .execute()
        )
        if not response.data:
            return jsonify({"error": "Plantilla no encontrada"}), 404

        return jsonify({"success": True}), 200
    except Exception as e:
        print(f"ERROR ELIMINAR PLANTILLA: {str(e)}")
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500


@plantillas_bp.route("/<plantilla_id>/aplicar/<competencia_id>", methods=["GET"])
def aplicar_plantilla_a_competencia(plantilla_id, competencia_id):
    try:
        docente_id = get_user_id_from_token()
        if not docente_id:
            return jsonify({"error": "No autorizado"}), 401

        plantilla_response = (
            supabase.table("plantillas")
            .select("*")
            .eq("id", plantilla_id)
            .execute()
        )
        if not plantilla_response.data:
            return jsonify({"error": "Plantilla no encontrada"}), 404

        plantilla = plantilla_response.data[0]
        contenido = normalizar_contenido(plantilla.get("contenido"))
        contenido_dict = contenido if isinstance(contenido, dict) else {"niveles": contenido}

        rubrica = {
            "nombre": contenido_dict.get("nombre") or plantilla.get("nombre"),
            "descripcion": contenido_dict.get("descripcion") or plantilla.get("descripcion") or "",
            "docente_id": docente_id,
            "competencia_id": competencia_id,
            "niveles": contenido_dict.get("niveles") or contenido_dict.get("criterios") or [],
        }

        rubrica_response = supabase.table("rubricas").insert(rubrica).execute()
        return jsonify(
            {
                "success": True,
                "mensaje": "Plantilla aplicada a la competencia",
                "rubrica": rubrica_response.data[0] if rubrica_response.data else rubrica,
            }
        ), 201
    except Exception as e:
        print(f"ERROR APLICAR PLANTILLA: {str(e)}")
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500
