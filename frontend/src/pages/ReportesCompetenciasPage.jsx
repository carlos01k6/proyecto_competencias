import React, { useState, useEffect } from 'react'
import { BarChart3, AlertTriangle, Download, RefreshCw, ChevronDown, BookOpen, Users } from 'lucide-react'
import axios from 'axios'
import { useReportesCompetencias } from '../hooks/useReportesCompetencias'
import GraficoComparativaGrados from '../components/GraficoComparativaGrados'

const BASE_URL = 'http://localhost:5000'
const headers = () => {
  const t = localStorage.getItem('acceso_token')
  return t ? { Authorization: `Bearer ${t}` } : {}
}

function BarraLogro({ pct, color }) {
  return (
    <div className="flex items-center gap-2 min-w-[120px]">
      <div className="flex-1 h-1.5 bg-neutral-700 rounded-full overflow-hidden">
        <div className="h-full rounded-full" style={{ width: `${Math.min(pct, 100)}%`, backgroundColor: color }} />
      </div>
      <span className="text-xs font-bold w-9 text-right" style={{ color }}>{pct}%</span>
    </div>
  )
}

function colorProm(p) {
  if (p < 40) return '#ef4444'
  if (p < 60) return '#f97316'
  if (p < 75) return '#eab308'
  return '#22c55e'
}

function badgeProm(p) {
  if (p < 40) return 'bg-red-500/20 text-red-400 border-red-500/30'
  if (p < 60) return 'bg-orange-500/20 text-orange-400 border-orange-500/30'
  if (p < 75) return 'bg-yellow-500/20 text-yellow-400 border-yellow-500/30'
  return 'bg-emerald-500/20 text-emerald-400 border-emerald-500/30'
}

function exportCSVCurso(reporte) {
  if (!reporte) return
  const rows = [['Competencia', 'Promedio', 'Estudiantes', 'Aprobados', '% Aprobados', 'En riesgo', '% Riesgo']]
  ;(reporte.competencias || []).forEach(c => {
    rows.push([c.competencia_nombre, c.promedio, c.estudiantes_total, c.aprobados, c.aprobados_pct, c.en_riesgo, c.riesgo_pct])
  })
  const csv = rows.map(r => r.map(v => `"${v}"`).join(',')).join('\n')
  const blob = new Blob(['﻿' + csv], { type: 'text/csv;charset=utf-8;' })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = `reporte_${reporte.curso_nombre?.replace(/\s/g, '_')}_${new Date().toISOString().slice(0, 10)}.csv`
  document.body.appendChild(a); a.click(); document.body.removeChild(a)
  URL.revokeObjectURL(url)
}

