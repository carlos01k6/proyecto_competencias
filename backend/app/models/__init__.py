from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import bcrypt
import uuid

db = SQLAlchemy()

class Usuario(db.Model):
    __tablename__ = 'usuarios'
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    email = db.Column(db.String(120), unique=True, nullable=False, index=True)
    nombre = db.Column(db.String(255), nullable=False)
    contrasena_hash = db.Column(db.String(255), nullable=False)
    rol = db.Column(db.String(50), default='estudiante')
    activo = db.Column(db.Boolean, default=True)
    fecha_creacion = db.Column(db.DateTime, default=datetime.utcnow)
    
    def set_password(self, password):
        self.contrasena_hash = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt(12)).decode('utf-8')
    
    def check_password(self, password):
        return bcrypt.checkpw(password.encode('utf-8'), self.contrasena_hash.encode('utf-8'))
    
    def to_dict(self):
        return {'id': self.id, 'email': self.email, 'nombre': self.nombre, 'rol': self.rol}

class Competencia(db.Model):
    __tablename__ = 'competencias'
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    nombre = db.Column(db.String(255), nullable=False)
    descripcion = db.Column(db.Text)
    descriptor = db.Column(db.Text, nullable=False)
    asignatura = db.Column(db.String(255), nullable=False)
    docente_id = db.Column(db.String(36), db.ForeignKey('usuarios.id'))
    fecha_creacion = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {'id': self.id, 'nombre': self.nombre, 'asignatura': self.asignatura}

class ResultadoAprendizaje(db.Model):
    __tablename__ = 'resultados_aprendizaje'
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    titulo = db.Column(db.String(255), nullable=False)
    descripcion = db.Column(db.Text)
    competencia_id = db.Column(db.String(36), db.ForeignKey('competencias.id'))
    
    def to_dict(self):
        return {'id': self.id, 'titulo': self.titulo}

class Criterio(db.Model):
    __tablename__ = 'criterios'
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    nombre = db.Column(db.String(255), nullable=False)
    resultado_aprendizaje_id = db.Column(db.String(36), db.ForeignKey('resultados_aprendizaje.id'))
    ponderacion = db.Column(db.Float, default=1.0)
    
    def to_dict(self):
        return {'id': self.id, 'nombre': self.nombre}

class Actividad(db.Model):
    __tablename__ = 'actividades'
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    titulo = db.Column(db.String(255), nullable=False)
    descripcion = db.Column(db.Text)
    resultado_aprendizaje_id = db.Column(db.String(36), db.ForeignKey('resultados_aprendizaje.id'))
    docente_id = db.Column(db.String(36), db.ForeignKey('usuarios.id'))
    fecha_entrega = db.Column(db.DateTime)
    fecha_creacion = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {'id': self.id, 'titulo': self.titulo}

class Evidencia(db.Model):
    __tablename__ = 'evidencias'
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    actividad_id = db.Column(db.String(36), db.ForeignKey('actividades.id'))
    estudiante_id = db.Column(db.String(36), db.ForeignKey('usuarios.id'))
    tipo = db.Column(db.String(50))
    contenido = db.Column(db.Text)
    estado = db.Column(db.String(50), default='pendiente')
    fecha_entrega = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {'id': self.id, 'tipo': self.tipo, 'estado': self.estado}

class Calificacion(db.Model):
    __tablename__ = 'calificaciones'
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    evidencia_id = db.Column(db.String(36), db.ForeignKey('evidencias.id'))
    criterio_id = db.Column(db.String(36), db.ForeignKey('criterios.id'))
    puntaje = db.Column(db.Float)
    comentarios = db.Column(db.Text)
    docente_id = db.Column(db.String(36), db.ForeignKey('usuarios.id'))
    fecha_calificacion = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {'id': self.id, 'puntaje': self.puntaje}

class Periodo(db.Model):
    __tablename__ = 'periodos'
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    nombre = db.Column(db.String(255), nullable=False)
    fecha_inicio = db.Column(db.Date)
    fecha_fin = db.Column(db.Date)
    estado = db.Column(db.String(50), default='activo')
    
    def to_dict(self):
        return {'id': self.id, 'nombre': self.nombre}
        
class Curso(db.Model):
    __tablename__ = 'cursos'
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    nombre = db.Column(db.String(255), nullable=False)
    codigo = db.Column(db.String(50), unique=True)
    descripcion = db.Column(db.Text)
    docente_id = db.Column(db.String(36), db.ForeignKey('usuarios.id'))
    estado = db.Column(db.String(50), default='activo')
    fecha_creacion = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {
            'id': self.id,
            'nombre': self.nombre,
            'codigo': self.codigo,
            'descripcion': self.descripcion,
            'docente_id': self.docente_id,
            'estado': self.estado
        }

class Auditoria(db.Model):
    __tablename__ = 'auditoria'
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    tabla = db.Column(db.String(255))
    usuario_id = db.Column(db.String(36), db.ForeignKey('usuarios.id'))
    accion = db.Column(db.String(50))
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {'id': self.id, 'tabla': self.tabla}