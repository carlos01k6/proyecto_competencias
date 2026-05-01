import os

from dotenv import load_dotenv
from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager

from .models import db
from .routes.auth import auth_bp
from .routes.competencias import competencias_bp
from .routes.resultados import resultados_bp
from .routes.criterios import criterios_bp
from .routes.actividades import actividades_bp
from .routes.evidencias import evidencias_bp
from .routes.evaluaciones import evaluaciones_bp
from .routes.reportes import reportes_bp
from .routes.config import config_bp
from .routes.excel import excel_bp
from .routes.evidencias_proyecto import evidencias_proyecto_bp
from .routes.niveles import niveles_bp
from .routes.escalas import escalas_bp
from .routes.retroalimentacion import retroalimentacion_bp
from .routes.auditoria import auditoria_bp
from .routes.boletin import boletin_bp
from .routes.improvement_plans import improvement_plans_bp
from .routes.group_tracking import group_tracking_bp
from .routes.academic_periods import academic_periods_bp
from .routes.re_evaluations import re_evaluations_bp
from .routes.plantillas import plantillas_bp
from .routes.rubricas import rubricas_bp
from .routes.seguimiento import seguimiento_bp
from .routes.cursos import cursos_bp
from .routes.estudiantes import estudiantes_bp
from .routes.estudiantes_curso import estudiantes_curso_bp
from .routes.registro_batch import registro_batch_bp
from .routes.usuarios import usuarios_bp
from .routes.roles import roles_bp
from .routes.asistencia import asistencia_bp
from .routes.exportacion import exportacion_bp
from .routes.correos import correos_bp, mail


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
    CORS(app, origins=["http://localhost:5173", "http://localhost:3000"])
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

    with app.app_context():
        db.create_all()

    @app.route("/api/health", methods=["GET"])
    def health():
        return {"status": "ok"}, 200

    return app
