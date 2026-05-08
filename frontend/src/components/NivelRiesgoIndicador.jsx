import React from 'react'

const CONFIG = {
  critico: { color: '#ef4444', track: '#450a0a', label: 'Crítico' },
  alto:    { color: '#f97316', track: '#431407', label: 'Alto' },
  medio:   { color: '#eab308', track: '#422006', label: 'Medio' },
  bajo:    { color: '#22c55e', track: '#052e16', label: 'Bajo' },
}

export default function NivelRiesgoIndicador({ nivel, porcentaje }) {
  const cfg = CONFIG[nivel] || CONFIG.bajo
  const radius = 20
  const circumference = 2 * Math.PI * radius
  const offset = circumference - (Math.min(porcentaje, 100) / 100) * circumference

  return (
    <div className="flex flex-col items-center gap-1">
      <div className="relative w-14 h-14">
        <svg width="56" height="56" viewBox="0 0 56 56" className="-rotate-90" aria-hidden="true">
          <circle cx="28" cy="28" r={radius} fill="none" stroke={cfg.track} strokeWidth="6" />
          <circle
            cx="28" cy="28" r={radius}
            fill="none"
            stroke={cfg.color}
            strokeWidth="6"
            strokeDasharray={circumference}
            strokeDashoffset={offset}
            strokeLinecap="round"
          />
        </svg>
        <div className="absolute inset-0 flex items-center justify-center">
          <span className="text-xs font-bold leading-none" style={{ color: cfg.color }}>
            {porcentaje}%
          </span>
        </div>
      </div>
      <span className="text-xs font-semibold" style={{ color: cfg.color }}>{cfg.label}</span>
    </div>
  )
}
