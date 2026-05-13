from flask import Blueprint, jsonify, request
from supabase import Client
from ..supabase_client import get_supabase

usuarios_bp = Blueprint('usuarios', __name__, url_prefix='/api/usuarios')
supabase: Client = get_supabase()


@usuarios_bp.route('', methods=['GET'])
def listar_usuarios():
    try:
        response = supabase.table('users').select('*').execute()

        usuarios = []
        for user in response.data or []:
            usuarios.append({
                'id': user.get('id'),
                'email': user.get('email'),
                'nombre': user.get('name') or user.get('nombre') or '',
                'role': user.get('role') or '',
                'created_at': user.get('created_at') or ''
            })

        return jsonify(usuarios), 200

    except Exception as e:
        print(f"ERROR LISTAR USUARIOS: {str(e)}")
        return jsonify({'error': str(e)}), 500


@usuarios_bp.route('', methods=['POST'])
def crear_usuario():
    try:
        data = request.get_json()
        email = data.get('email', '').strip()
        password = data.get('password', '').strip()
        name = data.get('name', '').strip()
        role = data.get('role', 'student').strip()

        if not email or not password or not name:
            return jsonify({'error': 'Email, contraseña y nombre son requeridos'}), 400

        if role not in ('student', 'teacher', 'admin'):
            return jsonify({'error': 'Rol inválido'}), 400

        # Verificar si el email ya existe en public.users
        email_check = supabase.table('users').select('id').eq('email', email).limit(1).execute()
        if email_check.data:
            return jsonify({'error': 'Ya existe un usuario con ese email'}), 400

        # Crear en Supabase Auth usando admin (auto-confirma email, más robusto)
        try:
            auth_response = supabase.auth.admin.create_user({
                'email': email,
                'password': password,
                'email_confirm': True,
                'user_metadata': {'name': name}
            })
        except Exception as auth_err:
            msg = str(auth_err).lower()
            if 'already' in msg or 'exists' in msg:
                return jsonify({'error': 'El email ya está registrado en el sistema de autenticación. Elimínalo desde el panel de Supabase y vuelve a intentarlo.'}), 400
            raise

        if not auth_response.user:
            return jsonify({'error': 'No se pudo crear el usuario en Supabase Auth'}), 400

        usuario_id = auth_response.user.id

        # Insertar en public.users
        supabase.table('users').insert({
            'id': usuario_id,
            'email': email,
            'name': name,
            'role': role,
        }).execute()

        # Asignar rol en user_roles
        rol_response = supabase.table('roles').select('id').eq('name', role).execute()
        if not rol_response.data:
            return jsonify({'error': f'Rol "{role}" no encontrado en BD'}), 400

        rol_id = rol_response.data[0]['id']
        supabase.table('user_roles').insert({'user_id': usuario_id, 'role_id': rol_id}).execute()

        return jsonify({
            'mensaje': 'Usuario creado exitosamente',
            'usuario': {
                'id': usuario_id,
                'email': email,
                'nombre': name,
                'role': role
            }
        }), 201

    except Exception as e:
        print(f"ERROR CREAR USUARIO: {str(e)}")
        return jsonify({'error': str(e)}), 400
