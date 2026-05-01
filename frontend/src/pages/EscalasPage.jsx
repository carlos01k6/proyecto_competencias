import React, { useState, useEffect } from "react"
import { useEscalaActual, useActualizarEscala, useConvertirCalificacion } from "../hooks/useEscalas"
import { Ruler } from "lucide-react"

export default function EscalasPage({ usuario }) {
  const { escala, obtenerEscala } = useEscalaActual()
  const { actualizar, cargando, exito, error } = useActualizarEscala()
  const [nuevaEscala, setNuevaEscala] = useState("")
  const [ejemploCalificacion, setEjemploCalificacion] = useState(85)
  const { convertida } = useConvertirCalificacion(ejemploCalificacion)

  useEffect(() => {
    setNuevaEscala(escala)
  }, [escala])

  const handleCambiarEscala = async () => {
    await actualizar(nuevaEscala)
    setTimeout(() => obtenerEscala(), 500)
  }

  const esAdmin = usuario?.rol?.toLowerCase() === "admin"

  const descripcionesEscalas = {
    "0-100": {
      nombre: "Escala Numérica (0-100)",
      descripcion: "Calificaciones de 0 a 100 puntos. Sistema más común.",
      ejemplo: "85/100"
    },
    "0-4": {
      nombre: "Escala GPA (0-4)",
      descripcion: "Calificaciones de 0 a 4 puntos. Usado en universidades.",
      ejemplo: "3.4/4"
    },
    "A-F": {
      nombre: "Escala de Letras (A-F)",
      descripcion: "Calificaciones en letras: A (Excelente), B (Bueno), C (Regular), D (Deficiente), F (Insuficiente).",
      ejemplo: "A (Excelente)"
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-4">
          <div className="p-3 bg-gradient-to-br from-teal-600 to-teal-700 rounded-lg">
            <Ruler className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Escalas de Calificación</h1>
            <p className="text-neutral-400">Configura el sistema de calificación de la institución</p>
          </div>
        </div>
      </div>

      {!esAdmin && (
        <div className="bg-warning/10 border border-warning/30 rounded-lg p-4 mb-6">
          <p className="text-warning font-semibold">Solo administradores pueden cambiar la escala</p>
        </div>
      )}

      {/* Escala Actual */}
      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8 mb-6">
        <h2 className="text-xl font-bold text-white mb-4">Escala Actual del Sistema</h2>
        <div className="bg-primary-brand/10 border border-primary-brand/30 rounded-lg p-8">
          <p className="text-sm text-neutral-400 mb-2">Escala activa:</p>
          <p className="text-3xl font-bold text-primary-brand mb-2">{descripcionesEscalas[escala].nombre}</p>
          <p className="text-neutral-300">{descripcionesEscalas[escala].descripcion}</p>
        </div>
      </div>

      {/* Cambiar Escala */}
      {esAdmin && (
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8 mb-6">
          <h2 className="text-xl font-bold text-white mb-4">Cambiar Escala</h2>

          <div className="space-y-4">
            <div>
              <label className="block text-sm font-semibold text-white mb-3">
                Selecciona nueva escala
              </label>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                {Object.entries(descripcionesEscalas).map(([key, desc]) => (
                  <button
                    key={key}
                    onClick={() => setNuevaEscala(key)}
                    className={`p-4 rounded-lg border-2 transition text-left ${
                      nuevaEscala === key
                        ? "border-primary-brand bg-primary-brand/10"
                        : "border-neutral-700 hover:border-primary-brand"
                    }`}
                  >
                    <p className="font-semibold text-white">{desc.nombre}</p>
                    <p className="text-sm text-neutral-400 mt-2">{desc.descripcion}</p>
                  </button>
                ))}
              </div>
            </div>

            {exito && (
              <div className="bg-success/10 border border-success/30 rounded-lg p-4">
                <p className="text-success font-semibold">✓ Escala actualizada correctamente</p>
              </div>
            )}

            {error && (
              <div className="bg-danger/10 border border-danger/30 rounded-lg p-4">
                <p className="text-danger font-semibold">✗ Error: {error}</p>
              </div>
            )}

            <button
              onClick={handleCambiarEscala}
              disabled={cargando || nuevaEscala === escala}
              className="w-full bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 disabled:opacity-50 text-white py-3 rounded-lg font-semibold transition"
            >
              {cargando ? "Actualizando..." : "Actualizar Escala"}
            </button>
          </div>
        </div>
      )}

      {/* Ejemplos de Conversión */}
      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8">
        <h2 className="text-xl font-bold text-white mb-4">Ejemplos de Conversión</h2>

        <div className="mb-6">
          <label className="block text-sm font-semibold text-white mb-3">
            Calificación de ejemplo (0-100)
          </label>
          <input
            type="number"
            value={ejemploCalificacion}
            onChange={(e) => setEjemploCalificacion(parseFloat(e.target.value))}
            min="0"
            max="100"
            step="1"
            className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
          />
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {Object.entries(descripcionesEscalas).map(([key, desc]) => (
            <div key={key} className="bg-neutral-900/50 rounded-lg p-4 border border-neutral-700/50">
              <p className="text-sm font-semibold text-neutral-400 mb-2">{desc.nombre}</p>
              <p className="text-2xl font-bold text-white">
                {key === "0-100" && `${ejemploCalificacion}`}
                {key === "0-4" && `${(ejemploCalificacion / 100 * 4).toFixed(2)}`}
                {key === "A-F" && (
                  ejemploCalificacion >= 90 ? "A" :
                  ejemploCalificacion >= 80 ? "B" :
                  ejemploCalificacion >= 70 ? "C" :
                  ejemploCalificacion >= 60 ? "D" : "F"
                )}
              </p>
              <p className="text-xs text-neutral-500 mt-2">
                {key === "0-100" && "puntos"}
                {key === "0-4" && "de 4"}
                {key === "A-F" && (
                  ejemploCalificacion >= 90 ? "(Excelente)" :
                  ejemploCalificacion >= 80 ? "(Bueno)" :
                  ejemploCalificacion >= 70 ? "(Regular)" :
                  ejemploCalificacion >= 60 ? "(Deficiente)" : "(Insuficiente)"
                )}
              </p>
            </div>
          ))}
        </div>

        <div className="mt-6 bg-primary-brand/10 border border-primary-brand/30 rounded-lg p-4">
          <p className="text-sm text-primary-300">
            <span className="font-semibold">Nota:</span> Los ejemplos muestran cómo se vería una calificación de {ejemploCalificacion}/100
            en cada una de las escalas disponibles.
          </p>
        </div>
      </div>
    </div>
  )
}
