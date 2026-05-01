from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import jwt

niveles_bp = Blueprint('niveles', __name__, url_prefix='/api/niveles')
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

def obtener_nivel(calificacion):
    calificacion = float(calificacion)
    if calificacion >= 91:
        return {
            'nivel': 'Avanzado',
            'codigo': 'A',
            'color': 'verde',
            'grade': calificacion
        }
    elif calificacion >= 71:
        return {
            'nivel': 'Satisfactorio',
            'codigo': 'S',
            'color': 'azul',
            'grade': calificacion
        }
    elif calificacion >= 41:
        return {
            'nivel': 'Básico',
            'codigo': 'B',
            'color': 'amarillo',
            'grade': calificacion
        }
    else:
        return {
            'nivel': 'Incipiente',
            'codigo': 'I',
            'color': 'rojo',
            'grade': calificacion
        }

# OBTENER NIVEL DE UNA CALIFICACIÓN
@niveles_bp.route('/calificacion/<float:calificacion>', methods=['GET'])
def obtener_nivel_calificacion(calificacion):
    try:
        nivel = obtener_nivel(calificacion)
        return jsonify(nivel), 200
    except Exception as e:
        print(f"ERROR OBTENER NIVEL: {str(e)}")
        return jsonify({'error': str(e)}), 500

# OBTENER NIVELES DE TODAS LAS EVALUACIONES DE UN ESTUDIANTE
@niveles_bp.route('/estudiante/<estudiante_id>', methods=['GET'])
def obtener_niveles_estudiante(estudiante_id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        evaluaciones_response = supabase.table('evaluations').select('*').eq('student_id', estudiante_id).execute()

        resultado = []
        criteria_cache = {}
        outcome_cache = {}

        for evaluacion in evaluaciones_response.data or []:
            criteria_id = evaluacion.get('criteria_id')
            if not criteria_id or evaluacion.get('grade') is None:
                continue

            if criteria_id not in criteria_cache:
                criterio_response = supabase.table('criteria').select('id, name, learning_outcome_id').eq('id', criteria_id).execute()
                criteria_cache[criteria_id] = criterio_response.data[0] if criterio_response.data else {}

            criterio = criteria_cache[criteria_id]
            learning_outcome_id = criterio.get('learning_outcome_id')
            if learning_outcome_id and learning_outcome_id not in outcome_cache:
                outcome_response = supabase.table('learning_outcomes').select('id, title').eq('id', learning_outcome_id).execute()
                outcome_cache[learning_outcome_id] = outcome_response.data[0] if outcome_response.data else {}

            nivel = obtener_nivel(evaluacion['grade'])
            resultado.append({
                'criteria_name': criterio.get('name') or criteria_id,
                'grade': evaluacion['grade'],
                'nivel': nivel['nivel'],
                'color': nivel['color'],
                'fecha_creacion': evaluacion.get('created_at') or evaluacion.get('evaluation_date') or evaluacion.get('grading_date') or ''
            })

        return jsonify(resultado), 200

    except Exception as e:
        print(f"ERROR OBTENER NIVELES ESTUDIANTE: {str(e)}")
        return jsonify({'error': str(e)}), 500

# OBTENER RESUMEN DE NIVELES POR COMPETENCIA
@niveles_bp.route('/competencia/<competencia_id>', methods=['GET'])
def obtener_niveles_competencia(competencia_id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Obtener resultados de la competencia
        resultados_response = supabase.table('learning_outcomes').select('id').eq('competency_id', competencia_id).execute()
        resultado_ids = [r['id'] for r in resultados_response.data]

        distribucion = {'Avanzado': 0, 'Satisfactorio': 0, 'Básico': 0, 'Incipiente': 0}
        total_evaluaciones = 0

        for resultado_id in resultado_ids:
            criterios_response = supabase.table('criteria').select('id').eq('learning_outcome_id', resultado_id).execute()
            for criterio in criterios_response.data:
                evaluaciones_response = supabase.table('evaluations').select('grade').eq('criteria_id', criterio['id']).execute()
                for eval in evaluaciones_response.data:
                    nivel = obtener_nivel(eval['grade'])
                    distribucion[nivel['nivel']] += 1
                    total_evaluaciones += 1

        return jsonify({
            'distribucion': distribucion,
            'total': total_evaluaciones
        }), 200

    except Exception as e:
        print(f"ERROR OBTENER NIVELES COMPETENCIA: {str(e)}")
        return jsonify({'error': str(e)}), 500





