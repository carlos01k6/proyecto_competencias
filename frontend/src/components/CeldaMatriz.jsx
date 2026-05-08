import React, { useState } from 'react'

const NIVEL = {
  incipiente:   { bg: 'bg-red-500/25 border-red-500/40',    text: 'text-red-300',    label: 'Incipiente',    hex: '#ef4444' },
  basico:       { bg: 'bg-orange-500/25 border-orange-500/40', text: 'text-orange-300', label: 'Básico',     hex: '#f97316' },
  satisfactorio:{ bg: 'bg-yellow-500/25 border-yellow-500/40', text: 'text-yellow-300', label: 'Satisfactorio', hex: '#eab308' },
  avanzado:     { bg: 'bg-emerald-500/25 border-emerald-500/40', text: 'text-emerald-300', label: 'Avanzado', hex: '#22c55e' },
}

export default function CeldaMatriz({ porcentaje, nivel, nombre_competencia, nombre_estudiante, evaluaciones, onClick }) {
  const [hover, setHover] = useState(false)

  if (porcentaje === null || porcentaje === undefined) {
    return (
      <div className="w-16 h-12 flex items-center justify-center bg-neutral-800/20 border border-neutral-700/20 rounded text-neutral-600 text-xs select-none">
        —
      </div>
    )
  }

  const cfg = NIVEL[nivel] || NIVEL.incipiente

  return (
    <div
      className="relative"
      onMouseEnter={() => setHover(true)}
      onMouseLeave={() => setHover(false)}
    >
      <div
        onClick={onClick}
        className={`w-16 h-12 flex items-center justify-center rounded border cursor-pointer transition-transform hover:scale-110 select-none ${cfg.bg}`}
      >
        <span className={`text-xs font-bold ${cfg.text}`}>{porcentaje}%</span>
      </div>

      {hover && (
        <div className="absolute z-30 bottom-full left-1/2 -translate-x-1/2 mb-2 pointer-events-none">
          <div className="bg-neutral-800 border border-neutral-600 rounded-xl px-3 py-2 text-xs shadow-2xl whitespace-nowrap">
            {nombre_estudiante && <p className="font-bold text-white mb-0.5">{nombre_estudiante}</p>}
            {nombre_competencia && <p className="text-neutral-400 mb-1">{nombre_competencia}</p>}
            <p className={`font-semibold ${cfg.text}`}>{cfg.label} — {porcentaje}%</p>
            {evaluaciones != null && <p className="text-neutral-500 mt-0.5">{evaluaciones} evaluación{evaluaciones !== 1 ? 'es' : ''}</p>}
          </div>
          <div className="w-2 h-2 bg-neutral-800 border-r border-b border-neutral-600 rotate-45 mx-auto -mt-1" />
        </div>
      )}
    </div>
  )
}
