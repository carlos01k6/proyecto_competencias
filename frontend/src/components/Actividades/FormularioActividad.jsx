import React, { useState } from 'react'

export default function FormularioActividad({ onSubmit, actividad = null, onCancel }) {
  const [formData, setFormData] = useState(actividad || {
    nombre: '',
    descripcion: '',
    fecha_inicio: '',
    fecha_cierre: '',
    tipo: 'tarea',
    puntaje_maximo: 100,
    estado: 'activa'
  })

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData({
      ...formData,
      [name]: name === 'puntaje_maximo' ? parseFloat(value) : value
    })
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    
    if (!formData.nombre || !formData.fecha_inicio || !formData.fecha_cierre) {
      alert('Nombre y fechas son requeridas')
      return
    }

    if (new Date(formData.fecha_inicio) >= new Date(formData.fecha_cierre)) {
      alert('La fecha de cierre debe ser posterior a la fecha de inicio')
      return
    }

    onSubmit(formData)
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-5">
      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          Nombre de la Actividad
        </label>
        <input
          type="text"
          name="nombre"
          value={formData.nombre}
          onChange={handleChange}
          className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none transition"
          placeholder="Ej: Tarea de análisis"
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
          placeholder="Descripción de la actividad..."
        />
      </div>

      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="block text-sm font-semibold text-neutral-900 mb-2">
            Fecha de Inicio
          </label>
          <input
            type="date"
            name="fecha_inicio"
            value={formData.fecha_inicio}
            onChange={handleChange}
            className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none transition"
          />
        </div>
        <div>
          <label className="block text-sm font-semibold text-neutral-900 mb-2">
            Fecha de Cierre
          </label>
          <input
            type="date"
            name="fecha_cierre"
            value={formData.fecha_cierre}
            onChange={handleChange}
            className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none transition"
          />
        </div>
      </div>

      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="block text-sm font-semibold text-neutral-900 mb-2">
            Tipo de Actividad
          </label>
          <select
            name="tipo"
            value={formData.tipo}
            onChange={handleChange}
            className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none transition"
          >
            <option value="tarea">Tarea</option>
            <option value="proyecto">Proyecto</option>
            <option value="examen">Examen</option>
            <option value="trabajo">Trabajo en grupo</option>
          </select>
        </div>
        <div>
          <label className="block text-sm font-semibold text-neutral-900 mb-2">
            Puntaje Máximo
          </label>
          <input
            type="number"
            name="puntaje_maximo"
            value={formData.puntaje_maximo}
            onChange={handleChange}
            min="1"
            max="500"
            className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none transition"
          />
        </div>
      </div>

      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          Estado
        </label>
        <select
          name="estado"
          value={formData.estado}
          onChange={handleChange}
          className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none transition"
        >
          <option value="activa">Activa</option>
          <option value="cerrada">Cerrada</option>
          <option value="cancelada">Cancelada</option>
        </select>
      </div>

      <div className="flex gap-3 pt-4">
        <button
          type="submit"
          className="flex-1 bg-primary-brand hover:bg-primary-600 text-white py-2 rounded-lg font-semibold transition"
        >
          {actividad ? 'Actualizar' : 'Crear'}
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
