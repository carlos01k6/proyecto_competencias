import React, { useState } from 'react'
import { useEvidencias } from '../../hooks/useEvidencias'
import EvidenciaCard from './EvidenciaCard'
import FormularioEvidencia from './FormularioEvidencia'

export default function EvidenciasModal({ actividad, onClose }) {
  const { evidencias, agregarEvidencia, actualizarEvidencia, eliminarEvidencia } = useEvidencias(actividad.id)
  const [mostrarFormulario, setMostrarFormulario] = useState(false)
  const [evidenciaEditando, setEvidenciaEditando] = useState(null)

  const handleSubmit = async (formData) => {
    try {
      // Obtener usuario autenticado
      const usuarioJSON = localStorage.getItem('usuario')
      const usuario = usuarioJSON ? JSON.parse(usuarioJSON) : null
      const estudianteId = usuario?.id || 'estudiante-temp'

      if (evidenciaEditando) {
        await actualizarEvidencia(evidenciaEditando.id, formData)
        setEvidenciaEditando(null)
      } else {
        // Agregar actividad_id y estudiante_id
        await agregarEvidencia({
          ...formData,
          actividad_id: actividad.id,
          estudiante_id: estudianteId
        })
      }
      setMostrarFormulario(false)
    } catch (err) {
      alert('Error: ' + err.response?.data?.error || err.message)
    }
  }

  const handleEdit = (evidencia) => {
    setEvidenciaEditando(evidencia)
    setMostrarFormulario(true)
  }

  const handleDelete = async (id) => {
    if (window.confirm('¿Estás seguro de que deseas eliminar esta evidencia?')) {
      try {
        await eliminarEvidencia(id)
      } catch (err) {
        alert('Error: ' + err.response?.data?.error || err.message)
      }
    }
  }

  const handleDownload = (evidencia) => {
    const link = document.createElement('a')
    link.href = evidencia.archivo_url
    link.download = evidencia.archivo_url.split('/').pop()
    link.click()
  }

  const handleCancel = () => {
    setMostrarFormulario(false)
    setEvidenciaEditando(null)
  }

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-lg shadow-2xl p-8 w-full max-w-3xl max-h-[90vh] overflow-y-auto">
        <div className="flex justify-between items-center mb-6">
          <div>
            <h2 className="text-2xl font-bold text-neutral-900">
              Evidencias
            </h2>
            <p className="text-sm text-neutral-600 mt-1">
              Actividad: {actividad.nombre}
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
              {evidenciaEditando ? 'Editar Evidencia' : 'Enviar Nueva Evidencia'}
            </h3>
            <FormularioEvidencia
              onSubmit={handleSubmit}
              evidencia={evidenciaEditando}
              onCancel={handleCancel}
            />
          </div>
        ) : (
          <button
            onClick={() => setMostrarFormulario(true)}
            className="bg-primary-brand hover:bg-primary-600 text-white px-6 py-2 rounded-lg mb-6 font-semibold transition"
          >
            Enviar Evidencia
          </button>
        )}

        {evidencias.length === 0 ? (
          <div className="text-center text-neutral-500 py-8">
            <p className="text-lg">No hay evidencias registradas</p>
            <p className="text-sm mt-2">Envía una evidencia haciendo clic en el botón superior</p>
          </div>
        ) : (
          <div>
            <h3 className="text-lg font-bold text-neutral-900 mb-4">
              {evidencias.length} {evidencias.length === 1 ? 'evidencia' : 'evidencias'} registradas
            </h3>
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
              {evidencias.map((evidencia) => (
                <EvidenciaCard
                  key={evidencia.id}
                  evidencia={evidencia}
                  onEdit={handleEdit}
                  onDelete={handleDelete}
                  onDownload={handleDownload}
                />
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
