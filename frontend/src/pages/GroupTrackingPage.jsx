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

  const totalDistribucion = (distribucion = {}) =>
    ["incipiente", "basico", "satisfactorio", "avanzado"].reduce((total, key) => total + Number(distribucion[key] || 0), 0)

  const segmentos = [
    { key: "incipiente", label: "incipiente", color: "bg-danger" },
    { key: "basico", label: "básico", color: "bg-warning" },
    { key: "satisfactorio", label: "satisfactorio", color: "bg-success" },
    { key: "avanzado", label: "avanzado", color: "bg-primary-brand" }
  ]

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
          <div className="divide-y divide-neutral-800/70">
            {resumen.map((item, index) => {
              const distribucion = item.distribucion || {}
              const total = totalDistribucion(distribucion)
              return (
                <div key={`${item.competencia_nombre || item.competencia_name}-${index}`} className="p-6">
                  <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4 mb-4">
                    <div>
                      <h3 className="text-lg font-bold text-white">{item.competencia_nombre || item.competencia_name}</h3>
                      <p className="text-sm text-neutral-500">{total} estudiantes evaluados</p>
                    </div>
                    <div className="flex flex-wrap gap-3 text-sm">
                      {segmentos.map((segmento) => (
                        <span key={segmento.key} className="text-neutral-300">
                          <strong className="text-white">{distribucion[segmento.key] || 0}</strong> {segmento.label}
                        </span>
                      ))}
                    </div>
                  </div>

                  <div className="h-5 w-full rounded-full overflow-hidden bg-neutral-800 flex">
                    {segmentos.map((segmento) => {
                      const valor = Number(distribucion[segmento.key] || 0)
                      const width = total > 0 ? `${(valor / total) * 100}%` : "0%"
                      return (
                        <div
                          key={segmento.key}
                          className={`${segmento.color} h-full`}
                          style={{ width }}
                          title={`${valor} ${segmento.label}`}
                        />
                      )
                    })}
                  </div>
                </div>
              )
            })}
          </div>
        )}
      </div>
    </div>
  )
}
