from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import uuid
import math

evaluaciones_bp = Blueprint('evaluations', __name__, url_prefix='/api/evaluaciones')
supabase: Client = get_supabase()

# LISTAR EVALUACIONES POR CRITERIO
@evaluaciones_bp.route('/criterio/<criterio_id>', methods=['GET'])
def listar_evaluaciones_criterio(criterio_id):
    try:
        response = supabase.table('evaluations').select('*').eq('criteria_id', criterio_id).execute()
        return jsonify(response.data), 200
    except Exception as e:
        print(f"ERROR LISTAR EVALUACIONES CRITERIO: {str(e)}")
        return jsonify({'error': str(e)}), 500

# LISTAR TODAS LAS EVALUACIONES DE UN ESTUDIANTE
@evaluaciones_bp.route('/<estudiante_id>', methods=['GET'])
@evaluaciones_bp.route('/estudiante/<estudiante_id>', methods=['GET'])
def listar_calificaciones_estudiante(estudiante_id):
    try:
        if not estudiante_id or str(estudiante_id) == 'NaN':
            return jsonify({'error': 'student_id invalido'}), 400

        evaluations_response = (
            supabase.table('evaluations')
            .select('*')
            .eq('student_id', estudiante_id)
            .execute()
        )

        calificaciones = []
        criteria_cache = {}
        outcome_cache = {}
        competency_cache = {}

        for evaluation in evaluations_response.data or []:
            criteria_id = evaluation.get('criteria_id')
            if not criteria_id:
                continue

            if criteria_id not in criteria_cache:
                criteria_response = supabase.table('criteria').select('id, name, learning_outcome_id').eq('id', criteria_id).execute()
                criteria_cache[criteria_id] = criteria_response.data[0] if criteria_response.data else {}

            criterio = criteria_cache[criteria_id]
            learning_outcome_id = criterio.get('learning_outcome_id')
            outcome = {}
            competency = {}

            if learning_outcome_id:
                if learning_outcome_id not in outcome_cache:
                    outcome_response = supabase.table('learning_outcomes').select('id, title, competency_id').eq('id', learning_outcome_id).execute()
                    outcome_cache[learning_outcome_id] = outcome_response.data[0] if outcome_response.data else {}

                outcome = outcome_cache[learning_outcome_id]
                competency_id = outcome.get('competency_id')

                if competency_id:
                    if competency_id not in competency_cache:
                        competency_response = supabase.table('competencies').select('id, name').eq('id', competency_id).execute()
                        competency_cache[competency_id] = competency_response.data[0] if competency_response.data else {}
                    competency = competency_cache[competency_id]

            calificaciones.append({
                'competencia_name': competency.get('name') or '',
                'outcome_name': outcome.get('title') or '',
                'criteria_name': criterio.get('name') or criteria_id,
                'grade': evaluation.get('grade'),
                'fecha': evaluation.get('evaluation_date') or evaluation.get('grading_date') or evaluation.get('created_at')
            })

        return jsonify(calificaciones), 200

    except Exception as e:
        print(f"ERROR LISTAR CALIFICACIONES ESTUDIANTE: {str(e)}")
        return jsonify({'error': str(e)}), 500

# LISTAR EVALUACIONES POR ESTUDIANTE Y RESULTADO
@evaluaciones_bp.route('/estudiante/<estudiante_id>/resultado/<resultado_id>', methods=['GET'])
def listar_evaluaciones_estudiante(estudiante_id, resultado_id):
    try:
        # Obtener criterios del resultado
        criterios = supabase.table('criteria').select('id').eq('learning_outcome_id', resultado_id).execute()
        criterios_ids = [c['id'] for c in criterios.data]

        # Si no hay criterios directos, tratar el parametro como competencia_id.
        if not criterios_ids:
            resultados = supabase.table('learning_outcomes').select('id').eq('competency_id', resultado_id).execute()
            resultado_ids = [r['id'] for r in resultados.data]
            if resultado_ids:
                criterios = supabase.table('criteria').select('id').in_('learning_outcome_id', resultado_ids).execute()
                criterios_ids = [c['id'] for c in criterios.data]
        
        # Obtener evaluaciones para esos criterios
        evaluaciones = []
        for criterio_id in criterios_ids:
            response = supabase.table('evaluations').select('*').eq('criteria_id', criterio_id).eq('student_id', estudiante_id).execute()
            evaluaciones.extend(response.data)
        
        return jsonify(evaluaciones), 200
    except Exception as e:
        print(f"ERROR LISTAR EVALUACIONES ESTUDIANTE: {str(e)}")
        return jsonify({'error': str(e)}), 500

