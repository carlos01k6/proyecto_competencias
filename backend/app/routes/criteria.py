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


def learning_outcome_exists(learning_outcome_id):
    response = supabase.table('learning_outcomes').select('id').eq('id', learning_outcome_id).limit(1).execute()
    return bool(response.data)


def normalize_criterio(criterio, outcomes_cache=None):
    outcomes_cache = outcomes_cache if outcomes_cache is not None else {}
    learning_outcome_id = criterio.get('learning_outcome_id')
    learning_outcome = None
    if learning_outcome_id:
        if learning_outcome_id not in outcomes_cache:
            outcome_response = supabase.table('learning_outcomes').select('id, title, competency_id').eq('id', learning_outcome_id).limit(1).execute()
            outcomes_cache[learning_outcome_id] = outcome_response.data[0] if outcome_response.data else None
        learning_outcome = outcomes_cache.get(learning_outcome_id)

    return {
        **criterio,
        'nombre': criterio.get('nombre') or criterio.get('name'),
        'descripcion': criterio.get('descripcion') or criterio.get('description'),
        'ponderacion': criterio.get('ponderacion') or criterio.get('weighting'),
        'learning_outcome_id': learning_outcome_id,
        'learning_outcome': learning_outcome,
        'learning_outcome_nombre': (learning_outcome or {}).get('title')
    }

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

        outcomes_cache = {}
        criterios = [normalize_criterio(criterio, outcomes_cache) for criterio in (response.data or [])]

        return jsonify(criterios), 200
    except Exception as e:
        print(f"ERROR GET CRITERIOS: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400

@criterios_bp.route('/resultado/<resultado_id>', methods=['GET'])
def get_criterios_by_resultado(resultado_id):
    try:
        response = supabase.table('criteria').select('*').eq('learning_outcome_id', resultado_id).execute()
        criterios = [normalize_criterio(criterio) for criterio in (response.data or [])]
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
        
        nombre = data.get('name') or data.get('nombre')
        descripcion = data.get('description') or data.get('descripcion') or ''
        ponderacion = data.get('weighting') if data.get('weighting') is not None else data.get('ponderacion')
        learning_outcome_id = data.get('learning_outcome_id')

        if not data or not nombre or not learning_outcome_id:
            return jsonify({'error': 'nombre y learning_outcome_id son requeridos'}), 400

        if not is_valid_uuid(learning_outcome_id):
            return jsonify({'error': 'learning_outcome_id debe ser un UUID valido'}), 400

        if not learning_outcome_exists(learning_outcome_id):
            return jsonify({'error': 'learning_outcome_id no existe'}), 400
        
        criterio = {
            'id': str(uuid.uuid4()),
            'learning_outcome_id': learning_outcome_id,
            'name': nombre,
            'description': descripcion,
            'weighting': ponderacion if ponderacion is not None else 100,
            'requires_observation': data.get('requires_observation', False)
        }
        
        response = supabase.table('criteria').insert(criterio).execute()
        return jsonify(response.data[0]), 201
        
    except Exception as e:
        print(f"ERROR CREATE CRITERIO: {str(e)}")
        return jsonify({'mensaje': str(e)}), 400


@criterios_bp.route('/<competencia_id>', methods=['GET'])
def get_criterios_by_competencia(competencia_id):
    try:
        if not is_valid_uuid(competencia_id):
            return jsonify({'mensaje': 'competencia_id debe ser un UUID valido'}), 400

        resultados_response = supabase.table('learning_outcomes').select('id, title, competency_id').eq('competency_id', competencia_id).execute()
        outcomes = resultados_response.data or []
        outcome_ids = [resultado['id'] for resultado in outcomes]
        if not outcome_ids:
            return jsonify([]), 200

        outcomes_cache = {outcome['id']: outcome for outcome in outcomes}
        response = supabase.table('criteria').select('*').in_('learning_outcome_id', outcome_ids).execute()
        criterios = [normalize_criterio(criterio, outcomes_cache) for criterio in (response.data or [])]
        return jsonify(criterios), 200
    except Exception as e:
        print(f"ERROR GET CRITERIOS COMPETENCIA: {str(e)}")
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




