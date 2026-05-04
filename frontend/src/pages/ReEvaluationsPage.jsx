import React, { useEffect, useState } from "react"
import { RefreshCw } from "lucide-react"
import * as reEvaluationsService from "../services/re_evaluations"

export default function ReEvaluationsPage({ usuario }) {
  const [estudiantesReevaluar, setEstudiantesReevaluar] = useState([])
  const [estudianteExpandido, setEstudianteExpandido] = useState(null)
  const [reevaluacionActiva, setReevaluacionActiva] = useState(null)
  const [formData, setFormData] = useState({ calificacion_nueva: "", observacion: "" })
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const cargarDisponibles = async () => {
    if (!usuario?.id) return
      setCargando(true)
      setError(null)

      try {
        const data = await reEvaluationsService.obtenerReevaluacionesDocente(usuario.id)
        setEstudiantesReevaluar(Array.isArray(data) ? data : [])
      } catch (err) {
        setError(err.response?.data?.error || err.message)
      } finally {
        setCargando(false)
      }
    }

  useEffect(() => {
    cargarDisponibles()
  }, [usuario?.id])

  const abrirEvaluacion = (reevaluacion) => {
    setReevaluacionActiva(reevaluacion)
    setFormData({ calificacion_nueva: "", observacion: "" })
  }

  const guardarEvaluacion = async (e) => {
    e.preventDefault()
    if (!reevaluacionActiva?.id) {
      alert("Esta re-evaluación no tiene ID para completar")
      return
    }

    try {
      await reEvaluationsService.completarReevaluacion(reevaluacionActiva.id, formData)
      setReevaluacionActiva(null)
      await cargarDisponibles()
    } catch (err) {
      alert("Error al completar re-evaluación: " + (err.response?.data?.error || err.message))
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-gradient-to-br from-blue-600 to-blue-700 rounded-lg">
            <RefreshCw className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Re-evaluaciones</h1>
            <p className="text-neutral-400">Estudiantes que necesitan re-evaluación</p>
          </div>
        </div>
      </div>

      {error && (
        <div className="bg-danger/10 border border-danger/30 rounded-lg p-4 mb-6">
          <p className="text-danger font-semibold">Error: {error}</p>
        </div>
      )}

      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
        {cargando ? (
          <div className="py-12 text-center text-neutral-400">Cargando estudiantes...</div>
        ) : estudiantesReevaluar.length === 0 ? (
          <div className="py-12 text-center text-neutral-400">No hay estudiantes pendientes de re-evaluación</div>
        ) : (
          <div className="divide-y divide-neutral-800/70">
            {estudiantesReevaluar.map((item) => {
              const pendientes = item.re_evaluaciones_pendientes || []
              const abierto = estudianteExpandido === item.estudiante_id
              return (
                <div key={item.estudiante_id}>
                  <button
                    onClick={() => setEstudianteExpandido(abierto ? null : item.estudiante_id)}
                    className="w-full px-6 py-5 flex items-center justify-between hover:bg-neutral-900/50 transition"
                  >
                    <div className="text-left">
                      <p className="text-white font-bold">{item.estudiante_nombre || item.student_name}</p>
                      <p className="text-xs text-neutral-500">{item.estudiante_id}</p>
                    </div>
                    <span className="bg-warning/20 text-warning px-3 py-1 rounded-full text-xs font-bold">
                      {pendientes.length} pendientes
                    </span>
                  </button>

                  {abierto && (
                    <div className="px-6 pb-5 space-y-3">
                      {pendientes.map((reevaluacion, index) => (
                        <div key={`${reevaluacion.id || reevaluacion.criteria_id}-${index}`} className="rounded-xl bg-neutral-900/70 border border-neutral-800 p-4 flex flex-col md:flex-row md:items-center justify-between gap-4">
                          <div>
                            <p className="text-white font-semibold">{reevaluacion.criteria_name || "Criterio"}</p>
                            <p className="text-sm text-neutral-400">{reevaluacion.competency_name || "Competencia no definida"}</p>
                            <p className="text-sm text-danger font-bold">Anterior: {reevaluacion.calificacion_anterior ?? reevaluacion.old_grade}/100</p>
                          </div>
                          <button
                            onClick={() => abrirEvaluacion(reevaluacion)}
                            className="bg-primary-brand hover:bg-primary-600 text-white px-4 py-2 rounded-lg text-sm font-semibold transition"
                          >
                            Evaluar
                          </button>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              )
            })}
          </div>
        )}
      </div>

      {reevaluacionActiva && (
        <div className="fixed inset-0 bg-black/70 z-50 flex items-center justify-center p-4">
          <div className="w-full max-w-lg rounded-2xl bg-neutral-950 border border-neutral-700 p-6">
            <h2 className="text-2xl font-bold text-white mb-2">Completar re-evaluación</h2>
            <p className="text-neutral-400 mb-6">{reevaluacionActiva.criteria_name}</p>
            <form onSubmit={guardarEvaluacion} className="space-y-4">
              <input
                type="number"
                min="0"
                max="100"
                value={formData.calificacion_nueva}
                onChange={(e) => setFormData({ ...formData, calificacion_nueva: e.target.value })}
                placeholder="Calificación nueva"
                className="w-full bg-neutral-800 border border-neutral-700 text-white rounded-lg px-4 py-3"
                required
              />
              <textarea
                value={formData.observacion}
                onChange={(e) => setFormData({ ...formData, observacion: e.target.value })}
                placeholder="Observación"
                rows="4"
                className="w-full bg-neutral-800 border border-neutral-700 text-white rounded-lg px-4 py-3"
              />
              <div className="flex gap-3">
                <button type="submit" className="flex-1 bg-primary-brand hover:bg-primary-600 text-white py-3 rounded-lg font-semibold">
                  Guardar
                </button>
                <button type="button" onClick={() => setReevaluacionActiva(null)} className="flex-1 bg-neutral-800 hover:bg-neutral-700 text-white py-3 rounded-lg font-semibold">
                  Cancelar
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  )
}
