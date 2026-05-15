from flask import Blueprint, jsonify, request
from supabase import Client
from ..supabase_client import get_supabase
from .emails import enviar_mensaje, is_valid_email

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

        if not is_valid_email(email):
            return jsonify({'error': 'El formato del email no es válido. Verifica que tenga @dominio.com'}), 400

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

        # Enviar email de bienvenida con credenciales
        if is_valid_email(email):
            try:
                rol_display = {'student': 'Estudiante', 'teacher': 'Docente', 'admin': 'Administrador'}.get(role, role)
                cuerpo = (
                    f"{'='*50}\n"
                    f"  BIENVENIDO AL SISTEMA DE EVALUACION\n"
                    f"{'='*50}\n\n"
                    f"Hola {name},\n\n"
                    f"Tu cuenta ha sido creada exitosamente.\n\n"
                    f"{'='*50}\n"
                    f"  TUS CREDENCIALES DE ACCESO\n"
                    f"{'='*50}\n"
                    f"  Usuario (email) : {email}\n"
                    f"  Contrasena      : {password}\n"
                    f"  Rol             : {rol_display}\n"
                    f"{'='*50}\n\n"
                    f"Por seguridad, te recomendamos cambiar tu\n"
                    f"contrasena despues de iniciar sesion.\n\n"
                    f"Saludos,\n"
                    f"Equipo del Sistema de Evaluacion por Competencias\n"
                    f"{'='*50}"
                )
                enviar_mensaje(email, "Bienvenido - Tus credenciales de acceso", cuerpo)
            except Exception as e:
                print(f"ERROR ENVIAR EMAIL BIENVENIDA: {str(e)}")

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


@usuarios_bp.route('/<user_id>', methods=['PUT'])
def editar_usuario(user_id):
    try:
        data = request.get_json() or {}
        name = (data.get('name') or '').strip()
        role = (data.get('role') or '').strip()

        if not name and not role:
            return jsonify({'error': 'Debes enviar al menos nombre o rol para actualizar'}), 400

        if role and role not in ('student', 'teacher', 'admin'):
            return jsonify({'error': 'Rol inválido'}), 400

        campos = {}
        if name:
            campos['name'] = name
        if role:
            campos['role'] = role

        supabase.table('users').update(campos).eq('id', user_id).execute()

        # Actualizar rol en user_roles si cambió el rol
        if role:
            try:
                rol_response = supabase.table('roles').select('id').eq('name', role).execute()
                if rol_response.data:
                    rol_id = rol_response.data[0]['id']
                    supabase.table('user_roles').delete().eq('user_id', user_id).execute()
                    supabase.table('user_roles').insert({'user_id': user_id, 'role_id': rol_id}).execute()
            except Exception as e:
                print(f"ADVERTENCIA AL ACTUALIZAR ROL: {str(e)}")

        return jsonify({'mensaje': 'Usuario actualizado exitosamente'}), 200

    except Exception as e:
        print(f"ERROR EDITAR USUARIO: {str(e)}")
        return jsonify({'error': str(e)}), 500


@usuarios_bp.route('/<user_id>', methods=['DELETE'])
def eliminar_usuario(user_id):
    try:
        # Verificar que el usuario existe
        user_check = supabase.table('users').select('id, email, name').eq('id', user_id).limit(1).execute()
        if not user_check.data:
            return jsonify({'error': 'Usuario no encontrado'}), 404

        # Eliminar de user_roles
        supabase.table('user_roles').delete().eq('user_id', user_id).execute()

        # Eliminar de public.users
        supabase.table('users').delete().eq('id', user_id).execute()

        # Eliminar de Supabase Auth
        try:
            supabase.auth.admin.delete_user(user_id)
        except Exception as auth_err:
            print(f"ADVERTENCIA: No se pudo eliminar de Auth: {str(auth_err)}")

        return jsonify({'mensaje': 'Usuario eliminado exitosamente'}), 200

    except Exception as e:
        print(f"ERROR ELIMINAR USUARIO: {str(e)}")
        return jsonify({'error': str(e)}), 500
