from flask import Blueprint, request, jsonify
from flask_cors import cross_origin
from supabase import Client
from ..supabase_client import get_supabase
from ..utils.student_codes import generar_codigo_estudiante
import uuid
import jwt

asistencia_bp = Blueprint("asistencia", __name__, url_prefix="/api/asistencia")
supabase: Client = get_supabase()

CURSO_FIJO_ID = "7ab7dd0e-b224-4b3a-81ca-34d47dd61f45"
ESTADOS_VALIDOS = {"presente", "ausente", "tardanza"}


def normalizar_estado(estado):
    estado_normalizado = (estado or "presente").strip().lower()
    return estado_normalizado if estado_normalizado in ESTADOS_VALIDOS else "presente"


def get_user_id_from_token():
    token = request.headers.get("Authorization", "").replace("Bearer ", "")
    if not token:
        return None
    try:
        payload = jwt.decode(token, options={"verify_signature": False})
        return payload.get("sub")
    except Exception:
        return None


@asistencia_bp.route("/<fecha>", methods=["GET"])
@cross_origin()
def obtener_asistencia_fecha(fecha):
    try:
        estudiantes_response = (
            supabase.table("users")
            .select("id, name, email")
            .eq("role", "student")
            .execute()
        )
        asistencias_response = (
            supabase.table("asistencias")
            .select("estudiante_id, estado, observacion")
            .eq("fecha", fecha)
            .execute()
        )

        asistencias_por_estudiante = {
            asistencia["estudiante_id"]: asistencia
            for asistencia in asistencias_response.data or []
        }

        resultado = []
        for estudiante in estudiantes_response.data or []:
            asistencia = asistencias_por_estudiante.get(estudiante["id"])
            codigo_estudiante = generar_codigo_estudiante(estudiante.get("id"), estudiante.get("email"))
            resultado.append(
                {
                    "student_id": estudiante["id"],
                    "codigo_estudiante": codigo_estudiante,
                    "student_code": codigo_estudiante,
                    "student_name": estudiante.get("name") or estudiante.get("email") or "Estudiante",
                    "email": estudiante.get("email") or "",
                    "estado": asistencia.get("estado") if asistencia else None,
                    "observacion": asistencia.get("observacion") if asistencia else "",
                }
            )

        resultado.sort(key=lambda item: (item["student_name"] or "").lower())
        return jsonify(resultado), 200
    except Exception as e:
        print(f"ERROR OBTENER ASISTENCIA: {str(e)}")
        return jsonify({"error": str(e)}), 500


@asistencia_bp.route("/curso/<curso_id>/<fecha>", methods=["GET"])
@cross_origin()
def obtener_asistencia_curso(curso_id, fecha):
    try:
        inscritos_response = (
            supabase.table("estudiante_curso")
            .select("estudiante_id")
            .eq("curso_id", curso_id)
            .execute()
        )
        estudiante_ids = [item["estudiante_id"] for item in inscritos_response.data or []]

        if not estudiante_ids:
            return jsonify([]), 200

        estudiantes_response = (
            supabase.table("users")
            .select("id, name, email")
            .in_("id", estudiante_ids)
            .execute()
        )
        asistencias_response = (
            supabase.table("asistencias")
            .select("estudiante_id, estado, observacion")
            .eq("curso_id", curso_id)
            .eq("fecha", fecha)
            .execute()
        )

        asistencias_por_estudiante = {
            asistencia["estudiante_id"]: asistencia
            for asistencia in asistencias_response.data or []
        }

        resultado = []
        for estudiante in estudiantes_response.data or []:
            asistencia = asistencias_por_estudiante.get(estudiante["id"])
            codigo_estudiante = generar_codigo_estudiante(estudiante.get("id"), estudiante.get("email"))
            resultado.append(
                {
                    "student_id": estudiante["id"],
                    "codigo_estudiante": codigo_estudiante,
                    "student_code": codigo_estudiante,
                    "student_name": estudiante.get("name") or estudiante.get("email") or "Estudiante",
                    "student_email": estudiante.get("email") or "",
                    "estado": asistencia.get("estado") if asistencia else None,
                    "observacion": asistencia.get("observacion") if asistencia else "",
                }
            )

        resultado.sort(key=lambda item: (item["student_name"] or "").lower())
        return jsonify(resultado), 200
    except Exception as e:
        print(f"ERROR OBTENER ASISTENCIA: {str(e)}")
        return jsonify({"error": str(e)}), 500