export default function ReportesCompetenciasPage({ usuario }) {
  const { comparativa, criticas, reporteCurso, loading, error, cargarPorGrado, refrescar } = useReportesCompetencias()
  const [grados, setGrados] = useState([])
  const [gradoSel, setGradoSel] = useState('')
  const [tab, setTab] = useState('criticas')

  useEffect(() => {
    axios.get(`${BASE_URL}/api/cursos`, { headers: headers() })
      .then(r => {
        const lista = Array.isArray(r.data) ? r.data : []
        setGrados(lista)
        if (lista.length) setGradoSel(lista[0].id)
      }).catch(() => {})
  }, [])

  useEffect(() => {
    if (gradoSel) cargarPorGrado(gradoSel)
  }, [gradoSel, cargarPorGrado])

  const tabs = [
    { id: 'criticas', label: 'Competencias Críticas', icon: AlertTriangle },
    { id: 'por-curso', label: 'Por Grado', icon: BookOpen },
    { id: 'comparativa', label: 'Comparativa', icon: BarChart3 },
  ]

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">

      {/* Header */}
      <div className="flex flex-wrap items-center justify-between gap-4 mb-8">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-gradient-to-br from-amber-600 to-orange-700 rounded-xl">
            <BarChart3 className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-3xl font-bold text-white">Análisis de Competencias</h1>
            <p className="text-neutral-400">Reportes por curso y comparativas</p>
          </div>
        </div>
        <button onClick={refrescar} className="flex items-center gap-2 px-3 py-2 bg-neutral-800 hover:bg-neutral-700 text-neutral-300 rounded-lg text-sm transition">
          <RefreshCw className="w-4 h-4" /> Actualizar
        </button>
      </div>

      {error && <div className="bg-red-500/10 border border-red-500/30 rounded-lg p-4 mb-6 text-red-400">Error: {error}</div>}

      {/* Tabs */}
      <div className="flex gap-2 mb-6 border-b border-neutral-700/50 pb-4">
        {tabs.map(t => {
          const Icon = t.icon
          return (
            <button
              key={t.id}
              onClick={() => setTab(t.id)}
              className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-semibold transition ${
                tab === t.id ? 'bg-amber-600 text-white' : 'text-neutral-400 hover:text-white hover:bg-neutral-800'
              }`}
            >
              <Icon className="w-4 h-4" />
              {t.label}
            </button>
          )
        })}
      </div>

      {/* ── Tab: Críticas ── */}
      {tab === 'criticas' && (
        <div>
          <div className="flex items-center gap-2 mb-4">
            <AlertTriangle className="w-5 h-5 text-red-400" />
            <h2 className="text-lg font-bold text-white">Competencias Críticas <span className="text-neutral-500 font-normal text-sm">(promedio &lt; 60%)</span></h2>
            {criticas.length > 0 && (
              <span className="px-2 py-0.5 bg-red-500/20 text-red-400 border border-red-500/30 rounded-full text-xs font-bold">
                {criticas.length}
              </span>
            )}
          </div>

          {loading ? (
            <div className="text-center py-12 text-neutral-400"><RefreshCw className="w-6 h-6 animate-spin mx-auto mb-2" />Cargando...</div>
          ) : criticas.length === 0 ? (
            <div className="bg-emerald-500/10 border border-emerald-500/30 rounded-2xl p-10 text-center">
              <p className="text-emerald-400 font-semibold">✓ No hay competencias críticas</p>
              <p className="text-neutral-500 text-sm mt-1">Todas las competencias superan el 60% de promedio</p>
            </div>
          ) : (
            <div className="bg-neutral-800/30 border border-neutral-700/30 rounded-2xl overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="border-b border-neutral-700/30">
                      {['Competencia', 'Curso', 'Promedio', 'Aprobados', 'En riesgo', 'Acción'].map(h => (
                        <th key={h} className="px-5 py-4 text-left text-xs font-bold text-neutral-400 uppercase tracking-wider">{h}</th>
                      ))}
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-neutral-800/50">
                    {criticas.map((c, i) => (
                      <tr key={i} className="hover:bg-neutral-800/20">
                        <td className="px-5 py-4 font-medium text-white">{c.competencia_nombre}</td>
                        <td className="px-5 py-4 text-neutral-400 text-sm">{c.curso_nombre}</td>
                        <td className="px-5 py-4">
                          <span className={`px-3 py-1 rounded-full text-xs font-bold border ${badgeProm(c.promedio)}`}>
                            {c.promedio}%
                          </span>
                        </td>
                        <td className="px-5 py-4">
                          <BarraLogro pct={c.aprobados_pct} color="#22c55e" />
                        </td>
                        <td className="px-5 py-4">
                          <BarraLogro pct={c.riesgo_pct} color="#ef4444" />
                        </td>
                        <td className="px-5 py-4">
                          <span className="text-xs text-amber-400 font-medium">{c.accion_sugerida}</span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}
        </div>
      )}

      {/* ── Tab: Por Curso ── */}
      {tab === 'por-curso' && (
        <div>
          <div className="flex flex-wrap items-center justify-between gap-4 mb-5">
            <div className="flex items-center gap-3">
              <label className="text-neutral-400 text-sm">Grado:</label>
              <select
                value={gradoSel}
                onChange={e => setGradoSel(e.target.value)}
                className="bg-neutral-800 border border-neutral-700 text-white rounded-lg px-3 py-2 text-sm focus:outline-none"
              >
                {grados.map(c => <option key={c.id} value={c.id}>{c.nombre}</option>)}
              </select>
            </div>
            {reporteCurso && (
              <button onClick={() => exportCSVCurso(reporteCurso)} className="flex items-center gap-2 px-4 py-2 bg-amber-600 hover:bg-amber-500 text-white rounded-lg text-sm font-semibold transition">
                <Download className="w-4 h-4" /> Descargar CSV
              </button>
            )}
          </div>

          {loading ? (
            <div className="text-center py-12 text-neutral-400"><RefreshCw className="w-6 h-6 animate-spin mx-auto mb-2" /></div>
          ) : !reporteCurso ? (
            <div className="text-center py-12 text-neutral-500">Selecciona un curso</div>
          ) : (
            <div className="space-y-4">
              <div className="flex items-center gap-4 p-4 bg-neutral-800/30 rounded-xl border border-neutral-700/30">
                <div>
                  <p className="text-white font-bold text-lg">{reporteCurso.curso_nombre}</p>
                  <p className="text-neutral-400 text-sm flex items-center gap-1">
                    <Users className="w-3.5 h-3.5" /> {reporteCurso.total_estudiantes} estudiantes · {reporteCurso.competencias?.length} competencias
                  </p>
                </div>
              </div>

              <div className="bg-neutral-800/30 border border-neutral-700/30 rounded-2xl overflow-hidden">
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead>
                      <tr className="border-b border-neutral-700/30">
                        {['Competencia', 'Promedio', 'Estudiantes', '% Aprobados', '% En riesgo'].map(h => (
                          <th key={h} className="px-5 py-4 text-left text-xs font-bold text-neutral-400 uppercase tracking-wider">{h}</th>
                        ))}
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-neutral-800/50">
                      {(reporteCurso.competencias || []).map((c, i) => (
                        <tr key={i} className="hover:bg-neutral-800/20">
                          <td className="px-5 py-4 font-medium text-white">{c.competencia_nombre}</td>
                          <td className="px-5 py-4">
                            <span className={`px-3 py-1 rounded-full text-xs font-bold border ${badgeProm(c.promedio)}`}>
                              {c.promedio}%
                            </span>
                          </td>
                          <td className="px-5 py-4 text-neutral-300">{c.estudiantes_total}</td>
                          <td className="px-5 py-4"><BarraLogro pct={c.aprobados_pct} color="#22c55e" /></td>
                          <td className="px-5 py-4"><BarraLogro pct={c.riesgo_pct} color="#ef4444" /></td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          )}
        </div>
      )}

      {/* ── Tab: Comparativa ── */}
      {tab === 'comparativa' && (
        <div className="space-y-6">
          {loading ? (
            <div className="text-center py-12 text-neutral-400"><RefreshCw className="w-6 h-6 animate-spin mx-auto mb-2" /></div>
          ) : (
            <>
              {/* Gráfico */}
              <div className="bg-neutral-800/30 border border-neutral-700/30 rounded-2xl p-6">
                <h2 className="font-bold text-white mb-4 flex items-center gap-2">
                  <BarChart3 className="w-5 h-5 text-amber-400" />
                  Comparativa de competencias por curso
                </h2>
                <GraficoComparativaGrados datos_cursos={comparativa} />
              </div>

              {/* Tabla resumen */}
              {comparativa.length > 0 && (
                <div className="bg-neutral-800/30 border border-neutral-700/30 rounded-2xl overflow-hidden">
                  <div className="p-5 border-b border-neutral-700/30">
                    <h2 className="font-bold text-white">Resumen por curso</h2>
                  </div>
                  <div className="divide-y divide-neutral-800/50">
                    {comparativa.map(curso => (
                      <div key={curso.curso_id} className="p-5">
                        <div className="flex items-center justify-between mb-3">
                          <div>
                            <p className="font-bold text-white">{curso.curso_nombre}</p>
                            <p className="text-xs text-neutral-500">{curso.total_estudiantes} estudiantes</p>
                          </div>
                          <span className={`px-3 py-1 rounded-full text-sm font-bold border ${badgeProm(curso.promedio_general)}`}>
                            {curso.promedio_general}% general
                          </span>
                        </div>
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                          {curso.competencia_mejor && (
                            <div className="bg-emerald-500/10 border border-emerald-500/20 rounded-lg px-4 py-2 text-sm">
                              <p className="text-neutral-500 text-xs">Mejor competencia</p>
                              <p className="text-emerald-400 font-semibold">{curso.competencia_mejor.competencia_nombre}</p>
                              <p className="text-emerald-300 text-xs">{curso.competencia_mejor.promedio}%</p>
                            </div>
                          )}
                          {curso.competencia_peor && (
                            <div className="bg-red-500/10 border border-red-500/20 rounded-lg px-4 py-2 text-sm">
                              <p className="text-neutral-500 text-xs">Necesita refuerzo</p>
                              <p className="text-red-400 font-semibold">{curso.competencia_peor.competencia_nombre}</p>
                              <p className="text-red-300 text-xs">{curso.competencia_peor.promedio}%</p>
                            </div>
                          )}
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </>
          )}
        </div>
      )}
    </div>
  )
}
