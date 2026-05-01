import React, { useState } from "react"
import { useActividades } from "../hooks/useActividades"
import { ClipboardList, Plus, Trash2, Download } from "lucide-react"

export default function ActividadesPage({ usuario }) {
  const { actividades, cargando, agregarActividad, eliminarActividad, obtenerActividades } = useActividades()
  
  const [tab, setTab] = useState("ver")
  const [cargandoCrear, setCargandoCrear] = useState(false)
  const [exitoCrear, setExitoCrear] = useState(false)
  const [formData, setFormData] = useState({
    name: "",
    description: "",
    learning_outcome_id: "",
    start_date: new Date().toISOString().split('T')[0],
    close_date: "",
    max_score: 100,
    tipo: "tarea"
  })

  const rolUsuario = usuario?.rol?.toLowerCase()
  const puedeCrear = rolUsuario === "teacher"

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData({
      ...formData,
      [name]: name === "max_score" ? parseInt(value) : value
    })
  }

  const handleCrear = async (e) => {
    e.preventDefault()
    if (!formData.name || !formData.description) {
      alert("Nombre y descripción son obligatorios")
      return
    }

    setCargandoCrear(true)
    try {
      await agregarActividad(formData)
      setExitoCrear(true)
      setFormData({
        name: "",
        description: "",
        learning_outcome_id: "",
        start_date: new Date().toISOString().split('T')[0],
        close_date: "",
        max_score: 100,
        tipo: "tarea"
      })
      setTimeout(() => {
        setExitoCrear(false)
        setTab("ver")
        obtenerActividades()
      }, 2000)
    } catch (error) {
      alert("Error al crear actividad: " + (error.response?.data?.mensaje || error.message))
    } finally {
      setCargandoCrear(false)
    }
  }

  const handleEliminar = async (actividad_id) => {
    if (window.confirm("¿Eliminar esta actividad?")) {
      try {
        await eliminarActividad(actividad_id)
        obtenerActividades()
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
            <div className="p-3 bg-gradient-to-br from-blue-600 to-blue-700 rounded-lg">
              <ClipboardList className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-4xl font-bold text-white">Actividades</h1>
              <p className="text-neutral-400">
                {puedeCrear ? "Crea actividades evaluables para tus estudiantes" : "Mis actividades disponibles"}
              </p>
            </div>
          </div>
          {puedeCrear && (
            <button
              onClick={() => setTab("crear")}
              className="bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-6 py-3 rounded-lg font-semibold flex items-center gap-2 transition"
            >
              <Plus className="w-5 h-5" />
              Nueva Actividad
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
          Ver Actividades
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

      {/* VER ACTIVIDADES */}
      {tab === "ver" && (
        <div className="space-y-6">
          {cargando ? (
            <div className="text-center text-neutral-400 py-12">
              <div className="animate-spin inline-block">
                <div className="w-8 h-8 border-4 border-neutral-700 border-t-primary-brand rounded-full"></div>
              </div>
              <p className="mt-4">Cargando actividades...</p>
            </div>
          ) : actividades.length === 0 ? (
            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 text-center">
              <p className="text-neutral-400 text-lg">No hay actividades disponibles</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {actividades.map((actividad) => (
                <div key={actividad.id} className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 hover:border-primary-brand/30 transition">
                  <div className="flex items-start justify-between mb-4">
                    <div className="flex-1">
                      <h3 className="text-lg font-bold text-white">{actividad.name}</h3>
                      <p className="text-xs text-neutral-500 mt-1">
                        {actividad.max_score} puntos
                      </p>
                    </div>
                    {puedeCrear && (
                      <button
                        onClick={() => handleEliminar(actividad.id)}
                        className="p-2 hover:bg-danger/20 rounded-lg transition text-danger ml-2"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    )}
                  </div>
                  
                  <p className="text-neutral-400 text-sm mb-4">{actividad.description}</p>

                  {actividad.close_date && (
                    <div className="text-xs text-neutral-500 mb-4">
                      📅 Entrega: {new Date(actividad.close_date).toLocaleDateString('es-ES')}
                    </div>
                  )}

                  {!puedeCrear && (
                    <button className="w-full bg-neutral-700 hover:bg-neutral-600 text-white px-4 py-2 rounded-lg text-sm font-semibold flex items-center justify-center gap-2 transition">
                      <Download className="w-4 h-4" />
                      Descargar
                    </button>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>
      )}

      {/* CREAR ACTIVIDAD */}
      {tab === "crear" && puedeCrear && (
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8 max-w-2xl">
          <h2 className="text-2xl font-bold text-white mb-6">Crear Nueva Actividad</h2>

          <form onSubmit={handleCrear} className="space-y-5">
            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Título *
              </label>
              <input
                type="text"
                name="name"
                value={formData.name}
                onChange={handleChange}
                placeholder="Ej: Proyecto Final de Análisis"
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Descripción *
              </label>
              <textarea
                name="description"
                value={formData.description}
                onChange={handleChange}
                placeholder="Describe la actividad y qué se espera..."
                rows="4"
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Puntos Máximos (opcional)
              </label>
              <input
                type="number"
                name="max_score"
                value={formData.max_score}
                onChange={handleChange}
                min="0"
                max="100"
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Fecha de Cierre (opcional)
              </label>
              <input
                type="date"
                name="close_date"
                value={formData.close_date}
                onChange={handleChange}
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              />
            </div>

            {exitoCrear && (
              <div className="bg-success/10 border border-success/30 rounded-lg p-4">
                <p className="text-success font-semibold">✓ Actividad creada correctamente</p>
              </div>
            )}

            <div className="flex gap-3 pt-4">
              <button
                type="submit"
                disabled={cargandoCrear}
                className="flex-1 bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white py-3 rounded-lg font-semibold transition disabled:opacity-50"
              >
                {cargandoCrear ? "Creando..." : "+ Crear Actividad"}
              </button>
              <button
                type="button"
                onClick={() => {
                  setTab("ver")
                  setFormData({
                    name: "",
                    description: "",
                    learning_outcome_id: "",
                    start_date: new Date().toISOString().split('T')[0],
                    close_date: "",
                    max_score: 100,
                    tipo: "tarea"
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