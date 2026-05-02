import React, { useState } from "react"
import { useResultados } from "../hooks/useOutcomes"
import { Award, Plus, Search, Trash2, Edit } from "lucide-react"

export default function ResultadosPage({ usuario }) {
  const { resultados, cargando, agregarResultado, eliminarResultado, obtenerResultados } = useResultados()
  
  const [busqueda, setBusqueda] = useState("")
  const [tab, setTab] = useState("ver")
  const [cargandoCrear, setCargandoCrear] = useState(false)
  const [exitoCrear, setExitoCrear] = useState(false)
  const [formData, setFormData] = useState({
    titulo: "",
    descripcion: "",
    competencia_id: ""
  })

  const rolUsuario = usuario?.rol?.toLowerCase()
  const esAdmin = rolUsuario === "admin"
  const esTeacher = rolUsuario === "teacher"
  const esStudent = rolUsuario === "student"

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData({
      ...formData,
      [name]: value
    })
  }

  const handleCrear = async (e) => {
    e.preventDefault()
    if (!formData.titulo || !formData.descripcion) {
      alert("Título y descripción son obligatorios")
      return
    }

    setCargandoCrear(true)
    try {
      await agregarResultado(formData)
      setExitoCrear(true)
      setFormData({
        titulo: "",
        descripcion: "",
        competencia_id: ""
      })
      setTimeout(() => {
        setExitoCrear(false)
        setTab("ver")
        obtenerResultados()
      }, 2000)
    } catch (error) {
      alert("Error al crear resultado: " + (error.response?.data?.mensaje || error.message))
    } finally {
      setCargandoCrear(false)
    }
  }

  const handleEliminar = async (resultado_id) => {
    if (window.confirm("¿Eliminar este resultado de aprendizaje? Esta acción no se puede deshacer.")) {
      try {
        await eliminarResultado(resultado_id)
        obtenerResultados()
      } catch (error) {
        alert("Error al eliminar: " + (error.response?.data?.mensaje || error.message))
      }
    }
  }

  const filtrados = resultados.filter(r =>
    r.titulo?.toLowerCase().includes(busqueda.toLowerCase()) ||
    r.descripcion?.toLowerCase().includes(busqueda.toLowerCase())
  )

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="p-3 bg-gradient-to-br from-emerald-600 to-emerald-700 rounded-lg">
              <Award className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-4xl font-bold text-white">Resultados de Aprendizaje</h1>
              <p className="text-neutral-400">
                {esAdmin && "Define los objetivos de aprendizaje de las competencias"}
                {esTeacher && "Resultados de aprendizaje disponibles"}
                {esStudent && "Mis objetivos de aprendizaje"}
              </p>
            </div>
          </div>
          {esAdmin && (
            <button
              onClick={() => setTab("crear")}
              className="bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-6 py-3 rounded-lg font-semibold flex items-center gap-2 transition"
            >
              <Plus className="w-5 h-5" />
              Nuevo Resultado
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
          Ver Resultados
        </button>
        {esAdmin && (
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
        )}
      </div>

      {/* VER RESULTADOS */}
      {tab === "ver" && (
        <div className="space-y-6">
          {/* Búsqueda */}
          {resultados.length > 0 && (
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-neutral-500" />
              <input
                type="text"
                placeholder="Buscar resultado..."
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
                <p className="text-neutral-400">No hay resultados de aprendizaje disponibles</p>
              </div>
            ) : (
              <table className="w-full">
                <thead>
                  <tr className="border-b border-neutral-700/50 bg-neutral-900/50">
                    <th className="px-6 py-4 text-left font-semibold text-neutral-300">Título</th>
                    <th className="px-6 py-4 text-left font-semibold text-neutral-300">Descripción</th>
                    {esAdmin && <th className="px-6 py-4 text-right font-semibold text-neutral-300">Acciones</th>}
                  </tr>
                </thead>
                <tbody>
                  {filtrados.map((res) => (
                    <tr key={res.id} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition group">
                      <td className="px-6 py-4 text-white font-semibold">{res.titulo}</td>
                      <td className="px-6 py-4 text-neutral-400 max-w-xs truncate">{res.descripcion}</td>
                      {esAdmin && (
                        <td className="px-6 py-4 text-right">
                          <div className="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition">
                            <button
                              onClick={() => handleEliminar(res.id)}
                              className="p-2 hover:bg-danger/10 rounded-lg transition text-danger"
                            >
                              <Trash2 className="w-4 h-4" />
                            </button>
                          </div>
                        </td>
                      )}
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </div>
      )}

      {/* CREAR RESULTADO */}
      {tab === "crear" && esAdmin && (
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8 max-w-2xl">
          <h2 className="text-2xl font-bold text-white mb-6">Crear Resultado de Aprendizaje</h2>

          <form onSubmit={handleCrear} className="space-y-5">
            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Título *
              </label>
              <input
                type="text"
                name="titulo"
                value={formData.titulo}
                onChange={handleChange}
                placeholder="Ej: El estudiante será capaz de..."
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Descripción Detallada *
              </label>
              <textarea
                name="descripcion"
                value={formData.descripcion}
                onChange={handleChange}
                placeholder="Describe específicamente qué debe aprender el estudiante..."
                rows="5"
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Competencia Asociada (opcional)
              </label>
              <input
                type="text"
                name="competencia_id"
                value={formData.competencia_id}
                onChange={handleChange}
                placeholder="ID de la competencia"
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              />
            </div>

            {exitoCrear && (
              <div className="bg-success/10 border border-success/30 rounded-lg p-4">
                <p className="text-success font-semibold">✓ Resultado de aprendizaje creado correctamente</p>
              </div>
            )}

            <div className="flex gap-3 pt-4">
              <button
                type="submit"
                disabled={cargandoCrear}
                className="flex-1 bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white py-3 rounded-lg font-semibold transition disabled:opacity-50"
              >
                {cargandoCrear ? "Creando..." : "+ Crear Resultado"}
              </button>
              <button
                type="button"
                onClick={() => {
                  setTab("ver")
                  setFormData({
                    titulo: "",
                    descripcion: "",
                    competencia_id: ""
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
