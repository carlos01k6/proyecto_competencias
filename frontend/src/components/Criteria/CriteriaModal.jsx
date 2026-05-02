import React, { useState } from 'react'
import { useCriterios } from '../../hooks/useCriteria'
import CriterioCard from './CriterionCard'
import FormularioCriterio from './CriterionForm'

export default function CriteriosModal({ resultado, onClose }) {
  const { criterios, agregarCriterio, actualizarCriterio, eliminarCriterio } = useCriterios(resultado.id)
  const [mostrarFormulario, setMostrarFormulario] = useState(false)
  const [criterioEditando, setCriterioEditando] = useState(null)

  const handleSubmit = async (formData) => {
    try {
      if (criterioEditando) {
        await actualizarCriterio(criterioEditando.id, formData)
        setCriterioEditando(null)
      } else {
        await agregarCriterio({
          resultado_id: resultado.id,
          ...formData
        })
      }
      setMostrarFormulario(false)
    } catch (err) {
      alert('Error: ' + err.response?.data?.mensaje)
    }
  }

  const handleEdit = (criterio) => {
    setCriterioEditando(criterio)
    setMostrarFormulario(true)
  }

  const handleDelete = async (id) => {
    if (window.confirm('¿Estás seguro?')) {
      try {
        await eliminarCriterio(id)
      } catch (err) {
        alert('Error: ' + err.response?.data?.mensaje)
      }
    }
  }

  const handleCancel = () => {
    setMostrarFormulario(false)
    setCriterioEditando(null)
  }

  const totalPonderacion = criterios.reduce((sum, c) => sum + parseFloat(c.ponderacion || 0), 0)

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-lg shadow-2xl p-8 w-full max-w-2xl max-h-[90vh] overflow-y-auto">
        <div className="flex justify-between items-center mb-6">
          <div>
            <h2 className="text-2xl font-bold text-neutral-900">
              Criterios: {resultado.titulo}
            </h2>
            <p className="text-sm text-neutral-600 mt-1">
              Ponderación total: <span className={totalPonderacion === 100 ? 'text-success font-bold' : 'text-danger font-bold'}>
                {totalPonderacion}%
              </span>
            </p>
          </div>
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
              {criterioEditando ? 'Editar Criterio' : 'Nuevo Criterio'}
            </h3>
            <FormularioCriterio
              onSubmit={handleSubmit}
              criterio={criterioEditando}
              onCancel={handleCancel}
            />
          </div>
        ) : (
          <button
            onClick={() => setMostrarFormulario(true)}
            className="bg-primary-brand hover:bg-primary-600 text-white px-6 py-2 rounded-lg mb-6 font-semibold transition"
          >
            Nuevo Criterio
          </button>
        )}

        {criterios.length === 0 ? (
          <div className="text-center text-neutral-500 py-8">
            <p className="text-lg">No hay criterios definidos</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 gap-4">
            {criterios.map((criterio) => (
              <CriterioCard
                key={criterio.id}
                criterio={criterio}
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
