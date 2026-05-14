from flask import Blueprint, jsonify, request
from supabase import Client
from ..supabase_client import get_supabase
import uuid

notificaciones_bp = Blueprint("notificaciones", __name__, url_prefix="/api/notificaciones")
supabase: Client = get_supabase()


def crear_notificacion_estudiante(estudiante_id, titulo, mensaje, tipo):
    notificacion = {
        "id": str(uuid.uuid4()),
        "estudiante_id": estudiante_id,
        "titulo": titulo,
        "mensaje": mensaje,
        "tipo": tipo,
        "leida": False,
    }
    response = supabase.table("notificaciones").insert(notificacion).execute()
    data = response.data[0] if response.data else notificacion
    return data.get("id")


@notificaciones_bp.route("/<student_id>", methods=["GET"])
def obtener_notificaciones(student_id):
    try:
        response = (
            supabase.table("notificaciones")
            .select("id, titulo, mensaje, tipo, leida, created_at")
            .eq("estudiante_id", student_id)
            .eq("leida", False)
            .order("created_at", desc=True)
            .execute()
        )
        return jsonify(response.data or []), 200
    except Exception as e:
        print(f"ERROR OBTENER NOTIFICACIONES: {str(e)}")
        return jsonify([]), 200


@notificaciones_bp.route("/<notificacion_id>/leer", methods=["PUT"])
def marcar_notificacion_leida(notificacion_id):
    try:
        supabase.table("notificaciones").update({"leida": True}).eq("id", notificacion_id).execute()
        return jsonify({"success": True}), 200
    except Exception as e:
        print(f"ERROR MARCAR NOTIFICACION LEIDA: {str(e)}")
        return jsonify({"error": str(e)}), 500


@notificaciones_bp.route("", methods=["POST"])
def crear_notificacion():
    try:
        data = request.get_json() or {}
        estudiante_id = data.get("estudiante_id")
        titulo = data.get("titulo")
        mensaje = data.get("mensaje")
        tipo = data.get("tipo")

        if not estudiante_id or not titulo or mensaje is None or not tipo:
            return jsonify({"error": "estudiante_id, titulo, mensaje y tipo son requeridos"}), 400

        notificacion_id = crear_notificacion_estudiante(estudiante_id, titulo, mensaje, tipo)
        return jsonify({"success": True, "id": notificacion_id}), 201
    except Exception as e:
        print(f"ERROR CREAR NOTIFICACION: {str(e)}")
        return jsonify({"error": str(e)}), 500
