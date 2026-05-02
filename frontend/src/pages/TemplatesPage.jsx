import React, { useMemo, useState } from "react"
import {
  Eye,
  LayoutTemplate,
  Loader2,
  Pencil,
  Plus,
  Save,
  Trash2,
  Wand2
} from "lucide-react"
import {
  useAplicarPlantilla,
  useEliminarPlantilla,
  useGuardarPlantilla,
  usePlantillas
} from "../hooks/useTemplates"
import { useCompetencias } from "../hooks/useCompetencies"

const contenidoInicial = {
  niveles: [
    { nivel: 1, descripcion: "Insuficiente", rango_min: 0, rango_max: 39 },
    { nivel: 2, descripcion: "Basico", rango_min: 40, rango_max: 69 },
    { nivel: 3, descripcion: "Intermedio", rango_min: 70, rango_max: 84 },
    { nivel: 4, descripcion: "Avanzado", rango_min: 85, rango_max: 100 }
  ]
}

function formatearFecha(fecha) {
  if (!fecha) return "Sin fecha"
  return new Date(fecha).toLocaleDateString("es-ES", {
    year: "numeric",
    month: "short",
    day: "numeric"
  })
}

function formatearJson(valor) {
  return JSON.stringify(valor || {}, null, 2)
}

function crearFormVacio() {
  return {
    id: null,
    nombre: "",
    descripcion: "",
    contenidoTexto: formatearJson(contenidoInicial)
  }
}

