from app import create_app
from app.models import db

app = create_app()

try:
    with app.app_context():
        print("Conectando a Supabase...")
        print("Creando tablas...")
        db.create_all()
        print("✅ Tablas creadas exitosamente!")
except Exception as e:
    print(f"❌ Error: {e}")
