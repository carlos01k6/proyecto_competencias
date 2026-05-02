import React, { useEffect, useState } from 'react'
import { BarChart3, Plus, Search, Trash2, Edit, Eye } from 'lucide-react'
import * as evaluacionesService from '../services/evaluations'

export default function EvaluacionPage({ usuario }) {
  const [evaluaciones, setEvaluaciones] = useState([])
  const [cargando, setCargando] = useState(false)
  const [busqueda, setBusqueda] = useState('')
  const [showForm, setShowForm] = useState(false)
  const [formData, setFormData] = useState({ student_id: '', grade: '', observation: '' })

  useEffect(() => {
    obtenerEvaluaciones()
  }, [])

  const obtenerEvaluaciones = async () => {
    setCargando(true)
    try {
      const data = await evaluacionesService.obtenerEvaluaciones()
      setEvaluaciones(data || [])
    } catch (err) {
      console.error(err)
    } finally {
      setCargando(false)
    }
  }

  const handleCrear = async (e) => {
    e.preventDefault()
    try {
      await evaluacionesService.crearEvaluacion(formData)
      setFormData({ student_id: '', grade: '', observation: '' })
      setShowForm(false)
      obtenerEvaluaciones()
    } catch (err) {
      console.error(err)
    }
  }

  const getGradeColor = (grade) => {
    if (grade >= 71) return 'bg-success/20 text-success'
    if (grade >= 41) return 'bg-warning/20 text-warning'
    return 'bg-danger/20 text-danger'
  }

  const filtrados = evaluaciones.filter(e => e.student_id?.includes(busqueda))

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-4">
          <div className="p-3 bg-gradient-to-br from-blue-600 to-blue-700 rounded-lg">
            <BarChart3 className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Evaluación</h1>
            <p className="text-neutral-400">Califica el desempeño de los estudiantes</p>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-neutral-500" />
          <input
            type="text"
            placeholder="Buscar estudiante..."
            value={busqueda}
            onChange={(e) => setBusqueda(e.target.value)}
            className="w-full pl-10 pr-4 py-3 bg-neutral-800/50 border border-neutral-700 rounded-lg text-white placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
          />
        </div>
        <div></div>
        <button
          onClick={() => setShowForm(!showForm)}
          className="flex items-center justify-center gap-2 px-4 py-3 bg-gradient-to-r from-primary-brand to-primary-600 text-white rounded-lg font-semibold shadow-lg shadow-primary-brand/20 transition"
        >
          <Plus className="w-5 h-5" />
          Nueva Evaluación
        </button>
      </div>

      {showForm && (
        <div className="mb-8 bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
          <h2 className="text-xl font-bold text-white mb-6">Crear Evaluación</h2>
          <form onSubmit={handleCrear} className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <input type="text" placeholder="ID Estudiante" value={formData.student_id} onChange={(e) => setFormData({...formData, student_id: e.target.value})} className="px-4 py-3 bg-neutral-800/50 border border-neutral-700 rounded-lg text-white placeholder-neutral-500 focus:outline-none focus:border-primary-brand transition" required />
            <input type="number" placeholder="Calificación (0-100)" value={formData.grade} onChange={(e) => setFormData({...formData, grade: e.target.value})} min="0" max="100" className="px-4 py-3 bg-neutral-800/50 border border-neutral-700 rounded-lg text-white placeholder-neutral-500 focus:outline-none focus:border-primary-brand transition" required />
            <textarea placeholder="Observación" value={formData.observation} onChange={(e) => setFormData({...formData, observation: e.target.value})} className="px-4 py-3 bg-neutral-800/50 border border-neutral-700 rounded-lg text-white placeholder-neutral-500 focus:outline-none focus:border-primary-brand transition md:col-span-3"></textarea>
            <div className="flex gap-3 md:col-span-3">
              <button type="submit" className="flex-1 px-4 py-3 bg-primary-brand hover:bg-primary-600 text-white rounded-lg font-semibold transition">Crear</button>
              <button type="button" onClick={() => setShowForm(false)} className="flex-1 px-4 py-3 bg-neutral-800 hover:bg-neutral-700 text-white rounded-lg font-semibold transition">Cancelar</button>
            </div>
          </form>
        </div>
      )}

      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
        {cargando ? (
          <div className="flex items-center justify-center py-12"><div className="animate-spin"><div className="w-8 h-8 border-4 border-neutral-700 border-t-primary-brand rounded-full"></div></div></div>
        ) : filtrados.length === 0 ? (
          <div className="text-center py-12"><p className="text-neutral-500">No hay evaluaciones</p></div>
        ) : (
          <table className="w-full">
            <thead>
              <tr className="border-b border-neutral-700/50 bg-neutral-900/50">
                <th className="px-6 py-4 text-left font-semibold text-neutral-300">Estudiante</th>
                <th className="px-6 py-4 text-left font-semibold text-neutral-300">Calificación</th>
                <th className="px-6 py-4 text-left font-semibold text-neutral-300">Observación</th>
                <th className="px-6 py-4 text-right font-semibold text-neutral-300">Acciones</th>
              </tr>
            </thead>
            <tbody>
              {filtrados.map((ev, idx) => (
                <tr key={idx} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition group">
                  <td className="px-6 py-4 text-white font-semibold">{ev.student_id?.substring(0, 8)}...</td>
                  <td className="px-6 py-4">
                    <span className={`px-3 py-1 rounded-full text-xs font-semibold ${getGradeColor(ev.grade)}`}>
                      {ev.grade}/100
                    </span>
                  </td>
                  <td className="px-6 py-4 text-neutral-400 max-w-xs truncate">{ev.observation}</td>
                  <td className="px-6 py-4 text-right">
                    <div className="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition">
                      <button className="p-2 hover:bg-neutral-800 rounded-lg transition text-info"><Eye className="w-4 h-4" /></button>
                      <button className="p-2 hover:bg-neutral-800 rounded-lg transition text-primary-brand"><Edit className="w-4 h-4" /></button>
                      <button className="p-2 hover:bg-danger/10 rounded-lg transition text-danger"><Trash2 className="w-4 h-4" /></button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  )
}