# CREAR EVALUACIÓN
@evaluaciones_bp.route('', methods=['POST'])
def crear_evaluacion():
    try:
        data = request.get_json()
        
        if not data.get('criteria_id') or not data.get('student_id') or data.get('grade') is None:
            return jsonify({'mensaje': 'criterio_id, estudiante_id y calificacion son requeridos'}), 400
        
        # Validar que calificación esté entre 0 y 100
        calificacion = float(data.get('grade', 0))
        if calificacion < 0 or calificacion > 100:
            return jsonify({'error': 'La calificación debe estar entre 0 y 100'}), 400
        
        nueva_evaluacion = {
            'id': str(uuid.uuid4()),
            'criteria_id': data.get('criteria_id'),
            'student_id': data.get('student_id'),
            'activity_id': data.get('activity_id'),
            'grade': calificacion,
            'observation': data.get('observation', ''),
            'teacher_id': data.get('teacher_id'),
            'grading_date': data.get('evaluation_date') or data.get('grading_date')
        }
        
        response = supabase.table('evaluations').insert(nueva_evaluacion).execute()
        
        # Calcular y actualizar promedio después de cada evaluación
        actualizar_promedio_resultado(data.get('student_id'), data.get('learning_outcome_id'))
        
        return jsonify(response.data[0]), 201
    except Exception as e:
        print(f"ERROR CREAR EVALUACIÓN: {str(e)}")
        return jsonify({'error': str(e)}), 500

# ACTUALIZAR EVALUACIÓN
@evaluaciones_bp.route('/<evaluacion_id>', methods=['PUT'])
def actualizar_evaluacion(evaluacion_id):
    try:
        data = request.get_json()
        
        calificacion = data.get('grade') if data.get('grade') is not None else data.get('calificacion')
        if calificacion is None:
            return jsonify({'error': 'calificacion es requerida'}), 400

        try:
            calificacion = float(calificacion)
        except (TypeError, ValueError):
            return jsonify({'error': 'calificacion debe ser numerica'}), 400

        if math.isnan(calificacion) or calificacion < 0 or calificacion > 100:
            return jsonify({'error': 'La calificación debe estar entre 0 y 100'}), 400
        
        actualizacion = {
            'grade': calificacion,
            'observation': data.get('observation'),
            'grading_date': data.get('evaluation_date') or data.get('grading_date')
        }
        
        response = supabase.table('evaluations').update(actualizacion).eq('id', evaluacion_id).execute()
        
        # Recalcular promedio
        if response.data:
            evaluacion = response.data[0]
            actualizar_promedio_resultado(evaluacion.get('student_id'), data.get('learning_outcome_id'))
        
        if not response.data:
            return jsonify({'error': 'Evaluacion no encontrada'}), 404

        return jsonify({'success': True, **response.data[0]}), 200
    except Exception as e:
        print(f"ERROR ACTUALIZAR EVALUACIÓN: {str(e)}")
        return jsonify({'error': str(e)}), 500

# ELIMINAR EVALUACIÓN
@evaluaciones_bp.route('/<evaluacion_id>', methods=['DELETE'])
def eliminar_evaluacion(evaluacion_id):
    try:
        supabase.table('evaluations').delete().eq('id', evaluacion_id).execute()
        return jsonify({'mensaje': 'Evaluación eliminada'}), 200
    except Exception as e:
        print(f"ERROR ELIMINAR EVALUACIÓN: {str(e)}")
        return jsonify({'error': str(e)}), 500

# CALCULAR PROMEDIO PONDERADO
def actualizar_promedio_resultado(estudiante_id, resultado_id):
    try:
        # Obtener criterios del resultado
        criterios_response = supabase.table('criteria').select('id, weighting').eq('learning_outcome_id', resultado_id).execute()
        criterios = criterios_response.data
        
        if not criterios:
            return
        
        # Calcular promedio ponderado
        suma_ponderada = 0
        suma_ponderaciones = 0
        
        for criterio in criterios:
            criterio_id = criterio['id']
            ponderacion = criterio['weighting']
            
            # Obtener evaluaciones de este criterio para el estudiante
            evaluaciones_response = supabase.table('evaluations').select('grade').eq('criteria_id', criterio_id).eq('student_id', estudiante_id).execute()
            evaluaciones = evaluaciones_response.data
            
            if evaluaciones:
                # Usar la calificación más reciente
                calificacion = evaluaciones[-1]['grade']
                suma_ponderada += calificacion * (ponderacion / 100)
                suma_ponderaciones += ponderacion
        
        # Calcular promedio final
        if suma_ponderaciones > 0:
            promedio = (suma_ponderada / (suma_ponderaciones / 100))
        else:
            promedio = 0
        
        # Guardar en calificaciones_finales
        calificaciones_response = supabase.table('final_grades').select('id').eq('learning_outcome_id', resultado_id).eq('student_id', estudiante_id).execute()
        
        calificacion_final = {
            'learning_outcome_id': resultado_id,
            'student_id': estudiante_id,
            'average_grade': round(promedio, 2),
            'status': 'calculada',
            'grading_date': 'now()'
        }
        
        if calificaciones_response.data:
            # Actualizar
            supabase.table('final_grades').update(calificacion_final).eq('learning_outcome_id', resultado_id).eq('student_id', estudiante_id).execute()
        else:
            # Crear
            calificacion_final['id'] = str(uuid.uuid4())
            supabase.table('final_grades').insert(calificacion_final).execute()
        
        print(f"Promedio calculado para estudiante {estudiante_id}: {promedio}")
        
    except Exception as e:
        print(f"ERROR CALCULAR PROMEDIO: {str(e)}")




