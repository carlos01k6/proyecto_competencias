import React, { useState } from 'react'

const TEMPLATES_FEEDBACK = {
  bajo: {
    label: 'Refuerzo Necesario (0-40)',
    sugerencias: [
      'Requiere fortalecimiento en los conceptos fundamentales',
      'Se recomienda sesiones de apoyo individual',
      'Revisar materiales básicos de la competencia',
      'Participar en tutorías adicionales'
    ]
  },
  medio: {
    label: 'En Desarrollo (41-70)',
    sugerencias: [
      'Ha alcanzado los aprendizajes básicos',
      'Sigue trabajando para consolidar la competencia',
      'Incrementar la profundidad en temas clave',
      'Practicar con ejercicios más desafiantes'
    ]
  },
  alto: {
    label: 'Consolidado (71-90)',
    sugerencias: [
      'Ha demostrado dominio de la competencia',
      'Puede asumir tareas más complejas',
      'Considere mentoría de compañeros',
      'Profundize en temas avanzados'
    ]
  },
  excelente: {
    label: 'Excelencia (91-100)',
    sugerencias: [
      'Desempeño excepcional en la competencia',
      'Pueden servir como modelo para otros',
      'Explorar aplicaciones avanzadas',
      'Considere roles de liderazgo'
    ]
  }
}

function obtenerTipoFeedback(calificacion) {
  if (calificacion < 40) return 'bajo'
  if (calificacion < 71) return 'medio'
  if (calificacion < 91) return 'alto'
  return 'excelente'
}

export default function FormularioCalificacion({ criterio, evaluacionExistente = null, onSubmit, onCancel }) {
  const [formData, setFormData] = useState({
    calificacion: evaluacionExistente?.grade ?? evaluacionExistente?.calificacion ?? '',
    observacion: evaluacionExistente?.observation ?? evaluacionExistente?.observacion ?? ''
  })
  const [cargando, setCargando] = useState(false)
  const [feedbackSugerido, setFeedbackSugerido] = useState(null)

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData({
      ...formData,
      [name]: value
    })

    if (name === 'calificacion') {
      const calificacion = parseFloat(value)
      if (!isNaN(calificacion) && calificacion >= 0 && calificacion <= 100) {
        const tipo = obtenerTipoFeedback(calificacion)
        setFeedbackSugerido(TEMPLATES_FEEDBACK[tipo])
      }
    }
  }

  const insertarTemplate = (template) => {
    setFormData({
      ...formData,
      observacion: template
    })
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    
    const calificacion = parseFloat(formData.calificacion)
    if (isNaN(calificacion) || calificacion < 0 || calificacion > 100) {
      alert('La calificación debe ser un número entre 0 y 100')
      return
    }

    if (!formData.observacion || formData.observacion.trim() === '') {
      alert('La observación es obligatoria')
      return
    }

    setCargando(true)
    try {
      await onSubmit({
        ...formData,
        calificacion,
        fecha_evaluacion: new Date().toISOString()
      })
      setFormData({ calificacion: '', observacion: '' })
      setFeedbackSugerido(null)
    } catch (err) {
      alert('Error: ' + err.response?.data?.error || err.message)
    } finally {
      setCargando(false)
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-5">
      <div className="bg-primary-50 border border-primary-brand rounded-lg p-4 mb-5">
        <h3 className="font-bold text-neutral-900">{criterio.nombre || criterio.name}</h3>
        <p className="text-sm text-neutral-700 mt-1">{criterio.descripcion || criterio.description}</p>
        <div className="mt-3 flex justify-between items-center">
          <span className="text-sm font-semibold text-neutral-700">Ponderación:</span>
          <span className="bg-primary-brand text-white px-3 py-1 rounded font-bold">{criterio.ponderacion || criterio.weighting || 0}%</span>
        </div>
      </div>

      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          Calificación (0-100) *
        </label>
        <input
          type="number"
          name="calificacion"
          value={formData.calificacion}
          onChange={handleChange}
          min="0"
          max="100"
          step="0.5"
          placeholder="Ej: 85.5"
          disabled={cargando}
          className="w-full border border-neutral-300 rounded-lg px-4 py-3 focus:ring-2 focus:ring-primary-brand outline-none transition disabled:opacity-50"
        />
        <p className="text-xs text-neutral-600 mt-2">Ingresa un valor decimal si es necesario</p>
      </div>

      {feedbackSugerido && (
        <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
          <p className="text-sm font-semibold text-blue-900 mb-3">{feedbackSugerido.label}</p>
          <div className="space-y-2">
            <p className="text-xs text-neutral-700 font-semibold">Sugerencias de feedback:</p>
            {feedbackSugerido.sugerencias.map((sugerencia, idx) => (
              <button
                key={idx}
                type="button"
                onClick={() => insertarTemplate(sugerencia)}
                className="w-full text-left text-xs bg-white hover:bg-blue-100 border border-blue-200 rounded p-2 transition"
              >
                Insertar: {sugerencia}
              </button>
            ))}
          </div>
        </div>
      )}

      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          Observación / Feedback * (Obligatorio)
        </label>
        <textarea
          name="observacion"
          value={formData.observacion}
          onChange={handleChange}
          placeholder="Escribe feedback específico sobre el desempeño del estudiante..."
          disabled={cargando}
          rows="5"
          className="w-full border border-neutral-300 rounded-lg px-4 py-3 focus:ring-2 focus:ring-primary-brand outline-none transition disabled:opacity-50"
        />
        <p className="text-xs text-neutral-600 mt-2">
          Caracteres: {formData.observacion.length} (requerido)
        </p>
      </div>

      <div className="bg-neutral-100 p-4 rounded-lg">
        <p className="text-sm text-neutral-700">
          <span className="font-semibold">Nota:</span> Las observaciones son esenciales para feedback constructivo
        </p>
      </div>

      <div className="flex gap-3 pt-4">
        <button
          type="submit"
          disabled={cargando}
          className="flex-1 bg-primary-brand hover:bg-primary-600 text-white py-3 rounded-lg font-semibold transition disabled:opacity-50"
        >
          {cargando ? 'Guardando...' : 'Guardar Calificación'}
        </button>
        <button
          type="button"
          onClick={onCancel}
          disabled={cargando}
          className="flex-1 bg-neutral-300 hover:bg-neutral-400 text-neutral-900 py-3 rounded-lg font-semibold transition disabled:opacity-50"
        >
          Cancelar
        </button>
      </div>
    </form>
  )
}
