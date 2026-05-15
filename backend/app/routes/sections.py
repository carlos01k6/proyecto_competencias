from flask import Blueprint, jsonify, request
from supabase import Client
from ..supabase_client import get_supabase
import uuid

secciones_bp = Blueprint('secciones', __name__, url_prefix='/api/secciones')
supabase: Client = get_supabase()


@secciones_bp.route('', methods=['GET'])
def listar_secciones():
    try:
        resp = supabase.table('sections').select('*').order('grade').order('letter').execute()
        secciones = resp.data or []

        for sec in secciones:
            try:
                est = supabase.table('student_section').select('student_id').eq('section_id', sec['id']).execute()
                sec['total_estudiantes'] = len(est.data or [])
            except Exception:
                sec['total_estudiantes'] = 0
            try:
                doc = supabase.table('teacher_section').select('teacher_id').eq('section_id', sec['id']).execute()
                sec['total_docentes'] = len(doc.data or [])
            except Exception:
                sec['total_docentes'] = 0

        return jsonify(secciones), 200
    except Exception as e:
        print(f"ERROR LISTAR SECCIONES: {str(e)}")
        return jsonify({'error': str(e)}), 500


@secciones_bp.route('', methods=['POST'])
def crear_seccion():
    try:
        data = request.get_json() or {}
        grade = (data.get('grade') or '').strip()
        letter = (data.get('letter') or '').strip().upper()

        if not grade or not letter:
            return jsonify({'error': 'Grado y letra son requeridos'}), 400

        name = f"{grade}{letter}"

        nueva = {
            'id': str(uuid.uuid4()),
            'name': name,
            'grade': grade,
            'letter': letter,
        }
        res = supabase.table('sections').insert(nueva).execute()
        return jsonify(res.data[0] if res.data else nueva), 201
    except Exception as e:
        print(f"ERROR CREAR SECCION: {str(e)}")
        return jsonify({'error': str(e)}), 500


@secciones_bp.route('/<seccion_id>', methods=['PUT'])
def actualizar_seccion(seccion_id):
    try:
        data = request.get_json() or {}
        grade = (data.get('grade') or '').strip()
        letter = (data.get('letter') or '').strip().upper()

        if not grade or not letter:
            return jsonify({'error': 'Grado y letra son requeridos'}), 400

        campos = {'grade': grade, 'letter': letter, 'name': f"{grade}{letter}"}
        res = supabase.table('sections').update(campos).eq('id', seccion_id).execute()
        if not res.data:
            return jsonify({'error': 'Sección no encontrada'}), 404
        return jsonify(res.data[0]), 200
    except Exception as e:
        print(f"ERROR ACTUALIZAR SECCION: {str(e)}")
        return jsonify({'error': str(e)}), 500


@secciones_bp.route('/<seccion_id>', methods=['DELETE'])
def eliminar_seccion(seccion_id):
    try:
        supabase.table('student_section').delete().eq('section_id', seccion_id).execute()
        supabase.table('teacher_section').delete().eq('section_id', seccion_id).execute()
        supabase.table('sections').delete().eq('id', seccion_id).execute()
        return jsonify({'mensaje': 'Sección eliminada exitosamente'}), 200
    except Exception as e:
        print(f"ERROR ELIMINAR SECCION: {str(e)}")
        return jsonify({'error': str(e)}), 500


@secciones_bp.route('/<seccion_id>/estudiantes', methods=['GET'])
def obtener_estudiantes_seccion(seccion_id):
    try:
        inscritos = supabase.table('student_section').select('student_id, enrollment_date').eq('section_id', seccion_id).execute()
        ids = [r['student_id'] for r in (inscritos.data or []) if r.get('student_id')]
        if not ids:
            return jsonify([]), 200
        users = supabase.table('users').select('id, name, email, role').in_('id', ids).execute()
        return jsonify(users.data or []), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@secciones_bp.route('/<seccion_id>/estudiantes', methods=['POST'])
def inscribir_estudiante(seccion_id):
    try:
        data = request.get_json() or {}
        student_id = (data.get('student_id') or '').strip()
        if not student_id:
            return jsonify({'error': 'student_id es requerido'}), 400

        existente = supabase.table('student_section').select('id').eq('section_id', seccion_id).eq('student_id', student_id).execute()
        if existente.data:
            return jsonify({'error': 'El estudiante ya está en esta sección'}), 409

        supabase.table('student_section').insert({'section_id': seccion_id, 'student_id': student_id}).execute()
        return jsonify({'mensaje': 'Estudiante inscrito en la sección'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@secciones_bp.route('/<seccion_id>/estudiantes/<student_id>', methods=['DELETE'])
def desinscribir_estudiante(seccion_id, student_id):
    try:
        supabase.table('student_section').delete().eq('section_id', seccion_id).eq('student_id', student_id).execute()
        return jsonify({'mensaje': 'Estudiante removido de la sección'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@secciones_bp.route('/<seccion_id>/docentes', methods=['GET'])
def obtener_docentes_seccion(seccion_id):
    try:
        asignados = supabase.table('teacher_section').select('teacher_id').eq('section_id', seccion_id).execute()
        ids = [r['teacher_id'] for r in (asignados.data or []) if r.get('teacher_id')]
        if not ids:
            return jsonify([]), 200
        users = supabase.table('users').select('id, name, email').in_('id', ids).execute()
        return jsonify(users.data or []), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@secciones_bp.route('/<seccion_id>/docentes', methods=['POST'])
def asignar_docente(seccion_id):
    try:
        data = request.get_json() or {}
        teacher_id = (data.get('teacher_id') or '').strip()
        if not teacher_id:
            return jsonify({'error': 'teacher_id es requerido'}), 400

        existente = supabase.table('teacher_section').select('id').eq('section_id', seccion_id).eq('teacher_id', teacher_id).execute()
        if existente.data:
            return jsonify({'error': 'El docente ya está asignado a esta sección'}), 409

        supabase.table('teacher_section').insert({'section_id': seccion_id, 'teacher_id': teacher_id}).execute()
        return jsonify({'mensaje': 'Docente asignado a la sección'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@secciones_bp.route('/<seccion_id>/docentes/<teacher_id>', methods=['DELETE'])
def desasignar_docente(seccion_id, teacher_id):
    try:
        supabase.table('teacher_section').delete().eq('section_id', seccion_id).eq('teacher_id', teacher_id).execute()
        return jsonify({'mensaje': 'Docente removido de la sección'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
