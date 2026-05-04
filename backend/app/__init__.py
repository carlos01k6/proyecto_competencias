import os
from functools import wraps

from dotenv import load_dotenv
from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_jwt_extended import JWTManager

from .models import db
from .routes.auth import auth_bp
from .routes.competencies import competencias_bp
from .routes.outcomes import resultados_bp
from .routes.criteria import criterios_bp
from .routes.activities import actividades_bp
from .routes.evidence import evidencias_bp
from .routes.evaluations import evaluaciones_bp
from .routes.reports import reportes_bp
from .routes.config import config_bp
from .routes.excel import excel_bp
from .routes.project_evidence import evidencias_proyecto_bp
from .routes.levels import niveles_bp
from .routes.scales import escalas_bp
from .routes.feedback import retroalimentacion_bp
from .routes.audit import auditoria_bp
from .routes.bulletin import boletin_bp
from .routes.improvement_plans import improvement_plans_bp
from .routes.group_tracking import group_tracking_bp
from .routes.academic_periods import academic_periods_bp
from .routes.re_evaluations import re_evaluations_bp, re_evaluations_es_bp
from .routes.templates import plantillas_bp
from .routes.rubrics import rubricas_bp
from .routes.tracking import seguimiento_bp
from .routes.courses import cursos_bp
from .routes.students import estudiantes_bp
from .routes.course_students import estudiantes_curso_bp
from .routes.batch_registration import registro_batch_bp
from .routes.users import usuarios_bp
from .routes.roles import roles_bp
from .routes.attendance import asistencia_bp
from .routes.export import exportacion_bp
from .routes.emails import correos_bp, mail
from .routes.notificaciones import notificaciones_bp


def get_user_role_from_token():
    token = request.headers.get("Authorization", "").replace("Bearer ", "")
    if not token:
        return None
    try:
        import jwt
        payload = jwt.decode(token, options={"verify_signature": False})
        return (payload.get("role") or payload.get("rol") or payload.get("user_role") or "").lower()
    except Exception:
        return None


def requiere_admin_o_docente():
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            role = get_user_role_from_token()
            if role not in ["admin", "docente", "teacher"]:
                return jsonify({"error": "No autorizado"}), 403
            return f(*args, **kwargs)
        return decorated_function
    return decorator


def create_app():
    load_dotenv()
    app = Flask(__name__)
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///competencias.db"
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.config["JWT_SECRET_KEY"] = os.getenv("JWT_SECRET_KEY", "tu-clave-secreta-cambiar-en-produccion")
    app.config["JSON_SORT_KEYS"] = False
    app.config["MAIL_SERVER"] = os.getenv("MAIL_SERVER", "smtp.gmail.com")
    app.config["MAIL_PORT"] = int(os.getenv("MAIL_PORT", "587"))
    app.config["MAIL_USE_TLS"] = os.getenv("MAIL_USE_TLS", "true").lower() == "true"
    app.config["MAIL_USE_SSL"] = os.getenv("MAIL_USE_SSL", "false").lower() == "true"
    app.config["MAIL_USERNAME"] = os.getenv("MAIL_USERNAME")
    app.config["MAIL_PASSWORD"] = os.getenv("MAIL_PASSWORD")
    app.config["MAIL_DEFAULT_SENDER"] = os.getenv("MAIL_DEFAULT_SENDER") or os.getenv("MAIL_USERNAME")

    db.init_app(app)
    mail.init_app(app)
    CORS(app,
         origins=["http://localhost:5173", "http://localhost:3000"],
         supports_credentials=True,
         allow_headers=["Content-Type", "Authorization"],
         expose_headers=["Content-Type", "Authorization"])
    JWTManager(app)

    app.register_blueprint(auth_bp)
    app.register_blueprint(competencias_bp)
    app.register_blueprint(resultados_bp)
    app.register_blueprint(criterios_bp)
    app.register_blueprint(actividades_bp)
    app.register_blueprint(evidencias_bp)
    app.register_blueprint(evaluaciones_bp)
    app.register_blueprint(reportes_bp)
    app.register_blueprint(config_bp)
    app.register_blueprint(excel_bp)
    app.register_blueprint(evidencias_proyecto_bp)
    app.register_blueprint(niveles_bp)
    app.register_blueprint(escalas_bp)
    app.register_blueprint(retroalimentacion_bp)
    app.register_blueprint(auditoria_bp)
    app.register_blueprint(boletin_bp)
    app.register_blueprint(improvement_plans_bp)
    app.register_blueprint(group_tracking_bp)
    app.register_blueprint(academic_periods_bp)
    app.register_blueprint(re_evaluations_bp)
    app.register_blueprint(re_evaluations_es_bp)
    app.register_blueprint(plantillas_bp)
    app.register_blueprint(rubricas_bp)
    app.register_blueprint(seguimiento_bp)
    app.register_blueprint(cursos_bp)
    app.register_blueprint(estudiantes_bp)
    app.register_blueprint(estudiantes_curso_bp)
    app.register_blueprint(registro_batch_bp)
    app.register_blueprint(usuarios_bp)
    app.register_blueprint(roles_bp)
    app.register_blueprint(asistencia_bp)
    app.register_blueprint(exportacion_bp)
    app.register_blueprint(correos_bp)
    app.register_blueprint(notificaciones_bp)

    with app.app_context():
        db.create_all()

    @app.route("/api/health", methods=["GET"])
    def health():
        return {"status": "ok"}, 200

    return app
