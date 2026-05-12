from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
from .emails import enviar_notificacion_calificacion
import uuid
import math
import jwt
import requests

evaluaciones_bp = Blueprint('evaluations', __name__, url_prefix='/api/evaluaciones')
supabase: Client = get_supabase()


def _registrar_auditoria(user_id, action, record_id, student_id, criteria_id,
                          calificacion_anterior=None, calificacion_nueva=None,
                          observation=None, action_date=None):
    try:
        from datetime import datetime
        supabase.table('audits').insert({
            'user_id': user_id,
            'action': action,
            'tabla_afectada': 'evaluations',
            'record_id': record_id,
            'student_id': student_id,
            'criteria_id': criteria_id,
            'calificacion_anterior': calificacion_anterior,
            'calificacion_nueva': calificacion_nueva,
            'observation': observation,
            'action_date': action_date or datetime.now().isoformat()
        }).execute()
    except Exception as e:
        print(f"AUDITORIA (no crítico): {e}")


def get_user_id_from_token():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    if not token:
        return None
    try:
        payload = jwt.decode(token, options={"verify_signature": False})
        token_user_id = payload.get('sub')
        user_response = supabase.table('users').select('id').eq('id', token_user_id).limit(1).execute()
        if user_response.data:
            return token_user_id
        email = payload.get('email')
        if email:
            user_response = supabase.table('users').select('id').eq('email', email).limit(1).execute()
            if user_response.data:
                return user_response.data[0]['id']
    except Exception:
        pass
    return None


def obtener_criterio_para_actividad(activity_id, criteria_id=None):
    if criteria_id:
        return criteria_id, None

    actividad_response = supabase.table('activities').select('id, title, learning_outcome_id').eq('id', activity_id).limit(1).execute()
    actividad = actividad_response.data[0] if actividad_response.data else {}
    learning_outcome_id = actividad.get('learning_outcome_id')
    if not learning_outcome_id:
        return None, None

    criterios_response = (
        supabase.table('criteria')
        .select('id')
        .eq('learning_outcome_id', learning_outcome_id)
        .limit(1)
        .execute()
    )
    if criterios_response.data:
        return criterios_response.data[0]['id'], learning_outcome_id

    criterio = {
        'id': str(uuid.uuid4()),
        'name': f"Evaluación de {actividad.get('title') or 'actividad'}",
        'learning_outcome_id': learning_outcome_id,
        'weighting': 100
    }
    response = supabase.table('criteria').insert(criterio).execute()
    creado = response.data[0] if response.data else criterio
    return creado['id'], learning_outcome_id


def obtener_actividad_relacionada(criteria_id):
    if not criteria_id:
        return None

    criterio_response = supabase.table('criteria').select('learning_outcome_id').eq('id', criteria_id).limit(1).execute()
    if not criterio_response.data:
        return None

    learning_outcome_id = criterio_response.data[0].get('learning_outcome_id')
    if not learning_outcome_id:
        return None

    actividad_response = (
        supabase.table('activities')
        .select('id')
        .eq('learning_outcome_id', learning_outcome_id)
        .limit(1)
        .execute()
    )
    if actividad_response.data:
        return actividad_response.data[0]['id']

    actividad = {
        'id': str(uuid.uuid4()),
        'learning_outcome_id': learning_outcome_id,
        'title': 'Evaluación de competencia',
        'description': 'Actividad generada para registrar calificaciones por competencia.',
        'type': 'evaluacion',
        'max_score': 100,
        'status': 'active'
    }
    response = supabase.table('activities').insert(actividad).execute()
    creada = response.data[0] if response.data else actividad
    return creada['id']

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
        
        activity_id = data.get('activity_id') or obtener_actividad_relacionada(data.get('criteria_id'))
        if not activity_id:
            return jsonify({'error': 'No se pudo asociar la evaluacion a una actividad'}), 400

        nueva_evaluacion = {
            'id': str(uuid.uuid4()),
            'criteria_id': data.get('criteria_id'),
            'student_id': data.get('student_id'),
            'activity_id': activity_id,
            'grade': calificacion,
            'observation': data.get('observation', ''),
            'teacher_id': data.get('teacher_id'),
            'grading_date': data.get('evaluation_date') or data.get('grading_date')
        }
        
        response = supabase.table('evaluations').insert(nueva_evaluacion).execute()
        creada = response.data[0] if response.data else nueva_evaluacion

        _registrar_auditoria(
            user_id=data.get('teacher_id') or get_user_id_from_token(),
            action='crear',
            record_id=creada.get('id'),
            student_id=data.get('student_id'),
            criteria_id=data.get('criteria_id'),
            calificacion_nueva=calificacion,
            observation=data.get('observation'),
            action_date=creada.get('grading_date') or creada.get('created_at')
        )

        actualizar_promedio_resultado(data.get('student_id'), data.get('learning_outcome_id'))

        enviar_notificacion_calificacion(
            data.get('student_id'),
            activity_id,
            calificacion,
            data.get('observation'),
            teacher_id=data.get('teacher_id') or get_user_id_from_token(),
        )

        # Crear snapshot de progreso
        try:
            crit_res = supabase.table('criteria').select('learning_outcome_id').eq('id', data.get('criteria_id')).execute()
            lo_id = crit_res.data[0].get('learning_outcome_id') if crit_res.data else None
            if lo_id:
                lo_res = supabase.table('learning_outcomes').select('competency_id').eq('id', lo_id).execute()
                comp_id = lo_res.data[0].get('competency_id') if lo_res.data else None
                if comp_id:
                    # Llamar a crear snapshot
                    import requests
                    base_url = request.host_url.rstrip('/')
                    requests.post(f"{base_url}/api/historial/crear-snapshot/{data.get('student_id')}/{comp_id}", 
                                  json={'fecha': nueva_evaluacion.get('grading_date')}, 
                                  headers={'Authorization': request.headers.get('Authorization')})
        except Exception as snap_e:
            print(f"Error creando snapshot: {snap_e}")

        return jsonify(creada), 201
    except Exception as e:
        print(f"ERROR CREAR EVALUACIÓN: {str(e)}")
        return jsonify({'error': str(e)}), 500


