from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import jwt

boletin_bp = Blueprint('boletin', __name__, url_prefix='/api/boletin')
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
        return {'nivel': 'Avanzado', 'codigo': 'A', 'color': 'verde'}
    elif calificacion >= 71:
        return {'nivel': 'Satisfactorio', 'codigo': 'S', 'color': 'azul'}
    elif calificacion >= 41:
        return {'nivel': 'Básico', 'codigo': 'B', 'color': 'amarillo'}
    else:
        return {'nivel': 'Incipiente', 'codigo': 'I', 'color': 'rojo'}

# GENERAR BOLETÍN POR COMPETENCIA
@boletin_bp.route('/competencia/<competencia_id>', methods=['GET'])
def generar_boletin_competencia(competencia_id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        outcomes_response = (
            supabase.table('learning_outcomes')
            .select('id, title')
            .eq('competency_id', competencia_id)
            .execute()
        )

        boletin = []

        for outcome in outcomes_response.data or []:
            criteria_response = (
                supabase.table('criteria')
                .select('id')
                .eq('learning_outcome_id', outcome['id'])
                .execute()
            )
            criteria_ids = [criteria['id'] for criteria in (criteria_response.data or [])]

            evaluaciones = []
            if criteria_ids:
                evaluations_response = (
                    supabase.table('evaluations')
                    .select('grade')
                    .in_('criteria_id', criteria_ids)
                    .execute()
                )
                evaluaciones = [
                    float(evaluation['grade'])
                    for evaluation in (evaluations_response.data or [])
                    if evaluation.get('grade') is not None
                ]

            total_evaluaciones = len(evaluaciones)
            promedio = sum(evaluaciones) / total_evaluaciones if total_evaluaciones else 0

            boletin.append({
                'learning_outcome_name': outcome.get('title') or outcome['id'],
                'total_evaluaciones': total_evaluaciones,
                'promedio': round(promedio, 2)
            })

        return jsonify(boletin), 200

    except Exception as e:
        print(f"ERROR GENERAR BOLETIN COMPETENCIA: {str(e)}")
        return jsonify({'error': str(e)}), 500

# GENERAR BOLETÍN POR ESTUDIANTE
@boletin_bp.route('/estudiante/<estudiante_id>', methods=['GET'])
def generar_boletin_estudiante(estudiante_id):
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Obtener todas las competencias
        competencias_response = supabase.table('competencies').select('*').execute()
        competencias = competencias_response.data

        boletin_competencias = []
        calificaciones_totales = []

        for competencia in competencias:
            # Obtener resultados de la competencia
            resultados_response = supabase.table('learning_outcomes').select('id').eq('competency_id', competencia['id']).execute()
            resultado_ids = [r['id'] for r in resultados_response.data]

            if not resultado_ids:
                continue

            # Obtener todas las evaluaciones de esta competencia para el estudiante
            evaluaciones_competencia = []
            for resultado_id in resultado_ids:
                criterios_response = supabase.table('criteria').select('id').eq('learning_outcome_id', resultado_id).execute()
                for criterio in criterios_response.data:
                    evaluaciones_response = supabase.table('evaluations').select('grade').eq('criteria_id', criterio['id']).eq('student_id', estudiante_id).execute()
                    for eval in evaluaciones_response.data:
                        evaluaciones_competencia.append(eval['grade'])

            if evaluaciones_competencia:
                promedio_competencia = sum(evaluaciones_competencia) / len(evaluaciones_competencia)
                nivel = obtener_nivel(promedio_competencia)
                
                boletin_competencias.append({
                    'competency_id': competencia['id'],
                    'competencia_nombre': competencia['name'],
                    'promedio': round(promedio_competencia, 2),
                    'nivel': nivel['nivel'],
                    'codigo': nivel['codigo'],
                    'color': nivel['color'],
                    'total_evaluaciones': len(evaluaciones_competencia)
                })
                
                calificaciones_totales.append(promedio_competencia)

        # Calcular promedio general
        promedio_general = sum(calificaciones_totales) / len(calificaciones_totales) if calificaciones_totales else 0
        nivel_general = obtener_nivel(promedio_general)

        # Contar logros por nivel
        logros = {
            'Avanzado': len([c for c in boletin_competencias if c['nivel'] == 'Avanzado']),
            'Satisfactorio': len([c for c in boletin_competencias if c['nivel'] == 'Satisfactorio']),
            'Básico': len([c for c in boletin_competencias if c['nivel'] == 'Básico']),
            'Incipiente': len([c for c in boletin_competencias if c['nivel'] == 'Incipiente'])
        }

        resultado = {
            'student_id': estudiante_id,
            'promedio_general': round(promedio_general, 2),
            'nivel_general': nivel_general['nivel'],
            'codigo_general': nivel_general['codigo'],
            'total_competencias': len(boletin_competencias),
            'competencies': boletin_competencias,
            'logros': logros,
            'resumen': {
                'fortalezas': [c['competencia_nombre'] for c in boletin_competencias if c['nivel'] in ['Avanzado', 'Satisfactorio']][:3],
                'areas_mejora': [c['competencia_nombre'] for c in boletin_competencias if c['nivel'] in ['Incipiente', 'Básico']][:3]
            }
        }

        return jsonify(resultado), 200

    except Exception as e:
        print(f"ERROR GENERAR BOLETIN: {str(e)}")
        return jsonify({'error': str(e)}), 500

# OBTENER BOLETINES DE MÚLTIPLES ESTUDIANTES (para descarga grupal)
@boletin_bp.route('/grupo', methods=['GET'])
def obtener_boletines_grupo():
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Obtener todos los estudiantes que tienen evaluaciones
        evaluaciones_response = supabase.table('evaluations').select('student_id').execute()
        estudiantes_unicos = list(set(e['student_id'] for e in evaluaciones_response.data))

        boletines = []
        for est_id in estudiantes_unicos[:50]:  # Limitar a 50 para performance
            try:
                # Llamar internamente a la función de boletín
                competencias_response = supabase.table('competencies').select('*').execute()
                competencias = competencias_response.data

                calificaciones_totales = []
                for competencia in competencias:
                    resultados_response = supabase.table('learning_outcomes').select('id').eq('competency_id', competencia['id']).execute()
                    resultado_ids = [r['id'] for r in resultados_response.data]

                    for resultado_id in resultado_ids:
                        criterios_response = supabase.table('criteria').select('id').eq('learning_outcome_id', resultado_id).execute()
                        for criterio in criterios_response.data:
                            evaluaciones_response = supabase.table('evaluations').select('grade').eq('criteria_id', criterio['id']).eq('student_id', est_id).execute()
                            for eval in evaluaciones_response.data:
                                calificaciones_totales.append(eval['grade'])

                if calificaciones_totales:
                    promedio = sum(calificaciones_totales) / len(calificaciones_totales)
                    boletines.append({
                        'student_id': est_id,
                        'promedio_general': round(promedio, 2)
                    })
            except:
                pass

        return jsonify({
            'total_estudiantes': len(boletines),
            'boletines': boletines
        }), 200

    except Exception as e:
        print(f"ERROR OBTENER BOLETINES GRUPO: {str(e)}")
        return jsonify({'error': str(e)}), 500




