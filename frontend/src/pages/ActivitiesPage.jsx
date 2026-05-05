import React, { useEffect, useState } from "react"
import { useActividades } from "../hooks/useActivities"
import { useCompetencias } from "../hooks/useCompetencies"
import { useResultados } from "../hooks/useOutcomes"
import * as evidenciasService from "../services/evidence"
import * as evaluacionesService from "../services/evaluations"
import { ClipboardList, Plus, Trash2, Download, Upload } from "lucide-react"

export default function ActividadesPage({ usuario }) {
  const { actividades, cargando, agregarActividad, eliminarActividad, obtenerActividades } = useActividades()
  const { competencias } = useCompetencias()
  
  const [tab, setTab] = useState("ver")
  const [cargandoCrear, setCargandoCrear] = useState(false)
  const [exitoCrear, setExitoCrear] = useState(false)
  const [evidenciasPorActividad, setEvidenciasPorActividad] = useState({})
  const [archivosPorActividad, setArchivosPorActividad] = useState({})
  const [descripcionPorActividad, setDescripcionPorActividad] = useState({})
  const [calificacionesPorEvidencia, setCalificacionesPorEvidencia] = useState({})
  const [observacionesPorEvidencia, setObservacionesPorEvidencia] = useState({})
  const [calificandoEvidenciaId, setCalificandoEvidenciaId] = useState(null)
  const [filtroEstudiante, setFiltroEstudiante] = useState("pendientes")
  const [subiendoActividadId, setSubiendoActividadId] = useState(null)
  const [formData, setFormData] = useState({
    name: "",
    description: "",
    competency_id: "",
    learning_outcome_id: "",
    start_date: new Date().toISOString().split('T')[0],
    close_date: "",
    max_score: 100,
    tipo: "tarea"
  })

  const rolUsuario = usuario?.rol?.toLowerCase()
  const puedeCrear = rolUsuario === "teacher"
  const esEstudiante = rolUsuario === "student"
  const { resultados, cargando: cargandoResultados } = useResultados(formData.competency_id)

  useEffect(() => {
    const cargarEvidencias = async () => {
      if ((!esEstudiante && !puedeCrear) || actividades.length === 0) return
      const entradas = await Promise.all(
        actividades.map(async (actividad) => {
          try {
            const evidencias = await evidenciasService.obtenerEvidencias(actividad.id)
            const visibles = esEstudiante ? evidencias.filter((ev) => ev.student_id === usuario.id) : evidencias
            return [actividad.id, visibles]
          } catch {
            return [actividad.id, []]
          }
        })
      )
      setEvidenciasPorActividad(Object.fromEntries(entradas))
    }

    cargarEvidencias()
  }, [actividades, esEstudiante, puedeCrear, usuario?.id])

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData({
      ...formData,
      [name]: name === "max_score" ? parseInt(value) : value,
      ...(name === "competency_id" ? { learning_outcome_id: "" } : {})
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
        competency_id: "",
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

  const handleCalificarEvidencia = async (actividad, evidencia) => {
    const grade = calificacionesPorEvidencia[evidencia.id]
    if (grade === undefined || grade === "") {
      alert("Ingresa una calificación")
      return
    }

    setCalificandoEvidenciaId(evidencia.id)
    try {
      await evaluacionesService.calificarActividad({
        activity_id: actividad.id,
        student_id: evidencia.student_id,
        grade,
        observation: observacionesPorEvidencia[evidencia.id] || "",
        teacher_id: usuario?.id,
        evaluation_date: new Date().toISOString()
      })
      const evidencias = await evidenciasService.obtenerEvidencias(actividad.id)
      setEvidenciasPorActividad({
        ...evidenciasPorActividad,
        [actividad.id]: esEstudiante ? evidencias.filter((ev) => ev.student_id === usuario.id) : evidencias
      })
    } catch (error) {
      alert("Error al calificar: " + (error.response?.data?.error || error.message))
    } finally {
      setCalificandoEvidenciaId(null)
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

  const handleDescargar = (actividad) => {
    const contenido = [
      `Actividad: ${actividad.name || actividad.title || "Actividad"}`,
      `Puntos: ${actividad.max_score || 100}`,
      actividad.close_date ? `Fecha de entrega: ${new Date(actividad.close_date).toLocaleDateString("es-ES")}` : "",
      "",
      actividad.description || "Sin descripcion"
    ].filter(Boolean).join("\n")

    const blob = new Blob([contenido], { type: "text/plain;charset=utf-8" })
    const url = URL.createObjectURL(blob)
    const link = document.createElement("a")
    link.href = url
    link.download = `${(actividad.name || actividad.title || "actividad").replace(/[^\w-]+/g, "_")}.txt`
    document.body.appendChild(link)
    link.click()
    link.remove()
    URL.revokeObjectURL(url)
  }

  const handleSubirEvidencia = async (actividadId) => {
    const archivo = archivosPorActividad[actividadId]
    if (!archivo) {
      alert("Selecciona un archivo")
      return
    }

    setSubiendoActividadId(actividadId)
    try {
      const data = new FormData()
      data.append("activity_id", actividadId)
      data.append("student_id", usuario.id)
      data.append("archivo", archivo)
      data.append("nombre", archivo.name)
      data.append("descripcion", descripcionPorActividad[actividadId] || "")

      await evidenciasService.crearEvidencia(data)
      const evidencias = await evidenciasService.obtenerEvidencias(actividadId)
      setEvidenciasPorActividad({
        ...evidenciasPorActividad,
        [actividadId]: evidencias.filter((ev) => ev.student_id === usuario.id)
      })
      setArchivosPorActividad({ ...archivosPorActividad, [actividadId]: null })
      setDescripcionPorActividad({ ...descripcionPorActividad, [actividadId]: "" })
    } catch (error) {
      alert("Error al subir evidencia: " + (error.response?.data?.error || error.response?.data?.mensaje || error.message))
    } finally {
      setSubiendoActividadId(null)
    }
  }

  const handleDescargarEvidencia = async (evidenciaId) => {
    try {
      const data = await evidenciasService.descargarEvidencia(evidenciaId)
      if (data.file_url) {
        window.open(data.file_url, "_blank", "noopener,noreferrer")
      }
    } catch (error) {
      alert("Error al descargar evidencia: " + (error.response?.data?.error || error.message))
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
          {esEstudiante && (
            <div className="flex flex-wrap gap-2">
              <button
                onClick={() => setFiltroEstudiante("pendientes")}
                className={`px-4 py-2 rounded-lg text-sm font-semibold transition ${
                  filtroEstudiante === "pendientes"
                    ? "bg-primary-brand text-white"
                    : "bg-neutral-800/70 text-neutral-300 border border-neutral-700"
                }`}
              >
                Pendientes
              </button>
              <button
                onClick={() => setFiltroEstudiante("completadas")}
                className={`px-4 py-2 rounded-lg text-sm font-semibold transition ${
                  filtroEstudiante === "completadas"
                    ? "bg-primary-brand text-white"
                    : "bg-neutral-800/70 text-neutral-300 border border-neutral-700"
                }`}
              >
                Completadas
              </button>
            </div>
          )}

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
              {actividades
                .filter((actividad) => {
                  if (!esEstudiante) return true
                  const tieneEvidencias = (evidenciasPorActividad[actividad.id] || []).length > 0
                  return filtroEstudiante === "completadas" ? tieneEvidencias : !tieneEvidencias
                })
                .map((actividad) => (
                <div key={actividad.id} className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 hover:border-primary-brand/30 transition">
                  <div className="flex items-start justify-between mb-4">
                    <div className="flex-1">
                      <h3 className="text-lg font-bold text-white">{actividad.name || actividad.title}</h3>
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

                  {puedeCrear && (
                    <div className="border-t border-neutral-700 pt-4 space-y-3">
                      <h4 className="text-sm font-bold text-white">Evidencias recibidas</h4>
                      {(evidenciasPorActividad[actividad.id] || []).length === 0 ? (
                        <p className="text-xs text-neutral-500">Sin evidencias entregadas.</p>
                      ) : (
                        <div className="space-y-3">
                          {(evidenciasPorActividad[actividad.id] || []).map((ev) => (
                            <div key={ev.id} className="rounded-lg bg-neutral-900/70 border border-neutral-800 p-3 space-y-2">
                              <div className="flex items-center justify-between gap-3">
                                <div>
                                  <p className="text-xs font-semibold text-white truncate">{ev.file_url || "Evidencia"}</p>
                                  <p className="text-[11px] text-neutral-500">{ev.student_id}</p>
                                </div>
                                <span className="text-xs font-bold text-primary-brand">
                                  {ev.grade ?? ev.calificacion ?? "Sin nota"}
                                </span>
                              </div>
                              <div className="grid grid-cols-1 gap-2">
                                <input
                                  type="number"
                                  min="0"
                                  max="100"
                                  value={calificacionesPorEvidencia[ev.id] ?? ev.grade ?? ""}
                                  onChange={(event) => setCalificacionesPorEvidencia({
                                    ...calificacionesPorEvidencia,
                                    [ev.id]: event.target.value
                                  })}
                                  placeholder="Calificación"
                                  className="w-full bg-neutral-800/70 border border-neutral-700 text-white rounded px-3 py-2 text-sm"
                                />
                                <input
                                  type="text"
                                  value={observacionesPorEvidencia[ev.id] ?? ev.feedback ?? ""}
                                  onChange={(event) => setObservacionesPorEvidencia({
                                    ...observacionesPorEvidencia,
                                    [ev.id]: event.target.value
                                  })}
                                  placeholder="Observación"
                                  className="w-full bg-neutral-800/70 border border-neutral-700 text-white rounded px-3 py-2 text-sm"
                                />
                                <button
                                  onClick={() => handleCalificarEvidencia(actividad, ev)}
                                  disabled={calificandoEvidenciaId === ev.id}
                                  className="bg-primary-brand hover:bg-primary-600 text-white rounded px-3 py-2 text-sm font-semibold disabled:opacity-50"
                                >
                                  {calificandoEvidenciaId === ev.id ? "Guardando..." : "Calificar actividad"}
                                </button>
                              </div>
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  )}

                  {!puedeCrear && (
                    <div className="space-y-4">
                      <button
                        onClick={() => handleDescargar(actividad)}
                        className="w-full bg-neutral-700 hover:bg-neutral-600 text-white px-4 py-2 rounded-lg text-sm font-semibold flex items-center justify-center gap-2 transition"
                      >
                        <Download className="w-4 h-4" />
                        Descargar
                      </button>

                      {esEstudiante && (
                        <div className="border-t border-neutral-700 pt-4 space-y-3">
                          <h4 className="text-sm font-bold text-white">Mis Evidencias para esta Actividad</h4>
                          <input
                            type="file"
                            onChange={(e) => setArchivosPorActividad({
                              ...archivosPorActividad,
                              [actividad.id]: e.target.files[0]
                            })}
                            className="block w-full text-xs text-neutral-300 file:mr-3 file:rounded file:border-0 file:bg-primary-brand file:px-3 file:py-2 file:text-white"
                          />
                          <textarea
                            value={descripcionPorActividad[actividad.id] || ""}
                            onChange={(e) => setDescripcionPorActividad({
                              ...descripcionPorActividad,
                              [actividad.id]: e.target.value
                            })}
                            placeholder="Descripción de la evidencia"
                            rows="2"
                            className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-3 py-2 text-sm placeholder-neutral-500 focus:outline-none focus:border-primary-brand"
                          />
                          <button
                            onClick={() => handleSubirEvidencia(actividad.id)}
                            disabled={subiendoActividadId === actividad.id}
                            className="w-full bg-primary-brand hover:bg-primary-600 text-white px-4 py-2 rounded-lg text-sm font-semibold flex items-center justify-center gap-2 transition disabled:opacity-50"
                          >
                            <Upload className="w-4 h-4" />
                            {subiendoActividadId === actividad.id ? "Subiendo..." : "Subir evidencia"}
                          </button>

                          {(evidenciasPorActividad[actividad.id] || []).length === 0 ? (
                            <p className="text-xs text-neutral-500">Aún no has subido evidencias.</p>
                          ) : (
                            <div className="space-y-2">
                              {(evidenciasPorActividad[actividad.id] || []).map((ev) => (
                                <div key={ev.id} className="flex items-center justify-between gap-2 rounded-lg bg-neutral-800/60 p-2">
                                  <span className="text-xs text-neutral-300 truncate">{ev.file_url || "Evidencia"}</span>
                                  <button
                                    onClick={() => handleDescargarEvidencia(ev.id)}
                                    className="text-primary-brand hover:text-primary-300"
                                    title="Descargar evidencia"
                                  >
                                    <Download className="w-4 h-4" />
                                  </button>
                                </div>
                              ))}
                            </div>
                          )}
                        </div>
                      )}
                    </div>
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
                Competencia asociada
              </label>
              <select
                name="competency_id"
                value={formData.competency_id}
                onChange={handleChange}
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              >
                <option value="">Selecciona una competencia</option>
                {competencias.map((competencia) => (
                  <option key={competencia.id} value={competencia.id}>
                    {competencia.name || competencia.nombre}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Resultado de aprendizaje asociado
              </label>
              <select
                name="learning_outcome_id"
                value={formData.learning_outcome_id}
                onChange={handleChange}
                disabled={cargandoCrear || !formData.competency_id || cargandoResultados}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              >
                <option value="">{!formData.competency_id ? "Primero selecciona competencia" : "Selecciona un resultado"}</option>
                {resultados.map((resultado) => (
                  <option key={resultado.id} value={resultado.id}>
                    {resultado.title || resultado.nombre || resultado.id}
                  </option>
                ))}
              </select>
            </div>

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
                    competency_id: "",
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
