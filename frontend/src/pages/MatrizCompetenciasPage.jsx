import React, { useState, useEffect, useMemo } from 'react'
import { Grid3x3, Download, Filter, RefreshCw, ChevronDown } from 'lucide-react'
import axios from 'axios'
import { useMatrizCompetencias } from '../hooks/useMatrizCompetencias'
import CeldaMatriz from '../components/CeldaMatriz'

const BASE_URL = 'http://localhost:5000'
const headers = () => {
  const t = localStorage.getItem('acceso_token')
  return t ? { Authorization: `Bearer ${t}` } : {}
}

const NIVELES = ['incipiente', 'basico', 'satisfactorio', 'avanzado']
const NIVEL_LABEL = { incipiente: 'Incipiente', basico: 'Básico', satisfactorio: 'Satisfactorio', avanzado: 'Avanzado' }
const NIVEL_COLOR = {
  incipiente: 'bg-red-500/20 text-red-300 border-red-500/30',
  basico: 'bg-orange-500/20 text-orange-300 border-orange-500/30',
  satisfactorio: 'bg-yellow-500/20 text-yellow-300 border-yellow-500/30',
  avanzado: 'bg-emerald-500/20 text-emerald-300 border-emerald-500/30',
}

export default function MatrizCompetenciasPage({ usuario }) {
  const rol = usuario?.rol?.toLowerCase()
  const esAdmin = rol === 'admin'
  const docenteId = !esAdmin ? usuario?.id : null

  const [grados, setGrados] = useState([])
  const [gradoSel, setGradoSel] = useState('')
  const [filtroNivel, setFiltroNivel] = useState('todos')
  const [ordenarPor, setOrdenarPor] = useState('nombre')

  const { matriz, loading, error, refrescar, exportarCSV } = useMatrizCompetencias({
    docenteId: !esAdmin && !gradoSel ? docenteId : null,
    gradoId: gradoSel || (esAdmin ? undefined : undefined),
  })

  useEffect(() => {
    axios.get(`${BASE_URL}/api/cursos`, { headers: headers() })
      .then(r => setGrados(Array.isArray(r.data) ? r.data : []))
      .catch(() => {})
  }, [])

  const estudiantesFiltrados = useMemo(() => {
    if (!matriz) return []
    let lista = matriz.estudiantes.map((est, i) => ({ ...est, fila: matriz.matriz[i] }))

    if (filtroNivel !== 'todos') {
      lista = lista.filter(est =>
        est.fila.some(celda => celda?.nivel === filtroNivel)
      )
    }

    if (ordenarPor === 'nombre') {
      lista.sort((a, b) => a.nombre.localeCompare(b.nombre))
    } else if (ordenarPor === 'riesgo') {
      lista.sort((a, b) => {
        const minA = Math.min(...est_promedios(a.fila))
        const minB = Math.min(...est_promedios(b.fila))
        return minA - minB
      })
    } else if (ordenarPor === 'promedio') {
      lista.sort((a, b) => {
        return promedio_arr(b.fila) - promedio_arr(a.fila)
      })
    }
    return lista
  }, [matriz, filtroNivel, ordenarPor])

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">

      {/* Header */}
      <div className="flex flex-wrap items-center justify-between gap-4 mb-8">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-gradient-to-br from-violet-600 to-purple-700 rounded-xl">
            <Grid3x3 className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-3xl font-bold text-white">Matriz de Competencias</h1>
            <p className="text-neutral-400">
              {matriz?.grado_nombre || matriz?.curso_nombre || (esAdmin ? 'Selecciona un grado' : 'Todos los estudiantes')}
            </p>
          </div>
        </div>
        <div className="flex gap-3">
          <button onClick={() => refrescar()} className="flex items-center gap-2 px-3 py-2 bg-neutral-800 hover:bg-neutral-700 text-neutral-300 rounded-lg text-sm transition">
            <RefreshCw className="w-4 h-4" />
          </button>
          <button onClick={exportarCSV} className="flex items-center gap-2 px-4 py-2 bg-violet-600 hover:bg-violet-500 text-white rounded-lg text-sm font-semibold transition">
            <Download className="w-4 h-4" /> CSV
          </button>
        </div>
      </div>

      {/* Leyenda */}
      <div className="flex flex-wrap gap-2 mb-6">
        {NIVELES.map(n => (
          <span key={n} className={`px-3 py-1 rounded-full text-xs font-semibold border ${NIVEL_COLOR[n]}`}>
            {NIVEL_LABEL[n]}
          </span>
        ))}
        <span className="px-3 py-1 rounded-full text-xs font-semibold border bg-neutral-800/20 text-neutral-500 border-neutral-700/20">— Sin datos</span>
      </div>

      {/* Filtros */}
      <div className="flex flex-wrap items-center gap-4 mb-6 p-4 bg-neutral-800/30 rounded-xl border border-neutral-700/30">
        <Filter className="w-4 h-4 text-neutral-500" />

        {(esAdmin || grados.length > 0) && (
          <div className="flex items-center gap-2">
            <label className="text-neutral-400 text-sm">Grado:</label>
            <select
              value={gradoSel}
              onChange={e => setGradoSel(e.target.value)}
              className="bg-neutral-800 border border-neutral-700 text-white rounded-lg px-3 py-2 text-sm focus:outline-none"
            >
              <option value="">{esAdmin ? 'Todos (por docente)' : 'Mis estudiantes'}</option>
              {grados.map(c => <option key={c.id} value={c.id}>{c.nombre || c.codigo}</option>)}
            </select>
          </div>
        )}

        <div className="flex items-center gap-2">
          <label className="text-neutral-400 text-sm">Mostrar:</label>
          <select
            value={filtroNivel}
            onChange={e => setFiltroNivel(e.target.value)}
            className="bg-neutral-800 border border-neutral-700 text-white rounded-lg px-3 py-2 text-sm focus:outline-none"
          >
            <option value="todos">Todos</option>
            <option value="incipiente">Solo en riesgo (&lt;40%)</option>
            <option value="basico">Solo básico (40-60%)</option>
            <option value="avanzado">Solo aprobados (&gt;75%)</option>
          </select>
        </div>

        <div className="flex items-center gap-2">
          <label className="text-neutral-400 text-sm">Ordenar:</label>
          <select
            value={ordenarPor}
            onChange={e => setOrdenarPor(e.target.value)}
            className="bg-neutral-800 border border-neutral-700 text-white rounded-lg px-3 py-2 text-sm focus:outline-none"
          >
            <option value="nombre">Alfabético</option>
            <option value="riesgo">Por mayor riesgo</option>
            <option value="promedio">Por promedio</option>
          </select>
        </div>
      </div>

      {error && <div className="bg-red-500/10 border border-red-500/30 rounded-lg p-4 mb-6 text-red-400">Error: {error}</div>}

      {/* Matrix */}
      {loading ? (
        <div className="text-center py-20 text-neutral-400">
          <RefreshCw className="w-8 h-8 animate-spin mx-auto mb-3 text-violet-500" />Calculando matriz...
        </div>
      ) : !matriz || !matriz.estudiantes.length ? (
        <div className="bg-neutral-800/30 border border-neutral-700/30 rounded-2xl p-12 text-center text-neutral-500">
          {esAdmin && !gradoSel ? 'Selecciona un grado para ver la matriz' : 'No hay datos disponibles'}
        </div>
      ) : (
        <div className="bg-neutral-800/30 border border-neutral-700/30 rounded-2xl overflow-hidden">
          <div className="overflow-auto max-h-[70vh]">
            <table className="border-separate border-spacing-0">
              <thead className="sticky top-0 z-10">
                <tr>
                  <th className="sticky left-0 z-20 bg-neutral-900 px-4 py-3 text-left text-xs font-bold text-neutral-400 uppercase whitespace-nowrap border-b border-r border-neutral-700/50 min-w-[160px]">
                    Estudiante
                  </th>
                  {matriz.competencias.map(comp => (
                    <th key={comp.id} className="bg-neutral-900 px-2 py-3 text-center border-b border-neutral-700/50 min-w-[72px]">
                      <span className="text-xs font-semibold text-neutral-300 writing-mode-vertical block max-h-24 overflow-hidden" style={{ writingMode: 'vertical-rl', transform: 'rotate(180deg)', maxHeight: 96, textOverflow: 'ellipsis' }} title={comp.nombre}>
                        {comp.nombre?.slice(0, 22)}{comp.nombre?.length > 22 ? '…' : ''}
                      </span>
                    </th>
                  ))}
                  <th className="bg-neutral-900 px-3 py-3 text-center border-b border-l border-neutral-700/50 min-w-[72px]">
                    <span className="text-xs font-bold text-neutral-400">Promedio</span>
                  </th>
                </tr>
              </thead>
              <tbody>
                {estudiantesFiltrados.map((est) => {
                  const promedios = est.fila.filter(c => c?.porcentaje != null).map(c => c.porcentaje)
                  const prom = promedios.length ? Math.round(promedios.reduce((a, b) => a + b, 0) / promedios.length) : null
                  return (
                    <tr key={est.id} className="hover:bg-neutral-800/30 transition">
                      <td className="sticky left-0 bg-neutral-900 border-b border-r border-neutral-700/30 px-4 py-2">
                        <p className="text-sm font-medium text-white truncate max-w-[150px]">{est.nombre}</p>
                      </td>
                      {est.fila.map((celda, ci) => (
                        <td key={ci} className="border-b border-neutral-700/20 px-1 py-1 text-center">
                          <div className="flex justify-center">
                            <CeldaMatriz
                              porcentaje={celda?.porcentaje}
                              nivel={celda?.nivel}
                              nombre_competencia={matriz.competencias[ci]?.nombre}
                              nombre_estudiante={est.nombre}
                              evaluaciones={celda?.evaluaciones}
                            />
                          </div>
                        </td>
                      ))}
                      <td className="border-b border-l border-neutral-700/30 px-3 py-2 text-center">
                        {prom != null ? (
                          <span className={`text-sm font-bold ${prom >= 75 ? 'text-emerald-400' : prom >= 60 ? 'text-yellow-400' : prom >= 40 ? 'text-orange-400' : 'text-red-400'}`}>
                            {prom}%
                          </span>
                        ) : <span className="text-neutral-600">—</span>}
                      </td>
                    </tr>
                  )
                })}
              </tbody>
            </table>
          </div>
          <div className="p-4 border-t border-neutral-700/30 text-xs text-neutral-500 flex justify-between">
            <span>{estudiantesFiltrados.length} estudiantes · {matriz.competencias.length} competencias</span>
            {filtroNivel !== 'todos' && <span className="text-yellow-400">Filtro activo: {NIVEL_LABEL[filtroNivel]}</span>}
          </div>
        </div>
      )}
    </div>
  )
}

function est_promedios(fila) {
  return fila.filter(c => c?.porcentaje != null).map(c => c.porcentaje)
}

function promedio_arr(fila) {
  const vals = est_promedios(fila)
  return vals.length ? vals.reduce((a, b) => a + b, 0) / vals.length : 0
}
