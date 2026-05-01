from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import jwt
from datetime import datetime
import json

academic_periods_bp = Blueprint('academic_periods', __name__, url_prefix='/api/academic-periods')
supabase: Client = get_supabase()

def get_user_id_from_token():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    if not token:
        return None
    try:
        payload = jwt.decode(token, options={"verify_signature": False})
        return payload.get('sub')
    except:
        return None

def parse_period_value(value):
    if not value:
        return {}
    try:
        return json.loads(value)
    except Exception:
        return {'description': value}

def build_period_response(config):
    data = parse_period_value(config.get('value'))
    descripcion = config.get('value') or ''
    return {
        'id': config.get('id'),
        'key': config.get('key'),
        'value': config.get('value') or '',
        'descripcion': descripcion,
        'description': data.get('name') or data.get('description') or descripcion,
        'nombre': data.get('name') or '',
        'tipo': data.get('type') or '',
        'fecha_inicio': data.get('start_date') or '',
        'fecha_fin': data.get('end_date') or '',
        'orden': data.get('order'),
        'activo': data.get('active', True)
    }

# CREAR PERÍODO ACADÉMICO
@academic_periods_bp.route('/crear', methods=['POST'])
def crear_periodo():
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        data = request.get_json()
        
        nombre = data.get('nombre')
        key = f'period_{nombre}'

        existente = supabase.table('configuration').select('id').eq('key', key).execute()
        if existente.data:
            return jsonify({'error': 'Ya existe un período con ese nombre'}), 409

        periodo_data = {
            'name': data.get('nombre'),
            'type': data.get('tipo'),  # bimestre, trimestre, semestre
            'start_date': data.get('fecha_inicio'),
            'end_date': data.get('fecha_fin'),
            'order': data.get('orden', 1),
            'active': data.get('activo', True),
            'created_at': datetime.now().isoformat()
        }

        periodo_response = supabase.table('configuration').insert({
            'key': key,
            'value': data.get('valor') or json.dumps(periodo_data, ensure_ascii=False)
        }).execute()

        return jsonify({
            'mensaje': 'Período creado exitosamente',
            'periodo': build_period_response(periodo_response.data[0]) if periodo_response.data else periodo_data
        }), 201

    except Exception as e:
        print(f"ERROR CREAR PERÍODO: {str(e)}")
        import traceback
        traceback.print_exc()
        if getattr(e, 'code', None) == '23505' or 'duplicate key value violates unique constraint' in str(e):
            return jsonify({'error': 'Ya existe un período con ese nombre'}), 409
        return jsonify({'error': str(e)}), 500

# OBTENER PERÍODOS POR TIPO
@academic_periods_bp.route('/por-tipo/<tipo>', methods=['GET'])
def obtener_periodos_tipo(tipo):
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        # La tabla configuration solo expone key/value para períodos.
        config_response = supabase.table('configuration').select('id, key, value').ilike('key', 'period_%').execute()
        periodos = []
        for config in config_response.data or []:
            periodo = build_period_response(config)
            if periodo.get('tipo') == tipo or tipo in (periodo.get('key') or ''):
                periodos.append(periodo)

        resultado = {
            'tipo': tipo,
            'periodos': periodos,
            'total': len(periodos)
        }

        return jsonify(resultado), 200

    except Exception as e:
        print(f"ERROR OBTENER PERÍODOS: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

# OBTENER CONFIGURACIÓN DE PERÍODOS ACADÉMICOS
@academic_periods_bp.route('/configuracion', methods=['GET'])
def obtener_configuracion_periodos():
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Obtener año académico actual
        year_response = supabase.table('configuration').select('value').eq('key', 'academic_year').execute()
        year = year_response.data[0]['value'] if year_response.data else '2026'

        # Obtener tipo de período configurado
        period_type_response = supabase.table('configuration').select('value').eq('key', 'period_type').execute()
        period_type = period_type_response.data[0]['value'] if period_type_response.data else 'semestre'

        # Obtener períodos del tipo configurado
        periodos_response = supabase.table('configuration').select('id, key, value').ilike('key', 'period_%').execute()
        periodos = []
        for config in periodos_response.data or []:
            periodo = build_period_response(config)
            if periodo.get('tipo') == period_type or period_type in (periodo.get('key') or ''):
                periodos.append(periodo)

        return jsonify({
            'academic_year': year,
            'period_type': period_type,
            'periodos': periodos,
            'disponibles': ['bimestre', 'trimestre', 'semestre']
        }), 200

    except Exception as e:
        print(f"ERROR OBTENER CONFIGURACIÓN: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

# ACTUALIZAR TIPO DE PERÍODO ACADÉMICO
@academic_periods_bp.route('/tipo-periodo', methods=['PUT'])
def actualizar_tipo_periodo():
    try:
        user_id = get_user_id_from_token()
        if not user_id:
            return jsonify({'error': 'No autorizado'}), 401

        data = request.get_json()
        key = 'period_type'
        nuevo_tipo = data.get('value') or data.get('tipo')

        if nuevo_tipo not in ['bimestre', 'trimestre', 'semestre']:
            return jsonify({'error': 'Tipo de período inválido'}), 400

        # Actualizar o crear configuración
        config_response = supabase.table('configuration').select('id').eq('key', key).execute()
        
        if config_response.data:
            supabase.table('configuration').update({'value': nuevo_tipo}).eq('key', key).execute()
        else:
            supabase.table('configuration').insert({
                'key': key,
                'value': nuevo_tipo
            }).execute()

        return jsonify({'mensaje': f'Tipo de período actualizado a {nuevo_tipo}'}), 200

    except Exception as e:
        print(f"ERROR ACTUALIZAR TIPO: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500



