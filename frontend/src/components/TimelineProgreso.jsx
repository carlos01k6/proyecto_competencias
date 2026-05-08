import React from 'react'
import { TrendingUp, TrendingDown, Minus, RefreshCw } from 'lucide-react'

export default function TimelineProgreso({ historial = [] }) {
  if (!historial.length) {
    return <p className="text-neutral-500 text-sm text-center py-6">Sin datos en el historial</p>
  }

  return (
    <div className="relative pl-8">
      {/* vertical line */}
      <div className="absolute left-3 top-2 bottom-2 w-0.5 bg-neutral-700 rounded-full" />

      <div className="space-y-3">
        {historial.map((punto, i) => {
          const mejoro = punto.cambio != null && punto.cambio > 0
          const bajo   = punto.cambio != null && punto.cambio < 0
          const Icon   = mejoro ? TrendingUp : bajo ? TrendingDown : Minus
          const dot    = mejoro ? 'bg-emerald-500' : bajo ? 'bg-red-500' : 'bg-neutral-500'
          const color  = mejoro ? 'text-emerald-400' : bajo ? 'text-red-400' : 'text-neutral-400'

          return (
            <div key={i} className="relative flex gap-3">
              {/* Dot */}
              <div className={`absolute -left-8 top-3 w-3 h-3 rounded-full border-2 border-neutral-900 ${dot}`} />

              <div className="flex-1 bg-neutral-800/50 border border-neutral-700/30 rounded-xl p-3">
                <div className="flex items-start justify-between gap-2">
                  <div className="min-w-0">
                    <p className="text-xs text-neutral-500 flex items-center gap-1.5">
                      {punto.fecha ? new Date(punto.fecha).toLocaleDateString('es-ES') : '—'}
                      {punto.es_reevaluacion && (
                        <span className="inline-flex items-center gap-0.5 text-blue-400 font-medium">
                          <RefreshCw className="w-2.5 h-2.5" /> Re-eval
                        </span>
                      )}
                    </p>
                    <p className="text-sm font-semibold text-white mt-0.5 truncate">
                      {punto.competencia_nombre || `Evaluación ${punto.evaluacion_num || i + 1}`}
                    </p>
                    {punto.porcentaje_antes != null && punto.porcentaje_despues != null && (
                      <p className="text-xs text-neutral-500 mt-0.5">
                        Promedio: {punto.porcentaje_antes}% → <span className="text-white font-semibold">{punto.porcentaje_despues}%</span>
                      </p>
                    )}
                    {punto.promedio_acumulado != null && punto.porcentaje_despues == null && (
                      <p className="text-xs text-neutral-500 mt-0.5">
                        Promedio acumulado: <span className="text-white font-semibold">{punto.promedio_acumulado}%</span>
                      </p>
                    )}
                  </div>
                  <div className="text-right flex-shrink-0">
                    <p className="text-xl font-black text-white">{punto.calificacion ?? punto.promedio_acumulado}</p>
                    {punto.cambio != null && (
                      <p className={`text-xs font-bold flex items-center justify-end gap-0.5 ${color}`}>
                        <Icon className="w-3 h-3" />
                        {punto.cambio > 0 ? '+' : ''}{punto.cambio}
                      </p>
                    )}
                  </div>
                </div>
              </div>
            </div>
          )
        })}
      </div>
    </div>
  )
}
