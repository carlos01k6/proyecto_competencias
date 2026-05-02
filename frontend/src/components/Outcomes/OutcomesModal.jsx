import React, { useState } from 'react'
import { useResultados } from '../../hooks/useOutcomes'
import ResultadoCard from './OutcomeCard'
import FormularioResultado from './OutcomeForm'

export default function ResultadosModal({ competencia, onClose }) {
  const { resultados, agregarResultado, actualizarResultado, eliminarResultado } = useResultados(competencia.id)
  const [mostrarFormulario, setMostrarFormulario] = useState(false)
  const [resultadoEditando, setResultadoEditando] = useState(null)

  const handleSubmit = async (formData) => {
    try {
      if (resultadoEditando) {
        await actualizarResultado(resultadoEditando.id, formData)
        setResultadoEditando(null)
      } else {
        await agregarResultado({
          competencia_id: competencia.id,
          ...formData
        })
      }
      setMostrarFormulario(false)
    } catch (err) {
      alert('Error: ' + err.response?.data?.mensaje)
    }
  }

  const handleEdit = (resultado) => {
    setResultadoEditando(resultado)
    setMostrarFormulario(true)
  }

  const handleDelete = async (id) => {
    if (window.confirm('¿Estás seguro?')) {
      try {
        await eliminarResultado(id)
      } catch (err) {
        alert('Error: ' + err.response?.data?.mensaje)
      }
    }
  }

  const handleCancel = () => {
    setMostrarFormulario(false)
    setResultadoEditando(null)
  }

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-lg shadow-2xl p-8 w-full max-w-2xl max-h-[90vh] overflow-y-auto">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-2xl font-bold text-neutral-900">
            Resultados de Aprendizaje: {competencia.nombre}
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
              {resultadoEditando ? 'Editar Resultado' : 'Nuevo Resultado'}
            </h3>
            <FormularioResultado
              onSubmit={handleSubmit}
              resultado={resultadoEditando}
              onCancel={handleCancel}
            />
          </div>
        ) : (
          <button
            onClick={() => setMostrarFormulario(true)}
            className="bg-primary-brand hover:bg-primary-600 text-white px-6 py-2 rounded-lg mb-6 font-semibold transition"
          >
            Nuevo Resultado
          </button>
        )}

        {resultados.length === 0 ? (
          <div className="text-center text-neutral-500 py-8">
            <p className="text-lg">No hay resultados de aprendizaje</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 gap-4">
            {resultados.map((resultado) => (
              <ResultadoCard
                key={resultado.id}
                resultado={resultado}
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
