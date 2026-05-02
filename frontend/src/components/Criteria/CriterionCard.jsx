import React from 'react'

export default function CriterioCard({ criterio, onEdit, onDelete }) {
  return (
    <div className="bg-white rounded-lg shadow p-6 hover:shadow-lg transition border-l-4 border-success">
      <h3 className="text-lg font-bold text-neutral-900 mb-2">{criterio.nombre}</h3>
      <p className="text-sm text-neutral-700 mb-3">{criterio.descripcion}</p>
      <div className="flex justify-between items-center mb-4">
        <span className="text-sm text-neutral-600">
          <span className="font-semibold">Ponderación:</span> {criterio.ponderacion}%
        </span>
        {criterio.requiere_observacion && (
          <span className="text-xs bg-warning bg-opacity-20 text-neutral-900 px-2 py-1 rounded font-semibold border border-warning">
            Requiere observación
          </span>
        )}
      </div>
      <div className="flex gap-2">
        <button
          onClick={() => onEdit(criterio)}
          className="flex-1 bg-primary-brand hover:bg-primary-600 text-white py-2 rounded-lg text-sm font-semibold transition"
        >
          Editar
        </button>
        <button
          onClick={() => onDelete(criterio.id)}
          className="flex-1 bg-danger hover:bg-red-700 text-white py-2 rounded-lg text-sm font-semibold transition"
        >
          Eliminar
        </button>
      </div>
    </div>
  )
}
