from flask import Blueprint, request, jsonify
from supabase import Client
import json
import jwt
from ..supabase_client import get_supabase

auth_bp = Blueprint('auth', __name__, url_prefix='/api/auth')
supabase: Client = get_supabase()

@auth_bp.route('/signup', methods=['POST'])
def signup():
    try:
        data = request.get_json()
        email = data.get('email')
        password = data.get('password')
        name = data.get('name')
        
        if not email or not password or not name:
            return jsonify({'mensaje': 'Email, contraseña y nombre son requeridos'}), 400
        
        # Registrar usuario en Supabase Auth
        response = supabase.auth.sign_up({
            'email': email,
            'password': password,
            'options': {
                'data': {
                    'name': name
                }
            }
        })
        
        if not response.user:
            return jsonify({'mensaje': 'No se pudo crear el usuario. El email ya puede estar registrado.'}), 400

        usuario_id = response.user.id

        # Insertar en public.users si aún no existe (requerido por FK de user_roles)
        user_check = supabase.table('users').select('id').eq('id', usuario_id).limit(1).execute()
        if not user_check.data:
            supabase.table('users').insert({
                'id': usuario_id,
                'email': email,
                'name': name,
                'role': 'student',
            }).execute()

        # Obtener rol "student" de la BD
        rol_response = supabase.table('roles').select('id').eq('name', 'student').execute()

        if not rol_response.data:
            return jsonify({'mensaje': 'Rol student no encontrado en BD'}), 400

        rol_id = rol_response.data[0]['id']

        # Asignar rol en tabla user_roles
        supabase.table('user_roles').insert({
            'user_id': usuario_id,
            'role_id': rol_id
        }).execute()
        
        return jsonify({
            'mensaje': 'Usuario creado exitosamente',
            'user_id': usuario_id,
            'rol': 'student'
        }), 201
        
    except Exception as e:
        print(f"ERROR SIGNUP: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400

@auth_bp.route('/login', methods=['POST'])
def login():
    try:
        data = request.get_json()
        email = data.get('email')
        password = data.get('password')
        
        if not email or not password:
            return jsonify({'mensaje': 'Email y contraseña son requeridos'}), 400
        
        response = supabase.auth.sign_in_with_password({
            'email': email,
            'password': password
        })
        
        usuario = response.user
        usuario_id = usuario.id
        
        # Obtener usuario DIRECTAMENTE de la tabla users. En algunos entornos el
        # id de Supabase Auth no coincide con public.users, pero el email si.
        user_response = supabase.table('users').select('id, role, name').eq('id', usuario_id).execute()
        if not user_response.data:
            user_response = supabase.table('users').select('id, role, name').eq('email', usuario.email).execute()
        
        if user_response.data:
            usuario_bd = user_response.data[0]
            usuario_id = usuario_bd['id']
            rol = usuario_bd['role']
            nombre = usuario_bd.get('name') or usuario.user_metadata.get('name', 'Usuario')
        else:
            nombre = usuario.user_metadata.get('name', 'Usuario')
            rol = 'student'  # Default
        
        return jsonify({
            'acceso_token': response.session.access_token,
            'usuario': {
                'id': usuario_id,
                'email': usuario.email,
                'name': nombre,
                'rol': rol
            }
        }), 200
        
    except Exception as e:
        print(f"ERROR LOGIN: {str(e)}")
        return jsonify({'mensaje': f'Error: {str(e)}'}), 401

@auth_bp.route('/me', methods=['GET'])
def get_user():
    try:
        token = request.headers.get('Authorization', '').replace('Bearer ', '')
        if not token:
            return jsonify({'mensaje': 'Token requerido'}), 401
        
        payload = jwt.decode(token, options={"verify_signature": False})
        usuario_id = payload.get('sub')
        
        user = supabase.auth.get_user(token)
        
        user_response = supabase.table('users').select('id, role, name').eq('id', usuario_id).execute()
        if not user_response.data:
            user_response = supabase.table('users').select('id, role, name').eq('email', user.user.email).execute()
        
        if user_response.data:
            usuario_bd = user_response.data[0]
            usuario_id = usuario_bd['id']
            rol = usuario_bd['role']
            nombre = usuario_bd.get('name') or user.user.user_metadata.get('name', 'Usuario')
        else:
            rol_response = supabase.table('user_roles').select('roles(name)').eq('user_id', usuario_id).execute()
            nombre = user.user.user_metadata.get('name', 'Usuario')
            if rol_response.data:
                rol = rol_response.data[0]['roles']['name']
            else:
                rol = 'student'
        
        return jsonify({
            'usuario': {
                'id': usuario_id,
                'email': user.user.email,
                'name': nombre,
                'rol': rol
            }
        }), 200
        
    except Exception as e:
        print(f"ERROR ME: {str(e)}")
        return jsonify({'mensaje': 'No autorizado'}), 401



