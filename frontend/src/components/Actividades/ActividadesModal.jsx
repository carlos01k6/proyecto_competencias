import React, { useState } from 'react'
import { useActividades } from '../../hooks/useActividades'
import ActividadCard from './ActividadCard'
import FormularioActividad from './FormularioActividad'

export default function ActividadesModal({ resultado, onClose }) {
  const { actividades, agregarActividad, actualizarActividad, eliminarActividad } = useActividades(resultado.id)
  const [mostrarFormulario, setMostrarFormulario] = useState(false)
  const [actividadEditando, setActividadEditando] = useState(null)

  const handleSubmit = async (formData) => {
    try {
      if (actividadEditando) {
        await actualizarActividad(actividadEditando.id, formData)
        setActividadEditando(null)
      } else {
        await agregarActividad(formData)
      }
      setMostrarFormulario(false)
    } catch (err) {
      alert('Error: ' + err.response?.data?.error || err.message)
    }
  }

  const handleEdit = (actividad) => {
    setActividadEditando(actividad)
    setMostrarFormulario(true)
  }

  const handleDelete = async (id) => {
    if (window.confirm('¿Estás seguro de que deseas eliminar esta actividad?')) {
      try {
        await eliminarActividad(id)
      } catch (err) {
        alert('Error: ' + err.response?.data?.error || err.message)
      }
    }
  }

  const handleCancel = () => {
    setMostrarFormulario(false)
    setActividadEditando(null)
  }

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-lg shadow-2xl p-8 w-full max-w-3xl max-h-[90vh] overflow-y-auto">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-2xl font-bold text-neutral-900">
            Actividades: {resultado.titulo}
          </h2>
          <button
            onClick={onClose}
            className="text-neutral-500 hover:text-neutral-700 text-2xl"
          >
            ✕
          </button>
        </div>

        {mostrarFormulario ? (
          <div className="bg-neutral-50 p-6 rounded-lg mb-6">
            <h3 className="text-lg font-bold text-neutral-900 mb-4">
              {actividadEditando ? 'Editar Actividad' : 'Nueva Actividad'}
            </h3>
            <FormularioActividad
              onSubmit={handleSubmit}
              actividad={actividadEditando}
              onCancel={handleCancel}
            />
          </div>
        ) : (
          <button
            onClick={() => setMostrarFormulario(true)}
            className="bg-primary-brand hover:bg-primary-600 text-white px-6 py-2 rounded-lg mb-6 font-semibold transition"
          >
            Nueva Actividad
          </button>
        )}

        {actividades.length === 0 ? (
          <div className="text-center text-neutral-500 py-8">
            <p className="text-lg">No hay actividades creadas</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
            {actividades.map((actividad) => (
              <ActividadCard
                key={actividad.id}
                actividad={actividad}
                onEdit={handleEdit}
                onDelete={handleDelete}
              />
            ))}
          </div>
        )}
      </div>
    </div>
  )
}
