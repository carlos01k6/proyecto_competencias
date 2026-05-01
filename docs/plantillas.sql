create table if not exists public.plantillas (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  descripcion text,
  contenido jsonb,
  created_at timestamp default now()
);

create index if not exists idx_plantillas_created_at
  on public.plantillas (created_at desc);
