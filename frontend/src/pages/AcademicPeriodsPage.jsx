import React, { useState, useEffect } from "react"
import { useConfiguracionPeriodos, useCrearPeriodo, useActualizarTipoPeriodo, usePeriodosPorTipo } from "../hooks/useAcademicPeriods"
import { Calendar } from "lucide-react"

export default function AcademicPeriodsPage({ usuario }) {
  const { configuracion, cargando: cargandoConfig, obtener: obtenerConfig } = useConfiguracionPeriodos()
  const { crear, cargando: cargandoCrear, exito: exitoCrear, error: errorCrear } = useCrearPeriodo()
  const { actualizar, cargando: cargandoActualizar, exito: exitoActualizar } = useActualizarTipoPeriodo()
  const { periodos, cargando: cargandoPeriodos } = usePeriodosPorTipo(configuracion?.period_type)

  const [tab, setTab] = useState("configuracion")
  const [tipoSeleccionado, setTipoSeleccionado] = useState("")

  const [formData, setFormData] = useState({
    nombre: "",
    tipo: "semestre",
    fecha_inicio: "",
    fecha_fin: "",
    orden: 1,
    activo: true
  })

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target
    setFormData({
      ...formData,
      [name]: type === "checkbox" ? checked : value
    })
  }

  const handleCrearPeriodo = async (e) => {
    e.preventDefault()
    if (!formData.nombre || !formData.fecha_inicio || !formData.fecha_fin) {
      alert("Completa todos los campos")
      return
    }
    await crear(formData)
    if (exitoCrear) {
      setFormData({
        nombre: "",
        tipo: "semestre",
        fecha_inicio: "",
        fecha_fin: "",
        orden: 1,
        activo: true
      })
      obtenerConfig()
    }
  }

  const handleCambiarTipo = async (nuevoTipo) => {
    setTipoSeleccionado(nuevoTipo)
    await actualizar(nuevoTipo)
  }

  const formatearFecha = (fecha) => {
    return new Date(fecha).toLocaleDateString("es-ES", {
      year: "numeric",
      month: "long",
      day: "numeric"
    })
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-4">
          <div className="p-3 bg-gradient-to-br from-purple-600 to-purple-700 rounded-lg">
            <Calendar className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Configuración de Períodos Académicos</h1>
            <p className="text-neutral-400">Configura bimestres, trimestres o semestres para tu institución</p>
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex gap-2 mb-6 border-b border-neutral-700">
        <button
          onClick={() => setTab("configuracion")}
          className={`px-6 py-3 font-semibold border-b-2 transition ${
            tab === "configuracion"
              ? "border-primary-brand text-primary-brand"
              : "border-transparent text-neutral-400 hover:text-neutral-200"
          }`}
        >
          Configuración
        </button>
        <button
          onClick={() => setTab("crear")}
          className={`px-6 py-3 font-semibold border-b-2 transition ${
            tab === "crear"
              ? "border-primary-brand text-primary-brand"
              : "border-transparent text-neutral-400 hover:text-neutral-200"
          }`}
        >
          Crear Período
        </button>
      </div>

      {/* TAB: CONFIGURACIÓN */}
      {tab === "configuracion" && (
        <div className="space-y-6">
          {cargandoConfig ? (
            <div className="text-center text-neutral-400 py-12">
              <div className="inline-block">
                <div className="animate-spin">
                  <div className="w-8 h-8 border-4 border-neutral-700 border-t-primary-brand rounded-full"></div>
                </div>
              </div>
              <p className="mt-4">Cargando configuración...</p>
            </div>
          ) : (
            <div className="space-y-6">
              {/* Año Académico */}
              <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8">
                <h2 className="text-lg font-bold text-white mb-4">Año Académico Actual</h2>
                <div className="bg-primary-brand/10 border border-primary-brand/30 rounded-lg p-6">
                  <p className="text-sm text-neutral-400 mb-2">Año:</p>
                  <p className="text-5xl font-bold text-primary-brand">{configuracion?.academic_year}</p>
                </div>
              </div>

              {/* Tipo de Período */}
              <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8">
                <h2 className="text-lg font-bold text-white mb-4">Tipo de Período Académico</h2>
                <p className="text-sm text-neutral-400 mb-6">Selecciona cómo dividir el año académico:</p>

                <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                  {configuracion?.disponibles?.map((tipo) => (
                    <button
                      key={tipo}
                      onClick={() => handleCambiarTipo(tipo)}
                      disabled={cargandoActualizar}
                      className={`p-6 rounded-lg border-2 transition text-center font-semibold ${
                        configuracion?.period_type === tipo
                          ? "border-primary-brand bg-primary-brand/10 text-primary-brand"
                          : "border-neutral-700 text-neutral-300 hover:border-primary-brand"
                      }`}
                    >
                      {tipo.charAt(0).toUpperCase() + tipo.slice(1)}
                      {tipo === "bimestre" && <p className="text-xs text-neutral-400 mt-2">2 períodos</p>}
                      {tipo === "trimestre" && <p className="text-xs text-neutral-400 mt-2">3 períodos</p>}
                      {tipo === "semestre" && <p className="text-xs text-neutral-400 mt-2">2 períodos</p>}
                    </button>
                  ))}
                </div>

                {exitoActualizar && (
                  <div className="bg-success/10 border border-success/30 rounded-lg p-4">
                    <p className="text-success font-semibold">✓ Tipo de período actualizado</p>
                  </div>
                )}
              </div>

              {/* Períodos Actuales */}
              {configuracion?.period_type && (
                <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8">
                  <h2 className="text-lg font-bold text-white mb-4">
                    Períodos {configuracion?.period_type?.charAt(0).toUpperCase() + configuracion?.period_type?.slice(1)}
                  </h2>

                  {cargandoPeriodos ? (
                    <p className="text-neutral-400">Cargando períodos...</p>
                  ) : periodos.length > 0 ? (
                    <div className="space-y-3">
                      {periodos.map((periodo, idx) => (
                        <div key={idx} className="border border-neutral-700/50 rounded-lg p-4 flex justify-between items-center bg-neutral-900/50 hover:border-primary-brand/30 transition">
                          <div>
                            <p className="font-semibold text-white">{periodo.description || periodo.nombre || periodo.key}</p>
                            {(periodo.fecha_inicio || periodo.fecha_fin) && (
                              <p className="text-sm text-neutral-400 mt-1">
                                {periodo.fecha_inicio ? formatearFecha(periodo.fecha_inicio) : '?'} → {periodo.fecha_fin ? formatearFecha(periodo.fecha_fin) : '?'}
                              </p>
                            )}
                          </div>
                          <span className="bg-success/20 text-success px-3 py-1 rounded-full text-sm font-semibold border border-success/30">
                            Activo
                          </span>
                        </div>
                      ))}
                    </div>
                  ) : (
                    <p className="text-neutral-400">No hay períodos configurados. Crea uno nuevo.</p>
                  )}
                </div>
              )}
            </div>
          )}
        </div>
      )}

      {/* TAB: CREAR PERÍODO */}
      {tab === "crear" && (
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8 max-w-2xl">
          <h2 className="text-2xl font-bold text-white mb-6">Crear Nuevo Período</h2>

          {errorCrear && (
            <div className="bg-danger/10 border border-danger/30 rounded-lg p-4 mb-6">
              <p className="text-danger font-semibold">Error: {errorCrear}</p>
            </div>
          )}

          {exitoCrear && (
            <div className="bg-success/10 border border-success/30 rounded-lg p-4 mb-6">
              <p className="text-success font-semibold">✓ Período creado exitosamente</p>
            </div>
          )}

          <form onSubmit={handleCrearPeriodo} className="space-y-5">
            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Nombre del Período *
              </label>
              <input
                type="text"
                name="nombre"
                value={formData.nombre}
                onChange={handleChange}
                placeholder="Ej: Primer Bimestre, Primer Trimestre"
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
              />
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-semibold text-white mb-2">
                  Tipo de Período *
                </label>
                <select
                  name="tipo"
                  value={formData.tipo}
                  onChange={handleChange}
                  className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
                >
                  <option value="bimestre">Bimestre</option>
                  <option value="trimestre">Trimestre</option>
                  <option value="semestre">Semestre</option>
                </select>
              </div>

              <div>
                <label className="block text-sm font-semibold text-white mb-2">
                  Orden *
                </label>
                <input
                  type="number"
                  name="orden"
                  value={formData.orden}
                  onChange={handleChange}
                  min="1"
                  max="4"
                  className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
                />
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-semibold text-white mb-2">
                  Fecha de Inicio *
                </label>
                <input
                  type="date"
                  name="fecha_inicio"
                  value={formData.fecha_inicio}
                  onChange={handleChange}
                  className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
                />
              </div>

              <div>
                <label className="block text-sm font-semibold text-white mb-2">
                  Fecha de Fin *
                </label>
                <input
                  type="date"
                  name="fecha_fin"
                  value={formData.fecha_fin}
                  onChange={handleChange}
                  className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
                />
              </div>
            </div>

            <div className="flex items-center gap-3">
              <input
                type="checkbox"
                name="activo"
                id="activo"
                checked={formData.activo}
                onChange={handleChange}
                className="w-4 h-4 rounded border-neutral-700"
              />
              <label htmlFor="activo" className="text-sm font-semibold text-white">
                Período activo
              </label>
            </div>

            <div className="flex gap-3 pt-4">
              <button
                type="submit"
                disabled={cargandoCrear}
                className="flex-1 bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white py-3 rounded-lg font-semibold transition disabled:opacity-50"
              >
                {cargandoCrear ? "Creando..." : "+ Crear Período"}
              </button>
              <button
                type="button"
                onClick={() => setTab("configuracion")}
                className="flex-1 bg-neutral-700 hover:bg-neutral-600 text-white py-3 rounded-lg font-semibold transition"
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
