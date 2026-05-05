import React, { useEffect, useMemo, useState } from "react"
import { useLogAuditoria, useResumenDocente } from "../hooks/useAudit"
import { obtenerUsuarios } from "../services/users"
import { Shield } from "lucide-react"

export default function AuditoriaPage({ usuario }) {
  const [tab, setTab] = useState("log")
  const [estudiante_id, setEstudiante_id] = useState("")
  const [docente_id, setDocente_id] = useState("")
  const [usuarios, setUsuarios] = useState([])
  const [cargandoUsuarios, setCargandoUsuarios] = useState(false)
  const [errorUsuarios, setErrorUsuarios] = useState(null)
  const { log, cargando: cargandoLog } = useLogAuditoria(estudiante_id || null)
  const { resumen, cargando: cargandoResumen } = useResumenDocente(docente_id)

  useEffect(() => {
    const cargarUsuarios = async () => {
      setCargandoUsuarios(true)
      setErrorUsuarios(null)
      try {
        const data = await obtenerUsuarios()
        setUsuarios(Array.isArray(data) ? data : [])
      } catch (err) {
        setUsuarios([])
        setErrorUsuarios(err.response?.data?.error || err.message)
      } finally {
        setCargandoUsuarios(false)
      }
    }

    cargarUsuarios()
  }, [])

  const estudiantes = useMemo(() => {
    return usuarios.filter((user) => {
      const role = (user.role || user.rol || "").toLowerCase()
      return role === "student" || role === "estudiante"
    })
  }, [usuarios])

  const docentes = useMemo(() => {
    return usuarios.filter((user) => {
      const role = (user.role || user.rol || "").toLowerCase()
      return role === "teacher" || role === "docente"
    })
  }, [usuarios])

  const usuariosPorId = useMemo(() => {
    return Object.fromEntries(usuarios.map((user) => [user.id, user]))
  }, [usuarios])

  const obtenerNombreUsuario = (id) => {
    const user = usuariosPorId[id]
    return user?.nombre || user?.name || user?.email || id
  }

  const obtenerFechaRegistro = (registro) => {
    return registro.fecha_registro || registro.action_date || registro.created_at
  }

  const obtenerAccion = (registro) => {
    return registro.accion || registro.action
  }

  const formatearFecha = (fecha) => {
    if (!fecha) return "-"
    return new Date(fecha).toLocaleDateString("es-ES", {
      year: "numeric",
      month: "long",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit",
      second: "2-digit"
    })
  }

  const getAccionColor = (accion) => {
    const colores = {
      crear: "bg-success/20 text-success border border-success/30",
      actualizar: "bg-primary-brand/20 text-primary-brand border border-primary-brand/30",
      eliminar: "bg-danger/20 text-danger border border-danger/30",
      ver: "bg-neutral-700/50 text-neutral-300 border border-neutral-700"
    }
    return colores[accion?.toLowerCase()] || "bg-neutral-700 text-neutral-300"
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-4">
          <div className="p-3 bg-gradient-to-br from-red-600 to-red-700 rounded-lg">
            <Shield className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Auditoría del Sistema</h1>
            <p className="text-neutral-400">Registro de cambios y actividades en el sistema</p>
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex gap-2 mb-6 border-b border-neutral-700">
        <button
          onClick={() => setTab("log")}
          className={`px-6 py-3 font-semibold border-b-2 transition ${
            tab === "log"
              ? "border-primary-brand text-primary-brand"
              : "border-transparent text-neutral-400 hover:text-neutral-200"
          }`}
        >
          Log Completo
        </button>
        <button
          onClick={() => setTab("resumen")}
          className={`px-6 py-3 font-semibold border-b-2 transition ${
            tab === "resumen"
              ? "border-primary-brand text-primary-brand"
              : "border-transparent text-neutral-400 hover:text-neutral-200"
          }`}
        >
          Resumen por Docente
        </button>
      </div>

      {/* TAB: LOG COMPLETO */}
      {tab === "log" && (
        <div className="space-y-6">
          <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
            <label className="block text-sm font-semibold text-white mb-3">
              Filtrar por estudiante (opcional)
            </label>
            <select
              value={estudiante_id}
              onChange={(e) => setEstudiante_id(e.target.value)}
              className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
            >
              <option value="">
                {cargandoUsuarios ? "Cargando estudiantes..." : "Todos los estudiantes"}
              </option>
              {estudiantes.map((estudiante) => (
                <option key={estudiante.id} value={estudiante.id}>
                  {estudiante.nombre || estudiante.name || estudiante.email} - {estudiante.email}
                </option>
              ))}
            </select>
            {errorUsuarios && (
              <p className="text-danger text-sm mt-3">Error cargando usuarios: {errorUsuarios}</p>
            )}
          </div>

          {cargandoLog ? (
            <div className="text-center text-neutral-400 py-12">
              <div className="inline-block">
                <div className="animate-spin">
                  <div className="w-8 h-8 border-4 border-neutral-700 border-t-primary-brand rounded-full"></div>
                </div>
              </div>
              <p className="mt-4">Cargando log de auditoría...</p>
            </div>
          ) : log.length === 0 ? (
            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 text-center">
              <p className="text-neutral-400 text-lg">No hay registros de auditoría</p>
            </div>
          ) : (
            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="bg-neutral-900/50 border-b border-neutral-700/50">
                      <th className="px-6 py-4 text-left font-semibold text-neutral-300 text-sm">Fecha</th>
                      <th className="px-6 py-4 text-left font-semibold text-neutral-300 text-sm">Acción</th>
                      <th className="px-6 py-4 text-left font-semibold text-neutral-300 text-sm">Usuario</th>
                      <th className="px-6 py-4 text-left font-semibold text-neutral-300 text-sm">Estudiante</th>
                      <th className="px-6 py-4 text-left font-semibold text-neutral-300 text-sm">Criterio</th>
                      <th className="px-6 py-4 text-left font-semibold text-neutral-300 text-sm">Calificación</th>
                    </tr>
                  </thead>
                  <tbody>
                    {log.map((registro, idx) => (
                      <tr key={idx} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition">
                        <td className="px-6 py-4 text-neutral-400 text-sm">
                          {formatearFecha(obtenerFechaRegistro(registro))}
                        </td>
                        <td className="px-6 py-4">
                          <span className={`px-3 py-1 rounded-full text-xs font-semibold ${getAccionColor(obtenerAccion(registro))}`}>
                            {obtenerAccion(registro)?.toUpperCase() || "-"}
                          </span>
                        </td>
                        <td className="px-6 py-4 text-white text-sm font-semibold">
                          {obtenerNombreUsuario(registro.usuario_id || registro.user_id)}
                          <p className="text-xs text-neutral-500 font-normal">
                            {(registro.usuario_id || registro.user_id)?.substring(0, 8) || "-"}...
                          </p>
                        </td>
                        <td className="px-6 py-4 text-neutral-400 text-sm">
                          {registro.estudiante_id || registro.student_id ? (
                            <>
                              <span className="text-neutral-200">
                                {obtenerNombreUsuario(registro.estudiante_id || registro.student_id)}
                              </span>
                              <p className="text-xs text-neutral-500">
                                {(registro.estudiante_id || registro.student_id)?.substring(0, 8)}...
                              </p>
                            </>
                          ) : "-"}
                        </td>
                        <td className="px-6 py-4 text-neutral-400 text-sm">
                          {(registro.criterio_id || registro.criteria_id)?.substring(0, 8) || "-"}...
                        </td>
                        <td className="px-6 py-4 text-white font-semibold">
                          {registro.calificacion_nueva ? `${registro.calificacion_nueva}/100` : "-"}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
              <div className="px-6 py-4 bg-neutral-900/50 border-t border-neutral-700/50">
                <p className="text-sm text-neutral-500">
                  Total de registros: <span className="font-bold text-white">{log.length}</span>
                </p>
              </div>
            </div>
          )}
        </div>
      )}

      {/* TAB: RESUMEN POR DOCENTE */}
      {tab === "resumen" && (
        <div className="space-y-6">
          <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
            <label className="block text-sm font-semibold text-white mb-3">
              Docente
            </label>
            <select
              value={docente_id}
              onChange={(e) => setDocente_id(e.target.value)}
              className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
            >
              <option value="">
                {cargandoUsuarios ? "Cargando docentes..." : "Selecciona un docente"}
              </option>
              {docentes.map((docente) => (
                <option key={docente.id} value={docente.id}>
                  {docente.nombre || docente.name || docente.email} - {docente.email}
                </option>
              ))}
            </select>
            {errorUsuarios && (
              <p className="text-danger text-sm mt-3">Error cargando usuarios: {errorUsuarios}</p>
            )}
          </div>

          {cargandoResumen ? (
            <div className="text-center text-neutral-400 py-12">
              <div className="inline-block">
                <div className="animate-spin">
                  <div className="w-8 h-8 border-4 border-neutral-700 border-t-primary-brand rounded-full"></div>
                </div>
              </div>
              <p className="mt-4">Cargando resumen...</p>
            </div>
          ) : !resumen ? (
            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 text-center">
              <p className="text-neutral-400 text-lg">
                {docente_id ? "No hay datos para este docente" : "Ingresa un ID de docente"}
              </p>
            </div>
          ) : (
            <div className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 border-l-4 border-l-primary-brand">
                  <p className="text-sm text-neutral-400 font-semibold">Total de Registros</p>
                  <p className="text-4xl font-bold text-primary-brand mt-3">{resumen.total_registros}</p>
                </div>
                <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 border-l-4 border-l-success">
                  <p className="text-sm text-neutral-400 font-semibold">Calificaciones Registradas</p>
                  <p className="text-4xl font-bold text-success mt-3">{resumen.total_calificaciones}</p>
                </div>
                <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 border-l-4 border-l-blue-500">
                  <p className="text-sm text-neutral-400 font-semibold">Estudiantes Calificados</p>
                  <p className="text-4xl font-bold text-blue-500 mt-3">{resumen.estudiantes_calificados}</p>
                </div>
              </div>

              <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
                <h3 className="text-lg font-bold text-white mb-4">Registros Recientes</h3>
                <div className="space-y-3">
                  {resumen.registros_recientes?.map((registro, idx) => (
                    <div key={idx} className="flex items-center justify-between p-4 border border-neutral-700/50 rounded-lg hover:bg-neutral-900/50 transition">
                      <div>
                        <p className="font-semibold text-white">
                          {obtenerAccion(registro)?.toUpperCase() || "-"} - {registro.tabla_afectada}
                        </p>
                        <p className="text-sm text-neutral-500 mt-1">
                          {formatearFecha(obtenerFechaRegistro(registro))}
                        </p>
                      </div>
                      {registro.calificacion_nueva && (
                        <span className="bg-primary-brand text-white px-3 py-1 rounded-full text-sm font-semibold">
                          {registro.calificacion_nueva}/100
                        </span>
                      )}
                    </div>
                  ))}
                </div>
              </div>
            </div>
          )}
        </div>
      )}

      <div className="mt-8 bg-primary-brand/10 border border-primary-brand/30 rounded-lg p-4">
        <p className="text-sm text-primary-300">
          <span className="font-semibold">ℹ️ Información:</span> El sistema registra automáticamente todas las evaluaciones creadas o modificadas.
          Esta información es esencial para auditoría, cumplimiento normativo y resolución de disputas.
        </p>
      </div>
    </div>
  )
}
