import React, { useEffect, useState } from "react"
import { BookOpen } from "lucide-react"
import * as boletinService from "../services/bulletin"
import competenciasService from "../services/competencies"

const NIVEL_COLORS = {
  Avanzado: "bg-emerald-500/20 text-emerald-300 border border-emerald-500/30",
  Satisfactorio: "bg-blue-500/20 text-blue-300 border border-blue-500/30",
  Básico: "bg-yellow-500/20 text-yellow-300 border border-yellow-500/30",
  Incipiente: "bg-red-500/20 text-red-300 border border-red-500/30",
}

export default function BoletinPage({ usuario }) {
  const rolUsuario = (usuario?.rol || usuario?.role || "").toLowerCase()
  const esEstudiante = rolUsuario === "student" || rolUsuario === "estudiante"

  // Estado para vista de estudiante
  const [boletinPersonal, setBoletinPersonal] = useState(null)
  const [cargandoPersonal, setCargandoPersonal] = useState(false)

  // Estado para vista de docente/admin
  const [competencias, setCompetencias] = useState([])
  const [competenciaId, setCompetenciaId] = useState("")
  const [datos, setDatos] = useState([])
  const [cargandoCompetencias, setCargandoCompetencias] = useState(false)
  const [cargando, setCargando] = useState(false)
  const [consultado, setConsultado] = useState(false)
  const [error, setError] = useState(null)

  useEffect(() => {
    if (esEstudiante && usuario?.id) {
      cargarBoletinPersonal()
    } else {
      cargarCompetencias()
    }
  }, [esEstudiante, usuario?.id])

  const cargarBoletinPersonal = async () => {
    setCargandoPersonal(true)
    setError(null)
    try {
      const data = await boletinService.generarBoletinEstudiante(usuario.id)
      setBoletinPersonal(data)
    } catch (err) {
      setError(err.response?.data?.error || err.message)
    } finally {
      setCargandoPersonal(false)
    }
  }

  const cargarCompetencias = async () => {
    setCargandoCompetencias(true)
    setError(null)
    try {
      const data = await competenciasService.getAll()
      const lista = Array.isArray(data) ? data : []
      setCompetencias(lista)
      setCompetenciaId(lista[0]?.id || "")
    } catch (err) {
      setError(err.response?.data?.error || err.message)
    } finally {
      setCargandoCompetencias(false)
    }
  }

  const handleCargar = async () => {
    if (!competenciaId) { setError("Selecciona una competencia"); return }
    setCargando(true)
    setConsultado(true)
    setError(null)
    try {
      const data = await boletinService.obtenerBoletinCompetencia(competenciaId)
      setDatos(Array.isArray(data) ? data : [])
    } catch (err) {
      setDatos([])
      setError(err.response?.data?.error || err.message)
    } finally {
      setCargando(false)
    }
  }

  const formatearFecha = (fecha) => {
    if (!fecha) return ""
    return new Date(fecha).toLocaleDateString("es-ES", { year: "numeric", month: "long", day: "numeric" })
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-gradient-to-br from-green-600 to-green-700 rounded-lg">
            <BookOpen className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">
              {esEstudiante ? "Mi Boletín" : "Boletín por Competencia"}
            </h1>
            <p className="text-neutral-400">
              {esEstudiante ? "Tu resumen de calificaciones por competencia" : "Resumen de evaluaciones por resultado de aprendizaje"}
            </p>
          </div>
        </div>
      </div>

      {error && (
        <div className="bg-red-500/10 border border-red-500/30 rounded-lg p-4 mb-6">
          <p className="text-red-400 font-semibold">Error: {error}</p>
        </div>
      )}

      {/* VISTA ESTUDIANTE */}
      {esEstudiante && (
        <div className="space-y-6">
          {cargandoPersonal ? (
            <div className="py-12 text-center text-neutral-400">Cargando tu boletín...</div>
          ) : !boletinPersonal ? (
            <div className="py-12 text-center text-neutral-400">No hay datos disponibles</div>
          ) : (
            <>
              {/* Resumen general */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 border-l-4 border-l-blue-500">
                  <p className="text-sm text-neutral-400 font-semibold">Promedio General</p>
                  <p className="text-4xl font-bold text-blue-400 mt-2">{boletinPersonal.promedio_general}/100</p>
                  <span className={`mt-2 inline-block px-2 py-1 rounded-full text-xs font-semibold ${NIVEL_COLORS[boletinPersonal.nivel_general] || "bg-neutral-700 text-neutral-300"}`}>
                    {boletinPersonal.nivel_general}
                  </span>
                </div>
                <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 border-l-4 border-l-emerald-500">
                  <p className="text-sm text-neutral-400 font-semibold">Total Competencias</p>
                  <p className="text-4xl font-bold text-emerald-400 mt-2">{boletinPersonal.total_competencias}</p>
                </div>
                <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 border-l-4 border-l-purple-500">
                  <p className="text-sm text-neutral-400 font-semibold mb-2">Distribución de Logros</p>
                  <div className="space-y-1 text-xs">
                    {Object.entries(boletinPersonal.logros || {}).map(([nivel, count]) => (
                      <div key={nivel} className="flex justify-between">
                        <span className="text-neutral-400">{nivel}</span>
                        <span className="font-bold text-white">{count}</span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>

              {/* Tabla de competencias */}
              <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
                <div className="px-6 py-4 border-b border-neutral-700/50">
                  <h2 className="text-lg font-bold text-white">Detalle por Competencia</h2>
                </div>
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead>
                      <tr className="bg-neutral-900/50 border-b border-neutral-700/50">
                        <th className="px-6 py-4 text-left font-semibold text-neutral-300">Competencia</th>
                        <th className="px-6 py-4 text-left font-semibold text-neutral-300">Promedio</th>
                        <th className="px-6 py-4 text-left font-semibold text-neutral-300">Nivel</th>
                        <th className="px-6 py-4 text-left font-semibold text-neutral-300">Evaluaciones</th>
                      </tr>
                    </thead>
                    <tbody>
                      {(boletinPersonal.competencies || []).map((comp) => (
                        <tr key={comp.competency_id} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition">
                          <td className="px-6 py-4 text-white font-semibold">{comp.competencia_nombre}</td>
                          <td className="px-6 py-4 text-blue-400 font-bold">{comp.promedio}/100</td>
                          <td className="px-6 py-4">
                            <span className={`px-2 py-1 rounded-full text-xs font-semibold ${NIVEL_COLORS[comp.nivel] || "bg-neutral-700 text-neutral-300"}`}>
                              {comp.nivel} ({comp.codigo})
                            </span>
                          </td>
                          <td className="px-6 py-4 text-neutral-400">{comp.total_evaluaciones}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>

              {/* Fortalezas y áreas de mejora */}
              {boletinPersonal.resumen && (
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="bg-emerald-500/10 border border-emerald-500/30 rounded-2xl p-6">
                    <h3 className="font-bold text-emerald-300 mb-3">Fortalezas</h3>
                    {boletinPersonal.resumen.fortalezas?.length > 0
                      ? boletinPersonal.resumen.fortalezas.map((f, i) => <p key={i} className="text-sm text-neutral-300">• {f}</p>)
                      : <p className="text-sm text-neutral-500">Sin fortalezas identificadas aún</p>}
                  </div>
                  <div className="bg-red-500/10 border border-red-500/30 rounded-2xl p-6">
                    <h3 className="font-bold text-red-300 mb-3">Áreas de Mejora</h3>
                    {boletinPersonal.resumen.areas_mejora?.length > 0
                      ? boletinPersonal.resumen.areas_mejora.map((a, i) => <p key={i} className="text-sm text-neutral-300">• {a}</p>)
                      : <p className="text-sm text-neutral-500">¡Excelente! Sin áreas críticas</p>}
                  </div>
                </div>
              )}
            </>
          )}
        </div>
      )}

      {/* VISTA DOCENTE/ADMIN */}
      {!esEstudiante && (
        <>
          <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 mb-6">
            <label className="block text-sm font-semibold text-white mb-3">Competencia</label>
            <div className="flex flex-col md:flex-row gap-3">
              <select
                value={competenciaId}
                onChange={(e) => setCompetenciaId(e.target.value)}
                disabled={cargandoCompetencias}
                className="flex-1 bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-primary-brand transition disabled:opacity-50"
              >
                <option value="">{cargandoCompetencias ? "Cargando..." : "Selecciona una competencia"}</option>
                {competencias.map((c) => (
                  <option key={c.id} value={c.id}>{c.nombre || c.name || c.id}</option>
                ))}
              </select>
              <button
                onClick={handleCargar}
                disabled={cargando || cargandoCompetencias || !competenciaId}
                className="bg-primary-brand hover:bg-primary-600 text-white px-6 py-3 rounded-lg font-semibold transition disabled:opacity-50"
              >
                {cargando ? "Cargando..." : "Cargar"}
              </button>
            </div>
          </div>

          <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
            {cargando ? (
              <div className="py-12 text-center text-neutral-400">Cargando boletín...</div>
            ) : consultado && datos.length === 0 ? (
              <div className="py-12 text-center text-neutral-400">Sin datos para esta competencia</div>
            ) : !consultado ? (
              <div className="py-12 text-center text-neutral-400">Selecciona una competencia y carga el boletín</div>
            ) : (
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="bg-neutral-900/50 border-b border-neutral-700/50">
                      <th className="px-6 py-4 text-left font-semibold text-neutral-300">Resultado</th>
                      <th className="px-6 py-4 text-left font-semibold text-neutral-300">Evaluaciones</th>
                      <th className="px-6 py-4 text-left font-semibold text-neutral-300">Promedio</th>
                    </tr>
                  </thead>
                  <tbody>
                    {datos.map((item, index) => (
                      <tr key={`${item.learning_outcome_name}-${index}`} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition">
                        <td className="px-6 py-4 text-white font-semibold">{item.learning_outcome_name}</td>
                        <td className="px-6 py-4 text-neutral-300">{item.total_evaluaciones}</td>
                        <td className="px-6 py-4 text-primary-brand font-bold">{item.promedio}/100</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </>
      )}
    </div>
  )
}
