from datetime import datetime
import math
from pathlib import Path
import sys
import uuid

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from app.supabase_client import get_supabase


supabase = get_supabase()


def first(data):
    return data[0] if data else None


def get_or_create_competency(name, description, descriptor, subject, teacher_id):
    response = supabase.table("competencies").select("*").eq("name", name).limit(1).execute()
    found = first(response.data or [])
    if found:
        return found

    row = {
        "id": str(uuid.uuid4()),
        "name": name,
        "description": description,
        "descriptor": descriptor,
        "subject": subject,
        "teacher_id": teacher_id,
    }
    response = supabase.table("competencies").insert(row).execute()
    return first(response.data or []) or row


def get_or_create_outcome(competency_id, title):
    response = (
        supabase.table("learning_outcomes")
        .select("*")
        .eq("competency_id", competency_id)
        .limit(1)
        .execute()
    )
    found = first(response.data or [])
    if found:
        return found

    row = {
        "id": str(uuid.uuid4()),
        "competency_id": competency_id,
        "title": title,
        "description": f"Resultado asociado a {title}",
    }
    response = supabase.table("learning_outcomes").insert(row).execute()
    return first(response.data or []) or row


def get_or_create_criterion(outcome_id, name):
    response = (
        supabase.table("criteria")
        .select("*")
        .eq("learning_outcome_id", outcome_id)
        .limit(1)
        .execute()
    )
    found = first(response.data or [])
    if found:
        return found

    row = {
        "id": str(uuid.uuid4()),
        "name": name,
        "learning_outcome_id": outcome_id,
        "weighting": 100,
    }
    response = supabase.table("criteria").insert(row).execute()
    return first(response.data or []) or row


def get_or_create_activity(outcome_id, title, teacher_id):
    response = (
        supabase.table("activities")
        .select("*")
        .eq("learning_outcome_id", outcome_id)
        .eq("title", title)
        .limit(1)
        .execute()
    )
    found = first(response.data or [])
    if found:
        return found

    row = {
        "id": str(uuid.uuid4()),
        "learning_outcome_id": outcome_id,
        "title": title,
        "description": f"Actividad demo para evaluar {title}.",
        "type": "tarea",
        "max_score": 100,
        "status": "active",
        "docente_id": teacher_id,
    }
    response = supabase.table("activities").insert(row).execute()
    return first(response.data or []) or row


def ensure_evidence(activity_id, student_id, student_name):
    response = (
        supabase.table("evidence")
        .select("*")
        .eq("activity_id", activity_id)
        .eq("student_id", student_id)
        .limit(1)
        .execute()
    )
    found = first(response.data or [])
    if found:
        return found

    safe_name = (student_name or "estudiante").replace(" ", "_").lower()
    row = {
        "id": str(uuid.uuid4()),
        "activity_id": activity_id,
        "student_id": student_id,
        "file_url": f"demo_evidencia_{safe_name}.pdf",
        "status": "pendiente",
    }
    response = supabase.table("evidence").insert(row).execute()
    return first(response.data or []) or row


def insert_evaluation(activity_id, criterion_id, student_id, teacher_id, grade):
    row = {
        "id": str(uuid.uuid4()),
        "activity_id": activity_id,
        "criteria_id": criterion_id,
        "student_id": student_id,
        "teacher_id": teacher_id,
        "grade": grade,
        "observation": "Demo: calificación precargada para presentación.",
        "grading_date": datetime.now().isoformat(),
    }
    supabase.table("evaluations").insert(row).execute()
    return row


def notify(student_id, title, message):
    row = {
        "id": str(uuid.uuid4()),
        "estudiante_id": student_id,
        "titulo": title,
        "mensaje": message,
        "tipo": "nueva_clase",
        "leida": False,
    }
    try:
        supabase.table("notificaciones").insert(row).execute()
    except Exception:
        pass


def main():
    teachers = supabase.table("users").select("id, name, email, role").in_("role", ["teacher", "docente"]).execute().data or []
    students = supabase.table("users").select("id, name, email, role").eq("role", "student").execute().data or []
    if not teachers:
        raise RuntimeError("No hay docente en users")
    if not students:
        raise RuntimeError("No hay estudiantes en users")

    teacher = teachers[0]
    count = max(1, math.ceil(len(students) / 2))
    selected = students[:count]

    definitions = [
        (
            "Comunicación efectiva",
            "Expresa ideas de forma clara, precisa y adecuada al contexto.",
            "Organiza información, argumenta con claridad y adapta su comunicación a diferentes audiencias.",
            "Competencia transversal",
            "Entrega oral y escrita",
            "Claridad y argumentación",
            "Actividad: informe de comunicación",
        ),
        (
            "Resolución de problemas",
            "Analiza situaciones y propone soluciones pertinentes.",
            "Identifica causas, evalúa alternativas y aplica procedimientos para resolver problemas.",
            "Competencia transversal",
            "Solución de caso práctico",
            "Análisis y solución",
            "Actividad: caso práctico",
        ),
        (
            "Trabajo colaborativo",
            "Participa de manera responsable en equipos de trabajo.",
            "Colabora, asume roles y contribuye al logro de objetivos comunes.",
            "Competencia transversal",
            "Proyecto colaborativo",
            "Participación y responsabilidad",
            "Actividad: proyecto en equipo",
        ),
    ]

    grades = [96, 88, 78, 67, 54, 92, 73, 61]
    created = []
    for comp_index, definition in enumerate(definitions):
        competency = get_or_create_competency(*definition[:4], teacher["id"])
        outcome = get_or_create_outcome(competency["id"], definition[4])
        criterion = get_or_create_criterion(outcome["id"], definition[5])
        activity = get_or_create_activity(outcome["id"], definition[6], teacher["id"])

        for index, student in enumerate(selected):
            name = student.get("name") or student.get("email") or student["id"]
            ensure_evidence(activity["id"], student["id"], name)
            grade = grades[(index + comp_index) % len(grades)]
            insert_evaluation(activity["id"], criterion["id"], student["id"], teacher["id"], grade)
            if comp_index == 0:
                notify(student["id"], "Actividad asignada", f"Tienes una actividad demo pendiente: {activity.get('title')}")
            created.append((name, competency["name"], grade))

    print("DOCENTE USADO:", teacher.get("name") or teacher.get("email") or teacher["id"])
    print("ESTUDIANTES CON CALIFICACIONES:")
    for student in selected:
        print("-", student.get("name") or student.get("email") or student["id"], "|", student["id"])
    print("TOTAL CALIFICACIONES CREADAS:", len(created))


if __name__ == "__main__":
    main()
