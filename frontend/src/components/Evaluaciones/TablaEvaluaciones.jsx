import React from 'react'

export default function TablaEvaluaciones({ criterios, evaluaciones, onCalificar, onEditar, onEliminar }) {
  const obtenerCalificacionCriterio = (criterio_id) => {
    const evaluacion = evaluaciones.find(e => (e.criteria_id || e.criterio_id) === criterio_id)
    return evaluacion ? (evaluacion.grade ?? evaluacion.calificacion) : null
  }

  const obtenerObservacionCriterio = (criterio_id) => {
    const evaluacion = evaluaciones.find(e => (e.criteria_id || e.criterio_id) === criterio_id)
    return evaluacion ? (evaluacion.observation || evaluacion.observacion || '') : ''
  }

  const obtenerIdEvaluacion = (criterio_id) => {
    const evaluacion = evaluaciones.find(e => (e.criteria_id || e.criterio_id) === criterio_id)
    return evaluacion ? evaluacion.id : null
  }

  return (
    <div className="overflow-x-auto">
      <table className="w-full border-collapse">
        <thead>
          <tr className="bg-primary-brand text-white">
            <th className="border border-neutral-300 px-4 py-3 text-left font-semibold">Criterio</th>
            <th className="border border-neutral-300 px-4 py-3 text-center font-semibold">Ponderación</th>
            <th className="border border-neutral-300 px-4 py-3 text-center font-semibold">Calificación</th>
            <th className="border border-neutral-300 px-4 py-3 text-left font-semibold">Observación</th>
            <th className="border border-neutral-300 px-4 py-3 text-center font-semibold">Acciones</th>
          </tr>
        </thead>
        <tbody>
          {criterios.length === 0 ? (
            <tr>
              <td colSpan="5" className="text-center py-8 text-neutral-500">
                No hay criterios para mostrar
              </td>
            </tr>
          ) : (
            criterios.map((criterio, index) => {
              const calificacion = obtenerCalificacionCriterio(criterio.id)
              const observacion = obtenerObservacionCriterio(criterio.id)
              const evaluacionId = obtenerIdEvaluacion(criterio.id)

              return (
                <tr key={criterio.id} className={index % 2 === 0 ? 'bg-white' : 'bg-neutral-50'}>
                  <td className="border border-neutral-300 px-4 py-3">
                    <div>
                      <p className="font-semibold text-neutral-900">{criterio.nombre || criterio.name}</p>
                      <p className="text-xs text-neutral-600">{criterio.descripcion || criterio.description}</p>
                    </div>
                  </td>
                  <td className="border border-neutral-300 px-4 py-3 text-center">
                    <span className="bg-primary-50 text-primary-brand px-3 py-1 rounded-full font-semibold text-sm">
                      {criterio.ponderacion || criterio.weighting || 0}%
                    </span>
                  </td>
                  <td className="border border-neutral-300 px-4 py-3 text-center">
                    {calificacion !== null ? (
                      <span className="text-lg font-bold text-neutral-900">{calificacion}</span>
                    ) : (
                      <span className="text-neutral-500">Sin calificar</span>
                    )}
                  </td>
                  <td className="border border-neutral-300 px-4 py-3">
                    {observacion ? (
                      <p className="text-sm text-neutral-700 italic">{observacion}</p>
                    ) : (
                      <p className="text-sm text-neutral-500">Sin observaciones</p>
                    )}
                  </td>
                  <td className="border border-neutral-300 px-4 py-3 text-center">
                    <button
                      onClick={() => onCalificar(criterio)}
                      className="bg-secondary-500 hover:bg-secondary-600 text-white px-3 py-1 rounded text-sm font-semibold transition"
                    >
                      {calificacion !== null ? 'Editar' : 'Calificar'}
                    </button>
                    {evaluacionId && (
                      <button
                        onClick={() => onEliminar(evaluacionId)}
                        className="bg-danger hover:bg-red-700 text-white px-3 py-1 rounded text-sm font-semibold transition ml-2"
                      >
                        Eliminar
                      </button>
                    )}
                  </td>
                </tr>
              )
            })
          )}
        </tbody>
      </table>
    </div>
  )
}
