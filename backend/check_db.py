from app import create_app
from app.models import db, Usuario

app = create_app()

with app.app_context():
    usuarios = Usuario.query.all()
    print(f"Total de usuarios: {len(usuarios)}")
    for u in usuarios:
        print(f"- {u.email}")
