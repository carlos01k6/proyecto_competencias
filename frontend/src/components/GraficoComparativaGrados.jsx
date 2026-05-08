import React from 'react'
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip,
  Legend, ResponsiveContainer, ReferenceLine,
} from 'recharts'

const COLORES = ['#3b82f6', '#8b5cf6', '#10b981', '#f59e0b', '#ef4444', '#06b6d4', '#f43f5e']

const CustomTooltip = ({ active, payload, label }) => {
  if (!active || !payload?.length) return null
  return (
    <div className="bg-neutral-800 border border-neutral-600 rounded-xl px-4 py-3 shadow-2xl">
      <p className="text-white font-semibold text-sm mb-2">{label}</p>
      {payload.map((p, i) => (
        <p key={i} className="text-xs" style={{ color: p.color }}>
          {p.name}: <strong>{p.value}%</strong>
        </p>
      ))}
    </div>
  )
}

export default function GraficoComparativaGrados({ datos_cursos = [] }) {
  if (!datos_cursos.length) {
    return (
      <div className="flex items-center justify-center h-48 text-neutral-500 text-sm">
        Sin datos para comparar
      </div>
    )
  }

  // Build: [{competencia, Curso1: val, Curso2: val, ...}]
  const compMap = {}
  datos_cursos.forEach(curso => {
    ;(curso.competencias || []).forEach(comp => {
      if (!compMap[comp.competencia_id]) {
        compMap[comp.competencia_id] = { competencia: comp.competencia_nombre?.slice(0, 20) || 'Sin nombre' }
      }
      compMap[comp.competencia_id][curso.curso_nombre] = comp.promedio
    })
  })

  const chartData = Object.values(compMap).slice(0, 10)

  return (
    <div style={{ width: '100%', height: 320 }}>
      <ResponsiveContainer>
        <BarChart data={chartData} margin={{ top: 10, right: 20, left: 0, bottom: 70 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="#374151" />
          <XAxis
            dataKey="competencia"
            tick={{ fill: '#9ca3af', fontSize: 10 }}
            angle={-35}
            textAnchor="end"
            interval={0}
            height={70}
          />
          <YAxis domain={[0, 100]} tick={{ fill: '#9ca3af', fontSize: 11 }} unit="%" />
          <Tooltip content={<CustomTooltip />} />
          <Legend wrapperStyle={{ color: '#9ca3af', paddingTop: '4px', fontSize: 12 }} />
          <ReferenceLine y={65} stroke="#f59e0b" strokeDasharray="4 4" label={{ value: 'Umbral', fill: '#f59e0b', fontSize: 10, position: 'right' }} />
          {datos_cursos.map((curso, i) => (
            <Bar
              key={curso.curso_id}
              dataKey={curso.curso_nombre}
              fill={COLORES[i % COLORES.length]}
              radius={[4, 4, 0, 0]}
              maxBarSize={32}
            />
          ))}
        </BarChart>
      </ResponsiveContainer>
    </div>
  )
}
