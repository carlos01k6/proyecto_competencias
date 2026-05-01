import React, { useState, useEffect } from 'react'
import { useGenerarPlanMejora, useEstudiantesEnRiesgo } from '../hooks/useImprovementPlans'

export default function ImprovementPlansPage({ usuario }) {
  const { plan, cargando: cargandoPlan, exito, generar } = useGenerarPlanMejora()
  const { estudiantes, cargando: cargandoEstudiantes, obtener } = useEstudiantesEnRiesgo()
  const [tab, setTab] = useState('en-riesgo')
  const [student_id_input, setStudent_id_input] = useState('')

  useEffect(() => {
    obtener()
  }, [])

  const handleGenerarPlan = () => {
    if (!student_id_input.trim()) {
      alert('Ingresa un ID de estudiante')
      return
    }
    generar(student_id_input)
  }

  const formatearFecha = (fecha) => {
    return new Date(fecha).toLocaleDateString('es-ES', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    })
  }

  return (
    <div className="p-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-neutral-900 mb-2">Planes de Mejora</h1>
        <p className="text-neutral-600">Generar y gestionar planes de mejora para estudiantes en riesgo</p>
      </div>

      {/* Tabs */}
      <div className="flex gap-2 mb-6 border-b border-neutral-200">
        <button
          onClick={() => setTab('en-riesgo')}
          className={`px-6 py-3 font-semibold border-b-2 transition ${
            tab === 'en-riesgo'
              ? 'border-primary-brand text-primary-brand'
              : 'border-transparent text-neutral-600 hover:text-neutral-900'
          }`}
        >
          Estudiantes en Riesgo
        </button>
        <button
          onClick={() => setTab('generar')}
          className={`px-6 py-3 font-semibold border-b-2 transition ${
            tab === 'generar'
              ? 'border-primary-brand text-primary-brand'
              : 'border-transparent text-neutral-600 hover:text-neutral-900'
          }`}
        >
          Generar Plan
        </button>
      </div>

      {/* TAB: ESTUDIANTES EN RIESGO */}
      {tab === 'en-riesgo' && (
        <div className="space-y-6">
          {cargandoEstudiantes ? (
            <div className="text-center text-neutral-600 py-12">
              <p>Cargando estudiantes en riesgo...</p>
            </div>
          ) : estudiantes.length === 0 ? (
            <div className="bg-white rounded-lg shadow p-8 text-center">
              <p className="text-neutral-500 text-lg">✓ No hay estudiantes en riesgo</p>
              <p className="text-sm text-neutral-600 mt-2">Todos los estudiantes tienen promedio ≥ 40</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {estudiantes.map((est) => (
                <div
                  key={est.student_id}
                  className="bg-danger bg-opacity-10 border border-danger rounded-lg shadow p-6 hover:shadow-lg transition"
                >
                  <div className="flex items-start justify-between mb-4">
                    <h3 className="font-bold text-neutral-900">ID: {est.student_id.substring(0, 8)}...</h3>
                    <span className="bg-danger text-white px-3 py-1 rounded-full text-xs font-semibold">
                      EN RIESGO
                    </span>
                  </div>

                  <div className="space-y-2 mb-4">
                    <p className="text-sm">
                      <span className="font-semibold text-neutral-900">Promedio:</span>
                      <span className="text-danger font-bold ml-2">{est.average_grade}/100</span>
                    </p>
                    <p className="text-sm">
                      <span className="font-semibold text-neutral-900">Evaluaciones:</span>
                      <span className="text-neutral-600 ml-2">{est.evaluation_count}</span>
                    </p>
                  </div>

                  <button
                    onClick={() => {
                      setStudent_id_input(est.student_id)
                      setTab('generar')
                    }}
                    className="w-full bg-danger hover:bg-red-700 text-white px-4 py-2 rounded-lg text-sm font-semibold transition"
                  >
                    Generar Plan
                  </button>
                </div>
              ))}
            </div>
          )}

          <div className="bg-warning bg-opacity-10 border border-warning rounded-lg p-4 mt-6">
            <p className="text-sm text-warning font-semibold">
              ⚠️ Estudiantes en riesgo: {estudiantes.length}
            </p>
            <p className="text-xs text-neutral-600 mt-1">
              Se considera en riesgo a estudiantes con promedio menor a 40 puntos
            </p>
          </div>
        </div>
      )}

      {/* TAB: GENERAR PLAN */}
      {tab === 'generar' && (
        <div className="space-y-6">
          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-xl font-bold text-neutral-900 mb-4">Generar Plan de Mejora</h2>

            <div className="mb-6">
              <label className="block text-sm font-semibold text-neutral-900 mb-3">
                ID del Estudiante
              </label>
              <div className="flex gap-3">
                <input
                  type="text"
                  value={student_id_input}
                  onChange={(e) => setStudent_id_input(e.target.value)}
                  placeholder="Ej: 36d1aded-a770-461c-a47c-81d847a19dae"
                  className="flex-1 border border-neutral-300 rounded-lg px-4 py-3 focus:ring-2 focus:ring-primary-brand outline-none"
                />
                <button
                  onClick={handleGenerarPlan}
                  disabled={cargandoPlan}
                  className="bg-primary-brand hover:bg-primary-600 text-white px-6 py-3 rounded-lg font-semibold transition disabled:opacity-50"
                >
                  {cargandoPlan ? 'Generando...' : 'Generar'}
                </button>
              </div>
            </div>

            {exito && (
              <div className="bg-success bg-opacity-10 border border-success rounded-lg p-4 mb-6">
                <p className="text-success font-semibold">✓ Plan generado exitosamente</p>
              </div>
            )}

            {plan && (
              <div className="space-y-6">
                {/* Competencias Débiles */}
                <div>
                  <h3 className="text-lg font-bold text-neutral-900 mb-4">Competencias Débiles</h3>
                  {plan.weak_competencies && plan.weak_competencies.length > 0 ? (
                    <div className="space-y-3">
                      {plan.weak_competencies.map((comp, idx) => (
                        <div key={idx} className="bg-danger bg-opacity-10 border border-danger rounded-lg p-4">
                          <h4 className="font-semibold text-neutral-900">{comp.competency_name}</h4>
                          <div className="mt-2 space-y-1 text-sm text-neutral-600">
                            <p>📊 Promedio: <span className="font-bold text-danger">{comp.average_grade}/100</span></p>
                            <p>📝 Evaluaciones: {comp.evaluation_count}</p>
                          </div>
                        </div>
                      ))}
                    </div>
                  ) : (
                    <p className="text-neutral-600">No hay competencias débiles identificadas</p>
                  )}
                </div>

                {/* Actividades de Mejora */}
                <div>
                  <h3 className="text-lg font-bold text-neutral-900 mb-4">Actividades Recomendadas</h3>
                  <div className="space-y-3">
                    {plan.improvement_activities && plan.improvement_activities.map((activity, idx) => (
                      <div key={idx} className="bg-blue-50 border border-blue-200 rounded-lg p-4 flex gap-3">
                        <span className="text-blue-600 font-bold flex-shrink-0">{idx + 1}.</span>
                        <p className="text-neutral-900">{activity}</p>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Cronograma */}
                <div className="bg-neutral-50 border border-neutral-200 rounded-lg p-6">
                  <h3 className="font-bold text-neutral-900 mb-4">Cronograma del Plan</h3>
                  <div className="space-y-2 text-sm">
                    <p>
                      <span className="font-semibold text-neutral-900">Inicio:</span>
                      <span className="text-neutral-600 ml-2">{formatearFecha(plan.start_date)}</span>
                    </p>
                    <p>
                      <span className="font-semibold text-neutral-900">Fin:</span>
                      <span className="text-neutral-600 ml-2">{formatearFecha(plan.end_date)}</span>
                    </p>
                    <p>
                      <span className="font-semibold text-neutral-900">Duración:</span>
                      <span className="text-neutral-600 ml-2">4 semanas</span>
                    </p>
                  </div>
                </div>

                {/* Acciones */}
                <div className="flex gap-3">
                  <button
                    onClick={() => {
                      navigator.clipboard.writeText(JSON.stringify(plan, null, 2))
                      alert('Plan copiado al portapapeles')
                    }}
                    className="flex-1 bg-neutral-300 hover:bg-neutral-400 text-neutral-900 px-4 py-3 rounded-lg font-semibold transition"
                  >
                    📋 Copiar
                  </button>
                  <button
                    onClick={() => window.print()}
                    className="flex-1 bg-primary-brand hover:bg-primary-600 text-white px-4 py-3 rounded-lg font-semibold transition"
                  >
                    🖨️ Imprimir
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
