import React, { useState } from "react"
import { useMisRubricas, useCrearRubrica, useEliminarRubrica } from "../hooks/useRubricas"
import { CheckSquare, Plus, Trash2 } from "lucide-react"

export default function RubricasPage({ usuario }) {
  const { rubricas, cargando, obtenerRubricas } = useMisRubricas()
  const { crear, cargando: cargandoCrear, exito: exitoCrear } = useCrearRubrica()
  const { eliminar } = useEliminarRubrica()

  const [tab, setTab] = useState("ver")
  const [formData, setFormData] = useState({
    nombre: "",
    descripcion: "",
    competencia_id: "",
    niveles: [
      { nivel: 1, descripcion: "Insuficiente", rango_min: 0, rango_max: 39 },
      { nivel: 2, descripcion: "Básico", rango_min: 40, rango_max: 69 },
      { nivel: 3, descripcion: "Intermedio", rango_min: 70, rango_max: 84 },
      { nivel: 4, descripcion: "Avanzado", rango_min: 85, rango_max: 100 }
    ]
  })

  const rolUsuario = usuario?.rol?.toLowerCase()
  const puedeCrear = rolUsuario === "teacher"

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData({
      ...formData,
      [name]: value
    })
  }

  const handleNivelChange = (idx, field, value) => {
    const nuevosNiveles = [...formData.niveles]
    nuevosNiveles[idx] = {
      ...nuevosNiveles[idx],
      [field]: field === "nivel" || field === "rango_min" || field === "rango_max" ? parseInt(value) : value
    }
    setFormData({
      ...formData,
      niveles: nuevosNiveles
    })
  }

  const handleCrear = async (e) => {
    e.preventDefault()
    if (!formData.nombre || !formData.descripcion) {
      alert("Nombre y descripción son obligatorios")
      return
    }

    try {
      await crear(formData)
      if (exitoCrear) {
        setFormData({
          nombre: "",
          descripcion: "",
          competencia_id: "",
          niveles: [
            { nivel: 1, descripcion: "Insuficiente", rango_min: 0, rango_max: 39 },
            { nivel: 2, descripcion: "Básico", rango_min: 40, rango_max: 69 },
            { nivel: 3, descripcion: "Intermedio", rango_min: 70, rango_max: 84 },
            { nivel: 4, descripcion: "Avanzado", rango_min: 85, rango_max: 100 }
          ]
        })
        obtenerRubricas()
        setTab("ver")
      }
    } catch (error) {
      alert("Error al crear rúbrica: " + (error.response?.data?.mensaje || error.message))
    }
  }

  const handleEliminar = async (rubrica_id) => {
    if (window.confirm("¿Eliminar esta rúbrica?")) {
      try {
        await eliminar(rubrica_id)
        obtenerRubricas()
      } catch (error) {
        alert("Error al eliminar: " + (error.response?.data?.mensaje || error.message))
      }
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="p-3 bg-gradient-to-br from-emerald-600 to-emerald-700 rounded-lg">
              <CheckSquare className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-4xl font-bold text-white">Rúbricas de Evaluación</h1>
              <p className="text-neutral-400">
                {puedeCrear ? "Crea rúbricas para evaluar competencias" : "Rúbricas disponibles"}
              </p>
            </div>
          </div>
          {puedeCrear && (
            <button
              onClick={() => setTab("crear")}
              className="bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-6 py-3 rounded-lg font-semibold flex items-center gap-2 transition"
            >
              <Plus className="w-5 h-5" />
              Nueva Rúbrica
            </button>
          )}
        </div>
      </div>

      {/* Tabs */}
      <div className="flex gap-2 mb-6 border-b border-neutral-700">
        <button
          onClick={() => setTab("ver")}
          className={`px-6 py-3 font-semibold border-b-2 transition ${
            tab === "ver"
              ? "border-primary-brand text-primary-brand"
              : "border-transparent text-neutral-400 hover:text-neutral-200"
          }`}
        >
          Ver Rúbricas
        </button>
        {puedeCrear && (
          <button
            onClick={() => setTab("crear")}
            className={`px-6 py-3 font-semibold border-b-2 transition ${
              tab === "crear"
                ? "border-primary-brand text-primary-brand"
                : "border-transparent text-neutral-400 hover:text-neutral-200"
            }`}
          >
            Crear Nueva
          </button>
        )}
      </div>

      {/* VER RUBRICAS */}
      {tab === "ver" && (
        <div className="space-y-6">
          {cargando ? (
            <div className="text-center text-neutral-400 py-12">
              <div className="animate-spin inline-block">
                <div className="w-8 h-8 border-4 border-neutral-700 border-t-primary-brand rounded-full"></div>
              </div>
              <p className="mt-4">Cargando rúbricas...</p>
            </div>
          ) : rubricas.length === 0 ? (
            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 text-center">
              <p className="text-neutral-400 text-lg">No hay rúbricas disponibles</p>
            </div>
          ) : (
            <div className="space-y-4">
              {rubricas.map((rubrica) => (
                <div key={rubrica.id} className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 hover:border-primary-brand/30 transition">
                  <div className="flex items-start justify-between mb-4">
                    <div className="flex-1">
                      <h3 className="text-xl font-bold text-white">{rubrica.nombre}</h3>
                      <p className="text-neutral-400 text-sm mt-1">{rubrica.descripcion}</p>
                    </div>
                    {puedeCrear && (
                      <button
                        onClick={() => handleEliminar(rubrica.id)}
                        className="p-2 hover:bg-danger/20 rounded-lg transition text-danger ml-2"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    )}
                  </div>

                  {/* Niveles */}
                  <div className="mt-4 space-y-2">
                    {rubrica.niveles && rubrica.niveles.map((nivel, idx) => (
                      <div key={idx} className="bg-neutral-900/50 p-3 rounded-lg">
                        <div className="flex items-center justify-between">
                          <span className="font-semibold text-white">{nivel.descripcion}</span>
                          <span className="text-xs text-neutral-500">{nivel.rango_min} - {nivel.rango_max}</span>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      )}

      {/* CREAR RUBRICA */}
      {tab === "crear" && puedeCrear && (
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8 max-w-4xl">
          <h2 className="text-2xl font-bold text-white mb-6">Crear Nueva Rúbrica</h2>

          <form onSubmit={handleCrear} className="space-y-6">
            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Nombre *
              </label>
              <input
                type="text"
                name="nombre"
                value={formData.nombre}
                onChange={handleChange}
                placeholder="Ej: Rúbrica de Liderazgo"
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Descripción *
              </label>
              <textarea
                name="descripcion"
                value={formData.descripcion}
                onChange={handleChange}
                placeholder="Describe los criterios de evaluación..."
                rows="3"
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              />
            </div>

            {/* Niveles de Logro */}
            <div>
              <label className="block text-sm font-semibold text-white mb-4">
                Niveles de Logro
              </label>
              <div className="space-y-4">
                {formData.niveles.map((nivel, idx) => (
                  <div key={idx} className="bg-neutral-900/50 p-4 rounded-lg space-y-3">
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
                      <div>
                        <label className="text-xs font-semibold text-neutral-400">Descripción</label>
                        <input
                          type="text"
                          value={nivel.descripcion}
                          onChange={(e) => handleNivelChange(idx, "descripcion", e.target.value)}
                          placeholder="Ej: Insuficiente"
                          disabled={cargandoCrear}
                          className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-3 py-2 text-sm placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
                        />
                      </div>
                      <div>
                        <label className="text-xs font-semibold text-neutral-400">Desde</label>
                        <input
                          type="number"
                          value={nivel.rango_min}
                          onChange={(e) => handleNivelChange(idx, "rango_min", e.target.value)}
                          min="0"
                          max="100"
                          disabled={cargandoCrear}
                          className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
                        />
                      </div>
                      <div>
                        <label className="text-xs font-semibold text-neutral-400">Hasta</label>
                        <input
                          type="number"
                          value={nivel.rango_max}
                          onChange={(e) => handleNivelChange(idx, "rango_max", e.target.value)}
                          min="0"
                          max="100"
                          disabled={cargandoCrear}
                          className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
                        />
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {exitoCrear && (
              <div className="bg-success/10 border border-success/30 rounded-lg p-4">
                <p className="text-success font-semibold">✓ Rúbrica creada correctamente</p>
              </div>
            )}

            <div className="flex gap-3 pt-4">
              <button
                type="submit"
                disabled={cargandoCrear}
                className="flex-1 bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white py-3 rounded-lg font-semibold transition disabled:opacity-50"
              >
                {cargandoCrear ? "Creando..." : "+ Crear Rúbrica"}
              </button>
              <button
                type="button"
                onClick={() => {
                  setTab("ver")
                  setFormData({
                    nombre: "",
                    descripcion: "",
                    competencia_id: "",
                    niveles: [
                      { nivel: 1, descripcion: "Insuficiente", rango_min: 0, rango_max: 39 },
                      { nivel: 2, descripcion: "Básico", rango_min: 40, rango_max: 69 },
                      { nivel: 3, descripcion: "Intermedio", rango_min: 70, rango_max: 84 },
                      { nivel: 4, descripcion: "Avanzado", rango_min: 85, rango_max: 100 }
                    ]
                  })
                }}
                disabled={cargandoCrear}
                className="flex-1 bg-neutral-700 hover:bg-neutral-600 text-white py-3 rounded-lg font-semibold transition disabled:opacity-50"
              >
                Cancelar
              </button>
            </div>
          </form>
        </div>
      )}
    </div>
  )
}
