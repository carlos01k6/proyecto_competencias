import React from 'react'

export default function ActividadCard({ actividad, onEdit, onDelete }) {
  const fechaInicio = new Date(actividad.fecha_inicio).toLocaleDateString('es-ES')
  const fechaCierre = new Date(actividad.fecha_cierre).toLocaleDateString('es-ES')
  
  const estadoColor = {
    'activa': 'bg-success bg-opacity-20 text-success',
    'cerrada': 'bg-warning bg-opacity-20 text-warning',
    'cancelada': 'bg-danger bg-opacity-20 text-danger'
  }

  return (
    <div className="bg-white rounded-lg shadow p-6 hover:shadow-lg transition border-l-4 border-primary-brand">
      <h3 className="text-lg font-bold text-neutral-900 mb-2">{actividad.nombre}</h3>
      <p className="text-sm text-neutral-700 mb-3">{actividad.descripcion}</p>
      
      <div className="grid grid-cols-2 gap-3 mb-4">
        <div>
          <span className="text-xs text-neutral-600">Inicio:</span>
          <p className="text-sm font-semibold text-neutral-900">{fechaInicio}</p>
        </div>
        <div>
          <span className="text-xs text-neutral-600">Cierre:</span>
          <p className="text-sm font-semibold text-neutral-900">{fechaCierre}</p>
        </div>
        <div>
          <span className="text-xs text-neutral-600">Tipo:</span>
          <p className="text-sm font-semibold text-neutral-900 capitalize">{actividad.tipo}</p>
        </div>
        <div>
          <span className="text-xs text-neutral-600">Puntaje máximo:</span>
          <p className="text-sm font-semibold text-neutral-900">{actividad.puntaje_maximo}</p>
        </div>
      </div>

      <div className="mb-4">
        <span className={`text-xs px-2 py-1 rounded font-semibold ${estadoColor[actividad.estado] || estadoColor['activa']}`}>
          {actividad.estado.charAt(0).toUpperCase() + actividad.estado.slice(1)}
        </span>
      </div>

      <div className="flex gap-2">
        <button
          onClick={() => onEdit(actividad)}
          className="flex-1 bg-primary-brand hover:bg-primary-600 text-white py-2 rounded-lg text-sm font-semibold transition"
        >
          Editar
        </button>
        <button
          onClick={() => onDelete(actividad.id)}
          className="flex-1 bg-danger hover:bg-red-700 text-white py-2 rounded-lg text-sm font-semibold transition"
        >
          Eliminar
        </button>
      </div>
    </div>
  )
}
