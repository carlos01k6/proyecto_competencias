import React, { useState } from 'react'
import { useResultados } from '../../hooks/useOutcomes'

export default function FormularioReporte({ onSubmit, onCancel }) {
  const { resultados } = useResultados()
  const [formData, setFormData] = useState({
    resultado_id: '',
    estudiante_id: '',
    nombre_estudiante: '',
    nombre_resultado: ''
  })
  const [cargando, setCargando] = useState(false)

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData({
      ...formData,
      [name]: value
    })
  }

  const handleSeleccionarResultado = (e) => {
    const resultado_id = e.target.value
    const resultado = resultados.find(r => r.id === resultado_id)
    
    setFormData({
      ...formData,
      resultado_id,
      nombre_resultado: resultado?.titulo || ''
    })
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    
    if (!formData.resultado_id || !formData.estudiante_id || !formData.nombre_estudiante) {
      alert('Completa todos los campos')
      return
    }

    setCargando(true)
    try {
      await onSubmit(formData)
      setFormData({
        resultado_id: '',
        estudiante_id: '',
        nombre_estudiante: '',
        nombre_resultado: ''
      })
    } catch (err) {
      alert('Error: ' + err.response?.data?.error || err.message)
    } finally {
      setCargando(false)
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-5">
      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          Seleccionar Resultado
        </label>
        <select
          name="resultado_id"
          value={formData.resultado_id}
          onChange={handleSeleccionarResultado}
          disabled={cargando}
          className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none disabled:opacity-50"
        >
          <option value="">-- Seleccionar --</option>
          {resultados.map(resultado => (
            <option key={resultado.id} value={resultado.id}>
              {resultado.titulo}
            </option>
          ))}
        </select>
      </div>

      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          ID del Estudiante
        </label>
        <input
          type="text"
          name="estudiante_id"
          value={formData.estudiante_id}
          onChange={handleChange}
          placeholder="Ej: student-123"
          disabled={cargando}
          className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none disabled:opacity-50"
        />
      </div>

      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          Nombre del Estudiante
        </label>
        <input
          type="text"
          name="nombre_estudiante"
          value={formData.nombre_estudiante}
          onChange={handleChange}
          placeholder="Ej: Juan Pérez"
          disabled={cargando}
          className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none disabled:opacity-50"
        />
      </div>

      <div className="bg-primary-50 border border-primary-brand rounded-lg p-4">
        <p className="text-sm text-neutral-700">
          <span className="font-semibold">Nota:</span> Se generará un PDF con todas las calificaciones de los criterios y el promedio ponderado.
        </p>
      </div>

      <div className="flex gap-3 pt-4">
        <button
          type="submit"
          disabled={cargando}
          className="flex-1 bg-primary-brand hover:bg-primary-600 text-white py-3 rounded-lg font-semibold transition disabled:opacity-50"
        >
          {cargando ? 'Generando...' : 'Generar Reporte PDF'}
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