@asistencia_bp.route("", methods=["POST"])
@cross_origin()
def guardar_asistencia():
    try:
        data = request.get_json() or {}
        docente_id = data.get("docente_id") or get_user_id_from_token()
        curso_id = CURSO_FIJO_ID
        fecha = data.get("fecha")
        asistencias = data.get("asistencias") or []

        if not fecha:
            return jsonify({"error": "fecha es requerida"}), 400

        guardados = 0
        for item in asistencias:
            estudiante_id = item.get("student_id") or item.get("estudiante_id")
            if not estudiante_id:
                continue

            registro = {
                "docente_id": docente_id,
                "estudiante_id": estudiante_id,
                "curso_id": curso_id,
                "fecha": fecha,
                "estado": normalizar_estado(item.get("estado")),
                "observacion": item.get("observacion") or "",
            }

            existente_response = (
                supabase.table("asistencias")
                .select("id")
                .eq("estudiante_id", estudiante_id)
                .eq("fecha", fecha)
                .execute()
            )

            if existente_response.data:
                supabase.table("asistencias").update(registro).eq(
                    "id", existente_response.data[0]["id"]
                ).execute()
            else:
                registro["id"] = str(uuid.uuid4())
                supabase.table("asistencias").insert(registro).execute()
            guardados += 1

        return jsonify({"success": True, "guardados": guardados}), 200
    except Exception as e:
        print(f"ERROR GUARDAR ASISTENCIA: {str(e)}")
        return jsonify({"error": str(e)}), 500


@asistencia_bp.route("/reporte/<estudiante_id>", methods=["GET"])
@cross_origin()
def obtener_reporte_asistencia(estudiante_id):
    try:
        fecha_inicio = request.args.get("fecha_inicio") or request.args.get("desde")
        fecha_fin = request.args.get("fecha_fin") or request.args.get("hasta")
        periodo_id = request.args.get("periodo_id")

        query = (
            supabase.table("asistencias")
            .select("estado")
            .eq("estudiante_id", estudiante_id)
        )

        if fecha_inicio:
            query = query.gte("fecha", fecha_inicio)
        if fecha_fin:
            query = query.lte("fecha", fecha_fin)

        response = query.execute()
        registros = response.data or []

        presentes = sum(1 for item in registros if item.get("estado") == "presente")
        ausentes = sum(1 for item in registros if item.get("estado") == "ausente")
        tardanzas = sum(1 for item in registros if item.get("estado") == "tardanza")
        total_clases = len(registros)
        porcentaje = round(((presentes + tardanzas * 0.5) / total_clases) * 100, 2) if total_clases else 0

        return jsonify(
            {
                "student_id": estudiante_id,
                "codigo_estudiante": generar_codigo_estudiante(estudiante_id),
                "student_code": generar_codigo_estudiante(estudiante_id),
                "periodo_id": periodo_id,
                "fecha_inicio": fecha_inicio,
                "fecha_fin": fecha_fin,
                "total": total_clases,
                "total_clases": total_clases,
                "presentes": presentes,
                "ausentes": ausentes,
                "tardanzas": tardanzas,
                "porcentaje_asistencia": porcentaje,
                "porcentaje": porcentaje,
            }
        ), 200
    except Exception as e:
        print(f"ERROR REPORTE ASISTENCIA: {str(e)}")
        return jsonify({"error": str(e)}), 500
