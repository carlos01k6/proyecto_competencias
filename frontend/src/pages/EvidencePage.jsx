import React, { useMemo, useState } from "react"
import { useEvidencias } from "../hooks/useEvidence"
import { useActividades } from "../hooks/useActivities"
import * as evidenciasService from "../services/evidence"
import { FileText, Plus, Search, Trash2, Download } from "lucide-react"

export default function EvidenciasPage({ usuario }) {
  const rolUsuario = usuario?.rol?.toLowerCase()
  const puedeSubir = rolUsuario === "student"
  const puedeRevisar = rolUsuario === "teacher" || rolUsuario === "admin" || rolUsuario === "docente"
  const { evidencias, cargando, agregarEvidencia, eliminarEvidencia, obtenerEvidencias } = useEvidencias(null, puedeSubir ? usuario?.id : null)
  const { actividades, cargando: cargandoActividades } = useActividades()
  
  const [busqueda, setBusqueda] = useState("")
  const [tab, setTab] = useState("ver")
  const [cargandoCrear, setCargandoCrear] = useState(false)
  const [exitoCrear, setExitoCrear] = useState(false)
  const [formData, setFormData] = useState({
    nombre: "",
    archivo: null,
    descripcion: "",
    activity_id: ""
  })

  const nombresActividades = useMemo(() => {
    return actividades.reduce((mapa, actividad) => {
      mapa[actividad.id] = actividad.title || actividad.name || actividad.nombre || actividad.id
      return mapa
    }, {})
  }, [actividades])

  const obtenerNombreActividad = (evidencia) => {
    return evidencia.activity_name ||
      evidencia.actividad_nombre ||
      nombresActividades[evidencia.activity_id] ||
      evidencia.activity_id ||
      "Sin actividad"
  }

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData({
      ...formData,
      [name]: value
    })
  }

  const handleFileChange = (e) => {
    setFormData({
      ...formData,
      archivo: e.target.files[0]
    })
  }

  const handleCrear = async (e) => {
    e.preventDefault()
    if (!formData.archivo || !formData.activity_id) {
      alert("Archivo y actividad son obligatorios")
      return
    }

    setCargandoCrear(true)
    try {
      const data = new FormData()
      data.append("nombre", formData.archivo.name)
      data.append("archivo", formData.archivo)
      data.append("descripcion", formData.descripcion)
      data.append("activity_id", formData.activity_id)
      data.append("student_id", usuario.id)

      await agregarEvidencia(data)
      setExitoCrear(true)
      setFormData({
        nombre: "",
        archivo: null,
        descripcion: "",
        activity_id: ""
      })
      setTimeout(() => {
        setExitoCrear(false)
        setTab("ver")
        obtenerEvidencias()
      }, 2000)
    } catch (error) {
      alert("Error al subir evidencia: " + (error.response?.data?.mensaje || error.response?.data?.error || error.message))
    } finally {
      setCargandoCrear(false)
    }
  }

  const handleEliminar = async (evidencia_id) => {
    if (window.confirm("¿Eliminar esta evidencia?")) {
      try {
        await eliminarEvidencia(evidencia_id)
        obtenerEvidencias()
      } catch (error) {
        alert("Error al eliminar: " + (error.response?.data?.mensaje || error.message))
      }
    }
  }

  const handleDescargar = async (evidencia_id) => {
    try {
      const data = await evidenciasService.descargarEvidencia(evidencia_id)
      if (data.file_url) {
        window.open(data.file_url, "_blank", "noopener,noreferrer")
      }
    } catch (error) {
      alert("Error al descargar: " + (error.response?.data?.error || error.message))
    }
  }

  const filtrados = evidencias.filter(e =>
    e.file_url?.toLowerCase().includes(busqueda.toLowerCase()) ||
    e.status?.toLowerCase().includes(busqueda.toLowerCase()) ||
    obtenerNombreActividad(e).toLowerCase().includes(busqueda.toLowerCase())
  )

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="p-3 bg-gradient-to-br from-cyan-600 to-cyan-700 rounded-lg">
              <FileText className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-4xl font-bold text-white">Evidencias</h1>
              <p className="text-neutral-400">
                {puedeSubir ? "Sube tus archivos de evidencia" : "Revisa las evidencias de los estudiantes"}
              </p>
            </div>
          </div>
          {puedeSubir && (
            <button
              onClick={() => setTab("subir")}
              className="bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-6 py-3 rounded-lg font-semibold flex items-center gap-2 transition"
            >
              <Plus className="w-5 h-5" />
              Subir Evidencia
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
          Ver Evidencias
        </button>
        {puedeSubir && (
          <button
            onClick={() => setTab("subir")}
            className={`px-6 py-3 font-semibold border-b-2 transition ${
              tab === "subir"
                ? "border-primary-brand text-primary-brand"
                : "border-transparent text-neutral-400 hover:text-neutral-200"
            }`}
          >
            Subir Nueva
          </button>
        )}
      </div>

      {/* VER EVIDENCIAS */}
      {tab === "ver" && (
        <div className="space-y-6">
          {/* Búsqueda */}
          {evidencias.length > 0 && (
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-neutral-500" />
              <input
                type="text"
                placeholder="Buscar evidencia..."
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
                <p className="text-neutral-400">No hay evidencias disponibles</p>
              </div>
            ) : (
              <table className="w-full">
                <thead>
                  <tr className="border-b border-neutral-700/50 bg-neutral-900/50">
                    <th className="px-6 py-4 text-left font-semibold text-neutral-300">Archivo</th>
                    <th className="px-6 py-4 text-left font-semibold text-neutral-300">Actividad</th>
                    <th className="px-6 py-4 text-left font-semibold text-neutral-300">Fecha</th>
                    <th className="px-6 py-4 text-left font-semibold text-neutral-300">Estado</th>
                    <th className="px-6 py-4 text-right font-semibold text-neutral-300">Acciones</th>
                  </tr>
                </thead>
                <tbody>
                  {filtrados.map((ev) => (
                    <tr key={ev.id} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition group">
                      <td className="px-6 py-4 text-white font-semibold">{ev.file_url || "Sin archivo"}</td>
                      <td className="px-6 py-4 text-neutral-300 text-sm font-medium">{obtenerNombreActividad(ev)}</td>
                      <td className="px-6 py-4 text-neutral-400 text-sm">
                        {ev.delivery_date || ev.send_date ? new Date(ev.delivery_date || ev.send_date).toLocaleDateString("es-ES") : "N/A"}
                      </td>
                      <td className="px-6 py-4">
                        <span className={`px-3 py-1 rounded-full text-xs font-semibold ${
                          ev.status === "aprobado"
                            ? "bg-success/20 text-success"
                            : ev.status === "rechazado"
                            ? "bg-danger/20 text-danger"
                            : "bg-warning/20 text-warning"
                        }`}>
                          {ev.status === "aprobado" ? "✓ Aprobado" : ev.status === "rechazado" ? "✗ Rechazado" : "⏳ Pendiente"}
                        </span>
                      </td>
                      <td className="px-6 py-4 text-right">
                        <div className="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition">
                          <button
                            onClick={() => handleDescargar(ev.id)}
                            className="p-2 hover:bg-neutral-800 rounded-lg transition text-info"
                          >
                            <Download className="w-4 h-4" />
                          </button>
                          {puedeSubir && (
                            <button
                              onClick={() => handleEliminar(ev.id)}
                              className="p-2 hover:bg-danger/10 rounded-lg transition text-danger"
                            >
                              <Trash2 className="w-4 h-4" />
                            </button>
                          )}
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

      {/* SUBIR EVIDENCIA */}
      {tab === "subir" && puedeSubir && (
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8 max-w-2xl">
          <h2 className="text-2xl font-bold text-white mb-6">Subir Nueva Evidencia</h2>

          <form onSubmit={handleCrear} className="space-y-5">
            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Nombre de la Evidencia *
              </label>
              <input
                type="text"
                name="nombre"
                value={formData.nombre}
                onChange={handleChange}
                placeholder="Ej: Proyecto Final"
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Archivo *
              </label>
              <div className="border-2 border-dashed border-neutral-700 rounded-lg p-6 text-center hover:border-primary-brand/50 transition cursor-pointer">
                <input
                  type="file"
                  onChange={handleFileChange}
                  disabled={cargandoCrear}
                  className="hidden"
                  id="file-input"
                />
                <label htmlFor="file-input" className="cursor-pointer">
                  <p className="text-neutral-400">
                    {formData.archivo ? formData.archivo.name : "Arrastra un archivo aquí o haz clic"}
                  </p>
                </label>
              </div>
            </div>

            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Actividad *
              </label>
              <select
                name="activity_id"
                value={formData.activity_id}
                onChange={handleChange}
                disabled={cargandoCrear || cargandoActividades}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              >
                <option value="">{cargandoActividades ? "Cargando actividades..." : "Selecciona una actividad"}</option>
                {actividades.map((actividad) => (
                  <option key={actividad.id} value={actividad.id}>
                    {actividad.title || actividad.name || actividad.nombre || actividad.id}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Descripción (opcional)
              </label>
              <textarea
                name="descripcion"
                value={formData.descripcion}
                onChange={handleChange}
                placeholder="Describe lo que has hecho..."
                rows="4"
                disabled={cargandoCrear}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
              />
            </div>

            {exitoCrear && (
              <div className="bg-success/10 border border-success/30 rounded-lg p-4">
                <p className="text-success font-semibold">✓ Evidencia subida correctamente</p>
              </div>
            )}

            <div className="flex gap-3 pt-4">
              <button
                type="submit"
                disabled={cargandoCrear}
                className="flex-1 bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white py-3 rounded-lg font-semibold transition disabled:opacity-50"
              >
                {cargandoCrear ? "Subiendo..." : "+ Subir Evidencia"}
              </button>
              <button
                type="button"
                onClick={() => {
                  setTab("ver")
                  setFormData({
                    nombre: "",
                    archivo: null,
                    descripcion: "",
                    activity_id: ""
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



