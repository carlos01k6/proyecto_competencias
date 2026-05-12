import re
from flask import Blueprint, jsonify, request
from flask_mail import Mail, Message
from supabase import Client

from ..supabase_client import get_supabase
from .export import crear_pdf_boletin, obtener_boletin_estudiante

correos_bp = Blueprint("correos", __name__, url_prefix="/api/correos")
supabase: Client = get_supabase()
mail = Mail()

EMAIL_REGEX = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")


def is_valid_email(email):
    if not email or not isinstance(email, str):
        return False
    return bool(EMAIL_REGEX.match(email.strip()))


def obtener_estudiante(student_id):
    response = supabase.table("users").select("id, name, email").eq("id", student_id).execute()
    return response.data[0] if response.data else None


def obtener_nombre_competencia(competencia_id):
    if not competencia_id:
        return "Competencia"
    response = supabase.table("competencies").select("name").eq("id", competencia_id).execute()
    if response.data:
        return response.data[0].get("name") or "Competencia"
    return "Competencia"


def obtener_nombre_actividad(actividad_id):
    if not actividad_id:
        return "Actividad"
    response = supabase.table("activities").select("title, name").eq("id", actividad_id).execute()
    if response.data:
        actividad = response.data[0]
        return actividad.get("title") or actividad.get("name") or "Actividad"
    return "Actividad"


def enviar_mensaje(destinatario, asunto, cuerpo, adjuntos=None):
    if not is_valid_email(destinatario):
        raise ValueError(f"Email inválido: {destinatario}")
    msg = Message(subject=asunto, recipients=[destinatario], body=cuerpo)
    for adjunto in adjuntos or []:
        msg.attach(
            adjunto["filename"],
            adjunto["content_type"],
            adjunto["data"],
        )
    mail.send(msg)


def enviar_notificacion_calificacion(student_id: str, activity_id: str, grade: float, observation: str = None):
    """Notifica al estudiante que se registró o actualizó su calificación. No lanza excepciones."""
    try:
        estudiante = obtener_estudiante(student_id)
        if not estudiante:
            return
        email = estudiante.get("email")
        if not is_valid_email(email):
            print(f"OMITIENDO EMAIL INVALIDO AL NOTIFICAR CALIFICACION: {email}")
            return
        nombre = estudiante.get("name") or "estudiante"
        titulo_actividad = obtener_nombre_actividad(activity_id)
        lineas = [
            f"Hola {nombre},",
            "",
            f"Se ha registrado una calificacion en la actividad: {titulo_actividad}.",
            "",
            f"Nota obtenida: {grade}/100",
        ]
        if observation:
            lineas += ["", f"Comentario del docente:\n{observation}"]
        lineas += ["", "Sistema de Evaluacion por Competencias"]
        enviar_mensaje(email, f"Calificacion registrada - {titulo_actividad}", "\n".join(lineas))
    except Exception as e:
        print(f"ERROR ENVIAR NOTIFICACION CALIFICACION: {str(e)}")


@correos_bp.route("/retroalimentacion", methods=["POST"])
def enviar_retroalimentacion():
    try:
        data = request.get_json() or {}
        student_id = data.get("student_id")
        competencia_id = data.get("competencia_id")
        mensaje = data.get("mensaje")

        if not student_id or not competencia_id or not mensaje:
            return jsonify({"error": "student_id, competencia_id y mensaje son requeridos"}), 400

        estudiante = obtener_estudiante(student_id)
        if not estudiante or not estudiante.get("email"):
            return jsonify({"error": "Estudiante sin email registrado"}), 404

        competencia = obtener_nombre_competencia(competencia_id)
        cuerpo = (
            f"Hola {estudiante.get('name') or 'estudiante'},\n\n"
            f"Retroalimentacion sobre {competencia}:\n\n"
            f"{mensaje}\n\n"
            "Sistema de Evaluacion por Competencias"
        )
        enviar_mensaje(estudiante["email"], f"Retroalimentacion - {competencia}", cuerpo)

        return jsonify({"success": True}), 200
    except Exception as e:
        print(f"ERROR ENVIAR RETROALIMENTACION: {str(e)}")
        return jsonify({"error": str(e)}), 500


@correos_bp.route("/boletin", methods=["POST"])
@correos_bp.route("/boletín", methods=["POST"])
def enviar_boletin():
    try:
        data = request.get_json() or {}
        student_id = data.get("student_id")

        if not student_id:
            return jsonify({"error": "student_id es requerido"}), 400

        estudiante = obtener_estudiante(student_id)
        if not estudiante or not estudiante.get("email"):
            return jsonify({"error": "Estudiante sin email registrado"}), 404

        boletin = obtener_boletin_estudiante(student_id)
        pdf_buffer = crear_pdf_boletin(boletin)
        cuerpo = (
            f"Hola {estudiante.get('name') or 'estudiante'},\n\n"
            "Adjuntamos tu boletin individual en PDF.\n\n"
            "Sistema de Evaluacion por Competencias"
        )
        enviar_mensaje(
            estudiante["email"],
            "Boletin individual",
            cuerpo,
            [
                {
                    "filename": f"boletin_{student_id}.pdf",
                    "content_type": "application/pdf",
                    "data": pdf_buffer.getvalue(),
                }
            ],
        )

        return jsonify({"success": True}), 200
    except Exception as e:
        print(f"ERROR ENVIAR BOLETIN: {str(e)}")
        return jsonify({"error": str(e)}), 500


@correos_bp.route("/notificacion-re-evaluacion", methods=["POST"])
def enviar_notificacion_re_evaluacion():
    try:
        data = request.get_json() or {}
        student_id = data.get("student_id")
        actividad_id = data.get("actividad_id")

        if not student_id or not actividad_id:
            return jsonify({"error": "student_id y actividad_id son requeridos"}), 400

        estudiante = obtener_estudiante(student_id)
        if not estudiante or not estudiante.get("email"):
            return jsonify({"error": "Estudiante sin email registrado"}), 404

        actividad = obtener_nombre_actividad(actividad_id)
        cuerpo = (
            f"Hola {estudiante.get('name') or 'estudiante'},\n\n"
            f"Ya puedes realizar la re-evaluacion de la actividad: {actividad}.\n\n"
            "Sistema de Evaluacion por Competencias"
        )
        enviar_mensaje(estudiante["email"], "Notificacion de re-evaluacion", cuerpo)

        return jsonify({"success": True}), 200
    except Exception as e:
        print(f"ERROR ENVIAR NOTIFICACION RE-EVALUACION: {str(e)}")
        return jsonify({"error": str(e)}), 500
