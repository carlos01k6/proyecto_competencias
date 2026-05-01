from flask import Blueprint, jsonify
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
