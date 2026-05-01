import sys
sys.path.insert(0, 'backend')

from app import create_app
from app.models import db, Usuario

app = create_app()

with app.app_context():
    usuario_existente = Usuario.query.filter_by(email='test@example.com').first()
    
    if usuario_existente:
        print('Usuario ya existe')
    else:
        usuario = Usuario(
            email='test@example.com',
            nombre='Usuario Prueba',
            rol='docente'
        )
        usuario.set_password('123456')
        db.session.add(usuario)
        db.session.commit()
        print('Usuario creado: test@example.com / 123456')
