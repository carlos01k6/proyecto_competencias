import React, { useState } from "react"
import { useTemplates, useFeedbackPersonalizado, useFeedbackPorCriterio } from "../hooks/useFeedback"
import { MessageSquare } from "lucide-react"

export default function RetroalimentacionPage({ usuario }) {
  const { templates } = useTemplates()
  const [calificacion, setCalificacion] = useState(85)
  const [criterioTipo, setCriterioTipo] = useState("contenido")
  const { feedback: feedbackPersonalizado } = useFeedbackPersonalizado(calificacion)
  const { feedback: feedbackCriterio } = useFeedbackPorCriterio(calificacion, criterioTipo)

  const getColorBadge = (color) => {
    const colores = {
      danger: "bg-danger text-white",
      warning: "bg-warning text-neutral-900",
      "primary-brand": "bg-primary-brand text-white",
      success: "bg-success text-white"
    }
    return colores[color] || "bg-neutral-300"
  }

  const criterios = ["contenido", "estructura", "presentación", "análisis"]

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-4">
          <div className="p-3 bg-gradient-to-br from-amber-600 to-amber-700 rounded-lg">
            <MessageSquare className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Retroalimentación Automática</h1>
            <p className="text-neutral-400">Sugerencias de feedback para docentes al calificar</p>
          </div>
        </div>
      </div>

      {/* Calculadora de Feedback */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
          <label className="block text-sm font-semibold text-white mb-3">
            Calificación del Estudiante (0-100)
          </label>
          <input
            type="number"
            value={calificacion}
            onChange={(e) => setCalificacion(parseFloat(e.target.value))}
            min="0"
            max="100"
            step="1"
            className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition mb-4"
          />
          <div className="bg-neutral-900/50 rounded-lg p-4 border border-neutral-700/50">
            <p className="text-xs text-neutral-500 font-semibold mb-2">Calificación ingresada:</p>
            <p className="text-3xl font-bold text-primary-brand">{calificacion}/100</p>
          </div>
        </div>

        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
          <label className="block text-sm font-semibold text-white mb-3">
            Tipo de Criterio
          </label>
          <select
            value={criterioTipo}
            onChange={(e) => setCriterioTipo(e.target.value)}
            className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition mb-4"
          >
            {criterios.map((criterio) => (
              <option key={criterio} value={criterio}>
                {criterio.charAt(0).toUpperCase() + criterio.slice(1)}
              </option>
            ))}
          </select>
          <div className="bg-neutral-900/50 rounded-lg p-4 border border-neutral-700/50">
            <p className="text-xs text-neutral-500 font-semibold mb-2">Criterio seleccionado:</p>
            <p className="text-lg font-bold text-white capitalize">{criterioTipo}</p>
          </div>
        </div>

        {feedbackPersonalizado && (
          <div className={`${getColorBadge(feedbackPersonalizado.color)} rounded-2xl shadow p-6`}>
            <p className="text-sm font-semibold opacity-75 mb-2">Rango identificado</p>
            <p className="text-2xl font-bold mb-2">{feedbackPersonalizado.titulo}</p>
            <p className="text-sm opacity-75">{feedbackPersonalizado.rango}</p>
          </div>
        )}
      </div>

      {/* Feedback Personalizado General */}
      {feedbackPersonalizado && (
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8 mb-6">
          <h2 className="text-xl font-bold text-white mb-4">
            Sugerencias de Feedback General
          </h2>
          <div className="space-y-3">
            {feedbackPersonalizado.sugerencias.map((sugerencia, idx) => (
              <div
                key={idx}
                className="flex gap-3 p-3 bg-neutral-900/50 rounded-lg border border-neutral-700/50 hover:border-primary-brand/30 cursor-pointer transition"
              >
                <span className="text-primary-brand font-bold flex-shrink-0">✓</span>
                <p className="text-neutral-300">{sugerencia}</p>
              </div>
            ))}
          </div>
          <p className="text-xs text-neutral-500 mt-4">
            💡 Haz clic en cualquier sugerencia para copiarla
          </p>
        </div>
      )}

      {/* Feedback Específico por Criterio */}
      {feedbackCriterio && (
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8 mb-6">
          <h2 className="text-xl font-bold text-white mb-4">
            Feedback Específico - Criterio: <span className="capitalize text-primary-brand">{criterioTipo}</span>
          </h2>
          <div className="bg-primary-brand/10 border border-primary-brand/30 rounded-lg p-6">
            <p className="text-lg text-neutral-300 leading-relaxed">
              {feedbackCriterio.feedback}
            </p>
          </div>
          <button
            onClick={() => {
              navigator.clipboard.writeText(feedbackCriterio.feedback)
              alert("Copiado al portapapeles")
            }}
            className="mt-4 bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-4 py-2 rounded-lg text-sm font-semibold transition"
          >
            📋 Copiar Feedback
          </button>
        </div>
      )}

      {/* Todos los Templates */}
      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8">
        <h2 className="text-xl font-bold text-white mb-4">Todos los Templates de Feedback</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {Object.entries(templates).map(([key, template]) => (
            <div key={key} className={`${getColorBadge(template.color)} rounded-lg p-6`}>
              <h3 className="text-lg font-bold mb-2">{template.titulo}</h3>
              <p className="text-sm opacity-75 mb-4">{template.rango}</p>
              <div className="space-y-2">
                {template.sugerencias.map((sugerencia, idx) => (
                  <p key={idx} className="text-sm opacity-90">
                    • {sugerencia}
                  </p>
                ))}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
