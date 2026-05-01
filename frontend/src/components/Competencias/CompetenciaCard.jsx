import React, { useState } from 'react'
import ResultadosModal from '../Resultados/ResultadosModal'

export default function CompetenciaCard({ competencia, onEdit, onDelete }) {
  const [mostrarResultados, setMostrarResultados] = useState(false)

  return (
    <>
      <div className="bg-white rounded-lg shadow p-6 hover:shadow-lg transition border-l-4 border-primary-brand">
        <h3 className="text-lg font-bold text-neutral-900 mb-2">{competencia.nombre}</h3>
        <p className="text-sm text-neutral-600 mb-3">
          <span className="font-semibold">Asignatura:</span> {competencia.asignatura || 'No especificada'}
        </p>
        <p className="text-sm text-neutral-700 mb-4">{competencia.descripcion}</p>
        <p className="text-xs text-neutral-600 mb-4 p-3 bg-neutral-50 rounded border border-neutral-200">
          <span className="font-semibold">Descriptor:</span> {competencia.descriptor}
        </p>
        <div className="flex gap-2">
          <button
            onClick={() => setMostrarResultados(true)}
            className="flex-1 bg-success hover:bg-green-700 text-white py-2 rounded-lg text-sm font-semibold transition"
          >
            Ver Resultados
          </button>
          <button
            onClick={() => onEdit(competencia)}
            className="flex-1 bg-primary-brand hover:bg-primary-600 text-white py-2 rounded-lg text-sm font-semibold transition"
          >
            Editar
          </button>
          <button
            onClick={() => onDelete(competencia.id)}
            className="flex-1 bg-danger hover:bg-red-700 text-white py-2 rounded-lg text-sm font-semibold transition"
          >
            Eliminar
          </button>
        </div>
      </div>

      {mostrarResultados && (
        <ResultadosModal
          competencia={competencia}
          onClose={() => setMostrarResultados(false)}
        />
      )}
    </>
  )
}
