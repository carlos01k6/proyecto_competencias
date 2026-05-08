import React from 'react'
import { AlertOctagon, AlertTriangle, AlertCircle, ChevronRight, Check } from 'lucide-react'
import NivelRiesgoIndicador from './NivelRiesgoIndicador'

const NIVEL_CONFIG = {
  critico: {
    bgClass: 'bg-red-500/10 border-red-500/30',
    textClass: 'text-red-400',
    barClass: 'from-red-600 to-red-500',
    icon: AlertOctagon,
    label: 'Crítico',
  },
  alto: {
    bgClass: 'bg-orange-500/10 border-orange-500/30',
    textClass: 'text-orange-400',
    barClass: 'from-orange-600 to-orange-500',
    icon: AlertTriangle,
    label: 'Alto',
  },
  medio: {
    bgClass: 'bg-yellow-500/10 border-yellow-500/30',
    textClass: 'text-yellow-400',
    barClass: 'from-yellow-600 to-yellow-500',
    icon: AlertCircle,
    label: 'Medio',
  },
}

export default function AlertaCard({
  estudiante_nombre,
  porcentaje_logro,
  nivel_riesgo,
  tipo_alerta,
  leida = false,
  onClick,
  onMarcarLeida,
}) {
  const config = NIVEL_CONFIG[nivel_riesgo] || NIVEL_CONFIG.medio
  const Icon = config.icon

  return (
    <div
      onClick={onClick}
      className={`rounded-xl border p-4 transition hover:shadow-lg cursor-pointer ${config.bgClass} ${leida ? 'opacity-50' : ''}`}
    >
      <div className="flex items-center justify-between mb-3">
        <div className="flex items-center gap-2 min-w-0">
          <Icon className={`w-5 h-5 flex-shrink-0 ${config.textClass}`} />
          <span className="font-semibold text-white truncate">{estudiante_nombre}</span>
        </div>
        <span className={`ml-2 flex-shrink-0 text-xs font-bold px-2 py-1 rounded-full border ${config.textClass} ${config.bgClass}`}>
          {config.label}
        </span>
      </div>

      <div className="mb-3">
        <div className="flex justify-between text-xs mb-1">
          <span className="text-neutral-400">% Logro</span>
          <span className={`font-bold ${config.textClass}`}>{porcentaje_logro}%</span>
        </div>
        <div className="h-2 bg-neutral-700 rounded-full overflow-hidden">
          <div
            className={`h-full rounded-full bg-gradient-to-r ${config.barClass}`}
            style={{ width: `${Math.min(porcentaje_logro, 100)}%` }}
          />
        </div>
      </div>

      <div className="flex items-center justify-between">
        <span className="text-xs text-neutral-500 capitalize">{tipo_alerta?.replace('_', ' ')}</span>
        <div className="flex gap-1">
          {!leida && onMarcarLeida && (
            <button
              onClick={e => { e.stopPropagation(); onMarcarLeida() }}
              title="Marcar como leída"
              className="p-1.5 rounded-lg hover:bg-neutral-700 transition text-neutral-400 hover:text-emerald-400"
            >
              <Check className="w-4 h-4" />
            </button>
          )}
          <ChevronRight className="w-4 h-4 text-neutral-500 self-center" />
        </div>
      </div>
    </div>
  )
}
