import React from "react"
import { useReportesDirector } from "../hooks/useReportesDirector"
import { BarChart3 } from "lucide-react"

export default function ReportesDirectorPage({ usuario }) {
  const { competencias, cargando } = useReportesDirector()

  const getColorPromedioGraduado = (promedio) => {
    if (promedio >= 90) return "text-success"
    if (promedio >= 70) return "text-primary-brand"
    if (promedio >= 40) return "text-warning"
    return "text-danger"
  }

  const getColorBarra = (porcentaje) => {
    if (porcentaje >= 75) return "bg-success"
    if (porcentaje >= 50) return "bg-primary-brand"
    if (porcentaje >= 25) return "bg-warning"
    return "bg-danger"
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-4">
          <div className="p-3 bg-gradient-to-br from-violet-600 to-violet-700 rounded-lg">
            <BarChart3 className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Reportes para Dirección</h1>
            <p className="text-neutral-400">Resumen de desempeño por competencia con estadísticas y percentiles</p>
          </div>
        </div>
      </div>

      {cargando ? (
        <div className="text-center text-neutral-400 py-12">
          <div className="inline-block">
            <div className="animate-spin">
              <div className="w-8 h-8 border-4 border-neutral-700 border-t-primary-brand rounded-full"></div>
            </div>
          </div>
          <p className="mt-4">Cargando reportes...</p>
        </div>
      ) : competencias.length === 0 ? (
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 text-center">
          <p className="text-neutral-400 text-lg">No hay datos de competencias</p>
        </div>
      ) : (
        <div className="space-y-6">
          {competencias.map((competencia) => (
            <div key={competencia.competencia_nombre} className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8">
              {/* Encabezado */}
              <div className="mb-8 pb-6 border-b border-neutral-700/50">
                <h2 className="text-2xl font-bold text-white">{competencia.competencia_nombre}</h2>
                <p className="text-sm text-neutral-400 mt-2">
                  {competencia.total_evaluaciones} evaluaciones registradas
                </p>
              </div>

              {/* Estadísticas principales */}
              <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
                <div className="bg-primary-brand/10 border border-primary-brand/30 rounded-lg p-4">
                  <p className="text-xs text-neutral-400 font-semibold">Promedio</p>
                  <p className={`text-3xl font-bold mt-2 ${getColorPromedioGraduado(competencia.promedio)}`}>
                    {competencia.promedio}
                  </p>
                </div>
                <div className="bg-blue-600/10 border border-blue-600/30 rounded-lg p-4">
                  <p className="text-xs text-neutral-400 font-semibold">Percentil 25</p>
                  <p className="text-3xl font-bold mt-2 text-blue-400">{competencia.percentil_25}</p>
                </div>
                <div className="bg-blue-600/10 border border-blue-600/30 rounded-lg p-4">
                  <p className="text-xs text-neutral-400 font-semibold">Mediana (P50)</p>
                  <p className="text-3xl font-bold mt-2 text-blue-400">{competencia.percentil_50}</p>
                </div>
                <div className="bg-blue-600/10 border border-blue-600/30 rounded-lg p-4">
                  <p className="text-xs text-neutral-400 font-semibold">Percentil 75</p>
                  <p className="text-3xl font-bold mt-2 text-blue-400">{competencia.percentil_75}</p>
                </div>
              </div>

              {/* Distribución de desempeño */}
              <div className="mb-8">
                <h3 className="text-lg font-bold text-white mb-6">Distribución de Desempeño</h3>
                <div className="space-y-4">
                  {/* Bajo */}
                  <div>
                    <div className="flex justify-between mb-2">
                      <span className="text-sm font-semibold text-neutral-300">Refuerzo Necesario (0-40)</span>
                      <span className="text-sm font-bold text-danger">{competencia.distribucion.bajo}</span>
                    </div>
                    <div className="w-full bg-neutral-900/50 rounded-full h-3 border border-neutral-700/50">
                      <div
                        className="bg-danger h-3 rounded-full"
                        style={{ width: `${(competencia.distribucion.bajo / competencia.total_evaluaciones) * 100}%` }}
                      ></div>
                    </div>
                  </div>

                  {/* Medio */}
                  <div>
                    <div className="flex justify-between mb-2">
                      <span className="text-sm font-semibold text-neutral-300">En Desarrollo (41-70)</span>
                      <span className="text-sm font-bold text-warning">{competencia.distribucion.medio}</span>
                    </div>
                    <div className="w-full bg-neutral-900/50 rounded-full h-3 border border-neutral-700/50">
                      <div
                        className="bg-warning h-3 rounded-full"
                        style={{ width: `${(competencia.distribucion.medio / competencia.total_evaluaciones) * 100}%` }}
                      ></div>
                    </div>
                  </div>

                  {/* Alto */}
                  <div>
                    <div className="flex justify-between mb-2">
                      <span className="text-sm font-semibold text-neutral-300">Consolidado (71-90)</span>
                      <span className="text-sm font-bold text-primary-brand">{competencia.distribucion.alto}</span>
                    </div>
                    <div className="w-full bg-neutral-900/50 rounded-full h-3 border border-neutral-700/50">
                      <div
                        className="bg-primary-brand h-3 rounded-full"
                        style={{ width: `${(competencia.distribucion.alto / competencia.total_evaluaciones) * 100}%` }}
                      ></div>
                    </div>
                  </div>

                  {/* Excelente */}
                  <div>
                    <div className="flex justify-between mb-2">
                      <span className="text-sm font-semibold text-neutral-300">Excelencia (91-100)</span>
                      <span className="text-sm font-bold text-success">{competencia.distribucion.excelente}</span>
                    </div>
                    <div className="w-full bg-neutral-900/50 rounded-full h-3 border border-neutral-700/50">
                      <div
                        className="bg-success h-3 rounded-full"
                        style={{ width: `${(competencia.distribucion.excelente / competencia.total_evaluaciones) * 100}%` }}
                      ></div>
                    </div>
                  </div>
                </div>
              </div>

              {/* Indicadores de meta */}
              <div className="bg-neutral-900/50 p-6 rounded-lg border border-neutral-700/50">
                <p className="text-sm font-semibold text-white mb-3">Meta Institucional</p>
                <div className="flex items-center gap-3">
                  <div className="flex-1 bg-neutral-800/50 rounded-full h-4 border border-neutral-700/50">
                    <div
                      className={`h-4 rounded-full ${competencia.promedio >= 80 ? "bg-success" : "bg-warning"}`}
                      style={{ width: `${Math.min(competencia.promedio, 100)}%` }}
                    ></div>
                  </div>
                  <span className="text-sm font-bold text-white">
                    {competencia.promedio >= 80 ? "✓ Meta alcanzada" : "⚠ Meta en progreso"}
                  </span>
                </div>
                <p className="text-xs text-neutral-500 mt-3">
                  Meta institucional: 80 puntos (Desempeño actual: {competencia.promedio}/100)
                </p>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
