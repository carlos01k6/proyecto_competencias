-- Crear tabla progreso_snapshots si no existe
CREATE TABLE IF NOT EXISTS progreso_snapshots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL REFERENCES users(id),
    competency_id UUID NOT NULL REFERENCES competencies(id),
    porcentaje_logro DECIMAL(5,2) NOT NULL CHECK (porcentaje_logro >= 0 AND porcentaje_logro <= 100),
    fecha_snapshot TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_progreso_snapshots_student_competency ON progreso_snapshots(student_id, competency_id);
CREATE INDEX IF NOT EXISTS idx_progreso_snapshots_fecha ON progreso_snapshots(fecha_snapshot);