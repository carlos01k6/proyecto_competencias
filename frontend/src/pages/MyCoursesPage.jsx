import React, { useEffect, useState } from "react"
import { useNavigate } from "react-router-dom"
import { useCursos } from "../hooks/useCourses"
import { getStudentCode } from "../utils/studentCode"
import { ArrowRight, BookOpen, Clock, Loader2, Users } from "lucide-react"

export default function MisCursosPage({ usuario }) {
  const navigate = useNavigate()
  const [tab, setTab] = useState("activos")
  const [estudiantesPorCurso, setEstudiantesPorCurso] = useState({})
  const [cargandoEstudiantes, setCargandoEstudiantes] = useState(false)

  const rolUsuario = usuario?.rol?.toLowerCase()
  const esTeacher = rolUsuario === "teacher" || rolUsuario === "docente"
  const usuarioID = esTeacher ? usuario?.id : null

  const { cursos, cargando, error } = useCursos(usuarioID)

  useEffect(() => {
    const cargarEstudiantesCursos = async () => {
      if (!cursos.length) {
        setEstudiantesPorCurso({})
        return
      }

      setCargandoEstudiantes(true)
      try {
        const token = localStorage.getItem("acceso_token")
        const pares = await Promise.all(
          cursos.map(async (curso) => {
            const response = await fetch(`http://localhost:5000/api/estudiantes/curso/${curso.id}`, {
              headers: { Authorization: `Bearer ${token}` }
            })
            const data = await response.json()
            return [curso.id, response.ok ? data || [] : []]
          })
        )
        setEstudiantesPorCurso(Object.fromEntries(pares))
      } catch (err) {
        console.error("Error cargando estudiantes por curso:", err)
      } finally {
        setCargandoEstudiantes(false)
      }
    }

    cargarEstudiantesCursos()
  }, [cursos])

  if (!esTeacher) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8 flex items-center justify-center">
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 max-w-md text-center">
          <p className="text-4xl mb-4">Bloqueado</p>
          <h1 className="text-2xl font-bold text-white mb-2">Acceso Restringido</h1>
          <p className="text-neutral-400 mb-6">Esta seccion es solo para docentes.</p>
          <button
            onClick={() => navigate("/")}
            className="inline-block bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-6 py-2 rounded-lg font-semibold transition"
          >
            Volver al Inicio
          </button>
        </div>
      </div>
    )
  }

  const cursosActivos = cursos.filter((curso) => !curso.estado || curso.estado === "activo")
  const cursosInactivos = cursos.filter((curso) => curso.estado === "inactivo")
  const mostrados = tab === "activos" ? cursosActivos : cursosInactivos
  const totalEstudiantes = Object.values(estudiantesPorCurso).reduce((total, lista) => total + lista.length, 0)

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="p-3 bg-gradient-to-br from-blue-600 to-blue-700 rounded-lg">
              <BookOpen className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-4xl font-bold text-white">Mis Cursos</h1>
              <p className="text-neutral-400">Gestiona tus cursos y sus estudiantes</p>
            </div>
          </div>
        </div>
      </div>

      {cargando && (
        <div className="flex items-center justify-center py-12">
          <Loader2 className="w-8 h-8 text-primary-brand animate-spin" />
        </div>
      )}

      {error && (
        <div className="bg-danger/10 border border-danger/30 rounded-2xl p-6 mb-8">
          <p className="text-danger font-semibold">Error: {error}</p>
        </div>
      )}

      {!cargando && !error && (
        <>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
              <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-blue-600 to-blue-700 flex items-center justify-center mb-4">
                <BookOpen className="w-5 h-5 text-white" />
              </div>
              <p className="text-neutral-400 text-sm mb-2">Cursos Activos</p>
              <p className="text-3xl font-bold text-white">{cursosActivos.length}</p>
            </div>

            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
              <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-purple-600 to-purple-700 flex items-center justify-center mb-4">
                <Users className="w-5 h-5 text-white" />
              </div>
              <p className="text-neutral-400 text-sm mb-2">Total Cursos</p>
              <p className="text-3xl font-bold text-white">{cursos.length}</p>
            </div>

            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
              <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-emerald-600 to-emerald-700 flex items-center justify-center mb-4">
                <Clock className="w-5 h-5 text-white" />
              </div>
              <p className="text-neutral-400 text-sm mb-2">Estudiantes</p>
              <p className="text-3xl font-bold text-white">{totalEstudiantes}</p>
            </div>
          </div>

          <div className="flex gap-2 mb-6 border-b border-neutral-700">
            <button
              onClick={() => setTab("activos")}
              className={`px-6 py-3 font-semibold border-b-2 transition ${
                tab === "activos"
                  ? "border-primary-brand text-primary-brand"
                  : "border-transparent text-neutral-400 hover:text-neutral-200"
              }`}
            >
              Activos ({cursosActivos.length})
            </button>
            <button
              onClick={() => setTab("inactivos")}
              className={`px-6 py-3 font-semibold border-b-2 transition ${
                tab === "inactivos"
                  ? "border-primary-brand text-primary-brand"
                  : "border-transparent text-neutral-400 hover:text-neutral-200"
              }`}
            >
              Inactivos ({cursosInactivos.length})
            </button>
          </div>

          {mostrados.length === 0 ? (
            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 text-center">
              <p className="text-neutral-400 text-lg">
                {tab === "activos" ? "No tienes cursos activos" : "No tienes cursos inactivos"}
              </p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {mostrados.map((curso) => {
                const estudiantes = estudiantesPorCurso[curso.id] || []

                return (
                  <div
                    key={curso.id}
                    className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 hover:border-primary-brand/30 transition group"
                  >
                    <div className="mb-4 pb-4 border-b border-neutral-700/50">
                      <div className="flex items-start justify-between mb-2">
                        <div>
                          <h3 className="text-lg font-bold text-white">{curso.nombre || curso.name || "Curso"}</h3>
                          <p className="text-xs text-neutral-500 mt-1">{curso.codigo || curso.id}</p>
                        </div>
                        <span
                          className={`px-3 py-1 rounded-full text-xs font-semibold ${
                            curso.estado === "inactivo"
                              ? "bg-neutral-700/50 text-neutral-400"
                              : "bg-success/20 text-success"
                          }`}
                        >
                          {curso.estado === "inactivo" ? "Inactivo" : "Activo"}
                        </span>
                      </div>
                    </div>

                    {curso.descripcion && (
                      <p className="text-xs text-neutral-400 mb-4 line-clamp-2">{curso.descripcion}</p>
                    )}

                    <div className="mb-5">
                      <div className="flex items-center justify-between mb-3">
                        <div className="flex items-center gap-2">
                          <Users className="w-4 h-4 text-primary-brand" />
                          <p className="text-sm font-semibold text-white">Estudiantes</p>
                        </div>
                        <span className="text-xs text-neutral-500">{estudiantes.length}</span>
                      </div>

                      {cargandoEstudiantes ? (
                        <div className="flex items-center gap-2 text-neutral-400 text-sm py-3">
                          <Loader2 className="w-4 h-4 animate-spin" />
                          Cargando estudiantes
                        </div>
                      ) : estudiantes.length === 0 ? (
                        <p className="text-sm text-neutral-500 bg-neutral-950/50 border border-neutral-700/40 rounded-lg px-3 py-3">
                          Sin estudiantes asignados
                        </p>
                      ) : (
                        <div className="space-y-2 max-h-44 overflow-y-auto pr-1">
                          {estudiantes.map((estudiante) => (
                            <div
                              key={estudiante.id || estudiante.email}
                              className="bg-neutral-950/50 border border-neutral-700/40 rounded-lg px-3 py-2"
                            >
                              <p className="text-sm font-semibold text-white">
                                {estudiante.name || estudiante.nombre || "Estudiante"}
                              </p>
                              <p className="text-xs font-semibold text-primary-brand">{getStudentCode(estudiante)}</p>
                              <p className="text-xs text-neutral-500 truncate">{estudiante.email || "Sin email"}</p>
                            </div>
                          ))}
                        </div>
                      )}
                    </div>

                    <button
                      onClick={() => navigate(`/curso/${curso.id}`)}
                      className="w-full bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-4 py-3 rounded-lg font-semibold flex items-center justify-center gap-2 transition"
                    >
                      Ver Curso
                      <ArrowRight className="w-4 h-4" />
                    </button>
                  </div>
                )
              })}
            </div>
          )}
        </>
      )}
    </div>
  )
}
