import React, { useState } from 'react'
import CriteriosModal from '../Criterios/CriteriosModal'

export default function ResultadoCard({ resultado, onEdit, onDelete }) {
  const [mostrarCriterios, setMostrarCriterios] = useState(false)

  return (
    <>
      <div className="bg-white rounded-lg shadow p-6 hover:shadow-lg transition border-l-4 border-secondary-600">
        <h3 className="text-lg font-bold text-neutral-900 mb-2">{resultado.titulo}</h3>
        <p className="text-sm text-neutral-700 mb-4">{resultado.descripcion}</p>
        <div className="flex gap-2">
          <button
            onClick={() => setMostrarCriterios(true)}
            className="flex-1 bg-secondary-600 hover:bg-secondary-700 text-white py-2 rounded-lg text-sm font-semibold transition"
          >
            Ver Criterios
          </button>
          <button
            onClick={() => onEdit(resultado)}
            className="flex-1 bg-primary-brand hover:bg-primary-600 text-white py-2 rounded-lg text-sm font-semibold transition"
          >
            Editar
          </button>
          <button
            onClick={() => onDelete(resultado.id)}
            className="flex-1 bg-danger hover:bg-red-700 text-white py-2 rounded-lg text-sm font-semibold transition"
          >
            Eliminar
          </button>
        </div>
      </div>

      {mostrarCriterios && (
        <CriteriosModal
          resultado={resultado}
          onClose={() => setMostrarCriterios(false)}
        />
      )}
    </>
  )
}
