# Sistema de Evaluacion por Competencias

Aplicacion web para gestionar evaluacion por competencias en un entorno academico. Incluye autenticacion, gestion de docentes/estudiantes, competencias, resultados de aprendizaje, criterios, actividades, evidencias, evaluaciones, reportes, rubricas, asistencia y seguimiento de progreso.

## Stack

### Backend
- Python 3.12 recomendado
- Flask
- Flask-CORS
- Flask-JWT-Extended
- Flask-SQLAlchemy
- Supabase Python Client
- OpenPyXL para exportaciones Excel

### Frontend
- React 18
- Vite
- React Router
- TailwindCSS
- Axios / Fetch
- Lucide React
- Recharts

### Base de datos y autenticacion
- Supabase Auth para login/registro
- Tablas de Supabase para la mayoria de modulos
- SQLite local usado por los modelos SQLAlchemy heredados (`instance/competencias.db`)

## Requisitos

- Python 3.12 o compatible
- Node.js 18 o superior
- npm
- Acceso a la instancia de Supabase configurada en `backend/app/supabase_client.py`

## Estructura del proyecto

```text
proyecto_competencias/
  backend/
    app/
      routes/              # Endpoints REST
      models/              # Modelos SQLAlchemy heredados
      supabase_client.py   # Cliente Supabase usado por las rutas
      __init__.py          # App Flask y blueprints
    requirements.txt
    wsgi.py
  frontend/
    src/
      pages/               # Pantallas React
      services/            # Clientes API por modulo
      hooks/               # Hooks reutilizables
      components/          # Componentes UI
    package.json
    vite.config.js
  docs/
    asistencias.sql        # SQL de tabla asistencias
```

## Instalacion

### 1. Clonar o abrir el proyecto

```powershell
cd C:\Windows\System32\proyecto_competencias
```

### 2. Instalar backend

```powershell
cd backend
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

Si PowerShell bloquea la activacion del entorno virtual, ejecuta:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\venv\Scripts\Activate.ps1
```

### 3. Instalar frontend

```powershell
cd ..\frontend
npm install
```

## Ejecucion en desarrollo

Abre dos terminales.

### Terminal 1: backend

```powershell
cd C:\Windows\System32\proyecto_competencias\backend
.\venv\Scripts\Activate.ps1
python wsgi.py
```

Backend:

```text
http://localhost:5000
```

Health check:

```text
GET http://localhost:5000/api/health
```

### Terminal 2: frontend

```powershell
cd C:\Windows\System32\proyecto_competencias\frontend
npm run dev
```

Frontend:

```text
http://localhost:5173
```

El proxy de Vite redirige `/api` a `http://localhost:5000`, aunque varios servicios del frontend tambien usan URLs absolutas a `localhost:5000`.

## Scripts utiles

### Backend

```powershell
python wsgi.py
python -m py_compile app\routes\asistencia.py
```

### Frontend

```powershell
npm run dev
npm run build
npm run preview
```

## Autenticacion

La app usa Supabase Auth. Al iniciar sesion, el frontend guarda:

```text
localStorage.acceso_token
localStorage.usuario
```

El token se envia como:

```text
Authorization: Bearer <token>
```

Rutas principales:

- `POST /api/auth/signup`
- `POST /api/auth/login`
- `GET /api/auth/me`

## Roles

El sistema trabaja principalmente con estos roles:

- `student`: estudiante
- `teacher`: docente
- `admin`: administrador

Algunas pantallas restringen acciones segun el rol guardado en `usuario.rol`.

## Modulos principales

- Dashboard
- Competencias
- Resultados de aprendizaje
- Criterios
- Actividades
- Evidencias
- Evaluaciones
- Reportes
- Reportes de director
- Boletin
- Retroalimentacion
- Auditoria
- Niveles y escalas
- Planes de mejora
- Seguimiento grupal
- Periodos academicos
- Re-evaluaciones
- Plantillas
- Rubricas
- Cursos
- Estudiantes
- Usuarios y roles
- Asistencia

## Endpoints principales

Base URL:

```text
http://localhost:5000/api
```

Prefijos registrados:

