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


def enviar_mensaje(destinatario, asunto, cuerpo, adjuntos=None, remitente_nombre=None):
    if not is_valid_email(destinatario):
        raise ValueError(f"Email inválido: {destinatario}")
    from flask import current_app
    email_cuenta = current_app.config.get("MAIL_DEFAULT_SENDER") or current_app.config.get("MAIL_USERNAME")
    sender = (remitente_nombre, email_cuenta) if remitente_nombre else email_cuenta
    msg = Message(subject=asunto, recipients=[destinatario], body=cuerpo, sender=sender)
    for adjunto in adjuntos or []:
        msg.attach(
            adjunto["filename"],
            adjunto["content_type"],
            adjunto["data"],
        )
    mail.send(msg)


def enviar_notificacion_calificacion(student_id: str, activity_id: str, grade: float, observation: str = None, teacher_id: str = None):
    """Notifica al estudiante que se registró o actualizó su calificación. No lanza excepciones."""
    try:
        estudiante = obtener_estudiante(student_id)
        if not estudiante:
            return
        email = estudiante.get("email")
        if not is_valid_email(email):
            print(f"OMITIENDO EMAIL INVALIDO AL NOTIFICAR CALIFICACION: {email}")
            return
        nombre_est = estudiante.get("name") or "Estudiante"
        titulo_actividad = obtener_nombre_actividad(activity_id)

        docente_nombre = "Tu docente"
        if teacher_id:
            docente_resp = supabase.table("users").select("name").eq("id", teacher_id).limit(1).execute()
            if docente_resp.data:
                docente_nombre = docente_resp.data[0].get("name") or "Tu docente"

        nota_str = f"{grade:.1f}" if grade != int(grade) else str(int(grade))
        estado = "Aprobado" if grade >= 60 else "No aprobado"

        cuerpo = (
            f"{'='*50}\n"
            f"  CALIFICACION REGISTRADA\n"
            f"{'='*50}\n\n"
            f"Hola {nombre_est},\n\n"
            f"{docente_nombre} ha registrado tu calificacion.\n\n"
            f"  {titulo_actividad.upper()}\n"
            f"{'-'*50}\n"
            f"  Nota obtenida : {nota_str} / 100\n"
            f"  Estado        : {estado}\n"
        )
        if observation:
            cuerpo += (
                f"\nCOMENTARIO DEL DOCENTE:\n"
                f"{'-'*50}\n"
                f"{observation}\n"
            )
        cuerpo += (
            f"{'-'*50}\n\n"
            f"Ingresa a la plataforma para ver el detalle\n"
            f"completo de tu evaluacion.\n\n"
            f"Saludos,\n"
            f"{docente_nombre}\n"
            f"Sistema de Evaluacion por Competencias\n"
            f"{'='*50}"
        )
        enviar_mensaje(
            email,
            f"[Calificacion] {titulo_actividad} — {nota_str}/100",
            cuerpo,
            remitente_nombre=docente_nombre,
        )
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
