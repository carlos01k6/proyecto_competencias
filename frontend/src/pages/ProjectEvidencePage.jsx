import React, { useState } from "react"
import { useActividadesResumen, useEvidenciasProyecto } from "../hooks/useProjectEvidence"
import { FileText, Download } from "lucide-react"

export default function EvidenciasProyectoPage({ usuario }) {
  const { actividades, cargando: cargandoActividades } = useActividadesResumen()
  const [actividadSeleccionada, setActividadSeleccionada] = useState(null)
  const { evidencias, cargando: cargandoEvidencias } = useEvidenciasProyecto(actividadSeleccionada?.id)

  const descargarArchivo = (ruta_archivo, nombre_archivo) => {
    const link = document.createElement("a")
    link.href = ruta_archivo
    link.download = nombre_archivo
    link.click()
  }

  const getEstadoBadge = (estado) => {
    const badges = {
      entregado: "bg-success/20 text-success border border-success/30",
      revisado: "bg-primary-brand/20 text-primary-brand border border-primary-brand/30",
      pendiente: "bg-warning/20 text-warning border border-warning/30",
      rechazado: "bg-danger/20 text-danger border border-danger/30"
    }
    return badges[estado] || "bg-neutral-700 text-neutral-300"
  }

  const formatearFecha = (fecha) => {
    return new Date(fecha).toLocaleDateString("es-ES", {
      year: "numeric",
      month: "long",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit"
    })
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-4">
          <div className="p-3 bg-gradient-to-br from-cyan-600 to-cyan-700 rounded-lg">
            <FileText className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Evidencias por Proyecto</h1>
            <p className="text-neutral-400">Visualiza todas las evidencias agrupadas por actividad/proyecto</p>
          </div>
        </div>
      </div>

      {cargandoActividades ? (
        <div className="text-center text-neutral-400 py-12">
          <div className="inline-block">
            <div className="animate-spin">
              <div className="w-8 h-8 border-4 border-neutral-700 border-t-primary-brand rounded-full"></div>
            </div>
          </div>
          <p className="mt-4">Cargando actividades...</p>
        </div>
      ) : actividades.length === 0 ? (
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 text-center">
          <p className="text-neutral-400 text-lg">No hay actividades con evidencias</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Panel de Actividades */}
          <div className="lg:col-span-1">
            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 sticky top-8">
              <h2 className="text-xl font-bold text-white mb-4">Actividades</h2>
              <div className="space-y-2">
                {actividades.map((actividad) => (
                  <button
                    key={actividad.id}
                    onClick={() => setActividadSeleccionada(actividad)}
                    className={`w-full text-left p-4 rounded-lg transition ${
                      actividadSeleccionada?.id === actividad.id
                        ? "bg-gradient-to-r from-primary-brand to-primary-600 text-white shadow-lg shadow-primary-brand/20"
                        : "bg-neutral-900/50 hover:bg-neutral-900/80 text-neutral-300 hover:text-white border border-neutral-700/50"
                    }`}
                  >
                    <p className="font-semibold text-sm">{actividad.nombre}</p>
                    <div className="text-xs mt-2 opacity-75">
                      <p>📁 {actividad.total_evidencias} evidencias</p>
                      <p>👥 {actividad.total_estudiantes} estudiantes</p>
                    </div>
                  </button>
                ))}
              </div>
            </div>
          </div>

          {/* Panel de Evidencias */}
          <div className="lg:col-span-2">
            {actividadSeleccionada ? (
              cargandoEvidencias ? (
                <div className="text-center text-neutral-400 py-12">
                  <div className="inline-block">
                    <div className="animate-spin">
                      <div className="w-8 h-8 border-4 border-neutral-700 border-t-primary-brand rounded-full"></div>
                    </div>
                  </div>
                  <p className="mt-4">Cargando evidencias...</p>
                </div>
              ) : (
                <div className="space-y-6">
                  {/* Información de la actividad */}
                  <div className="bg-gradient-to-br from-primary-brand/10 to-transparent border border-primary-brand/30 rounded-2xl p-8">
                    <h3 className="text-2xl font-bold text-white mb-2">
                      {evidencias.actividad_nombre}
                    </h3>
                    {evidencias.actividad_descripcion && (
                      <p className="text-neutral-300 mb-6">{evidencias.actividad_descripcion}</p>
                    )}
                    <div className="grid grid-cols-2 gap-4">
                      <div className="bg-neutral-900/50 rounded-lg p-4">
                        <p className="text-xs text-neutral-500">Total de Estudiantes</p>
                        <p className="text-3xl font-bold text-primary-brand">{evidencias.total_estudiantes}</p>
                      </div>
                      <div className="bg-neutral-900/50 rounded-lg p-4">
                        <p className="text-xs text-neutral-500">Total de Evidencias</p>
                        <p className="text-3xl font-bold text-primary-brand">{evidencias.total_evidencias}</p>
                      </div>
                    </div>
                    {evidencias.fecha_limite && (
                      <div className="mt-6 pt-6 border-t border-primary-brand/30">
                        <p className="text-sm text-neutral-300">
                          <span className="font-semibold">Fecha límite:</span> {formatearFecha(evidencias.fecha_limite)}
                        </p>
                      </div>
                    )}
                  </div>

                  {/* Evidencias por estudiante */}
                  <div className="space-y-6">
                    {evidencias.estudiantes && evidencias.estudiantes.map((estudiante) => (
                      <div key={estudiante.estudiante_id} className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden hover:border-neutral-700 transition">
                        <div className="bg-gradient-to-r from-neutral-800/50 to-neutral-900/50 px-6 py-4 border-b border-neutral-700/50">
                          <h4 className="text-lg font-bold text-white">
                            {estudiante.estudiante_id}
                          </h4>
                          <p className="text-sm text-neutral-400 mt-1">
                            {estudiante.evidencias.length} archivo(s) subido(s)
                          </p>
                        </div>

                        <div className="p-6 space-y-3">
                          {estudiante.evidencias.map((evidencia) => (
                            <div
                              key={evidencia.id}
                              className="flex items-center justify-between p-4 border border-neutral-700/50 rounded-lg hover:bg-neutral-900/50 transition bg-neutral-900/20"
                            >
                              <div className="flex-1">
                                <p className="font-semibold text-white text-sm flex items-center gap-2">
                                  <FileText className="w-4 h-4" />
                                  {evidencia.nombre_archivo}
                                </p>
                                <p className="text-xs text-neutral-500 mt-1">
                                  {formatearFecha(evidencia.fecha_subida)}
                                </p>
                                <span className={`inline-block px-3 py-1 rounded-full text-xs font-semibold mt-2 ${getEstadoBadge(evidencia.estado)}`}>
                                  {evidencia.estado.toUpperCase()}
                                </span>
                              </div>
                              <button
                                onClick={() => descargarArchivo(evidencia.ruta_archivo, evidencia.nombre_archivo)}
                                className="ml-4 bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-4 py-2 rounded-lg text-sm font-semibold transition flex items-center gap-2"
                              >
                                <Download className="w-4 h-4" />
                                Descargar
                              </button>
                            </div>
                          ))}
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )
            ) : (
              <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 text-center">
                <p className="text-neutral-400 text-lg">Selecciona una actividad para ver las evidencias</p>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
