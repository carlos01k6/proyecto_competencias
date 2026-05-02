import React, { useState } from 'react'
import { Settings, Save, AlertCircle } from 'lucide-react'

export default function ConfiguracionPage({ usuario }) {
  const [config, setConfig] = useState({
    institucion: 'Instituto Politécnico Parroquial Santa Ana',
    año: '2026',
    notificaciones: true,
    privacidad: true
  })
  const [saved, setSaved] = useState(false)

  const handleChange = (field, value) => {
    setConfig({...config, [field]: value})
    setSaved(false)
  }

  const handleSave = () => {
    setSaved(true)
    setTimeout(() => setSaved(false), 3000)
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-4">
          <div className="p-3 bg-gradient-to-br from-slate-600 to-slate-700 rounded-lg">
            <Settings className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Configuración</h1>
            <p className="text-neutral-400">Personaliza el sistema</p>
          </div>
        </div>
      </div>

      {saved && (
        <div className="mb-6 p-4 bg-success/10 border border-success/30 rounded-lg flex gap-2">
          <AlertCircle className="w-5 h-5 text-success flex-shrink-0" />
          <p className="text-success text-sm">Cambios guardados exitosamente</p>
        </div>
      )}

      <div className="max-w-2xl space-y-6">
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
          <h2 className="text-xl font-bold text-white mb-6">Información General</h2>
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-semibold text-white mb-2">Nombre Institución</label>
              <input
                type="text"
                value={config.institucion}
                onChange={(e) => handleChange('institucion', e.target.value)}
                className="w-full px-4 py-3 bg-neutral-800/50 border border-neutral-700 rounded-lg text-white focus:outline-none focus:border-primary-brand transition"
              />
            </div>
            <div>
              <label className="block text-sm font-semibold text-white mb-2">Año Académico</label>
              <input
                type="text"
                value={config.año}
                onChange={(e) => handleChange('año', e.target.value)}
                className="w-full px-4 py-3 bg-neutral-800/50 border border-neutral-700 rounded-lg text-white focus:outline-none focus:border-primary-brand transition"
              />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
          <h2 className="text-xl font-bold text-white mb-6">Privacidad y Notificaciones</h2>
          <div className="space-y-4">
            <label className="flex items-center gap-3 cursor-pointer">
              <input
                type="checkbox"
                checked={config.notificaciones}
                onChange={(e) => handleChange('notificaciones', e.target.checked)}
                className="w-4 h-4 rounded bg-neutral-800 border-neutral-700"
              />
              <span className="text-white">Recibir notificaciones por email</span>
            </label>
            <label className="flex items-center gap-3 cursor-pointer">
              <input
                type="checkbox"
                checked={config.privacidad}
                onChange={(e) => handleChange('privacidad', e.target.checked)}
                className="w-4 h-4 rounded bg-neutral-800 border-neutral-700"
              />
              <span className="text-white">Perfil privado</span>
            </label>
          </div>
        </div>

        <button
          onClick={handleSave}
          className="w-full flex items-center justify-center gap-2 px-4 py-3 bg-gradient-to-r from-primary-brand to-primary-600 text-white rounded-lg font-semibold shadow-lg shadow-primary-brand/20 transition"
        >
          <Save className="w-5 h-5" />
          Guardar Cambios
        </button>
      </div>
    </div>
  )
}