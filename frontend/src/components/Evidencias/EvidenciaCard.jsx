import React from 'react'

export default function EvidenciaCard({ evidencia, onEdit, onDelete, onDownload }) {
  const fechaEnvio = new Date(evidencia.fecha_envio).toLocaleDateString('es-ES')
  
  const estadoColor = {
    'pendiente': 'bg-warning bg-opacity-20 text-warning',
    'revisada': 'bg-info bg-opacity-20 text-info',
    'aprobada': 'bg-success bg-opacity-20 text-success',
    'rechazada': 'bg-danger bg-opacity-20 text-danger'
  }

  // Extraer nombre del archivo de la URL
  const nombreArchivo = evidencia.archivo_url.split('/').pop()

  return (
    <div className="bg-white rounded-lg shadow p-6 hover:shadow-lg transition border-l-4 border-primary-brand">
      <div className="flex justify-between items-start mb-3">
        <h3 className="text-lg font-bold text-neutral-900">Evidencia enviada</h3>
        <span className={`text-xs px-2 py-1 rounded font-semibold ${estadoColor[evidencia.estado] || estadoColor['pendiente']}`}>
          {evidencia.estado.charAt(0).toUpperCase() + evidencia.estado.slice(1)}
        </span>
      </div>

      <div className="mb-4 p-3 bg-neutral-50 rounded border border-neutral-200">
        <p className="text-sm font-semibold text-neutral-900 mb-2">📎 Archivo:</p>
        <p className="text-sm text-neutral-700 break-all">{nombreArchivo}</p>
      </div>

      <div className="grid grid-cols-2 gap-3 mb-4">
        <div>
          <span className="text-xs text-neutral-600">Enviado:</span>
          <p className="text-sm font-semibold text-neutral-900">{fechaEnvio}</p>
        </div>
        <div>
          <span className="text-xs text-neutral-600">ID Evidencia:</span>
          <p className="text-xs font-mono text-neutral-700">{evidencia.id.substring(0, 8)}...</p>
        </div>
      </div>

      <div className="flex gap-2">
        <button
          onClick={() => onDownload(evidencia)}
          className="flex-1 bg-primary-brand hover:bg-primary-600 text-white py-2 rounded-lg text-sm font-semibold transition"
        >
          Descargar
        </button>
        <button
          onClick={() => onEdit(evidencia)}
          className="flex-1 bg-secondary-500 hover:bg-secondary-600 text-white py-2 rounded-lg text-sm font-semibold transition"
        >
          Editar
        </button>
        <button
          onClick={() => onDelete(evidencia.id)}
          className="flex-1 bg-danger hover:bg-red-700 text-white py-2 rounded-lg text-sm font-semibold transition"
        >
          Eliminar
        </button>
      </div>
    </div>
  )
}
