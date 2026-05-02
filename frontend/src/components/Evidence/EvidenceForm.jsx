import React, { useState } from 'react'
import { subirArchivo } from '../../services/evidence'

export default function FormularioEvidencia({ onSubmit, evidencia = null, onCancel }) {
  const [formData, setFormData] = useState(evidencia || {
    archivo_url: '',
    estado: 'pendiente'
  })
  const [archivo, setArchivo] = useState(null)
  const [cargando, setCargando] = useState(false)

  const handleFileChange = (e) => {
    const file = e.target.files[0]
    if (file) {
      // Validar tamaño (máximo 10MB)
      if (file.size > 10 * 1024 * 1024) {
        alert('El archivo no puede exceder 10MB')
        return
      }
      
      // Validar formato
      const formatosPermitidos = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'image/jpeg', 'image/png', 'image/gif']
      if (!formatosPermitidos.includes(file.type)) {
        alert('Solo se permiten: PDF, DOC, DOCX, JPG, PNG, GIF')
        return
      }

      setArchivo(file)
      setFormData({
        ...formData,
        archivo_url: file.name
      })
    }
  }

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData({
      ...formData,
      [name]: value
    })
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    
    if (!archivo) {
      alert('Debes seleccionar un archivo')
      return
    }

    setCargando(true)
    try {
      // Paso 1: Subir archivo a Supabase Storage
      console.log('Subiendo archivo...')
      const resultadoSubida = await subirArchivo(archivo)
      const archivoUrl = resultadoSubida.archivo_url
      
      console.log('Archivo subido exitosamente:', archivoUrl)
      
      // Paso 2: Crear evidencia con la URL del archivo
      await onSubmit({
        ...formData,
        archivo_url: archivoUrl,
        fecha_envio: new Date().toISOString()
      })
      
      setArchivo(null)
      setFormData({
        archivo_url: '',
        estado: 'pendiente'
      })
    } catch (err) {
      console.error('Error:', err)
      alert('Error: ' + err.response?.data?.error || err.message)
    } finally {
      setCargando(false)
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-5">
      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          Seleccionar archivo
        </label>
        <div className="border-2 border-dashed border-primary-brand rounded-lg p-6 text-center hover:bg-primary-50 transition">
          <input
            type="file"
            onChange={handleFileChange}
            accept=".pdf,.doc,.docx,.jpg,.jpeg,.png,.gif"
            className="hidden"
            id="fileInput"
            disabled={cargando}
          />
          <label htmlFor="fileInput" className="cursor-pointer">
            <p className="text-primary-brand font-semibold">📎 Haz clic para seleccionar</p>
            <p className="text-xs text-neutral-600 mt-1">o arrastra un archivo aquí</p>
            <p className="text-xs text-neutral-500 mt-2">Máximo 10MB | Formatos: PDF, DOC, DOCX, JPG, PNG, GIF</p>
          </label>
        </div>
        {archivo && (
          <p className="mt-2 text-sm text-success font-semibold">✓ Archivo seleccionado: {archivo.name}</p>
        )}
      </div>

      <div>
        <label className="block text-sm font-semibold text-neutral-900 mb-2">
          Estado
        </label>
        <select
          name="estado"
          value={formData.estado}
          onChange={handleChange}
          disabled={cargando}
          className="w-full border border-neutral-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary-brand outline-none transition disabled:opacity-50"
        >
          <option value="pendiente">Pendiente de revisión</option>
          <option value="revisada">Revisada</option>
          <option value="aprobada">Aprobada</option>
          <option value="rechazada">Rechazada</option>
        </select>
      </div>

      <div className="flex gap-3 pt-4">
        <button
          type="submit"
          disabled={cargando}
          className="flex-1 bg-primary-brand hover:bg-primary-600 text-white py-2 rounded-lg font-semibold transition disabled:opacity-50"
        >
          {cargando ? 'Cargando...' : 'Enviar Evidencia'}
        </button>
        <button
          type="button"
          onClick={onCancel}
          disabled={cargando}
          className="flex-1 bg-neutral-300 hover:bg-neutral-400 text-neutral-900 py-2 rounded-lg font-semibold transition disabled:opacity-50"
        >
          Cancelar
        </button>
      </div>
    </form>
  )
}
