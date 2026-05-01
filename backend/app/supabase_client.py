from supabase import create_client, Client

# Credenciales de Supabase
SUPABASE_URL = "https://skdzcvvkemitkavejvcc.supabase.co"
SUPABASE_SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNrZHpjdnZrZW1pdGthdmVqdmNjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MjcyMDIzNCwiZXhwIjoyMDg4Mjk2MjM0fQ.U6gToqNpMw1PVqzorjooIYuEY_wr6mOtMgrglVTuQrQ"

# Crear cliente de Supabase
supabase: Client = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)

def get_supabase():
    return supabase
