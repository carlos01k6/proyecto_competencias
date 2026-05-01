import React, { useState } from "react"
import { useConfig } from "../hooks/useConfig"
import { Settings, Save } from "lucide-react"

export default function ConfigPage({ usuario }) {
  const { configuraciones, actualizarConfiguracion } = useConfig()
  const [editando, setEditando] = useState(null)
  const [nuevoValor, setNuevoValor] = useState("")
  const [cargando, setCargando] = useState(false)
  const [mensaje, setMensaje] = useState("")

  const es_admin = usuario?.rol?.toLowerCase() === "admin"

  const handleEditar = (clave, valor) => {
    if (!es_admin) {
      alert("Solo administradores pueden editar la configuración")
      return
    }
    setEditando(clave)
    setNuevoValor(valor)
  }

  const handleGuardar = async (clave) => {
    if (!nuevoValor) {
      alert("El valor no puede estar vacío")
      return
    }

    setCargando(true)
    try {
      await actualizarConfiguracion(clave, nuevoValor)
      setMensaje("✅ Configuración actualizada exitosamente")
      setEditando(null)
      setTimeout(() => setMensaje(""), 3000)
    } catch (err) {
      setMensaje("❌ Error al actualizar: " + err.message)
    } finally {
      setCargando(false)
    }
  }

  const handleCancelar = () => {
    setEditando(null)
    setNuevoValor("")
  }

  const obtenerIcono = (tipo) => {
    const iconos = {
      text: "📝",
      number: "🔢",
      boolean: "✓"
    }
    return iconos[tipo] || "⚙️"
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-4">
          <div className="p-3 bg-gradient-to-br from-slate-600 to-slate-700 rounded-lg">
            <Settings className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Configuración del Sistema</h1>
            <p className="text-neutral-400">
              {es_admin ? "Gestiona la configuración de la plataforma" : "Solo administradores pueden modificar la configuración"}
            </p>
          </div>
        </div>
      </div>

      {/* Mensajes */}
      {mensaje && (
        <div className={`mb-6 p-4 rounded-lg border ${
          mensaje.startsWith("✅") 
            ? "bg-success/10 border-success/30 text-success" 
            : "bg-danger/10 border-danger/30 text-danger"
        }`}>
          {mensaje}
        </div>
      )}

      {/* Advertencia para no-admin */}
      {!es_admin && (
        <div className="bg-warning/10 border-l-4 border-warning rounded-lg p-4 mb-8">
          <p className="text-sm text-neutral-300">
            <span className="font-semibold text-warning">Aviso:</span> No tienes permisos para editar la configuración. Solo administradores pueden hacer cambios.
          </p>
        </div>
      )}

      {/* Grid de configuraciones */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {Object.entries(configuraciones).map(([clave, config]) => (
          <div key={clave} className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 hover:border-neutral-700 transition">
            <div className="flex items-start justify-between mb-4">
              <div>
                <h3 className="text-lg font-bold text-white flex items-center gap-2">
                  {obtenerIcono(config.tipo)} {config.descripcion || clave}
                </h3>
                <p className="text-xs text-neutral-500 font-mono mt-1">{clave}</p>
              </div>
            </div>

            {editando === clave ? (
              <div className="space-y-3">
                <div>
                  {config.tipo === "boolean" ? (
                    <select
                      value={nuevoValor}
                      onChange={(e) => setNuevoValor(e.target.value)}
                      className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
                    >
                      <option value="true">Sí (true)</option>
                      <option value="false">No (false)</option>
                    </select>
                  ) : (
                    <input
                      type={config.tipo === "number" ? "number" : "text"}
                      value={nuevoValor}
                      onChange={(e) => setNuevoValor(e.target.value)}
                      className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
                    />
                  )}
                </div>
                <div className="flex gap-2">
                  <button
                    onClick={() => handleGuardar(clave)}
                    disabled={cargando}
                    className="flex-1 bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white py-2 rounded-lg font-semibold transition disabled:opacity-50 flex items-center justify-center gap-2"
                  >
                    <Save className="w-4 h-4" />
                    {cargando ? "Guardando..." : "Guardar"}
                  </button>
                  <button
                    onClick={handleCancelar}
                    disabled={cargando}
                    className="flex-1 bg-neutral-700 hover:bg-neutral-600 text-white py-2 rounded-lg font-semibold transition disabled:opacity-50"
                  >
                    Cancelar
                  </button>
                </div>
              </div>
            ) : (
              <div>
                <div className="bg-neutral-900/50 border border-neutral-700/50 p-4 rounded-lg mb-4">
                  <p className="text-xs text-neutral-500 mb-2">Valor actual:</p>
                  <p className="text-lg font-bold text-white font-mono">{config.valor}</p>
                </div>
                {es_admin && (
                  <button
                    onClick={() => handleEditar(clave, config.valor)}
                    className="w-full bg-gradient-to-r from-secondary-500 to-secondary-600 hover:from-secondary-600 hover:to-secondary-700 text-white py-2 rounded-lg font-semibold transition"
                  >
                    ✏️ Editar
                  </button>
                )}
              </div>
            )}
          </div>
        ))}
      </div>

      {/* Estado vacío */}
      {Object.keys(configuraciones).length === 0 && (
        <div className="text-center py-12 bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl">
          <p className="text-neutral-500">Cargando configuraciones...</p>
        </div>
      )}
    </div>
  )
}
