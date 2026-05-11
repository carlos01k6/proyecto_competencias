import React, { useState, useEffect, useMemo } from 'react'
import { useGenerarPlanMejora, useEstudiantesEnRiesgo } from '../hooks/useImprovementPlans'
import { obtenerUsuarios } from '../services/users'
import { TrendingUp, AlertTriangle, User, CheckCircle, Calendar, ChevronRight, BookOpen, Target, Clock } from 'lucide-react'

function Initials({ nombre }) {
  const parts = (nombre || '?').split(' ')
  const letters = parts.length >= 2 ? parts[0][0] + parts[1][0] : parts[0].slice(0, 2)
  return (
    <div className="w-10 h-10 rounded-full bg-gradient-to-br from-primary-brand to-blue-700 flex items-center justify-center text-white font-bold text-sm flex-shrink-0">
      {letters.toUpperCase()}
    </div>
  )
}

function NivelBadge({ nivel }) {
  const map = {
    'Incipiente':    'bg-red-500/20 text-red-400 border border-red-500/30',
    'Básico':        'bg-amber-500/20 text-amber-400 border border-amber-500/30',
    'En Desarrollo': 'bg-yellow-500/20 text-yellow-400 border border-yellow-500/30',
  }
  return (
    <span className={`px-2.5 py-0.5 rounded-full text-xs font-semibold ${map[nivel] || 'bg-neutral-700 text-neutral-300'}`}>
      {nivel}
    </span>
  )
}

function GradeBar({ value, max = 100 }) {
  const pct = Math.min(100, Math.max(0, (value / max) * 100))
  const color = pct < 40 ? 'from-red-600 to-red-500'
    : pct < 55 ? 'from-amber-600 to-amber-400'
    : 'from-yellow-500 to-yellow-400'
  return (
    <div className="w-full bg-neutral-700/50 rounded-full h-2 mt-1">
      <div
        className={`h-2 rounded-full bg-gradient-to-r ${color} transition-all duration-500`}
        style={{ width: `${pct}%` }}
      />
    </div>
  )
}

