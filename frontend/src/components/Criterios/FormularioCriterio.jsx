import React, { useState } from 'react'

export default function FormularioCriterio({ onSubmit, criterio = null, onCancel }) {
  const [formData, setFormData] = useState(criterio || {
    nombre: '',
    descripcion: '',
    ponderacion: 100,
    requiere_observacion: false
  })

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target
    setFormData({
      ...formData,
      [name]: type === 'checkbox' ? checked : value
    })
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    if (!formData.nombre) {
      alert('El nombre es requerido')
      return
    }
    if (formData.ponderacion < 0 || formData.ponderacion > 100) {
      alert('La ponderación debe estar entre 0 y 100')
      return
    }
    onSubmit(formData)
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-5">
      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          Nombre del Criterio
        </label>
        <input
          type="text"
          name="nombre"
          value={formData.nombre}
          onChange={handleChange}
          className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none transition"
          placeholder="Ej: Precisión en la respuesta"
        />
      </div>

      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          Descripción (Opcional)
        </label>
        <textarea
          name="descripcion"
          value={formData.descripcion}
          onChange={handleChange}
          className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none h-20 transition"
          placeholder="Describe el criterio de evaluación..."
        />
      </div>

      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          Ponderación (%)
        </label>
        <input
          type="number"
          name="ponderacion"
          value={formData.ponderacion}
          onChange={handleChange}
          min="0"
          max="100"
          className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none transition"
          placeholder="100"
        />
      </div>

      <div className="flex items-center">
        <input
          type="checkbox"
          name="requiere_observacion"
          checked={formData.requiere_observacion}
          onChange={handleChange}
          className="w-4 h-4 text-primary-brand rounded"
        />
        <label className="ml-3 text-sm font-semibold text-neutral-900">
          Requiere observación o comentario
        </label>
      </div>

      <div className="flex gap-3 pt-4">
        <button
          type="submit"
          className="flex-1 bg-primary-brand hover:bg-primary-600 text-white py-2 rounded-lg font-semibold transition"
        >
          {criterio ? 'Actualizar' : 'Crear'}
        </button>
        <button
          type="button"
          onClick={onCancel}
          className="flex-1 bg-neutral-300 hover:bg-neutral-400 text-neutral-900 py-2 rounded-lg font-semibold transition"
        >
          Cancelar
        </button>
      </div>
    </form>
  )
}
