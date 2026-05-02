import React, { useEffect, useState } from "react"
import { BookOpen } from "lucide-react"
import * as boletinService from "../services/bulletin"
import competenciasService from "../services/competencies"

export default function BoletinPage() {
  const [competencias, setCompetencias] = useState([])
  const [competenciaId, setCompetenciaId] = useState("")
  const [datos, setDatos] = useState([])
  const [cargandoCompetencias, setCargandoCompetencias] = useState(false)
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)
  const [consultado, setConsultado] = useState(false)

  useEffect(() => {
    const cargarCompetencias = async () => {
      setCargandoCompetencias(true)
      setError(null)

      try {
        const data = await competenciasService.getAll()
        const lista = Array.isArray(data) ? data : []
        setCompetencias(lista)
        setCompetenciaId(lista[0]?.id || "")
      } catch (err) {
        setError(err.response?.data?.error || err.response?.data?.mensaje || err.message)
      } finally {
        setCargandoCompetencias(false)
      }
    }

    cargarCompetencias()
  }, [])

  const handleCargar = async () => {
    if (!competenciaId) {
      setError("Selecciona una competencia")
      return
    }

    setCargando(true)
    setConsultado(true)
    setError(null)

    try {
      const data = await boletinService.obtenerBoletinCompetencia(competenciaId)
      setDatos(Array.isArray(data) ? data : [])
    } catch (err) {
      setDatos([])
      setError(err.response?.data?.error || err.response?.data?.mensaje || err.message)
    } finally {
      setCargando(false)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-gradient-to-br from-green-600 to-green-700 rounded-lg">
            <BookOpen className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Boletín por Competencia</h1>
            <p className="text-neutral-400">Resumen de evaluaciones por resultado de aprendizaje</p>
          </div>
        </div>
      </div>

      {error && (
        <div className="bg-danger/10 border border-danger/30 rounded-lg p-4 mb-6">
          <p className="text-danger font-semibold">Error: {error}</p>
        </div>
      )}

      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 mb-6">
        <label className="block text-sm font-semibold text-white mb-3">Competencia</label>
        <div className="flex flex-col md:flex-row gap-3">
          <select
            value={competenciaId}
            onChange={(e) => setCompetenciaId(e.target.value)}
            disabled={cargandoCompetencias}
            className="flex-1 bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
          >
            <option value="">{cargandoCompetencias ? "Cargando competencias..." : "Selecciona una competencia"}</option>
            {competencias.map((competencia) => (
              <option key={competencia.id} value={competencia.id}>
                {competencia.nombre || competencia.name || competencia.id}
              </option>
            ))}
          </select>

          <button
            onClick={handleCargar}
            disabled={cargando || cargandoCompetencias || !competenciaId}
            className="bg-primary-brand hover:bg-primary-600 text-white px-6 py-3 rounded-lg font-semibold transition disabled:opacity-50"
          >
            {cargando ? "Cargando..." : "Cargar"}
          </button>
        </div>
      </div>

      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
        {cargando ? (
          <div className="py-12 text-center text-neutral-400">Cargando boletín...</div>
        ) : consultado && datos.length === 0 ? (
          <div className="py-12 text-center text-neutral-400">Sin datos para esta competencia</div>
        ) : !consultado ? (
          <div className="py-12 text-center text-neutral-400">Selecciona una competencia y carga el boletín</div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="bg-neutral-900/50 border-b border-neutral-700/50">
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Resultado</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Evaluaciones</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Promedio</th>
                </tr>
              </thead>
              <tbody>
                {datos.map((item, index) => (
                  <tr key={`${item.learning_outcome_name}-${index}`} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition">
                    <td className="px-6 py-4 text-white font-semibold">{item.learning_outcome_name}</td>
                    <td className="px-6 py-4 text-neutral-300">{item.total_evaluaciones}</td>
                    <td className="px-6 py-4 text-primary-brand font-bold">{item.promedio}/100</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  )
}
