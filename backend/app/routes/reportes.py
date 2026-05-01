import jwt
from flask import Blueprint, request, jsonify
from supabase import Client
from ..supabase_client import get_supabase
import uuid
from datetime import datetime
from reportlab.lib.pagesizes import letter, A4
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.lib import colors
from io import BytesIO
import base64

reportes_bp = Blueprint('reportes', __name__, url_prefix='/api/reportes')
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

# OBTENER CALIFICACIONES DE UN ESTUDIANTE POR RESULTADO
def obtener_calificaciones_estudiante(estudiante_id, resultado_id):
    try:
        # Obtener criterios del resultado
        criterios = supabase.table('criteria').select('*').eq('learning_outcome_id', resultado_id).execute()
        
        datos = []
        for criterio in criterios.data:
            # Obtener evaluacion para este criterio y estudiante
            evaluaciones = supabase.table('evaluations').select('*').eq('criteria_id', criterio['id']).eq('student_id', str(estudiante_id)).execute()
            
            if evaluaciones.data:
                eval = evaluaciones.data[-1]  # Tomar ultima evaluacion
                datos.append({
                    'criterio_nombre': criterio['name'],
                    'criterio_ponderacion': criterio['weighting'],
                    'grade': eval['grade'],
                    'observation': eval.get('observation', '')
                })
            else:
                datos.append({
                    'criterio_nombre': criterio['name'],
                    'criterio_ponderacion': criterio['weighting'],
                    'grade': None,
                    'observation': 'Sin calificar'
                })
        
        return datos
    except Exception as e:
        print(f"ERROR OBTENER CALIFICACIONES: {str(e)}")
        return []

# CALCULAR PROMEDIO PONDERADO
def calcular_promedio(calificaciones):
    try:
        suma_ponderada = 0
        suma_ponderaciones = 0
        
        for item in calificaciones:
            if item['grade'] is not None:
                suma_ponderada += item['grade'] * (item['criterio_ponderacion'] / 100)
                suma_ponderaciones += item['criterio_ponderacion']
        
        if suma_ponderaciones > 0:
            return round(suma_ponderada / (suma_ponderaciones / 100), 2)
        return 0
    except:
        return 0

# GENERAR REPORTE INDIVIDUAL EN PDF
@reportes_bp.route('/individual', methods=['POST'])
def generar_reporte_individual():
    try:
        data = request.get_json()
        
        resultado_id = data.get('learning_outcome_id')
        estudiante_id = data.get('student_id')
        nombre_estudiante = data.get('nombre_estudiante', 'Estudiante')
        nombre_resultado = data.get('nombre_resultado', 'Resultado')
        
        if not resultado_id or not estudiante_id:
            return jsonify({'error': 'resultado_id y estudiante_id son requeridos'}), 400
        
        # Obtener calificaciones
        calificaciones = obtener_calificaciones_estudiante(estudiante_id, resultado_id)
        promedio = calcular_promedio(calificaciones)
        
        # Crear PDF
        buffer = BytesIO()
        doc = SimpleDocTemplate(buffer, pagesize=letter)
        elements = []
        styles = getSampleStyleSheet()
        
        # Titulo
        title_style = ParagraphStyle(
            'Title',
            parent=styles['Heading1'],
            fontSize=18,
            textColor=colors.HexColor('#2563EB'),
            spaceAfter=20,
            alignment=1
        )
        
        elements.append(Paragraph('REPORTE DE CALIFICACIONES', title_style))
        elements.append(Spacer(1, 0.2*inch))
        
        # Datos del estudiante
        info_data = [
            ['Estudiante:', nombre_estudiante],
            ['Resultado:', nombre_resultado],
            ['Fecha:', datetime.now().strftime('%d/%m/%Y')],
        ]
        
        info_table = Table(info_data, colWidths=[2*inch, 3*inch])
        info_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (0, -1), colors.HexColor('#E3F2FD')),
            ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 10),
            ('GRID', (0, 0), (-1, -1), 1, colors.grey),
            ('LEFTPADDING', (0, 0), (-1, -1), 10),
            ('TOPPADDING', (0, 0), (-1, -1), 8),
        ]))
        
        elements.append(info_table)
        elements.append(Spacer(1, 0.3*inch))
        
        # Tabla de criterios
        tabla_data = [['Criterio', 'Ponderación', 'Calificación', 'Observación']]
        
        for item in calificaciones:
            tabla_data.append([
                item['criterio_nombre'],
                f"{item['criterio_ponderacion']}%",
                str(item['grade']) if item['grade'] is not None else 'S/C',
                item['observation'][:50]
            ])
        
        tabla = Table(tabla_data, colWidths=[2*inch, 1.2*inch, 1.2*inch, 1.6*inch])
        tabla.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#2563EB')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 9),
            ('GRID', (0, 0), (-1, -1), 1, colors.grey),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor('#F9FAFB')]),
            ('LEFTPADDING', (0, 0), (-1, -1), 8),
            ('TOPPADDING', (0, 0), (-1, -1), 6),
        ]))
        
        elements.append(tabla)
        elements.append(Spacer(1, 0.3*inch))
        
        # Promedio final
        promedio_style = ParagraphStyle(
            'Promedio',
            parent=styles['Heading2'],
            fontSize=14,
            textColor=colors.HexColor('#16A34A'),
            spaceAfter=10
        )
        
        elements.append(Paragraph(f'CALIFICACIÓN FINAL: {promedio}', promedio_style))
        
        # Generar PDF
        doc.build(elements)
        pdf_base64 = base64.b64encode(buffer.getvalue()).decode()
        
        # Guardar referencia en BD
        nuevo_reporte = {
            'id': str(uuid.uuid4()),
            'teacher_id': data.get('teacher_id'),
            'title': f'Reporte {nombre_estudiante} - {nombre_resultado}',
            'tipo': 'individual',
            'datos_json': {
                'student_id': estudiante_id,
                'learning_outcome_id': resultado_id,
                'promedio': promedio
            },
            'fecha_generacion': datetime.now().isoformat(),
            'pdf_url': f'data:application/pdf;base64,{pdf_base64}'
        }
        
        response = supabase.table('reports').insert(nuevo_reporte).execute()
        
        return jsonify({
            'reporte_id': response.data[0]['id'],
            'pdf_base64': pdf_base64,
            'promedio': promedio
        }), 201
        
    except Exception as e:
        print(f"ERROR GENERAR REPORTE INDIVIDUAL: {str(e)}")
        return jsonify({'error': str(e)}), 500

