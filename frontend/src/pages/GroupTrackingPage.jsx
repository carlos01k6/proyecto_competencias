import React, { useEffect, useState } from "react"
import { Users } from "lucide-react"
import * as groupTrackingService from "../services/group_tracking"

export default function GroupTrackingPage({ usuario }) {
  const [resumen, setResumen] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  useEffect(() => {
    const cargarResumen = async () => {
      if (!usuario?.id) return

      setCargando(true)
      setError(null)

      try {
        const data = await groupTrackingService.obtenerResumenDocente(usuario.id)
        setResumen(Array.isArray(data) ? data : [])
      } catch (err) {
        setResumen([])
        setError(err.response?.data?.error || err.message)
      } finally {
        setCargando(false)
      }
    }

    cargarResumen()
  }, [usuario?.id])

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-gradient-to-br from-pink-600 to-pink-700 rounded-lg">
            <Users className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Progreso del Grupo</h1>
            <p className="text-neutral-400">Resumen de evaluaciones por competencia</p>
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
          <div className="py-12 text-center text-neutral-400">Cargando progreso del grupo...</div>
        ) : resumen.length === 0 ? (
          <div className="py-12 text-center text-neutral-400">Sin evaluaciones del grupo</div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="bg-neutral-900/50 border-b border-neutral-700/50">
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Competencia</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Promedio</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Total Evals</th>
                </tr>
              </thead>
              <tbody>
                {resumen.map((item, index) => (
                  <tr key={`${item.competencia_name}-${index}`} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition">
                    <td className="px-6 py-4 text-white font-semibold">{item.competencia_name}</td>
                    <td className="px-6 py-4 text-primary-brand font-bold">{item.promedio}/100</td>
                    <td className="px-6 py-4 text-neutral-300">{item.total_evals}</td>
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
