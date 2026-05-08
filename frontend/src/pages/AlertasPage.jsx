import React, { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import {
  AlertTriangle, Download, Eye, EyeOff, Check, X,
  RefreshCw, BookOpen, User, BarChart3, ArrowRight, Bell,
} from 'lucide-react'
import axios from 'axios'
import { useAlertas } from '../hooks/useAlertas'
import NivelRiesgoIndicador from '../components/NivelRiesgoIndicador'

const BASE_URL = 'http://localhost:5000'

function getHeaders() {
  const token = localStorage.getItem('acceso_token')
  return token ? { Authorization: `Bearer ${token}` } : {}
}

const NIVEL_CONFIG = {
  critico: {
    rowClass: 'border-l-4 border-red-500 bg-red-500/5',
    badge: 'bg-red-500/20 text-red-400 border border-red-500/30',
    bar: 'bg-red-500',
    label: 'Crítico',
  },
  alto: {
    rowClass: 'border-l-4 border-orange-500 bg-orange-500/5',
    badge: 'bg-orange-500/20 text-orange-400 border border-orange-500/30',
    bar: 'bg-orange-500',
    label: 'Alto',
  },
  medio: {
    rowClass: 'border-l-4 border-yellow-500 bg-yellow-500/5',
    badge: 'bg-yellow-500/20 text-yellow-400 border border-yellow-500/30',
    bar: 'bg-yellow-500',
    label: 'Medio',
  },
}

export default function AlertasPage({ usuario }) {
  const navigate = useNavigate()
  const docenteId = usuario?.id
  const { alertas, estadisticas, loading, error, marcarLeida, descargarCSV, refrescar } = useAlertas(docenteId)

  const [tabActiva, setTabActiva] = useState(null)
  const [filtroNivel, setFiltroNivel] = useState('todos')
  const [mostrarLeidas, setMostrarLeidas] = useState(false)
  const [modalData, setModalData] = useState(null)
  const [historial, setHistorial] = useState([])
  const [cargandoModal, setCargandoModal] = useState(false)

  useEffect(() => {
    if (alertas.length > 0 && !tabActiva) {
      setTabActiva(alertas[0].competency_id)
    }
  }, [alertas])

  const handleToggleLeidas = () => {
    const nuevo = !mostrarLeidas
    setMostrarLeidas(nuevo)
    refrescar(nuevo)
  }

  const abrirModal = async (alerta, competency_name) => {
    setModalData({ ...alerta, competency_name })
    setHistorial([])
    setCargandoModal(true)
    try {
      const res = await axios.get(
        `${BASE_URL}/api/re-evaluations/historial/${alerta.student_id}`,
        { headers: getHeaders() },
      )
      const evs = res.data?.evaluations || []
      setHistorial(evs.slice(0, 5))
    } catch {
      setHistorial([])
    } finally {
      setCargandoModal(false)
    }
  }

  const tabActual = alertas.find(g => g.competency_id === tabActiva)
  const alertasFiltradas = (tabActual?.alertas || []).filter(a => {
    if (filtroNivel !== 'todos' && a.nivel_riesgo !== filtroNivel) return false
    return true
  })

  const statCards = [
    { label: 'Total Alertas', value: estadisticas.total, color: 'from-neutral-800 to-neutral-900', numColor: 'text-white' },
    { label: 'Críticos',      value: estadisticas.critico, color: 'from-red-900/60 to-red-950/60',    numColor: 'text-red-400' },
    { label: 'Altos',         value: estadisticas.alto,    color: 'from-orange-900/60 to-orange-950/60', numColor: 'text-orange-400' },
    { label: 'Medios',        value: estadisticas.medio,   color: 'from-yellow-900/60 to-yellow-950/60', numColor: 'text-yellow-400' },
  ]

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">

      {/* ── Header ── */}
      <div className="flex flex-wrap items-center justify-between gap-4 mb-8">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-gradient-to-br from-red-600 to-orange-600 rounded-xl">
            <Bell className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Alertas de Desempeño</h1>
            <p className="text-neutral-400">Estudiantes con bajo rendimiento en competencias</p>
          </div>
        </div>
        <div className="flex gap-3">
          <button
            onClick={() => refrescar(mostrarLeidas)}
            className="flex items-center gap-2 px-4 py-2 bg-neutral-800 hover:bg-neutral-700 text-neutral-300 rounded-lg transition text-sm"
          >
            <RefreshCw className="w-4 h-4" />
            Actualizar
          </button>
          <button
            onClick={() => descargarCSV(alertas)}
            className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-500 hover:to-blue-600 text-white rounded-lg transition text-sm font-semibold"
          >
            <Download className="w-4 h-4" />
            Descargar CSV
          </button>
        </div>
      </div>

      {/* ── Stat Cards ── */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
        {statCards.map(card => (
          <div
            key={card.label}
            className={`bg-gradient-to-br ${card.color} rounded-2xl p-6 border border-neutral-700/40`}
          >
            <p className="text-neutral-400 text-sm font-medium mb-2">{card.label}</p>
            <p className={`text-5xl font-black ${card.numColor}`}>{card.value}</p>
          </div>
        ))}
      </div>

      {/* ── Filters ── */}
      <div className="flex flex-wrap items-center gap-4 mb-6 p-4 bg-neutral-800/30 rounded-xl border border-neutral-700/30">
        <div className="flex items-center gap-2">
          <label className="text-neutral-400 text-sm font-medium">Nivel:</label>
          <select
            value={filtroNivel}
            onChange={e => setFiltroNivel(e.target.value)}
            className="bg-neutral-800 border border-neutral-700 text-white rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="todos">Todos</option>
            <option value="critico">Críticos</option>
            <option value="alto">Altos</option>
            <option value="medio">Medios</option>
          </select>
        </div>

        <div className="flex items-center gap-2">
          <label className="text-neutral-400 text-sm font-medium">Competencia:</label>
          <select
            value={tabActiva || ''}
            onChange={e => setTabActiva(e.target.value)}
            className="bg-neutral-800 border border-neutral-700 text-white rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            {alertas.map(g => (
              <option key={g.competency_id} value={g.competency_id}>
                {g.competency_name || 'Sin nombre'}
              </option>
            ))}
          </select>
        </div>

        <label className="flex items-center gap-3 cursor-pointer select-none">
          <button
            onClick={handleToggleLeidas}
            className={`relative w-10 h-6 rounded-full transition-colors ${mostrarLeidas ? 'bg-blue-600' : 'bg-neutral-700'}`}
          >
            <span className={`absolute top-1 left-1 w-4 h-4 rounded-full bg-white shadow transition-transform ${mostrarLeidas ? 'translate-x-4' : ''}`} />
          </button>
          <span className="flex items-center gap-1 text-neutral-400 text-sm">
            {mostrarLeidas ? <Eye className="w-4 h-4" /> : <EyeOff className="w-4 h-4" />}
            Mostrar leídas
          </span>
        </label>
      </div>

      {/* ── Error ── */}
      {error && (
        <div className="bg-red-500/10 border border-red-500/30 rounded-lg p-4 mb-6">
          <p className="text-red-400 text-sm">Error: {error}</p>
        </div>
      )}

      {/* ── States ── */}
      {loading ? (
        <div className="text-center text-neutral-400 py-20">
          <RefreshCw className="w-8 h-8 animate-spin mx-auto mb-3 text-blue-500" />
          <p>Cargando alertas...</p>
        </div>
      ) : alertas.length === 0 ? (
        <div className="bg-neutral-800/30 border border-neutral-700/30 rounded-2xl p-16 text-center">
          <div className="w-16 h-16 mx-auto mb-4 rounded-full bg-emerald-500/10 flex items-center justify-center">
            <Check className="w-8 h-8 text-emerald-400" />
          </div>
          <h3 className="text-xl font-bold text-white mb-2">Sin alertas activas</h3>
          <p className="text-neutral-400">Todos los estudiantes tienen buen desempeño (≥ 75%)</p>
        </div>
      ) : (
        <>
          {/* ── Tabs por competencia ── */}
          <div className="flex flex-wrap gap-2 mb-6 pb-4 border-b border-neutral-700/50">
            {alertas.map(grupo => (
              <button
                key={grupo.competency_id}
                onClick={() => setTabActiva(grupo.competency_id)}
                className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-semibold transition ${
                  tabActiva === grupo.competency_id
                    ? 'bg-blue-600 text-white shadow-lg shadow-blue-600/20'
                    : 'text-neutral-400 hover:text-white hover:bg-neutral-800'
                }`}
              >
                <BookOpen className="w-4 h-4" />
                <span className="max-w-[180px] truncate">{grupo.competency_name || 'Sin nombre'}</span>
                <span className={`ml-1 px-2 py-0.5 rounded-full text-xs font-bold ${
                  tabActiva === grupo.competency_id ? 'bg-white/20 text-white' : 'bg-neutral-700 text-neutral-300'
                }`}>
                  {grupo.total_alertas}
                </span>
              </button>
            ))}
          </div>

          {/* ── Tabla ── */}
          {tabActual && (
            <div className="bg-neutral-800/30 border border-neutral-700/30 rounded-2xl overflow-hidden">
              <div className="flex items-center justify-between p-5 border-b border-neutral-700/30">
                <h2 className="font-bold text-white flex items-center gap-2">
                  <BookOpen className="w-5 h-5 text-blue-400" />
                  {tabActual.competency_name}
                  <span className="text-neutral-500 text-sm font-normal">
                    — {alertasFiltradas.length} {alertasFiltradas.length === 1 ? 'alerta' : 'alertas'}
                  </span>
                </h2>
                {tabActual.competency_description && (
                  <p className="text-neutral-500 text-xs max-w-xs truncate hidden md:block">
                    {tabActual.competency_description}
                  </p>
                )}
              </div>

              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="border-b border-neutral-700/30">
                      <th className="text-left px-6 py-4 text-xs font-bold text-neutral-400 uppercase tracking-wider">Estudiante</th>
                      <th className="text-left px-6 py-4 text-xs font-bold text-neutral-400 uppercase tracking-wider">% Logro</th>
                      <th className="text-left px-6 py-4 text-xs font-bold text-neutral-400 uppercase tracking-wider">Tipo Alerta</th>
                      <th className="text-left px-6 py-4 text-xs font-bold text-neutral-400 uppercase tracking-wider">Nivel</th>
                      <th className="text-left px-6 py-4 text-xs font-bold text-neutral-400 uppercase tracking-wider">Acciones</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-neutral-800/50">
                    {alertasFiltradas.length === 0 ? (
                      <tr>
                        <td colSpan={5} className="px-6 py-12 text-center text-neutral-500">
                          No hay alertas con los filtros seleccionados
                        </td>
                      </tr>
                    ) : alertasFiltradas.map(alerta => {
                      const cfg = NIVEL_CONFIG[alerta.nivel_riesgo] || NIVEL_CONFIG.medio
                      return (
                        <tr
                          key={alerta.id}
                          className={`transition hover:bg-neutral-700/20 ${cfg.rowClass} ${alerta.leida ? 'opacity-50' : ''}`}
                        >
                          <td className="px-6 py-4">
                            <div className="flex items-center gap-3">
                              <div className="w-8 h-8 rounded-full bg-neutral-700 flex items-center justify-center flex-shrink-0">
                                <User className="w-4 h-4 text-neutral-400" />
                              </div>
                              <span className="font-medium text-white">{alerta.student_name}</span>
                            </div>
                          </td>
                          <td className="px-6 py-4 min-w-[180px]">
                            <div className="flex items-center gap-3">
                              <div className="flex-1 h-2 bg-neutral-700 rounded-full overflow-hidden">
                                <div
                                  className={`h-full rounded-full ${cfg.bar}`}
                                  style={{ width: `${Math.min(alerta.porcentaje_logro, 100)}%` }}
                                />
                              </div>
                              <span className={`text-sm font-bold w-10 text-right ${cfg.badge.split(' ')[1]}`}>
                                {alerta.porcentaje_logro}%
                              </span>
                            </div>
                          </td>
                          <td className="px-6 py-4">
                            <span className="text-neutral-300 text-sm capitalize">
                              {alerta.tipo_alerta?.replace('_', ' ')}
                            </span>
                          </td>
                          <td className="px-6 py-4">
                            <span className={`px-3 py-1 rounded-full text-xs font-bold ${cfg.badge}`}>
                              {cfg.label}
                            </span>
                          </td>
                          <td className="px-6 py-4">
                            <div className="flex gap-2">
                              <button
                                onClick={() => abrirModal(alerta, tabActual.competency_name)}
                                className="px-3 py-1.5 bg-neutral-700 hover:bg-neutral-600 text-white rounded-lg text-xs font-medium transition flex items-center gap-1"
                              >
                                <Eye className="w-3.5 h-3.5" />
                                Ver detalle
                              </button>
                              {!alerta.leida && (
                                <button
                                  onClick={() => marcarLeida(alerta.id)}
                                  className="px-3 py-1.5 bg-emerald-600/20 hover:bg-emerald-600/40 text-emerald-400 border border-emerald-600/30 rounded-lg text-xs font-medium transition flex items-center gap-1"
                                >
                                  <Check className="w-3.5 h-3.5" />
                                  Leída
                                </button>
                              )}
                            </div>
                          </td>
                        </tr>
                      )
                    })}
                  </tbody>
                </table>
              </div>
            </div>
          )}
        </>
      )}

      {/* ── Modal detalle ── */}
      {modalData && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm p-4">
          <div className="bg-neutral-900 border border-neutral-700 rounded-2xl w-full max-w-2xl max-h-[90vh] overflow-y-auto shadow-2xl">

            {/* Modal header */}
            <div className="flex items-center justify-between p-6 border-b border-neutral-700">
              <h3 className="text-xl font-bold text-white flex items-center gap-2">
                <AlertTriangle className="w-5 h-5 text-orange-400" />
                Detalle del Estudiante
              </h3>
              <button
                onClick={() => setModalData(null)}
                className="p-2 hover:bg-neutral-800 rounded-lg text-neutral-400 hover:text-white transition"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="p-6 space-y-6">
              {/* Info */}
              <div className="flex items-center gap-4 p-4 bg-neutral-800/50 rounded-xl">
                <div className="w-14 h-14 rounded-full bg-neutral-700 flex items-center justify-center flex-shrink-0">
                  <User className="w-7 h-7 text-neutral-400" />
                </div>
                <div className="flex-1 min-w-0">
                  <h4 className="text-lg font-bold text-white">{modalData.student_name}</h4>
                  <p className="text-neutral-400 text-sm truncate">{modalData.competency_name}</p>
                  <p className="text-neutral-500 text-xs mt-1">
                    {modalData.total_evaluaciones} evaluación{modalData.total_evaluaciones !== 1 ? 'es' : ''} registrada{modalData.total_evaluaciones !== 1 ? 's' : ''}
                  </p>
                </div>
                <NivelRiesgoIndicador nivel={modalData.nivel_riesgo} porcentaje={modalData.porcentaje_logro} />
              </div>

              {/* Historial */}
              <div>
                <h5 className="font-semibold text-white mb-3 flex items-center gap-2">
                  <BarChart3 className="w-4 h-4 text-blue-400" />
                  Últimas evaluaciones
                </h5>
                {cargandoModal ? (
                  <p className="text-neutral-400 text-sm py-4 text-center">
                    <RefreshCw className="w-4 h-4 animate-spin inline mr-2" />Cargando...
                  </p>
                ) : historial.length === 0 ? (
                  <p className="text-neutral-500 text-sm py-4 text-center">Sin historial disponible</p>
                ) : (
                  <div className="space-y-2">
                    {historial.map((ev, i) => {
                      const esReeval = (ev.observation || '').includes('Re-evaluación')
                      return (
                        <div key={i} className="flex items-center justify-between bg-neutral-800/50 rounded-lg px-4 py-3">
                          <div>
                            <span className="text-neutral-300 text-sm">
                              {esReeval ? '🔄 Re-evaluación' : `Evaluación ${i + 1}`}
                            </span>
                            {ev.grading_date && (
                              <p className="text-neutral-500 text-xs mt-0.5">
                                {new Date(ev.grading_date).toLocaleDateString('es-ES')}
                              </p>
                            )}
                          </div>
                          <div className="flex items-center gap-3">
                            <div className="w-24 h-1.5 bg-neutral-700 rounded-full overflow-hidden">
                              <div
                                className="h-full rounded-full bg-blue-500"
                                style={{ width: `${ev.grade ?? 0}%` }}
                              />
                            </div>
                            <span className={`font-bold text-sm w-8 text-right ${
                              ev.grade >= 75 ? 'text-emerald-400' :
                              ev.grade >= 60 ? 'text-yellow-400' : 'text-red-400'
                            }`}>
                              {ev.grade ?? '–'}
                            </span>
                          </div>
                        </div>
                      )
                    })}
                    <div className="flex justify-between pt-1 px-1">
                      <span className="text-neutral-500 text-xs">Promedio competencia</span>
                      <span className="font-bold text-white text-sm">{modalData.porcentaje_logro}%</span>
                    </div>
                  </div>
                )}
              </div>

              {/* Acciones sugeridas */}
              <div>
                <h5 className="font-semibold text-white mb-3">Acciones sugeridas</h5>
                <div className="space-y-3">
                  <button
                    onClick={() => { setModalData(null); navigate('/re-evaluations') }}
                    className="w-full flex items-center justify-between p-4 bg-blue-600/10 border border-blue-600/30 hover:bg-blue-600/20 rounded-xl text-left transition"
                  >
                    <div>
                      <p className="font-semibold text-blue-400">Crear Re-evaluación</p>
                      <p className="text-xs text-neutral-400 mt-0.5">
                        Programar una nueva oportunidad de evaluación
                      </p>
                    </div>
                    <ArrowRight className="w-5 h-5 text-blue-400 flex-shrink-0" />
                  </button>
                  <button
                    onClick={() => { setModalData(null); navigate('/improvement-plans') }}
                    className="w-full flex items-center justify-between p-4 bg-emerald-600/10 border border-emerald-600/30 hover:bg-emerald-600/20 rounded-xl text-left transition"
                  >
                    <div>
                      <p className="font-semibold text-emerald-400">Crear Plan de Mejora</p>
                      <p className="text-xs text-neutral-400 mt-0.5">
                        Establecer objetivos y estrategias de mejora
                      </p>
                    </div>
                    <ArrowRight className="w-5 h-5 text-emerald-400 flex-shrink-0" />
                  </button>
                  <button
                    onClick={() => { setModalData(null); navigate('/evidencias') }}
                    className="w-full flex items-center justify-between p-4 bg-purple-600/10 border border-purple-600/30 hover:bg-purple-600/20 rounded-xl text-left transition"
                  >
                    <div>
                      <p className="font-semibold text-purple-400">Ver Evidencias</p>
                      <p className="text-xs text-neutral-400 mt-0.5">
                        Revisar trabajos y entregables del estudiante
                      </p>
                    </div>
                    <ArrowRight className="w-5 h-5 text-purple-400 flex-shrink-0" />
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
