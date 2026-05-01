from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import jwt

retroalimentacion_bp = Blueprint('retroalimentacion', __name__, url_prefix='/api/retroalimentacion')
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

TEMPLATES_FEEDBACK = {
    'bajo': {
        'rango': '0-40 (Incipiente)',
        'color': 'danger',
        'titulo': 'Refuerzo Necesario',
        'sugerencias': [
            'Requiere apoyo inmediato en conceptos fundamentales',
            'Se recomienda sesiones de tutoría individual',
            'Revisar material básico y recursos complementarios',
            'Establecer plan de mejora con metas corto plazo',
            'Participar en talleres de refuerzo',
            'Aumentar horas de práctica independiente'
        ]
    },
    'medio': {
        'rango': '41-70 (Básico)',
        'color': 'warning',
        'titulo': 'En Desarrollo',
        'sugerencias': [
            'Ha alcanzado aprendizajes básicos pero incompletos',
            'Continuar trabajando para consolidar la competencia',
            'Incrementar profundidad en temas clave',
            'Practicar con ejercicios más desafiantes',
            'Buscar retroalimentación periódica de docente',
            'Estudiar casos de aplicación práctica'
        ]
    },
    'alto': {
        'rango': '71-90 (Satisfactorio)',
        'color': 'primary-brand',
        'titulo': 'Consolidado',
        'sugerencias': [
            'Ha demostrado dominio sólido de la competencia',
            'Puede asumir tareas más complejas',
            'Considerar mentoría de compañeros menos avanzados',
            'Profundizar en temas avanzados relacionados',
            'Explorar aplicaciones en contextos reales',
            'Prepararse para evaluaciones de mayor complejidad'
        ]
    },
    'excelente': {
        'rango': '91-100 (Avanzado)',
        'color': 'success',
        'titulo': 'Excelencia',
        'sugerencias': [
            'Desempeño excepcional en la competencia',
            'Puede servir como modelo para otros estudiantes',
            'Explorar investigación en el tema',
            'Considerar roles de liderazgo en proyectos',
            'Documentar y compartir aprendizajes con pares',
            'Buscar certificaciones adicionales en el área'
        ]
    }
}

TEMPLATES_POR_CRITERIO = {
    'contenido': {
        'bajo': 'Falta comprensión de conceptos clave. Repasa las definiciones fundamentales.',
        'medio': 'Entiendes lo básico pero faltan detalles. Profundiza en los ejemplos.',
        'alto': 'Buen dominio del contenido. Intenta aplicarlo a problemas más complejos.',
        'excelente': 'Excelente manejo del contenido. Podrías crear recursos para enseñar a otros.'
    },
    'estructura': {
        'bajo': 'La organización es confusa. Aprende a hacer esquemas antes de escribir.',
        'medio': 'Hay estructura pero faltan conexiones lógicas. Mejora las transiciones.',
        'alto': 'Buena organización general. Refina los detalles de cada sección.',
        'excelente': 'Estructura clara y coherente. Excepcional en fluidez y coherencia.'
    },
    'presentación': {
        'bajo': 'Necesitas mejorar la claridad. Revisa ortografía, gramática y formato.',
        'medio': 'Presentable pero con errores. Cuida más los detalles finales.',
        'alto': 'Buena presentación visual. Añade elementos que lo hagan más atractivo.',
        'excelente': 'Presentación profesional y pulida. Muy cuidado en cada detalle.'
    },
    'análisis': {
        'bajo': 'Análisis superficial. Necesitas profundizar más en las causas y efectos.',
        'medio': 'Análisis básico presente. Añade más perspectivas y conexiones.',
        'alto': 'Análisis sólido. Intenta incluir pensamiento crítico más avanzado.',
        'excelente': 'Análisis profundo y crítico. Excelente en conexión de ideas.'
    }
}

def obtener_rango_feedback(calificacion):
    calificacion = float(calificacion)
    if calificacion >= 91:
        return 'excelente'
    elif calificacion >= 71:
        return 'alto'
    elif calificacion >= 41:
        return 'medio'
    else:
        return 'bajo'

# OBTENER TEMPLATES DE FEEDBACK GENERAL
@retroalimentacion_bp.route('/templates', methods=['GET'])
def obtener_templates():
    try:
        return jsonify(TEMPLATES_FEEDBACK), 200
    except Exception as e:
        print(f"ERROR OBTENER TEMPLATES: {str(e)}")
        return jsonify({'error': str(e)}), 500

# OBTENER FEEDBACK PERSONALIZADO POR CALIFICACIÓN
@retroalimentacion_bp.route('/personalizado/<int:calificacion>', methods=['GET'])
def obtener_feedback_personalizado(calificacion):
    try:
        rango = obtener_rango_feedback(calificacion)
        template = TEMPLATES_FEEDBACK[rango]
        
        return jsonify({
            'grade': calificacion,
            'rango': rango,
            'titulo': template['titulo'],
            'color': template['color'],
            'sugerencias': template['sugerencias']
        }), 200

    except Exception as e:
        print(f"ERROR FEEDBACK PERSONALIZADO: {str(e)}")
        return jsonify({'error': str(e)}), 500

# OBTENER FEEDBACK ESPECÍFICO POR CRITERIO
@retroalimentacion_bp.route('/por-criterio/<int:calificacion>/<criterio_tipo>', methods=['GET'])
def obtener_feedback_criterio(calificacion, criterio_tipo):
    try:
        criterio_tipo = criterio_tipo.lower()
        rango = obtener_rango_feedback(calificacion)
        
        if criterio_tipo not in TEMPLATES_POR_CRITERIO:
            criterio_tipo = 'contenido'
        
        feedback_especifico = TEMPLATES_POR_CRITERIO[criterio_tipo][rango]
        
        return jsonify({
            'grade': calificacion,
            'criterio': criterio_tipo,
            'rango': rango,
            'feedback': feedback_especifico
        }), 200

    except Exception as e:
        print(f"ERROR FEEDBACK CRITERIO: {str(e)}")
        return jsonify({'error': str(e)}), 500





