import React, { useState } from 'react'

export default function FormularioCompetencia({ onSubmit, competencia = null, onCancel }) {
  const [formData, setFormData] = useState(competencia || {
    nombre: '',
    asignatura: '',
    descriptor: '',
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
    if (!formData.nombre || !formData.descriptor) {
      alert('Nombre y descriptor son requeridos')
      return
    }
    onSubmit(formData)
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-2">
          Nombre de Competencia
        </label>
        <input
          type="text"
          name="nombre"
          value={formData.nombre}
          onChange={handleChange}
          className="w-full border rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 outline-none"
          placeholder="Ej: An?lisis Cr?tico"
        />
      </div>

      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-2">
          Asignatura
        </label>
        <input
          type="text"
          name="asignatura"
          value={formData.asignatura}
          onChange={handleChange}
          className="w-full border rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 outline-none"
          placeholder="Ej: Matem?ticas"
        />
      </div>

      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-2">
          Descriptor (?C?mo se demuestra?)
        </label>
        <textarea
          name="descriptor"
          value={formData.descriptor}
          onChange={handleChange}
          className="w-full border rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 outline-none h-24"
          placeholder="Describe c?mo se observa esta competencia..."
        />
      </div>

      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-2">
          Descripci?n (Opcional)
        </label>
        <textarea
          name="descripcion"
          value={formData.descripcion}
          onChange={handleChange}
          className="w-full border rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 outline-none h-20"
          placeholder="Descripci?n adicional..."
        />
      </div>

      <div className="flex gap-3 pt-4">
        <button
          type="submit"
          className="flex-1 bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700"
        >
          {competencia ? 'Actualizar' : 'Crear'}
        </button>
        <button
          type="button"
          onClick={onCancel}
          className="flex-1 bg-gray-300 text-gray-700 py-2 rounded-lg hover:bg-gray-400"
        >
          Cancelar
        </button>
      </div>
    </form>
  )
}
