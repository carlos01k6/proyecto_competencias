from backend.supabase_client import get_supabase

supabase = get_supabase()


def main():
    response = supabase.table('users').select('id, email, role').eq('role', 'student').execute()
    estudiantes = response.data or []
    cambios = 0

    for estudiante in estudiantes:
        email = estudiante.get('email', '')
        if email.endswith('@edu.com'):
            nuevo_email = email.replace('@edu.com', '@gmail.com')
            update_resp = supabase.table('users').update({'email': nuevo_email}).eq('id', estudiante['id']).execute()
            if update_resp.error:
                print(f"ERROR al actualizar {email}: {update_resp.error}")
            else:
                print(f"✅ {email} → {nuevo_email}")
                cambios += 1

    print(f"\nTotal de correos actualizados: {cambios}")


if __name__ == '__main__':
    main()
