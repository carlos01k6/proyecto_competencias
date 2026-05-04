import React, { useEffect, useState } from "react"
import { Layers } from "lucide-react"
import * as nivelesService from "../services/levels"
import { getStudentCode } from "../utils/studentCode"

export default function NivelesPage({ usuario }) {
  const [studentId, setStudentId] = useState(usuario?.id || "")
  const [niveles, setNiveles] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)
  const [consultado, setConsultado] = useState(false)

  useEffect(() => {
    if (usuario?.id && !studentId) {
      setStudentId(usuario.id)
    }
  }, [usuario?.id, studentId])

  const getNivelColor = (color) => {
    const colores = {
      rojo: "bg-danger/20 text-danger border border-danger/30",
      amarillo: "bg-warning/20 text-warning border border-warning/30",
      azul: "bg-primary-brand/20 text-primary-brand border border-primary-brand/30",
      verde: "bg-success/20 text-success border border-success/30"
    }
    return colores[color] || "bg-neutral-700 text-neutral-300"
  }

  const formatearFecha = (fecha) => {
    if (!fecha) return "Sin fecha"

    const date = new Date(fecha)
    if (Number.isNaN(date.getTime())) return "Sin fecha"

    return date.toLocaleDateString("es-ES", {
      year: "numeric",
      month: "long",
      day: "numeric"
    })
  }

  const handleCargar = async () => {
    if (!studentId.trim()) {
      setError("Ingresa un ID de estudiante")
      return
    }

    setCargando(true)
    setConsultado(true)
    setError(null)

    try {
      const data = await nivelesService.obtenerNivelesEstudiante(studentId.trim())
      setNiveles(Array.isArray(data) ? data : [])
    } catch (err) {
      setNiveles([])
      setError(err.response?.data?.error || err.message)
    } finally {
      setCargando(false)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-gradient-to-br from-indigo-600 to-indigo-700 rounded-lg">
            <Layers className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Niveles de Logro</h1>
            <p className="text-neutral-400">Consulta los niveles alcanzados por estudiante</p>
          </div>
        </div>
      </div>

      {error && (
        <div className="bg-danger/10 border border-danger/30 rounded-lg p-4 mb-6">
          <p className="text-danger font-semibold">Error: {error}</p>
        </div>
      )}

      {usuario?.id && (
        <div className="mb-6 rounded-lg bg-neutral-800/60 border border-neutral-700 p-4 flex flex-col md:flex-row md:items-center justify-between gap-3">
          <p className="text-neutral-300">Tu código: <strong className="text-white">{getStudentCode(usuario)}</strong></p>
          <button onClick={() => navigator.clipboard.writeText(getStudentCode(usuario))} className="bg-primary-brand hover:bg-primary-600 text-white px-4 py-2 rounded-lg font-semibold">
            Copiar código
          </button>
        </div>
      )}

      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 mb-6">
        <label className="block text-sm font-semibold text-white mb-3">student_id</label>
        <div className="flex flex-col md:flex-row gap-3">
          <input
            type="text"
            value={studentId}
            onChange={(e) => setStudentId(e.target.value)}
            placeholder="Ej: uuid-del-estudiante"
            className="flex-1 bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
          />
          <button
            onClick={handleCargar}
            disabled={cargando}
            className="bg-primary-brand hover:bg-primary-600 text-white px-6 py-3 rounded-lg font-semibold transition disabled:opacity-50"
          >
            {cargando ? "Cargando..." : "Cargar"}
          </button>
        </div>
      </div>

      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
        {cargando ? (
          <div className="py-12 text-center text-neutral-400">Cargando niveles...</div>
        ) : consultado && niveles.length === 0 ? (
          <div className="py-12 text-center text-neutral-400">Sin evaluaciones</div>
        ) : !consultado ? (
          <div className="py-12 text-center text-neutral-400">Ingresa un ID de estudiante y carga sus niveles</div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="bg-neutral-900/50 border-b border-neutral-700/50">
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Criterio</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Calificación</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Nivel</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Fecha</th>
                </tr>
              </thead>
              <tbody>
                {niveles.map((nivel, index) => (
                  <tr key={`${nivel.criteria_name}-${nivel.fecha_creacion}-${index}`} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition">
                    <td className="px-6 py-4 text-white font-semibold">{nivel.criteria_name}</td>
                    <td className="px-6 py-4 text-white font-bold">{nivel.grade}/100</td>
                    <td className="px-6 py-4">
                      <span className={`px-3 py-1 rounded-full text-sm font-semibold ${getNivelColor(nivel.color)}`}>
                        {nivel.nivel}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-neutral-400 text-sm">{formatearFecha(nivel.fecha_creacion)}</td>
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
