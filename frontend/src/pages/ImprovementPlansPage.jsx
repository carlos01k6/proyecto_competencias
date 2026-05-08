import React, { useState, useEffect, useMemo } from 'react'
import { useGenerarPlanMejora, useEstudiantesEnRiesgo } from '../hooks/useImprovementPlans'
import { obtenerUsuarios } from '../services/users'

export default function ImprovementPlansPage({ usuario }) {
  const { plan, cargando: cargandoPlan, exito, generar } = useGenerarPlanMejora()
  const { estudiantes, cargando: cargandoEstudiantes, obtener } = useEstudiantesEnRiesgo()
  const [tab, setTab] = useState('en-riesgo')
  const [studentIdSeleccionado, setStudentIdSeleccionado] = useState('')
  const [todosEstudiantes, setTodosEstudiantes] = useState([])

  useEffect(() => {
    obtener()
    obtenerUsuarios().then(data => {
      const lista = Array.isArray(data) ? data : []
      setTodosEstudiantes(lista.filter(u => {
        const role = (u.role || u.rol || '').toLowerCase()
        return role === 'student' || role === 'estudiante'
      }))
    }).catch(() => {})
  }, [])

  const estudiantesMap = useMemo(() => {
    return Object.fromEntries(todosEstudiantes.map(u => [u.id, u.nombre || u.name || u.email || u.id]))
  }, [todosEstudiantes])

  const handleGenerarPlan = () => {
    if (!studentIdSeleccionado.trim()) {
      alert('Selecciona un estudiante')
      return
    }
    generar(studentIdSeleccionado)
  }

  const formatearFecha = (fecha) => {
    return new Date(fecha).toLocaleDateString('es-ES', { year: 'numeric', month: 'long', day: 'numeric' })
  }

  const getNombreEstudiante = (id) => estudiantesMap[id] || id?.substring(0, 8) + '...'

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <h1 className="text-4xl font-bold text-white mb-2">Planes de Mejora</h1>
        <p className="text-neutral-400">Generar y gestionar planes de mejora para estudiantes en riesgo</p>
      </div>

      <div className="flex gap-2 mb-6 border-b border-neutral-700">
        <button
          onClick={() => setTab('en-riesgo')}
          className={`px-6 py-3 font-semibold border-b-2 transition ${tab === 'en-riesgo' ? 'border-primary-brand text-primary-brand' : 'border-transparent text-neutral-400 hover:text-neutral-200'}`}
        >
          Estudiantes en Riesgo
        </button>
        <button
          onClick={() => setTab('generar')}
          className={`px-6 py-3 font-semibold border-b-2 transition ${tab === 'generar' ? 'border-primary-brand text-primary-brand' : 'border-transparent text-neutral-400 hover:text-neutral-200'}`}
        >
          Generar Plan
        </button>
      </div>

      {/* TAB: ESTUDIANTES EN RIESGO */}
      {tab === 'en-riesgo' && (
        <div className="space-y-6">
          {cargandoEstudiantes ? (
            <div className="text-center text-neutral-400 py-12">Cargando estudiantes en riesgo...</div>
          ) : estudiantes.length === 0 ? (
            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 text-center">
              <p className="text-neutral-400 text-lg">✓ No hay estudiantes en riesgo</p>
              <p className="text-sm text-neutral-500 mt-2">Todos los estudiantes tienen promedio ≥ 40</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {estudiantes.map((est) => (
                <div key={est.student_id} className="bg-red-500/10 border border-red-500/30 rounded-2xl p-6 hover:shadow-lg transition">
                  <div className="flex items-start justify-between mb-4">
                    <div>
                      <h3 className="font-bold text-white">{getNombreEstudiante(est.student_id)}</h3>
                      <p className="text-xs text-neutral-500 mt-1">{est.student_id?.substring(0, 16)}...</p>
                    </div>
                    <span className="bg-red-500 text-white px-2 py-1 rounded-full text-xs font-semibold">EN RIESGO</span>
                  </div>
                  <div className="space-y-1 mb-4">
                    <p className="text-sm text-neutral-300">Promedio: <span className="text-red-400 font-bold">{est.average_grade}/100</span></p>
                    <p className="text-sm text-neutral-300">Evaluaciones: <span className="text-neutral-200">{est.evaluation_count}</span></p>
                  </div>
                  <button
                    onClick={() => { setStudentIdSeleccionado(est.student_id); setTab('generar') }}
                    className="w-full bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg text-sm font-semibold transition"
                  >
                    Generar Plan
                  </button>
                </div>
              ))}
            </div>
          )}
          <div className="bg-yellow-500/10 border border-yellow-500/30 rounded-lg p-4">
            <p className="text-sm text-yellow-400 font-semibold">⚠️ Estudiantes en riesgo: {estudiantes.length}</p>
            <p className="text-xs text-neutral-500 mt-1">Se considera en riesgo a estudiantes con promedio menor a 40 puntos</p>
          </div>
        </div>
      )}

      {/* TAB: GENERAR PLAN */}
      {tab === 'generar' && (
        <div className="space-y-6">
          <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
            <h2 className="text-xl font-bold text-white mb-4">Generar Plan de Mejora</h2>
            <div className="mb-6">
              <label className="block text-sm font-semibold text-neutral-300 mb-2">Estudiante</label>
              <div className="flex gap-3">
                <select
                  value={studentIdSeleccionado}
                  onChange={(e) => setStudentIdSeleccionado(e.target.value)}
                  className="flex-1 bg-neutral-800 border border-neutral-600 rounded-lg px-4 py-3 text-white focus:outline-none focus:border-primary-brand transition"
                >
                  <option value="">Selecciona un estudiante</option>
                  {todosEstudiantes.map((est) => (
                    <option key={est.id} value={est.id}>
                      {est.nombre || est.name || est.email}
                    </option>
                  ))}
                </select>
                <button
                  onClick={handleGenerarPlan}
                  disabled={cargandoPlan || !studentIdSeleccionado}
                  className="bg-primary-brand hover:bg-primary-600 text-white px-6 py-3 rounded-lg font-semibold transition disabled:opacity-50"
                >
                  {cargandoPlan ? 'Generando...' : 'Generar'}
                </button>
              </div>
            </div>

            {exito && (
              <div className="bg-emerald-500/10 border border-emerald-500/30 rounded-lg p-4 mb-6">
                <p className="text-emerald-400 font-semibold">✓ Plan generado exitosamente</p>
              </div>
            )}

            {plan && (
              <div className="space-y-6">
                <div>
                  <h3 className="text-lg font-bold text-white mb-4">Competencias Débiles</h3>
                  {plan.weak_competencies?.length > 0 ? (
                    <div className="space-y-3">
                      {plan.weak_competencies.map((comp, idx) => (
                        <div key={idx} className="bg-red-500/10 border border-red-500/30 rounded-lg p-4">
                          <h4 className="font-semibold text-white">{comp.competency_name}</h4>
                          <div className="mt-2 space-y-1 text-sm text-neutral-400">
                            <p>Promedio: <span className="font-bold text-red-400">{comp.average_grade}/100</span></p>
                            <p>Evaluaciones: {comp.evaluation_count}</p>
                          </div>
                        </div>
                      ))}
                    </div>
                  ) : (
                    <p className="text-neutral-500">No hay competencias débiles identificadas</p>
                  )}
                </div>

                <div>
                  <h3 className="text-lg font-bold text-white mb-4">Actividades Recomendadas</h3>
                  <div className="space-y-3">
                    {plan.improvement_activities?.map((activity, idx) => (
                      <div key={idx} className="bg-blue-500/10 border border-blue-500/30 rounded-lg p-4 flex gap-3">
                        <span className="text-blue-400 font-bold flex-shrink-0">{idx + 1}.</span>
                        <p className="text-neutral-200">{activity}</p>
                      </div>
                    ))}
                  </div>
                </div>

                <div className="bg-neutral-800/50 border border-neutral-700/50 rounded-2xl p-6">
                  <h3 className="font-bold text-white mb-4">Cronograma del Plan</h3>
                  <div className="space-y-2 text-sm text-neutral-300">
                    <p>Inicio: <span className="text-white">{formatearFecha(plan.start_date)}</span></p>
                    <p>Fin: <span className="text-white">{formatearFecha(plan.end_date)}</span></p>
                    <p>Duración: <span className="text-white">4 semanas</span></p>
                  </div>
                </div>

                <div className="flex gap-3">
                  <button
                    onClick={() => { navigator.clipboard.writeText(JSON.stringify(plan, null, 2)); alert('Plan copiado') }}
                    className="flex-1 border border-neutral-600 text-neutral-300 hover:bg-neutral-800 px-4 py-3 rounded-lg font-semibold transition"
                  >
                    Copiar
                  </button>
                  <button
                    onClick={() => window.print()}
                    className="flex-1 bg-primary-brand hover:bg-primary-600 text-white px-4 py-3 rounded-lg font-semibold transition"
                  >
                    Imprimir
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
