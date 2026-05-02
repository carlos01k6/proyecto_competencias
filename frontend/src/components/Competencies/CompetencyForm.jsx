import React, { useState } from 'react'

export default function FormularioCompetencia({ onSubmit, competencia = null, onCancel }) {
  const [formData, setFormData] = useState(competencia || {
    nombre: '',
    descripcion: '',
    descriptor: '',
    asignatura: ''
  })

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    })
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    if (!formData.nombre || !formData.descriptor) {
      alert('Nombre y descriptor son requeridos')
      return
    }
    onSubmit(formData)
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-5">
      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          Nombre de la Competencia
        </label>
        <input
          type="text"
          name="nombre"
          value={formData.nombre}
          onChange={handleChange}
          className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none transition"
          placeholder="Ej: Pensamiento Crítico"
        />
      </div>

      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          Descripción
        </label>
        <textarea
          name="descripcion"
          value={formData.descripcion}
          onChange={handleChange}
          className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none h-20 transition"
          placeholder="Descripción de la competencia..."
        />
      </div>

      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          Descriptor (Requerido)
        </label>
        <input
          type="text"
          name="descriptor"
          value={formData.descriptor}
          onChange={handleChange}
          className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none transition"
          placeholder="Descriptor o estándar..."
        />
      </div>

      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          Asignatura
        </label>
        <input
          type="text"
          name="asignatura"
          value={formData.asignatura}
          onChange={handleChange}
          className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none transition"
          placeholder="Ej: Matemáticas"
        />
      </div>

      <div className="flex gap-3 pt-4">
        <button
          type="submit"
          className="flex-1 bg-primary-brand hover:bg-primary-600 text-white py-2 rounded-lg font-semibold transition"
        >
          {competencia ? 'Actualizar' : 'Crear'}
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
