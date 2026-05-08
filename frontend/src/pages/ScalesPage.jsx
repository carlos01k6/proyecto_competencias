import React, { useState, useEffect } from "react"
import axios from "axios"
import { useEscalaActual, useActualizarEscala, useConvertirCalificacion } from "../hooks/useScales"
import { Ruler, Save, AlertTriangle } from "lucide-react"

const BASE_URL = "http://localhost:5000"
function getHeaders() {
  const t = localStorage.getItem("acceso_token")
  return t ? { Authorization: `Bearer ${t}` } : {}
}

function formatUmbral(valor, escala) {
  if (escala === "0-4") return `${(valor / 100 * 4).toFixed(2)} / 4`
  if (escala === "A-F") {
    if (valor >= 90) return "A (Excelente)"
    if (valor >= 80) return "B (Bueno)"
    if (valor >= 70) return "C (Regular)"
    if (valor >= 60) return "D (Deficiente)"
    return "F (Insuficiente)"
  }
  return `${valor} / 100`
}

export default function EscalasPage({ usuario }) {
  const { escala, obtenerEscala } = useEscalaActual()
  const { actualizar, cargando, exito, error } = useActualizarEscala()
  const [nuevaEscala, setNuevaEscala] = useState("")
  const [ejemploCalificacion, setEjemploCalificacion] = useState(85)
  const { convertida } = useConvertirCalificacion(ejemploCalificacion)

  // Umbral de re-evaluación
  const [umbral, setUmbral] = useState(65)
  const [umbralInput, setUmbralInput] = useState("65")
  const [guardandoUmbral, setGuardandoUmbral] = useState(false)
  const [umbralMsg, setUmbralMsg] = useState(null)

  useEffect(() => {
    axios.get(`${BASE_URL}/api/escalas/umbral`, { headers: getHeaders() })
      .then(r => {
        const v = parseFloat(r.data?.umbral ?? 65)
        setUmbral(v)
        setUmbralInput(String(v))
      })
      .catch(() => {})
  }, [])

  const handleGuardarUmbral = async () => {
    const v = parseFloat(umbralInput)
    if (isNaN(v) || v < 1 || v > 99) {
      setUmbralMsg({ tipo: "error", texto: "El umbral debe ser un número entre 1 y 99" })
      return
    }
    setGuardandoUmbral(true)
    setUmbralMsg(null)
    try {
      await axios.put(
        `${BASE_URL}/api/escalas/umbral`,
        { umbral: v },
        { headers: getHeaders() },
      )
      setUmbral(v)
      setUmbralMsg({ tipo: "exito", texto: `Umbral actualizado a ${formatUmbral(v, escala)}` })
    } catch (e) {
      setUmbralMsg({ tipo: "error", texto: e.response?.data?.error || e.message })
    } finally {
      setGuardandoUmbral(false)
      setTimeout(() => setUmbralMsg(null), 4000)
    }
  }

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

      {/* ── Umbral de Re-evaluación ── */}
      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8 mb-6">
        <div className="flex items-center gap-3 mb-6">
          <div className="p-2 bg-orange-600/20 rounded-lg">
            <AlertTriangle className="w-5 h-5 text-orange-400" />
          </div>
          <div>
            <h2 className="text-xl font-bold text-white">Umbral de Re-evaluación</h2>
            <p className="text-sm text-neutral-400">
              Calificación mínima (0-100) por debajo de la cual un estudiante puede acceder a re-evaluación y aparece en alertas de desempeño
            </p>
          </div>
        </div>

        {/* Valor actual en cada escala */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
          {[["0-100", "Escala 0-100"], ["0-4", "Escala GPA 0-4"], ["A-F", "Escala Letras A-F"]].map(([key, label]) => (
            <div key={key} className={`rounded-xl p-4 border ${escala === key ? "border-orange-500/50 bg-orange-500/10" : "border-neutral-700/40 bg-neutral-900/40"}`}>
              <p className="text-xs text-neutral-400 mb-1">{label}</p>
              <p className={`text-2xl font-black ${escala === key ? "text-orange-400" : "text-neutral-300"}`}>
                {formatUmbral(umbral, key)}
              </p>
              {escala === key && (
                <span className="text-xs text-orange-400 font-semibold mt-1 block">← Escala actual</span>
              )}
            </div>
          ))}
        </div>

        {esAdmin ? (
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Nuevo umbral (en escala 0-100)
              </label>
              <div className="flex gap-3">
                <input
                  type="number"
                  min="1"
                  max="99"
                  step="1"
                  value={umbralInput}
                  onChange={e => setUmbralInput(e.target.value)}
                  className="w-40 bg-neutral-800 border border-neutral-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-orange-500 text-lg font-bold"
                />
                <button
                  onClick={handleGuardarUmbral}
                  disabled={guardandoUmbral || parseFloat(umbralInput) === umbral}
                  className="flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-orange-600 to-orange-700 hover:from-orange-500 hover:to-orange-600 disabled:opacity-50 text-white rounded-lg font-semibold transition"
                >
                  <Save className="w-4 h-4" />
                  {guardandoUmbral ? "Guardando..." : "Guardar"}
                </button>
              </div>
              <p className="text-xs text-neutral-500 mt-2">
                Equivale a <span className="text-orange-400 font-semibold">{formatUmbral(parseFloat(umbralInput) || umbral, escala)}</span> en la escala actual
              </p>
            </div>

            {umbralMsg && (
              <div className={`p-3 rounded-lg border text-sm font-medium ${
                umbralMsg.tipo === "exito"
                  ? "bg-emerald-500/10 border-emerald-500/30 text-emerald-400"
                  : "bg-red-500/10 border-red-500/30 text-red-400"
              }`}>
                {umbralMsg.texto}
              </div>
            )}

            <div className="p-4 bg-neutral-900/50 rounded-xl border border-neutral-700/30 text-sm text-neutral-400 space-y-1">
              <p>• Estudiantes con promedio <strong className="text-red-400">{"< 40"}</strong> → Alerta <strong className="text-red-400">Crítico</strong></p>
              <p>• Estudiantes con promedio <strong className="text-orange-400">40 – 59</strong> → Alerta <strong className="text-orange-400">Alto</strong></p>
              <p>• Estudiantes con promedio <strong className="text-yellow-400">60 – {Math.round(umbral) - 1}</strong> → Alerta <strong className="text-yellow-400">Medio</strong> (re-evaluación)</p>
              <p>• Estudiantes con promedio <strong className="text-emerald-400">≥ {Math.round(umbral)}</strong> → Sin alerta</p>
            </div>
          </div>
        ) : (
          <div className="p-4 bg-neutral-900/50 rounded-xl border border-neutral-700/30 text-sm text-neutral-400">
            Solo administradores pueden cambiar el umbral de re-evaluación.
          </div>
        )}
      </div>

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
