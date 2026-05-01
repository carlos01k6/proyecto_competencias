from app import create_app

app = create_app()
print(f"Base de datos: {app.config['SQLALCHEMY_DATABASE_URI']}")
