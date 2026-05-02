from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import uuid

criterios_bp = Blueprint('criteria', __name__, url_prefix='/api/criterios')
supabase: Client = get_supabase()

def is_valid_uuid(value):
    try:
        uuid.UUID(str(value))
        return True
    except (TypeError, ValueError):
        return False

def get_user_id_from_token():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    if not token:
        return None
    try:
        user = supabase.auth.get_user(token)
        return user.user.id
    except:
        return None

@criterios_bp.route('', methods=['GET'])
def get_criterios():
    try:
        competencia_id = request.args.get('competencia_id')
        if competencia_id:
            if not is_valid_uuid(competencia_id):
                return jsonify({'mensaje': 'competencia_id debe ser un UUID valido'}), 400

            resultados_response = supabase.table('learning_outcomes').select('id').eq('competency_id', competencia_id).execute()
            resultado_ids = [resultado['id'] for resultado in resultados_response.data]

            if not resultado_ids:
                return jsonify([]), 200

            response = supabase.table('criteria').select('*').in_('learning_outcome_id', resultado_ids).execute()
        else:
            response = supabase.table('criteria').select('*').execute()

        criterios = []
        for criterio in response.data:
            criterios.append({
                **criterio,
                'nombre': criterio.get('nombre') or criterio.get('name'),
                'descripcion': criterio.get('descripcion') or criterio.get('description'),
                'ponderacion': criterio.get('ponderacion') or criterio.get('weighting')
            })

        return jsonify(criterios), 200
    except Exception as e:
        print(f"ERROR GET CRITERIOS: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400

@criterios_bp.route('/resultado/<resultado_id>', methods=['GET'])
def get_criterios_by_resultado(resultado_id):
    try:
        response = supabase.table('criteria').select('*').eq('learning_outcome_id', resultado_id).execute()
        criterios = []
        for criterio in response.data:
            criterios.append({
                **criterio,
                'nombre': criterio.get('nombre') or criterio.get('name'),
                'descripcion': criterio.get('descripcion') or criterio.get('description'),
                'ponderacion': criterio.get('ponderacion') or criterio.get('weighting')
            })
        return jsonify(criterios), 200
    except Exception as e:
        print(f"ERROR GET CRITERIOS: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400

@criterios_bp.route('', methods=['POST'])
def create_criterio():
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'mensaje': 'No autorizado'}), 401
        
        data = request.get_json()
        
        if not data or not data.get('name') or not data.get('learning_outcome_id'):
            return jsonify({'error': 'name y learning_outcome_id son requeridos'}), 400

        if not is_valid_uuid(data.get('learning_outcome_id')):
            return jsonify({'error': 'learning_outcome_id debe ser un UUID valido'}), 400
        
        criterio = {
            'id': str(uuid.uuid4()),
            'learning_outcome_id': data['learning_outcome_id'],
            'name': data['name'],
            'description': data.get('description', ''),
            'weighting': data.get('weighting') if data.get('weighting') is not None else 100,
            'requires_observation': data.get('requires_observation', False)
        }
        
        response = supabase.table('criteria').insert(criterio).execute()
        return jsonify(response.data[0]), 201
        
    except Exception as e:
        print(f"ERROR CREATE CRITERIO: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400

@criterios_bp.route('/<id>', methods=['PUT'])
def update_criterio(id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'mensaje': 'No autorizado'}), 401
        
        data = request.get_json()
        
        update_data = {}
        if 'name' in data:
            update_data['name'] = data['name']
        if 'description' in data:
            update_data['description'] = data['description']
        if 'weighting' in data:
            update_data['weighting'] = data['weighting']
        if 'requires_observation' in data:
            update_data['requires_observation'] = data['requires_observation']
        
        response = supabase.table('criteria').update(update_data).eq('id', id).execute()
        
        if not response.data:
            return jsonify({'mensaje': 'Criterio no encontrado'}), 404
        
        return jsonify(response.data[0]), 200
        
    except Exception as e:
        print(f"ERROR UPDATE CRITERIO: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400

@criterios_bp.route('/<id>', methods=['DELETE'])
def delete_criterio(id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'mensaje': 'No autorizado'}), 401
        
        supabase.table('criteria').delete().eq('id', id).execute()
        return jsonify({'mensaje': 'Criterio eliminado'}), 200
    except Exception as e:
        print(f"ERROR DELETE CRITERIO: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400




