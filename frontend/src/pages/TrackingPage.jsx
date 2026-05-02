import React, { useEffect, useState } from 'react'
import { TrendingUp, Search, Filter } from 'lucide-react'
import * as seguimientoService from '../services/tracking'

export default function SeguimientoPage({ usuario }) {
  const [datos, setDatos] = useState([])
  const [cargando, setCargando] = useState(false)
  const [busqueda, setBusqueda] = useState('')

  useEffect(() => {
    obtenerDatos()
  }, [])

  const obtenerDatos = async () => {
    setCargando(true)
    try {
      const data = await seguimientoService.obtenerSeguimiento()
      setDatos(data || [])
    } catch (err) {
      console.error(err)
    } finally {
      setCargando(false)
    }
  }

  const filtrados = datos.filter(d => d.student_id?.includes(busqueda))

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-4">
          <div className="p-3 bg-gradient-to-br from-pink-600 to-pink-700 rounded-lg">
            <TrendingUp className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Seguimiento</h1>
            <p className="text-neutral-400">Monitorea el progreso de los estudiantes</p>
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
        <button className="flex items-center justify-center gap-2 px-4 py-3 bg-neutral-800/50 border border-neutral-700 rounded-lg text-neutral-300 hover:border-neutral-600 transition">
          <Filter className="w-5 h-5" />
          Filtrar
        </button>
        <div></div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {[1, 2, 3, 4].map((item) => (
          <div key={item} className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 hover:border-neutral-700 transition">
            <div className="flex items-start justify-between mb-4">
              <div>
                <p className="text-sm text-neutral-400">Estudiante {item}</p>
                <p className="text-lg font-bold text-white">ID: 36d1ade...{item}</p>
              </div>
              <span className="px-3 py-1 bg-success/20 text-success rounded-full text-xs font-semibold">Activo</span>
            </div>
            <div className="space-y-3">
              <div>
                <p className="text-xs text-neutral-500 mb-2">Progreso General</p>
                <div className="w-full h-2 bg-neutral-700 rounded-full overflow-hidden">
                  <div className="h-full bg-gradient-to-r from-primary-brand to-primary-600" style={{width: `${70 + item * 5}%`}}></div>
                </div>
              </div>
              <div className="grid grid-cols-3 gap-2 text-xs">
                <div className="text-center p-2 bg-neutral-900/50 rounded">
                  <p className="text-neutral-500">Evaluaciones</p>
                  <p className="font-bold text-white">{5 + item}</p>
                </div>
                <div className="text-center p-2 bg-neutral-900/50 rounded">
                  <p className="text-neutral-500">Promedio</p>
                  <p className="font-bold text-white">{75 + item}%</p>
                </div>
                <div className="text-center p-2 bg-neutral-900/50 rounded">
                  <p className="text-neutral-500">Actividades</p>
                  <p className="font-bold text-white">{8 + item}</p>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}