import React, { useState } from 'react'

export default function FormularioResultado({ onSubmit, resultado = null, onCancel }) {
  const [formData, setFormData] = useState(resultado || {
    titulo: '',
    descripcion: ''
  })

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    })
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    if (!formData.titulo) {
      alert('El título es requerido')
      return
    }
    onSubmit(formData)
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-5">
      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          Título del Resultado
        </label>
        <input
          type="text"
          name="titulo"
          value={formData.titulo}
          onChange={handleChange}
          className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none transition"
          placeholder="Ej: Analizar casos de estudio"
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
          placeholder="Descripción del resultado de aprendizaje..."
        />
      </div>

      <div className="flex gap-3 pt-4">
        <button
          type="submit"
          className="flex-1 bg-primary-brand hover:bg-primary-600 text-white py-2 rounded-lg font-semibold transition"
        >
          {resultado ? 'Actualizar' : 'Crear'}
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