# OBTENER REPORTES DEL DOCENTE
@reportes_bp.route('', methods=['GET'])
def obtener_reportes():
    try:
        docente_id = request.args.get('teacher_id')
        
        if not docente_id:
            return jsonify({'error': 'docente_id es requerido'}), 400
        
        response = supabase.table('reports').select('*').eq('teacher_id', docente_id).execute()
        return jsonify(response.data), 200
        
    except Exception as e:
        print(f"ERROR OBTENER REPORTES: {str(e)}")
        return jsonify({'error': str(e)}), 500


# OBTENER RESUMEN POR COMPETENCIA (PARA DIRECCIÓN)
@reportes_bp.route('/director/competencias', methods=['GET'])
def obtener_resumen_competencias():
    try:
        usuario_id = get_user_id_from_token()
        if not usuario_id:
            return jsonify({'error': 'No autorizado'}), 401

        # Obtener todas las competencias
        competencias_response = supabase.table('competencies').select('*').execute()
        competencias = competencias_response.data

        resultado = []

        for competencia in competencias:
            # Obtener resultados de esta competencia
            resultados_response = supabase.table('learning_outcomes').select('id').eq('competency_id', competencia['id']).execute()
            resultado_ids = [r['id'] for r in resultados_response.data]

            if not resultado_ids:
                continue

            # Obtener criterios y evaluaciones
            calificaciones = []
            for resultado_id in resultado_ids:
                criterios_response = supabase.table('criteria').select('id').eq('learning_outcome_id', resultado_id).execute()
                for criterio in criterios_response.data:
                    evaluaciones_response = supabase.table('evaluations').select('grade').eq('criteria_id', criterio['id']).execute()
                    for eval in evaluaciones_response.data:
                        calificaciones.append(eval['grade'])

            # Calcular estadísticas
            if calificaciones:
                promedio = sum(calificaciones) / len(calificaciones)
                calificaciones.sort()
                percentil_25 = calificaciones[int(len(calificaciones) * 0.25)]
                percentil_50 = calificaciones[int(len(calificaciones) * 0.50)]
                percentil_75 = calificaciones[int(len(calificaciones) * 0.75)]
                
                # Contar por rango
                bajo = len([c for c in calificaciones if c < 40])
                medio = len([c for c in calificaciones if 40 <= c < 70])
                alto = len([c for c in calificaciones if 70 <= c < 90])
                excelente = len([c for c in calificaciones if c >= 90])

                resultado.append({
                    'competencia_nombre': competencia['name'],
                    'total_evaluaciones': len(calificaciones),
                    'promedio': round(promedio, 2),
                    'percentil_25': round(percentil_25, 2),
                    'percentil_50': round(percentil_50, 2),
                    'percentil_75': round(percentil_75, 2),
                    'distribucion': {
                        'bajo': bajo,
                        'medio': medio,
                        'alto': alto,
                        'excelente': excelente
                    }
                })

        return jsonify(resultado), 200

    except Exception as e:
        print(f"ERROR OBTENER RESUMEN: {str(e)}")
        return jsonify({'error': str(e)}), 500

# ELIMINAR REPORTE
@reportes_bp.route('/<reporte_id>', methods=['DELETE'])
def eliminar_reporte(reporte_id):
    try:
        supabase.table('reports').delete().eq('id', reporte_id).execute()
        return jsonify({'mensaje': 'Reporte eliminado'}), 200
    except Exception as e:
        print(f"ERROR ELIMINAR REPORTE: {str(e)}")
        return jsonify({'error': str(e)}), 500








