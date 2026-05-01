create table if not exists public.asistencias (
  id uuid primary key,
  docente_id uuid not null,
  estudiante_id uuid not null,
  curso_id uuid not null,
  fecha date not null,
  estado text not null check (estado in ('presente', 'ausente', 'tardanza')),
  observacion text default '',
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique (docente_id, estudiante_id, curso_id, fecha)
);

create index if not exists idx_asistencias_curso_fecha
  on public.asistencias (curso_id, fecha);

create index if not exists idx_asistencias_estudiante_fecha
  on public.asistencias (estudiante_id, fecha);
