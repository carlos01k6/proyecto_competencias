from flask import Blueprint, jsonify
from supabase import Client
from ..supabase_client import get_supabase

roles_bp = Blueprint('roles', __name__, url_prefix='/api/roles')
supabase: Client = get_supabase()


@roles_bp.route('', methods=['GET'])
def listar_roles():
    try:
        response = supabase.table('roles').select('*').execute()

        roles = []
        for role in response.data or []:
            roles.append({
                'id': role.get('id'),
                'nombre': role.get('name') or role.get('nombre') or '',
                'descripcion': role.get('description') or role.get('descripcion') or ''
            })

        return jsonify(roles), 200

    except Exception as e:
        print(f"ERROR LISTAR ROLES: {str(e)}")
        return jsonify({'error': str(e)}), 500


@roles_bp.route('/<role_id>/permisos', methods=['GET'])
def listar_permisos_rol(role_id):
    try:
        permisos_por_rol = {
            "admin": [
                {"id": "1", "nombre": "Gestionar usuarios", "accion": "users.manage"},
                {"id": "2", "nombre": "Ver reportes", "accion": "reports.view"},
                {"id": "3", "nombre": "Configurar sistema", "accion": "config.manage"}
            ],
            "teacher": [
                {"id": "4", "nombre": "Calificar", "accion": "grades.create"},
                {"id": "5", "nombre": "Ver competencias", "accion": "competencies.view"},
                {"id": "6", "nombre": "Crear actividades", "accion": "activities.create"}
            ],
            "student": [
                {"id": "7", "nombre": "Ver calificaciones", "accion": "grades.view"},
                {"id": "8", "nombre": "Subir evidencias", "accion": "evidence.upload"}
            ]
        }

        role_response = supabase.table('roles').select('name').eq('id', role_id).execute()
        role = role_response.data[0].get('name') if role_response.data else role_id

        return jsonify(permisos_por_rol.get(role, [])), 200

    except Exception as e:
        print(f"ERROR LISTAR PERMISOS ROL: {str(e)}")
        return jsonify([]), 200
