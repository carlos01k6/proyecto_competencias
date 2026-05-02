import React, { useEffect, useState } from 'react'
import { Award, BookOpen, CheckCircle, Clock } from 'lucide-react'

export default function ProgresoPage({ usuario }) {
  const [competencias] = useState([
    { nombre: 'Liderazgo', progreso: 85, nivel: 'Satisfactorio' },
    { nombre: 'Comunicación', progreso: 72, nivel: 'Básico' },
    { nombre: 'Pensamiento Crítico', progreso: 68, nivel: 'Básico' },
    { nombre: 'Trabajo en Equipo', progreso: 90, nivel: 'Avanzado' }
  ])

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-4">
          <div className="p-3 bg-gradient-to-br from-emerald-600 to-emerald-700 rounded-lg">
            <TrendingUp className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Mi Progreso</h1>
            <p className="text-neutral-400">Visualiza tu avance académico</p>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
        {[
          { icon: BookOpen, label: 'Competencias', valor: '4', color: 'from-blue-600 to-blue-700' },
          { icon: CheckCircle, label: 'Completadas', valor: '2', color: 'from-emerald-600 to-emerald-700' },
          { icon: Clock, label: 'En Progreso', valor: '2', color: 'from-amber-600 to-amber-700' },
          { icon: Award, label: 'Promedio', valor: '78%', color: 'from-purple-600 to-purple-700' }
        ].map((stat, idx) => {
          const Icon = stat.icon
          return (
            <div key={idx} className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
              <div className={`w-12 h-12 rounded-lg bg-gradient-to-br ${stat.color} flex items-center justify-center mb-4`}>
                <Icon className="w-6 h-6 text-white" />
              </div>
              <p className="text-neutral-400 text-sm mb-1">{stat.label}</p>
              <p className="text-3xl font-bold text-white">{stat.valor}</p>
            </div>
          )
        })}
      </div>

      <div className="space-y-6">
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8">
          <h2 className="text-2xl font-bold text-white mb-6">Competencias</h2>
          <div className="space-y-6">
            {competencias.map((comp, idx) => (
              <div key={idx}>
                <div className="flex items-center justify-between mb-3">
                  <div>
                    <p className="font-bold text-white">{comp.nombre}</p>
                    <p className="text-sm text-neutral-500">{comp.nivel}</p>
                  </div>
                  <p className="text-2xl font-bold text-primary-brand">{comp.progreso}%</p>
                </div>
                <div className="w-full h-3 bg-neutral-700 rounded-full overflow-hidden">
                  <div
                    className="h-full bg-gradient-to-r from-primary-brand to-primary-600 transition-all"
                    style={{width: `${comp.progreso}%`}}
                  ></div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}