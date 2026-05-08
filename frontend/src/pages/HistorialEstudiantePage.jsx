import React, { useState, useMemo } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { ArrowLeft, Download, User, TrendingUp, BookOpen, RefreshCw, Filter } from 'lucide-react'
import { useHistorial, useHistorialCompetencia } from '../hooks/useHistorial'
import TimelineProgreso from '../components/TimelineProgreso'
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, ReferenceLine } from 'recharts'

const NIVEL_BADGE = {
  critico:      'bg-red-500/20 text-red-400 border-red-500/30',
  alto:         'bg-orange-500/20 text-orange-400 border-orange-500/30',
  medio:        'bg-yellow-500/20 text-yellow-400 border-yellow-500/30',
}

export default function HistorialEstudiantePage({ usuario }) {
  const { estudianteId } = useParams()
  const navigate = useNavigate()
  const { historial, loading, error, refrescar, descargarCSV } = useHistorial(estudianteId)

  const [competenciaFiltro, setCompetenciaFiltro] = useState('todas')
  const [compDetalle, setCompDetalle] = useState(null)
  const { data: detalleComp, loading: loadDetalle } = useHistorialCompetencia(
    compDetalle ? estudianteId : null,
    compDetalle
  )

  // Unique competencies for filter
  const competencias = useMemo(() => {
    const seen = {}
    historial.forEach(h => { if (h.competencia_id) seen[h.competencia_id] = h.competencia_nombre })
    return Object.entries(seen).map(([id, nombre]) => ({ id, nombre }))
  }, [historial])

  const filtrado = useMemo(() => {
    if (competenciaFiltro === 'todas') return historial
    return historial.filter(h => h.competencia_id === competenciaFiltro)
  }, [historial, competenciaFiltro])

  // Stats
  const stats = useMemo(() => {
    if (!filtrado.length) return null
    const con_cambio = filtrado.filter(h => h.cambio != null)
    const mejoras = con_cambio.filter(h => h.cambio > 0).length
    const caidas = con_cambio.filter(h => h.cambio < 0).length
    const promedio = filtrado.reduce((s, h) => s + (h.calificacion ?? 0), 0) / filtrado.length
    const ultima = filtrado[0] // already sorted desc
    return { total: filtrado.length, mejoras, caidas, promedio: Math.round(promedio * 10) / 10, ultima }
  }, [filtrado])

  // Chart data for selected competency
  const chartData = useMemo(() => {
    if (!detalleComp?.timeline) return []
    return detalleComp.timeline.map(p => ({
      evaluacion: `E${p.evaluacion_num}`,
      promedio: p.promedio_acumulado,
      calificacion: p.calificacion,
    }))
  }, [detalleComp])

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">

      {/* Header */}
      <div className="flex items-center gap-4 mb-8">
        <button onClick={() => navigate(-1)} className="p-2 hover:bg-neutral-800 rounded-lg text-neutral-400 hover:text-white transition">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div className="p-3 bg-gradient-to-br from-blue-600 to-indigo-700 rounded-xl">
          <User className="w-6 h-6 text-white" />
        </div>
        <div>
          <h1 className="text-3xl font-bold text-white">Historial de Progreso</h1>
          <p className="text-neutral-400 text-sm font-mono">{estudianteId}</p>
        </div>
        <div className="ml-auto flex gap-3">
          <button onClick={() => refrescar()} className="flex items-center gap-2 px-3 py-2 bg-neutral-800 hover:bg-neutral-700 text-neutral-300 rounded-lg text-sm transition">
            <RefreshCw className="w-4 h-4" /> Actualizar
          </button>
          <button onClick={() => descargarCSV()} className="flex items-center gap-2 px-4 py-2 bg-blue-600 hover:bg-blue-500 text-white rounded-lg text-sm font-semibold transition">
            <Download className="w-4 h-4" /> Descargar CSV
          </button>
        </div>
      </div>

      {error && <div className="bg-red-500/10 border border-red-500/30 rounded-lg p-4 mb-6 text-red-400">Error: {error}</div>}

      {/* Stats */}
      {stats && (
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
          {[
            { label: 'Total registros', value: stats.total, color: 'text-white' },
            { label: 'Mejoras', value: stats.mejoras, color: 'text-emerald-400' },
            { label: 'Caídas', value: stats.caidas, color: 'text-red-400' },
            { label: 'Promedio', value: `${stats.promedio}%`, color: 'text-blue-400' },
          ].map(s => (
            <div key={s.label} className="bg-neutral-800/40 border border-neutral-700/30 rounded-2xl p-5">
              <p className="text-neutral-400 text-sm mb-1">{s.label}</p>
              <p className={`text-4xl font-black ${s.color}`}>{s.value}</p>
            </div>
          ))}
        </div>
      )}

      {/* Filters */}
      <div className="flex flex-wrap items-center gap-4 mb-6 p-4 bg-neutral-800/30 rounded-xl border border-neutral-700/30">
        <Filter className="w-4 h-4 text-neutral-500" />
        <select
          value={competenciaFiltro}
          onChange={e => { setCompetenciaFiltro(e.target.value); setCompDetalle(e.target.value !== 'todas' ? e.target.value : null) }}
          className="bg-neutral-800 border border-neutral-700 text-white rounded-lg px-3 py-2 text-sm focus:outline-none"
        >
          <option value="todas">Todas las competencias</option>
          {competencias.map(c => <option key={c.id} value={c.id}>{c.nombre}</option>)}
        </select>
        {competenciaFiltro !== 'todas' && (
          <button onClick={() => { setCompetenciaFiltro('todas'); setCompDetalle(null) }} className="text-xs text-neutral-400 hover:text-white">× Limpiar filtro</button>
        )}
      </div>

      {/* Chart (shown when a specific competency is selected) */}
      {compDetalle && detalleComp && (
        <div className="bg-neutral-800/30 border border-neutral-700/30 rounded-2xl p-6 mb-6">
          <h2 className="font-bold text-white mb-1 flex items-center gap-2">
            <TrendingUp className="w-5 h-5 text-blue-400" />
            Progreso en {detalleComp.estadisticas?.competencia_nombre}
          </h2>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-4 text-sm">
            <div className="bg-neutral-900/50 rounded-lg p-3">
              <p className="text-neutral-500">Intentos</p>
              <p className="font-bold text-white">{detalleComp.estadisticas?.intentos}</p>
            </div>
            <div className="bg-neutral-900/50 rounded-lg p-3">
              <p className="text-neutral-500">Mejora total</p>
              <p className={`font-bold ${detalleComp.estadisticas?.mejora_total >= 0 ? 'text-emerald-400' : 'text-red-400'}`}>
                {detalleComp.estadisticas?.mejora_total > 0 ? '+' : ''}{detalleComp.estadisticas?.mejora_total}
              </p>
            </div>
            <div className="bg-neutral-900/50 rounded-lg p-3">
              <p className="text-neutral-500">Inicial → Final</p>
              <p className="font-bold text-white">
                {detalleComp.estadisticas?.calificacion_inicial} → {detalleComp.estadisticas?.calificacion_final}
              </p>
            </div>
            <div className="bg-neutral-900/50 rounded-lg p-3">
              <p className="text-neutral-500">Promedio</p>
              <p className="font-bold text-white">{detalleComp.estadisticas?.promedio}%</p>
            </div>
          </div>
          {chartData.length > 1 && (
            <div style={{ height: 200 }}>
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={chartData}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#374151" />
                  <XAxis dataKey="evaluacion" tick={{ fill: '#9ca3af', fontSize: 11 }} />
                  <YAxis domain={[0, 100]} tick={{ fill: '#9ca3af', fontSize: 11 }} />
                  <Tooltip contentStyle={{ backgroundColor: '#1f2937', border: '1px solid #374151', borderRadius: '8px' }} />
                  <ReferenceLine y={65} stroke="#f59e0b" strokeDasharray="4 4" />
                  <Line type="monotone" dataKey="calificacion" stroke="#3b82f6" strokeWidth={2} dot={{ r: 4, fill: '#3b82f6' }} name="Calificación" />
                  <Line type="monotone" dataKey="promedio" stroke="#10b981" strokeWidth={2} strokeDasharray="5 5" dot={false} name="Promedio acum." />
                </LineChart>
              </ResponsiveContainer>
            </div>
          )}
        </div>
      )}

      {/* Timeline */}
      {loading ? (
        <div className="text-center py-20 text-neutral-400">
          <RefreshCw className="w-8 h-8 animate-spin mx-auto mb-3 text-blue-500" />Cargando historial...
        </div>
      ) : filtrado.length === 0 ? (
        <div className="bg-neutral-800/30 border border-neutral-700/30 rounded-2xl p-12 text-center text-neutral-500">
          Sin registros en el historial
        </div>
      ) : (
        <div className="bg-neutral-800/30 border border-neutral-700/30 rounded-2xl p-6">
          <h2 className="font-bold text-white mb-6 flex items-center gap-2">
            <BookOpen className="w-5 h-5 text-blue-400" />
            Timeline de cambios
            <span className="text-neutral-500 text-sm font-normal">— {filtrado.length} registros</span>
          </h2>
          <TimelineProgreso historial={filtrado} />
        </div>
      )}
    </div>
  )
}