export default function PlantillasPage({ usuario }) {
  const { plantillas, cargando, error, obtenerPlantillas } = usePlantillas()
  const { crear, actualizar, cargando: guardando, error: errorGuardar } = useGuardarPlantilla()
  const { eliminar, cargando: eliminando, error: errorEliminar } = useEliminarPlantilla()
  const { aplicar, cargando: aplicando, error: errorAplicar } = useAplicarPlantilla()
  const { competencias, loading: cargandoCompetencias } = useCompetencias()

  const [formData, setFormData] = useState(crearFormVacio())
  const [modoFormulario, setModoFormulario] = useState(false)
  const [plantillaPreview, setPlantillaPreview] = useState(null)
  const [competenciaId, setCompetenciaId] = useState("")
  const [mensaje, setMensaje] = useState("")
  const [errorLocal, setErrorLocal] = useState("")

  const rolUsuario = usuario?.rol?.toLowerCase()
  const puedeGestionar = rolUsuario === "teacher" || rolUsuario === "docente" || rolUsuario === "admin"

  const errorVisible = error || errorGuardar || errorEliminar || errorAplicar || errorLocal

  const plantillasOrdenadas = useMemo(
    () => [...plantillas].sort((a, b) => (a.nombre || "").localeCompare(b.nombre || "")),
    [plantillas]
  )

  const abrirCrear = () => {
    setFormData(crearFormVacio())
    setModoFormulario(true)
    setErrorLocal("")
    setMensaje("")
  }

  const abrirEditar = (plantilla) => {
    setFormData({
      id: plantilla.id,
      nombre: plantilla.nombre || "",
      descripcion: plantilla.descripcion || "",
      contenidoTexto: formatearJson(plantilla.contenido || {})
    })
    setModoFormulario(true)
    setErrorLocal("")
    setMensaje("")
  }

  const cancelarFormulario = () => {
    setFormData(crearFormVacio())
    setModoFormulario(false)
    setErrorLocal("")
  }

  const handleChange = (event) => {
    const { name, value } = event.target
    setFormData((actual) => ({ ...actual, [name]: value }))
  }

  const parsearContenido = () => {
    try {
      return JSON.parse(formData.contenidoTexto || "{}")
    } catch (err) {
      throw new Error("El contenido debe ser JSON valido")
    }
  }

  const guardarPlantilla = async (event) => {
    event.preventDefault()
    setMensaje("")
    setErrorLocal("")

    if (!formData.nombre.trim()) {
      setErrorLocal("El nombre es obligatorio")
      return
    }

    try {
      const payload = {
        nombre: formData.nombre.trim(),
        descripcion: formData.descripcion.trim(),
        contenido: parsearContenido()
      }

      if (formData.id) {
        await actualizar(formData.id, payload)
        setMensaje("Plantilla actualizada correctamente")
      } else {
        await crear(payload)
        setMensaje("Plantilla creada correctamente")
      }

      cancelarFormulario()
      obtenerPlantillas()
    } catch (err) {
      setErrorLocal(err.message)
    }
  }

  const eliminarPlantilla = async (plantillaId) => {
    if (!window.confirm("Eliminar esta plantilla?")) return

    const eliminada = await eliminar(plantillaId)
    if (eliminada) {
      setMensaje("Plantilla eliminada")
      obtenerPlantillas()
      if (plantillaPreview?.id === plantillaId) {
        setPlantillaPreview(null)
      }
    }
  }

  const usarPlantilla = async (plantillaId) => {
    setMensaje("")
    setErrorLocal("")

    if (!competenciaId) {
      setErrorLocal("Selecciona una competencia antes de usar la plantilla")
      return
    }

    try {
      await aplicar(plantillaId, competenciaId)
      setMensaje("Plantilla aplicada: se creo una rubrica para la competencia seleccionada")
    } catch (err) {
      setErrorLocal(err.message)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
          <div className="flex items-center gap-3">
            <div className="p-3 bg-gradient-to-br from-rose-600 to-rose-700 rounded-lg">
              <LayoutTemplate className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-4xl font-bold text-white">Plantillas de Rubricas</h1>
              <p className="text-neutral-400">Crea, previsualiza y aplica plantillas a competencias</p>
            </div>
          </div>

          {puedeGestionar && (
            <button
              onClick={abrirCrear}
              className="bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-6 py-3 rounded-lg font-semibold flex items-center justify-center gap-2 transition"
            >
              <Plus className="w-5 h-5" />
              Crear Plantilla
            </button>
          )}
        </div>
      </div>

      {errorVisible && (
        <div className="bg-danger/10 border border-danger/30 rounded-lg p-4 mb-6">
          <p className="text-danger font-semibold">{errorVisible}</p>
        </div>
      )}

      {mensaje && (
        <div className="bg-success/10 border border-success/30 rounded-lg p-4 mb-6">
          <p className="text-success font-semibold">{mensaje}</p>
        </div>
      )}

      {modoFormulario && puedeGestionar && (
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 mb-6">
          <h2 className="text-2xl font-bold text-white mb-5">
            {formData.id ? "Editar Plantilla" : "Crear Plantilla"}
          </h2>

          <form onSubmit={guardarPlantilla} className="space-y-5">
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
              <label className="block">
                <span className="text-sm font-semibold text-neutral-300">Nombre</span>
                <input
                  type="text"
                  name="nombre"
                  value={formData.nombre}
                  onChange={handleChange}
                  disabled={guardando}
                  className="mt-2 w-full bg-neutral-950 border border-neutral-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-primary-brand"
                  placeholder="Rubrica de proyecto final"
                />
              </label>

              <label className="block">
                <span className="text-sm font-semibold text-neutral-300">Descripcion</span>
                <input
                  type="text"
                  name="descripcion"
                  value={formData.descripcion}
                  onChange={handleChange}
                  disabled={guardando}
                  className="mt-2 w-full bg-neutral-950 border border-neutral-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-primary-brand"
                  placeholder="Plantilla base para evaluar entregables"
                />
              </label>
            </div>

            <label className="block">
              <span className="text-sm font-semibold text-neutral-300">Contenido JSON</span>
              <textarea
                name="contenidoTexto"
                value={formData.contenidoTexto}
                onChange={handleChange}
                disabled={guardando}
                rows="12"
                className="mt-2 w-full bg-neutral-950 border border-neutral-700 text-white rounded-lg px-4 py-3 font-mono text-sm focus:outline-none focus:border-primary-brand"
              />
            </label>

            <div className="flex flex-col sm:flex-row gap-3">
              <button
                type="submit"
                disabled={guardando}
                className="bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 disabled:opacity-50 text-white px-6 py-3 rounded-lg font-semibold flex items-center justify-center gap-2 transition"
              >
                {guardando ? <Loader2 className="w-5 h-5 animate-spin" /> : <Save className="w-5 h-5" />}
                Guardar Plantilla
              </button>
              <button
                type="button"
                onClick={cancelarFormulario}
                disabled={guardando}
                className="bg-neutral-700 hover:bg-neutral-600 disabled:opacity-50 text-white px-6 py-3 rounded-lg font-semibold transition"
              >
                Cancelar
              </button>
            </div>
          </form>
        </div>
      )}

      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 mb-6">
        <label className="block max-w-xl">
          <span className="text-sm font-semibold text-neutral-300">Competencia para usar plantilla</span>
          <select
            value={competenciaId}
            onChange={(event) => setCompetenciaId(event.target.value)}
            disabled={cargandoCompetencias}
            className="mt-2 w-full bg-neutral-950 border border-neutral-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-primary-brand"
          >
            <option value="">Selecciona una competencia</option>
            {competencias.map((competencia) => (
              <option key={competencia.id} value={competencia.id}>
                {competencia.name || competencia.nombre || competencia.id}
              </option>
            ))}
          </select>
        </label>
      </div>

      <div className="grid grid-cols-1 xl:grid-cols-[minmax(0,1fr)_420px] gap-6">
        <div className="space-y-4">
          {cargando ? (
            <div className="flex items-center justify-center py-12 text-neutral-400">
              <Loader2 className="w-7 h-7 animate-spin mr-2" />
              Cargando plantillas
            </div>
          ) : plantillasOrdenadas.length === 0 ? (
            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 text-center">
              <p className="text-neutral-400 text-lg mb-4">No hay plantillas guardadas.</p>
              {puedeGestionar && (
                <button
                  onClick={abrirCrear}
                  className="bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-6 py-3 rounded-lg font-semibold inline-flex items-center gap-2 transition"
                >
                  <Plus className="w-5 h-5" />
                  Crear Plantilla
                </button>
              )}
            </div>
          ) : (
            plantillasOrdenadas.map((plantilla) => (
              <div
                key={plantilla.id}
                className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 hover:border-primary-brand/40 rounded-2xl p-6 transition"
              >
                <div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                  <div className="min-w-0">
                    <h3 className="text-xl font-bold text-white">{plantilla.nombre}</h3>
                    <p className="text-neutral-400 text-sm mt-1">{plantilla.descripcion || "Sin descripcion"}</p>
                    <p className="text-neutral-500 text-xs mt-3">Creada: {formatearFecha(plantilla.created_at)}</p>
                  </div>

                  <div className="flex flex-wrap gap-2">
                    <button
                      onClick={() => setPlantillaPreview(plantilla)}
                      className="bg-neutral-700 hover:bg-neutral-600 text-white px-3 py-2 rounded-lg text-sm font-semibold inline-flex items-center gap-2 transition"
                    >
                      <Eye className="w-4 h-4" />
                      Preview
                    </button>
                    {puedeGestionar && (
                      <button
                        onClick={() => usarPlantilla(plantilla.id)}
                        disabled={aplicando || !competenciaId}
                        className="bg-emerald-600 hover:bg-emerald-700 disabled:opacity-50 disabled:cursor-not-allowed text-white px-3 py-2 rounded-lg text-sm font-semibold inline-flex items-center gap-2 transition"
                      >
                        <Wand2 className="w-4 h-4" />
                        Usar Plantilla
                      </button>
                    )}
                    {puedeGestionar && (
                      <button
                        onClick={() => abrirEditar(plantilla)}
                        className="bg-primary-brand hover:bg-primary-600 text-white px-3 py-2 rounded-lg text-sm font-semibold inline-flex items-center gap-2 transition"
                      >
                        <Pencil className="w-4 h-4" />
                        Editar
                      </button>
                    )}
                    {puedeGestionar && (
                      <button
                        onClick={() => eliminarPlantilla(plantilla.id)}
                        disabled={eliminando}
                        className="bg-danger hover:bg-red-700 disabled:opacity-50 text-white px-3 py-2 rounded-lg text-sm font-semibold inline-flex items-center gap-2 transition"
                      >
                        <Trash2 className="w-4 h-4" />
                        Eliminar
                      </button>
                    )}
                  </div>
                </div>
              </div>
            ))
          )}
        </div>

        <aside className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 h-fit">
          <div className="flex items-center gap-2 mb-4">
            <Eye className="w-5 h-5 text-primary-brand" />
            <h2 className="text-lg font-bold text-white">Preview de Contenido</h2>
          </div>

          {plantillaPreview ? (
            <div>
              <h3 className="font-semibold text-white mb-1">{plantillaPreview.nombre}</h3>
              <p className="text-sm text-neutral-400 mb-4">{plantillaPreview.descripcion || "Sin descripcion"}</p>
              <pre className="bg-neutral-950 border border-neutral-700 rounded-lg p-4 text-xs text-neutral-200 overflow-auto max-h-[520px]">
                {formatearJson(plantillaPreview.contenido)}
              </pre>
            </div>
          ) : (
            <p className="text-neutral-400">Selecciona Preview en una plantilla para ver su JSON.</p>
          )}
        </aside>
      </div>
    </div>
  )
}

