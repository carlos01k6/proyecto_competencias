import React, { useEffect, useState } from "react"
import { RefreshCw } from "lucide-react"
import * as reEvaluationsService from "../services/re_evaluations"

export default function ReEvaluationsPage() {
  const [estudiantesReevaluar, setEstudiantesReevaluar] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  useEffect(() => {
    const cargarDisponibles = async () => {
      setCargando(true)
      setError(null)

      try {
        const data = await reEvaluationsService.obtenerDisponiblesReevaluar()
        setEstudiantesReevaluar(Array.isArray(data) ? data : [])
      } catch (err) {
        setError(err.response?.data?.error || err.message)
      } finally {
        setCargando(false)
      }
    }

    cargarDisponibles()
  }, [])

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
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="bg-neutral-900/50 border-b border-neutral-700/50">
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Estudiante</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Criterio</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Calificación Anterior</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Competencia</th>
                  <th className="px-6 py-4 text-right font-semibold text-neutral-300">Acción</th>
                </tr>
              </thead>
              <tbody>
                {estudiantesReevaluar.map((item, index) => (
                  <tr key={`${item.student_id}-${item.criteria_name}-${index}`} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition">
                    <td className="px-6 py-4 text-white font-semibold">{item.student_name}</td>
                    <td className="px-6 py-4 text-neutral-300">{item.criteria_name}</td>
                    <td className="px-6 py-4 text-danger font-bold">{item.old_grade}/100</td>
                    <td className="px-6 py-4 text-neutral-400">{item.competency_name || "N/A"}</td>
                    <td className="px-6 py-4 text-right">
                      <button className="bg-primary-brand hover:bg-primary-600 text-white px-4 py-2 rounded-lg text-sm font-semibold transition">
                        Re-evaluar
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  )
}