export default function ImprovementPlansPage({ usuario }) {
  const { plan, cargando: cargandoPlan, exito, error: errorPlan, generar } = useGenerarPlanMejora()
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

  const estudiantesMap = useMemo(() =>
    Object.fromEntries(todosEstudiantes.map(u => [u.id, u.nombre || u.name || u.email || u.id]))
  , [todosEstudiantes])

  const getNombre = (id) => estudiantesMap[id] || id?.substring(0, 8) + '...'

  const handleGenerarPlan = () => {
    if (!studentIdSeleccionado) return
    generar(studentIdSeleccionado)
  }

  const formatFecha = (f) => f
    ? new Date(f).toLocaleDateString('es-ES', { day: 'numeric', month: 'long', year: 'numeric' })
    : '—'

  const estudianteSeleccionadoNombre = getNombre(studentIdSeleccionado)

  /* ── separa actividades personalizadas de las generales ── */
  const actividadesPersonalizadas = plan?.improvement_activities?.filter(a =>
    plan.weak_competencies?.some(wc => a.includes(`«${wc.competency_name}»`))
  ) || []
  const actividadesGenerales = plan?.improvement_activities?.filter(a =>
    !plan.weak_competencies?.some(wc => a.includes(`«${wc.competency_name}»`))
  ) || []

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">

      {/* ── Header ── */}
      <div className="flex flex-col sm:flex-row sm:items-center gap-4 mb-8">
        <div className="p-3 bg-gradient-to-br from-amber-600 to-orange-700 rounded-xl w-fit">
          <TrendingUp className="w-6 h-6 text-white" />
        </div>
        <div>
          <h1 className="text-3xl font-bold text-white">Planes de Mejora</h1>
          <p className="text-neutral-400 text-sm mt-0.5">Detecta estudiantes en riesgo y genera planes de acción personalizados</p>
        </div>
        <div className="sm:ml-auto flex gap-3">
          <div className="bg-red-500/10 border border-red-500/20 rounded-xl px-4 py-2 text-center">
            <p className="text-2xl font-bold text-red-400">{estudiantes.length}</p>
            <p className="text-xs text-neutral-400">En riesgo</p>
          </div>
          <div className="bg-emerald-500/10 border border-emerald-500/20 rounded-xl px-4 py-2 text-center">
            <p className="text-2xl font-bold text-emerald-400">{todosEstudiantes.length - estudiantes.length}</p>
            <p className="text-xs text-neutral-400">Al día</p>
          </div>
        </div>
      </div>

      {/* ── Tabs ── */}
      <div className="flex gap-1 mb-6 p-1 bg-neutral-800/40 rounded-xl border border-neutral-700/30 w-fit">
        {[
          { id: 'en-riesgo', label: 'Estudiantes en Riesgo', icon: AlertTriangle },
          { id: 'generar',   label: 'Generar Plan',          icon: Target },
        ].map(({ id, label, icon: Icon }) => (
          <button
            key={id}
            onClick={() => setTab(id)}
            className={`flex items-center gap-2 px-5 py-2.5 rounded-lg text-sm font-semibold transition ${
              tab === id
                ? 'bg-primary-brand text-white shadow-lg shadow-primary-brand/20'
                : 'text-neutral-400 hover:text-white'
            }`}
          >
            <Icon className="w-4 h-4" />
            {label}
          </button>
        ))}
      </div>

      {/* ══════════════════════════════════
          TAB — ESTUDIANTES EN RIESGO
      ══════════════════════════════════ */}
      {tab === 'en-riesgo' && (
        <div className="space-y-5">
          {cargandoEstudiantes ? (
            <div className="flex items-center justify-center py-20">
              <div className="w-8 h-8 border-4 border-neutral-700 border-t-primary-brand rounded-full animate-spin" />
            </div>
          ) : estudiantes.length === 0 ? (
            <div className="bg-gradient-to-br from-emerald-900/20 to-neutral-900/40 border border-emerald-700/30 rounded-2xl p-12 text-center">
              <CheckCircle className="w-12 h-12 text-emerald-500 mx-auto mb-4" />
              <p className="text-white font-bold text-lg">Sin estudiantes en riesgo</p>
              <p className="text-neutral-400 text-sm mt-1">Todos los estudiantes tienen un desempeño adecuado</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
              {estudiantes.map((est) => {
                const nombre = getNombre(est.student_id)
                const nivel = est.average_grade < 40 ? 'Incipiente' : est.average_grade < 55 ? 'Básico' : 'En Desarrollo'
                return (
                  <div
                    key={est.student_id}
                    className="bg-gradient-to-br from-neutral-800/60 to-neutral-900/60 border border-neutral-700/50 hover:border-red-500/40 rounded-2xl p-5 transition group"
                  >
                    <div className="flex items-start gap-3 mb-4">
                      <Initials nombre={nombre} />
                      <div className="flex-1 min-w-0">
                        <p className="font-semibold text-white truncate">{nombre}</p>
                        <p className="text-xs text-neutral-500">{est.student_id?.substring(0, 12)}…</p>
                      </div>
                      <NivelBadge nivel={nivel} />
                    </div>

                    <div className="mb-4">
                      <div className="flex justify-between text-xs text-neutral-400 mb-1">
                        <span>Promedio general</span>
                        <span className="text-red-400 font-bold">{est.average_grade} / 100</span>
                      </div>
                      <GradeBar value={est.average_grade} />
                    </div>

                    <div className="flex items-center justify-between text-xs text-neutral-500 mb-4">
                      <span>{est.evaluation_count} evaluación{est.evaluation_count !== 1 ? 'es' : ''}</span>
                      <span>Umbral mínimo: 70</span>
                    </div>

                    <button
                      onClick={() => { setStudentIdSeleccionado(est.student_id); setTab('generar') }}
                      className="w-full flex items-center justify-center gap-2 bg-gradient-to-r from-primary-brand to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white px-4 py-2.5 rounded-lg text-sm font-semibold transition shadow-lg shadow-primary-brand/10"
                    >
                      Generar Plan de Mejora
                      <ChevronRight className="w-4 h-4" />
                    </button>
                  </div>
                )
              })}
            </div>
          )}

          <div className="flex items-start gap-3 bg-amber-500/10 border border-amber-500/20 rounded-xl p-4">
            <AlertTriangle className="w-5 h-5 text-amber-400 flex-shrink-0 mt-0.5" />
            <div>
              <p className="text-amber-400 text-sm font-semibold">Criterio de riesgo</p>
              <p className="text-neutral-400 text-xs mt-0.5">
                Se considera en riesgo todo estudiante con promedio inferior a 70 puntos en cualquier competencia evaluada.
              </p>
            </div>
          </div>
        </div>
      )}

      {/* ══════════════════════════════════
          TAB — GENERAR PLAN
      ══════════════════════════════════ */}
      {tab === 'generar' && (
        <div className="space-y-6">

          {/* Selector de estudiante */}
          <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
            <h2 className="text-lg font-bold text-white mb-4 flex items-center gap-2">
              <User className="w-5 h-5 text-primary-brand" />
              Seleccionar Estudiante
            </h2>
            <div className="flex flex-col sm:flex-row gap-3">
              <select
                value={studentIdSeleccionado}
                onChange={(e) => setStudentIdSeleccionado(e.target.value)}
                className="flex-1 bg-neutral-800 border border-neutral-600 rounded-lg px-4 py-3 text-white focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
              >
                <option value="">— Selecciona un estudiante —</option>
                {todosEstudiantes.map((est) => (
                  <option key={est.id} value={est.id}>
                    {est.nombre || est.name || est.email}
                  </option>
                ))}
              </select>
              <button
                onClick={handleGenerarPlan}
                disabled={cargandoPlan || !studentIdSeleccionado}
                className="flex items-center gap-2 bg-gradient-to-r from-primary-brand to-blue-600 hover:from-blue-600 hover:to-blue-700 disabled:opacity-50 text-white px-6 py-3 rounded-lg font-semibold transition shadow-lg shadow-primary-brand/20 whitespace-nowrap"
              >
                {cargandoPlan ? (
                  <>
                    <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                    Generando…
                  </>
                ) : (
                  <>
                    <Target className="w-4 h-4" />
                    Generar Plan
                  </>
                )}
              </button>
            </div>
            {errorPlan && (
              <p className="text-red-400 text-sm mt-3">{errorPlan}</p>
            )}
          </div>

          {/* Resultado del plan */}
          {exito && plan && (
            <div id="improvement-plan-printable">
              {/* Banner de éxito + info del estudiante */}
              <div className="print-hide-banner bg-gradient-to-r from-emerald-900/30 to-teal-900/20 border border-emerald-600/30 rounded-2xl p-5 flex flex-col sm:flex-row sm:items-center gap-4">
                <CheckCircle className="w-8 h-8 text-emerald-400 flex-shrink-0" />
                <div className="flex-1">
                  <p className="text-emerald-400 font-bold text-lg">Plan generado exitosamente</p>
                  <p className="text-neutral-300 text-sm mt-0.5">
                    Estudiante: <span className="font-semibold text-white">{estudianteSeleccionadoNombre}</span>
                    {' · '}
                    {plan.weak_competencies?.length || 0} competencia{plan.weak_competencies?.length !== 1 ? 's' : ''} débil{plan.weak_competencies?.length !== 1 ? 'es' : ''} identificada{plan.weak_competencies?.length !== 1 ? 's' : ''}
                  </p>
                </div>
                <button
                  onClick={() => window.print()}
                  className="flex items-center gap-2 border border-neutral-600 hover:border-neutral-400 text-neutral-300 hover:text-white px-4 py-2 rounded-lg text-sm font-semibold transition"
                >
                  Imprimir
                </button>
              </div>

              {/* Competencias débiles */}
              <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
                <h3 className="text-base font-bold text-white mb-4 flex items-center gap-2">
                  <BookOpen className="w-5 h-5 text-red-400" />
                  Competencias que necesitan refuerzo
                </h3>
                {plan.weak_competencies?.length > 0 ? (
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {plan.weak_competencies.map((comp, idx) => (
                      <div key={idx} className="bg-neutral-900/60 border border-neutral-700/50 rounded-xl p-4">
                        <div className="flex items-start justify-between gap-2 mb-3">
                          <p className="font-semibold text-white text-sm leading-snug">{comp.competency_name}</p>
                          <NivelBadge nivel={comp.nivel || 'Básico'} />
                        </div>
                        {comp.competency_description && (
                          <p className="text-xs text-neutral-500 mb-3 leading-relaxed">{comp.competency_description}</p>
                        )}
                        <div className="flex justify-between text-xs text-neutral-400 mb-1">
                          <span>Promedio obtenido</span>
                          <span className="font-bold text-red-400">{comp.average_grade} / 100</span>
                        </div>
                        <GradeBar value={comp.average_grade} />
                        <p className="text-xs text-neutral-500 mt-2">{comp.evaluation_count} evaluación{comp.evaluation_count !== 1 ? 'es' : ''} registrada{comp.evaluation_count !== 1 ? 's' : ''}</p>
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="flex items-center gap-3 text-emerald-400 bg-emerald-500/10 border border-emerald-500/20 rounded-xl p-4">
                    <CheckCircle className="w-5 h-5 flex-shrink-0" />
                    <p className="text-sm font-medium">No se identificaron competencias débiles para este estudiante.</p>
                  </div>
                )}
              </div>

              {/* Actividades */}
              <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
                <h3 className="text-base font-bold text-white mb-4 flex items-center gap-2">
                  <Target className="w-5 h-5 text-primary-brand" />
                  Plan de Actividades
                </h3>

                {actividadesPersonalizadas.length > 0 && (
                  <div className="mb-5">
                    <p className="text-xs font-semibold text-primary-brand uppercase tracking-wider mb-3">Actividades por competencia</p>
                    <div className="space-y-2">
                      {actividadesPersonalizadas.map((act, idx) => (
                        <div key={idx} className="flex gap-3 bg-primary-brand/10 border border-primary-brand/20 rounded-xl p-3.5">
                          <span className="w-6 h-6 rounded-full bg-primary-brand/20 text-primary-brand text-xs font-bold flex items-center justify-center flex-shrink-0 mt-0.5">
                            {idx + 1}
                          </span>
                          <p className="text-neutral-200 text-sm leading-relaxed">{act}</p>
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                <div>
                  <p className="text-xs font-semibold text-neutral-500 uppercase tracking-wider mb-3">Actividades generales de refuerzo</p>
                  <div className="space-y-2">
                    {actividadesGenerales.map((act, idx) => (
                      <div key={idx} className="flex gap-3 bg-neutral-800/40 border border-neutral-700/40 rounded-xl p-3.5">
                        <span className="w-6 h-6 rounded-full bg-neutral-700 text-neutral-300 text-xs font-bold flex items-center justify-center flex-shrink-0 mt-0.5">
                          {actividadesPersonalizadas.length + idx + 1}
                        </span>
                        <p className="text-neutral-300 text-sm leading-relaxed">{act}</p>
                      </div>
                    ))}
                  </div>
                </div>
              </div>

              {/* Cronograma */}
              <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
                <h3 className="text-base font-bold text-white mb-4 flex items-center gap-2">
                  <Calendar className="w-5 h-5 text-amber-400" />
                  Cronograma del Plan
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                  <div className="bg-neutral-900/50 rounded-xl p-4 text-center">
                    <Clock className="w-5 h-5 text-neutral-400 mx-auto mb-2" />
                    <p className="text-xs text-neutral-500 mb-1">Inicio</p>
                    <p className="text-white font-semibold text-sm">{formatFecha(plan.start_date)}</p>
                  </div>
                  <div className="bg-neutral-900/50 rounded-xl p-4 text-center">
                    <Clock className="w-5 h-5 text-neutral-400 mx-auto mb-2" />
                    <p className="text-xs text-neutral-500 mb-1">Finalización</p>
                    <p className="text-white font-semibold text-sm">{formatFecha(plan.end_date)}</p>
                  </div>
                  <div className="bg-primary-brand/10 border border-primary-brand/20 rounded-xl p-4 text-center">
                    <Target className="w-5 h-5 text-primary-brand mx-auto mb-2" />
                    <p className="text-xs text-neutral-500 mb-1">Duración</p>
                    <p className="text-primary-brand font-bold text-sm">4 semanas</p>
                  </div>
                </div>
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  )
}
