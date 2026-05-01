import React, { useState } from "react"
import { useCompetencias } from "../hooks/useCompetencias"
import { BookOpen, Plus, Trash2 } from "lucide-react"

export default function CompetenciasPage({ usuario }) {
  const {
    competencias,
    loading: cargando,
    agregarCompetencia,
    eliminarCompetencia,
    fetchCompetencias
  } = useCompetencias()

  const [tab, setTab] = useState("ver")
  const [cargandoCrear, setCargandoCrear] = useState(false)
  const [exitoCrear, setExitoCrear] = useState(false)
  const [formData, setFormData] = useState({
    name: "",
    description: "",
    subject: "",
    descriptor: ""
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

  const handleCrear = async (e) => {
    e.preventDefault()
    if (!formData.name || !formData.description || !formData.descriptor) {
      alert("Nombre, descripción y descriptor son obligatorios")
      return
    }

    setCargandoCrear(true)
    try {
      await agregarCompetencia(formData)
      setExitoCrear(true)
      setFormData({ name: "", description: "", subject: "", descriptor: "" })
      setTimeout(() => {
        setExitoCrear(false)
        setTab("ver")
        fetchCompetencias()
      }, 2000)
    } catch (error) {
      alert("Error al crear competencia: " + (error.response?.data?.mensaje || error.message))
    } finally {
      setCargandoCrear(false)
    }
  }

  const handleEliminar = async (competencia_id) => {
    if (window.confirm("¿Eliminar esta competencia?")) {
      try {
        await eliminarCompetencia(competencia_id)
        fetchCompetencias()
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
            <div className="p-3 bg-gradient-to-br from-purple-600 to-purple-700 rounded-lg">
              <BookOpen className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-4xl font-bold text-white">Competencias</h1>
              <p className="text-neutral-400">
                {puedeCrear ? "Crea y gestiona tus competencias" : "Competencias disponibles"}
              </p>
            </div>
          </div>
          {puedeCrear && (
            <button
              onClick={() => setTab("crear")}
              className="bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-6 py-3 rounded-lg font-semibold flex items-center gap-2 transition"
            >
              <Plus className="w-5 h-5" />
              Nueva Competencia
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
          Ver Competencias
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

      {/* VER COMPETENCIAS */}
      {tab === "ver" && (
        <div className="space-y-6">
          {cargando ? (
            <div className="text-center text-neutral-400 py-12">
              <div className="animate-spin inline-block">
                <div className="w-8 h-8 border-4 border-neutral-700 border-t-primary-brand rounded-full"></div>
              </div>
              <p className="mt-4">Cargando competencias...</p>
            </div>
          ) : competencias.length === 0 ? (
            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 text-center">
              <p className="text-neutral-400 text-lg">No hay competencias disponibles</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {competencias.map((comp) => (
                <div key={comp.id} className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 hover:border-primary-brand/30 transition">
                  <div className="flex items-start justify-between mb-4">
                    <div className="flex-1">
                      <h3 className="text-lg font-bold text-white">{comp.name}</h3>
                      {comp.subject && <p className="text-xs text-neutral-500 mt-1">{comp.subject}</p>}
                    </div>
                    {puedeCrear && (
                      <button
                        onClick={() => handleEliminar(comp.id)}
                        className="p-2 hover:bg-danger/20 rounded-lg transition text-danger ml-2"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    )}
                  </div>
                  <p className="text-neutral-400 text-sm">{comp.description}</p>
                  <p className="text-neutral-500 text-xs mt-3 italic">{comp.descriptor}</p>
                </div>
              ))}
            </div>
          )}
        </div>
      )}

      {/* CREAR COMPETENCIA */}
      {tab === "crear" && puedeCrear && (
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8 max-w-2xl">
          <h2 className="text-2xl font-bold text-white mb-6">Crear Nueva Competencia</h2>

          <form onSubmit={handleCrear} className="space-y-5">
            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Nombre *
              </label>
              <input
                type="text"
                name="name"
                value={formData.name}
                onChange={handleChange}
                placeholder="Ej: Liderazgo"
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
                placeholder="Describe la competencia..."
                rows="3"
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Descriptor *
              </label>
              <textarea
                name="descriptor"
                value={formData.descriptor}
                onChange={handleChange}
                placeholder="Describe detalladamente la competencia..."
                rows="3"
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Área/Asignatura (opcional)
              </label>
              <input
                type="text"
                name="subject"
                value={formData.subject}
                onChange={handleChange}
                placeholder="Ej: Técnica, Blanda, Matemáticas"
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              />
            </div>

            {exitoCrear && (
              <div className="bg-success/10 border border-success/30 rounded-lg p-4">
                <p className="text-success font-semibold">✓ Competencia creada correctamente</p>
              </div>
            )}

            <div className="flex gap-3 pt-4">
              <button
                type="submit"
                disabled={cargandoCrear}
                className="flex-1 bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white py-3 rounded-lg font-semibold transition disabled:opacity-50"
              >
                {cargandoCrear ? "Creando..." : "+ Crear Competencia"}
              </button>
              <button
                type="button"
                onClick={() => {
                  setTab("ver")
                  setFormData({ name: "", description: "", subject: "", descriptor: "" })
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
