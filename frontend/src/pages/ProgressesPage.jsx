import React, { useEffect, useState } from "react"
import { TrendingUp } from "lucide-react"
import * as seguimientoService from "../services/tracking"

export default function ProgresosPage({ usuario }) {
  const [competencias, setCompetencias] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  useEffect(() => {
    const cargarProgreso = async () => {
      if (!usuario?.id) return

      setCargando(true)
      setError(null)

      try {
        const data = await seguimientoService.obtenerProgresoCompetencias(usuario.id)
        setCompetencias(Array.isArray(data) ? data : [])
      } catch (err) {
        setCompetencias([])
        setError(err.response?.data?.error || err.response?.data?.mensaje || err.message)
      } finally {
        setCargando(false)
      }
    }

    cargarProgreso()
  }, [usuario?.id])

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-gradient-to-br from-emerald-600 to-emerald-700 rounded-lg">
            <TrendingUp className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Mi Progreso Estudiante</h1>
            <p className="text-neutral-400">Resumen de tus evaluaciones por competencia</p>
          </div>
        </div>
      </div>

      {usuario?.id && (
        <div className="mb-6 rounded-lg bg-neutral-800/60 border border-neutral-700 p-4 flex flex-col md:flex-row md:items-center justify-between gap-3">
          <p className="text-neutral-300">Tu ID: <strong className="text-white">{usuario.id}</strong></p>
          <button onClick={() => navigator.clipboard.writeText(usuario.id)} className="bg-primary-brand hover:bg-primary-600 text-white px-4 py-2 rounded-lg font-semibold">
            Copiar ID
          </button>
        </div>
      )}

      {error && (
        <div className="bg-danger/10 border border-danger/30 rounded-lg p-4 mb-6">
          <p className="text-danger font-semibold">Error: {error}</p>
        </div>
      )}

      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
        {cargando ? (
          <div className="py-12 text-center text-neutral-400">Cargando tu progreso...</div>
        ) : competencias.length === 0 ? (
          <div className="py-12 text-center text-neutral-400">Sin evaluaciones aún</div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="bg-neutral-900/50 border-b border-neutral-700/50">
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Competencia</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Promedio General</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Cantidad Evaluaciones</th>
                </tr>
              </thead>
              <tbody>
                {competencias.map((competencia) => (
                  <tr key={competencia.competency_id} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition">
                    <td className="px-6 py-4 text-white font-semibold">
                      {competencia.competencia_name || competencia.competencia_nombre}
                    </td>
                    <td className="px-6 py-4 text-primary-brand font-bold">
                      {competencia.promedio_general}/100
                    </td>
                    <td className="px-6 py-4 text-neutral-300">
                      {competencia.total_evaluaciones}
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