- `/auth`
- `/competencias`
- `/resultados`
- `/criterios`
- `/actividades`
- `/evidencias`
- `/evaluaciones`
- `/reportes`
- `/config`
- `/excel`
- `/evidencias-proyecto`
- `/niveles`
- `/escalas`
- `/retroalimentacion`
- `/auditoria`
- `/boletin`
- `/improvement-plans`
- `/group-tracking`
- `/academic-periods`
- `/re-evaluations`
- `/plantillas`
- `/rubricas`
- `/seguimiento`
- `/cursos`
- `/estudiantes`
- `/registro`
- `/usuarios`
- `/roles`
- `/asistencia`
- `/correos`
- `/exportar`

## Asistencia

El modulo de asistencia usa un curso fijo actualmente:

```text
7ab7dd0e-b224-4b3a-81ca-34d47dd61f45
```

Endpoints actuales:

```text
GET  /api/asistencia/<fecha>
POST /api/asistencia
GET  /api/asistencia/reporte/<estudiante_id>
```

`GET /api/asistencia/<fecha>`:

- Obtiene todos los usuarios con `role = student`.
- Busca asistencias del curso fijo para esa fecha.
- Devuelve estudiantes con su estado si ya existe asistencia.

Respuesta esperada:

```json
[
  {
    "student_id": "uuid",
    "student_name": "Nombre",
    "email": "estudiante@example.com",
    "estado": "presente"
  }
]
```

`POST /api/asistencia`:

```json
{
  "docente_id": "uuid-del-docente",
  "fecha": "2026-05-01",
  "asistencias": [
    {
      "student_id": "uuid-del-estudiante",
      "estado": "presente"
    }
  ]
}
```

Respuesta:

```json
{
  "success": true
}
```

Estados validos:

- `presente`
- `ausente`
- `tardanza`

SQL relacionado:

```text
docs/asistencias.sql
```

## Variables y configuracion

Actualmente el cliente de Supabase esta definido en:

```text
backend/app/supabase_client.py
```

Para produccion se recomienda mover estos valores a un archivo `.env`:

```env
SUPABASE_URL=...
SUPABASE_SERVICE_KEY=...
JWT_SECRET_KEY=...
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=tu_email@gmail.com
MAIL_PASSWORD=tu_app_password
```

Nota: no subas llaves reales de Supabase ni secretos JWT a un repositorio publico.

## Tablas usadas con frecuencia

El proyecto consulta o escribe en tablas como:

- `users`
- `user_roles`
- `roles`
- `cursos`
- `estudiante_curso`
- `competencies`
- `learning_outcomes`
- `criteria`
- `activities`
- `evidence`
- `evaluations`
- `reports`
- `rubricas`
- `plantillas`
- `academic_periods`
- `asistencias`
- `audits`

Los nombres exactos de columnas pueden variar por modulo; revisa `backend/app/routes/` para el contrato actual de cada endpoint.

## Verificacion rapida

Desde la raiz del proyecto:

```powershell
cd backend
.\venv\Scripts\Activate.ps1
python -m py_compile app\routes\asistencia.py

cd ..\frontend
npm run build
```

## Problemas comunes

### `ModuleNotFoundError: No module named 'supabase'`

Instala dependencias actualizadas:

```powershell
cd backend
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

### Error de CORS

El backend permite por defecto:

```text
http://localhost:5173
http://localhost:3000
```

Si usas otro puerto, actualiza `backend/app/__init__.py`.

### Frontend no conecta con backend

Confirma que Flask este corriendo en:

```text
http://localhost:5000
```

Y prueba:

```text
http://localhost:5000/api/health
```

### No aparecen estudiantes en asistencia

Verifica en Supabase que existan usuarios en la tabla `users` con:

```text
role = student
```

### No guarda asistencia

Verifica que la tabla `asistencias` exista. Puedes usar el SQL de:

```text
docs/asistencias.sql
```

## Estado actual

Este proyecto esta en desarrollo activo. Algunas partes usan modelos SQLAlchemy locales y otras consultan Supabase directamente. La fuente practica de verdad para cada modulo son las rutas en `backend/app/routes/` y las pantallas/servicios en `frontend/src/`.
