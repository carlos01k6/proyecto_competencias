import React, { useState } from "react"
import { useCriterios } from "../hooks/useCriterios"
import { useResultados } from "../hooks/useResultados"
import { Target, Plus, Search, Trash2, Edit } from "lucide-react"

export default function CriteriosPage({ usuario }) {
  const { criterios, cargando, agregarCriterio, eliminarCriterio, obtenerCriterios } = useCriterios()
  const { resultados, cargando: cargandoResultados } = useResultados()
  
  const [busqueda, setBusqueda] = useState("")
  const [tab, setTab] = useState("ver")
  const [cargandoCrear, setCargandoCrear] = useState(false)
  const [exitoCrear, setExitoCrear] = useState(false)
  const [formData, setFormData] = useState({
    nombre: "",
    descripcion: "",
    ponderacion: 100,
    learning_outcome_id: ""
  })

  const rolUsuario = usuario?.rol?.toLowerCase()
  const puedeCrear = rolUsuario === "admin" || rolUsuario === "teacher"

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData({
      ...formData,
      [name]: name === "ponderacion" ? parseInt(value) : value
    })
  }

  const handleCrear = async (e) => {
    e.preventDefault()
    if (!formData.nombre || !formData.learning_outcome_id) {
      alert("Nombre y resultado de aprendizaje son obligatorios")
      return
    }

    setCargandoCrear(true)
    try {
      const dataEnviada = {
        name: formData.nombre,
        learning_outcome_id: formData.learning_outcome_id,
        weighting: formData.ponderacion,
        description: formData.descripcion
      }
      console.log("DEBUG criterio enviado:", dataEnviada)
      await agregarCriterio(dataEnviada)
      setExitoCrear(true)
      setFormData({
        nombre: "",
        descripcion: "",
        ponderacion: 100,
        learning_outcome_id: ""
      })
      setTimeout(() => {
        setExitoCrear(false)
        setTab("ver")
        obtenerCriterios()
      }, 2000)
    } catch (error) {
      alert("Error al crear criterio: " + (error.response?.data?.error || error.response?.data?.mensaje || error.message))
    } finally {
      setCargandoCrear(false)
    }
  }

  const handleEliminar = async (criterio_id) => {
    if (window.confirm("¿Eliminar este criterio? Esta acción no se puede deshacer.")) {
      try {
        await eliminarCriterio(criterio_id)
        obtenerCriterios()
      } catch (error) {
        alert("Error al eliminar: " + (error.response?.data?.mensaje || error.message))
      }
    }
  }

  const filtrados = criterios.filter(c =>
    (c.nombre || c.name)?.toLowerCase().includes(busqueda.toLowerCase()) ||
    (c.descripcion || c.description)?.toLowerCase().includes(busqueda.toLowerCase())
  )

  // Si no es admin, mostrar acceso denegado
  if (!puedeCrear && rolUsuario !== "admin") {
    return (
      <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8 flex items-center justify-center">
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 max-w-md text-center">
          <p className="text-4xl mb-4">🔒</p>
          <h1 className="text-2xl font-bold text-white mb-2">Acceso Restringido</h1>
          <p className="text-neutral-400 mb-6">
            Solo los administradores pueden ver y gestionar criterios de evaluación.
          </p>
          <a href="/" className="inline-block bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-6 py-2 rounded-lg font-semibold transition">
            Volver al Inicio
          </a>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="p-3 bg-gradient-to-br from-pink-600 to-pink-700 rounded-lg">
              <Target className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-4xl font-bold text-white">Criterios de Evaluación</h1>
              <p className="text-neutral-400">Establece los estándares de evaluación para competencias</p>
            </div>
          </div>
          <button
            onClick={() => setTab("crear")}
            className="bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-6 py-3 rounded-lg font-semibold flex items-center gap-2 transition"
          >
            <Plus className="w-5 h-5" />
            Nuevo Criterio
          </button>
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
          Ver Criterios
        </button>
        <button
          onClick={() => setTab("crear")}
          className={`px-6 py-3 font-semibold border-b-2 transition ${
            tab === "crear"
              ? "border-primary-brand text-primary-brand"
              : "border-transparent text-neutral-400 hover:text-neutral-200"
          }`}
        >
          Crear Nuevo
        </button>
      </div>

      {/* VER CRITERIOS */}
      {tab === "ver" && (
        <div className="space-y-6">
          {/* Búsqueda */}
          {criterios.length > 0 && (
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-neutral-500" />
              <input
                type="text"
                placeholder="Buscar criterio..."
                value={busqueda}
                onChange={(e) => setBusqueda(e.target.value)}
                className="w-full pl-10 pr-4 py-3 bg-neutral-800/50 border border-neutral-700 rounded-lg text-white placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
              />
            </div>
          )}

          {/* Tabla */}
          <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
            {cargando ? (
              <div className="flex items-center justify-center py-12">
                <div className="animate-spin inline-block">
                  <div className="w-8 h-8 border-4 border-neutral-700 border-t-primary-brand rounded-full"></div>
                </div>
              </div>
            ) : filtrados.length === 0 ? (
              <div className="text-center py-12">
                <p className="text-neutral-400">No hay criterios disponibles</p>
              </div>
            ) : (
              <table className="w-full">
                <thead>
                  <tr className="border-b border-neutral-700/50 bg-neutral-900/50">
                    <th className="px-6 py-4 text-left font-semibold text-neutral-300">Nombre</th>
                    <th className="px-6 py-4 text-left font-semibold text-neutral-300">Descripción</th>
                    <th className="px-6 py-4 text-left font-semibold text-neutral-300">Ponderación</th>
                    <th className="px-6 py-4 text-right font-semibold text-neutral-300">Acciones</th>
                  </tr>
                </thead>
                <tbody>
                  {filtrados.map((crit) => (
                    <tr key={crit.id} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition group">
                      <td className="px-6 py-4 text-white font-semibold">{crit.nombre || crit.name}</td>
                      <td className="px-6 py-4 text-neutral-400 max-w-xs truncate">{crit.descripcion || crit.description}</td>
                      <td className="px-6 py-4 text-neutral-400">{crit.ponderacion || crit.weighting || 0}%</td>
                      <td className="px-6 py-4 text-right">
                        <div className="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition">
                          <button
                            onClick={() => handleEliminar(crit.id)}
                            className="p-2 hover:bg-danger/10 rounded-lg transition text-danger"
                          >
                            <Trash2 className="w-4 h-4" />
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </div>
      )}

      {/* CREAR CRITERIO */}
      {tab === "crear" && (
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8 max-w-2xl">
          <h2 className="text-2xl font-bold text-white mb-6">Crear Nuevo Criterio</h2>

          <form onSubmit={handleCrear} className="space-y-5">
            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Resultado de Aprendizaje *
              </label>
              <select
                name="learning_outcome_id"
                value={formData.learning_outcome_id}
                onChange={handleChange}
                disabled={cargandoCrear || cargandoResultados}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              >
                <option value="">{cargandoResultados ? "Cargando resultados..." : "Selecciona un resultado"}</option>
                {resultados.map((resultado) => (
                  <option key={resultado.id} value={resultado.id}>
                    {resultado.title || resultado.titulo || resultado.name || resultado.nombre || resultado.id}
                  </option>
                ))}
              </select>
              {!cargandoResultados && resultados.length === 0 && (
                <p className="text-xs text-warning mt-1">No hay resultados de aprendizaje disponibles.</p>
              )}
            </div>

            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Nombre del Criterio *
              </label>
              <input
                type="text"
                name="nombre"
                value={formData.nombre}
                onChange={handleChange}
                placeholder="Ej: Pensamiento Crítico"
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
                placeholder="Describe qué implica este criterio..."
                rows="4"
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Ponderación (%)
              </label>
              <input
                type="number"
                name="ponderacion"
                value={formData.ponderacion}
                onChange={handleChange}
                min="0"
                max="100"
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              />
              <p className="text-xs text-neutral-500 mt-1">Peso relativo en la calificación final</p>
            </div>

            {exitoCrear && (
              <div className="bg-success/10 border border-success/30 rounded-lg p-4">
                <p className="text-success font-semibold">✓ Criterio creado correctamente</p>
              </div>
            )}

            <div className="flex gap-3 pt-4">
              <button
                type="submit"
                disabled={cargandoCrear}
                className="flex-1 bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white py-3 rounded-lg font-semibold transition disabled:opacity-50"
              >
                {cargandoCrear ? "Creando..." : "+ Crear Criterio"}
              </button>
              <button
                type="button"
                onClick={() => {
                  setTab("ver")
                  setFormData({
                    nombre: "",
                    descripcion: "",
                    ponderacion: 100,
                    learning_outcome_id: ""
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

