import React, { useEffect, useState } from "react"
import { CheckSquare } from "lucide-react"
import * as rubricasService from "../services/rubrics"

export default function RubricasGlobalesPage() {
  const [rubricas, setRubricas] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  useEffect(() => {
    const cargarRubricas = async () => {
      setCargando(true)
      setError(null)

      try {
        const data = await rubricasService.obtenerRubricasGlobales()
        setRubricas(Array.isArray(data) ? data : [])
      } catch (err) {
        setRubricas([])
        setError(err.response?.data?.error || err.message)
      } finally {
        setCargando(false)
      }
    }

    cargarRubricas()
  }, [])

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-gradient-to-br from-emerald-600 to-emerald-700 rounded-lg">
            <CheckSquare className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Rúbricas Globales</h1>
            <p className="text-neutral-400">Rúbricas disponibles en toda la institución</p>
          </div>
        </div>
      </div>

      {error && (
        <div className="bg-danger/10 border border-danger/30 rounded-lg p-4 mb-6">
          <p className="text-danger font-semibold">Error: {error}</p>
        </div>
      )}

      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
        {cargando ? (
          <div className="py-12 text-center text-neutral-400">Cargando rúbricas...</div>
        ) : rubricas.length === 0 ? (
          <div className="py-12 text-center text-neutral-400">Sin rúbricas globales</div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="bg-neutral-900/50 border-b border-neutral-700/50">
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Nombre</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Descripción</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Criterios</th>
                </tr>
              </thead>
              <tbody>
                {rubricas.map((rubrica) => (
                  <tr key={rubrica.id} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition">
                    <td className="px-6 py-4 text-white font-semibold">{rubrica.nombre}</td>
                    <td className="px-6 py-4 text-neutral-300">{rubrica.descripcion || "N/A"}</td>
                    <td className="px-6 py-4 text-primary-brand font-bold">{rubrica.criterios_count}</td>
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