@evaluaciones_bp.route('/actividad', methods=['POST'])
def calificar_actividad():
    try:
        data = request.get_json() or {}
        student_id = data.get('student_id')
        activity_id = data.get('activity_id')
        grade = data.get('grade')

        if not student_id or not activity_id or grade is None:
            return jsonify({'error': 'student_id, activity_id y grade son requeridos'}), 400

        try:
            calificacion = float(grade)
        except (TypeError, ValueError):
            return jsonify({'error': 'grade debe ser numerico'}), 400

        if calificacion < 0 or calificacion > 100:
            return jsonify({'error': 'La calificación debe estar entre 0 y 100'}), 400

        criteria_id, learning_outcome_id = obtener_criterio_para_actividad(activity_id, data.get('criteria_id'))
        if not criteria_id:
            return jsonify({'error': 'La actividad no está asociada a una competencia/resultado'}), 400

        existente_response = (
            supabase.table('evaluations')
            .select('id')
            .eq('student_id', student_id)
            .eq('activity_id', activity_id)
            .eq('criteria_id', criteria_id)
            .limit(1)
            .execute()
        )

        payload = {
            'criteria_id': criteria_id,
            'student_id': student_id,
            'activity_id': activity_id,
            'grade': calificacion,
            'observation': data.get('observation') or '',
            'teacher_id': data.get('teacher_id') or get_user_id_from_token(),
            'grading_date': data.get('evaluation_date') or data.get('grading_date')
        }

        teacher_id = data.get('teacher_id') or get_user_id_from_token()

        if existente_response.data:
            eval_existente = existente_response.data[0]
            cal_anterior_resp = supabase.table('evaluations').select('grade').eq('id', eval_existente['id']).limit(1).execute()
            cal_anterior = cal_anterior_resp.data[0].get('grade') if cal_anterior_resp.data else None
            response = supabase.table('evaluations').update(payload).eq('id', eval_existente['id']).execute()
            action = 'actualizar'
        else:
            cal_anterior = None
            payload['id'] = str(uuid.uuid4())
            response = supabase.table('evaluations').insert(payload).execute()
            action = 'crear'

        resultado = response.data[0] if response.data else payload
        _registrar_auditoria(
            user_id=teacher_id,
            action=action,
            record_id=resultado.get('id'),
            student_id=student_id,
            criteria_id=criteria_id,
            calificacion_anterior=cal_anterior,
            calificacion_nueva=calificacion,
            observation=data.get('observation'),
            action_date=resultado.get('grading_date') or resultado.get('created_at')
        )

        actualizar_promedio_resultado(student_id, learning_outcome_id)

        enviar_notificacion_calificacion(
            student_id,
            activity_id,
            calificacion,
            data.get('observation'),
            teacher_id=teacher_id,
        )

        return jsonify(resultado), 200
    except Exception as e:
        print(f"ERROR CALIFICAR ACTIVIDAD: {str(e)}")
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
        
        cal_anterior_resp = supabase.table('evaluations').select('grade, student_id, criteria_id').eq('id', evaluacion_id).limit(1).execute()
        cal_anterior = cal_anterior_resp.data[0].get('grade') if cal_anterior_resp.data else None

        response = supabase.table('evaluations').update(actualizacion).eq('id', evaluacion_id).execute()

        if not response.data:
            return jsonify({'error': 'Evaluacion no encontrada'}), 404

        evaluacion = response.data[0]
        _registrar_auditoria(
            user_id=get_user_id_from_token(),
            action='actualizar',
            record_id=evaluacion_id,
            student_id=evaluacion.get('student_id'),
            criteria_id=evaluacion.get('criteria_id'),
            calificacion_anterior=cal_anterior,
            calificacion_nueva=calificacion,
            observation=data.get('observation'),
            action_date=evaluacion.get('grading_date') or evaluacion.get('created_at')
        )

        actualizar_promedio_resultado(evaluacion.get('student_id'), data.get('learning_outcome_id'))

        enviar_notificacion_calificacion(
            evaluacion.get('student_id'),
            evaluacion.get('activity_id'),
            calificacion,
            data.get('observation'),
            teacher_id=get_user_id_from_token(),
        )

        return jsonify({'success': True, **evaluacion}), 200
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




