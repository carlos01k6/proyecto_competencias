import React, { useEffect, useState } from "react"
import { Link } from "react-router-dom"
import { BarChart3, CalendarCheck, Save, Loader2, Search } from "lucide-react"
import { getStudentCode } from "../utils/studentCode"

const API_URL = "http://localhost:5000/api/asistencia"

const estadoLabels = {
  presente: "Presente",
  ausente: "Ausente",
  tardanza: "Tardanza"
}

function hoyISO() {
  return new Date().toISOString().slice(0, 10)
}

export default function AsistenciaPage({ usuario }) {
  const rolUsuario = usuario?.rol?.toLowerCase()
  const esTeacher = rolUsuario === "teacher" || rolUsuario === "docente"

  const [fecha, setFecha] = useState(hoyISO())
  const [filas, setFilas] = useState([])
  const [estudiantesCargados, setEstudiantesCargados] = useState(false)
  const [cargando, setCargando] = useState(false)
  const [guardando, setGuardando] = useState(false)
  const [mensaje, setMensaje] = useState("")
  const [error, setError] = useState("")
  const [reporte, setReporte] = useState(null)
  const [estudianteReporte, setEstudianteReporte] = useState(null)
  const [cargandoReporte, setCargandoReporte] = useState(false)

  useEffect(() => {
    setFilas([])
    setEstudiantesCargados(false)
    setMensaje("")
    setError("")
    setReporte(null)
    setEstudianteReporte(null)
  }, [fecha])

  const obtenerHeaders = () => {
    const token = localStorage.getItem("acceso_token")
    return {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`
    }
  }

  const cargarAsistencia = async () => {
    if (!fecha) return

    setCargando(true)
    setError("")
    setMensaje("")

    try {
      const response = await fetch(`${API_URL}/${fecha}`, {
        headers: obtenerHeaders()
      })
      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.error || "No se pudo cargar la asistencia")
      }

      setFilas(data || [])
      setEstudiantesCargados(true)
    } catch (err) {
      setError(err.message)
      setFilas([])
      setEstudiantesCargados(false)
    } finally {
      setCargando(false)
    }
  }

  const actualizarFila = (studentId, campo, valor) => {
    setFilas((actuales) =>
      actuales.map((fila) =>
        fila.student_id === studentId ? { ...fila, [campo]: valor } : fila
      )
    )
  }

  const guardarAsistencia = async () => {
    if (!fecha) {
      setError("Selecciona una fecha")
      return
    }

    setGuardando(true)
    setError("")
    setMensaje("")

    try {
      const response = await fetch(API_URL, {
        method: "POST",
        headers: obtenerHeaders(),
        body: JSON.stringify({
          docente_id: usuario?.id,
          fecha,
          asistencias: filas.map((fila) => ({
            student_id: fila.student_id,
            estado: fila.estado,
            observacion: fila.observacion || ""
          }))
        })
      })
      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.error || "No se pudo guardar la asistencia")
      }

      setMensaje(
        typeof data.guardados === "number"
          ? `Asistencia guardada correctamente (${data.guardados} registros)`
          : "Asistencia guardada correctamente"
      )
      setTimeout(() => setMensaje(""), 3000)
    } catch (err) {
      setError(err.message)
    } finally {
      setGuardando(false)
    }
  }

  const verReporte = async (fila) => {
    setCargandoReporte(true)
    setError("")
    setReporte(null)
    setEstudianteReporte(fila)

    try {
      const response = await fetch(`${API_URL}/reporte/${fila.student_id}`, {
        headers: obtenerHeaders()
      })
      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.error || "No se pudo cargar el reporte")
      }

      setReporte(data)
    } catch (err) {
      setError(err.message)
      setEstudianteReporte(null)
    } finally {
      setCargandoReporte(false)
    }
  }

  if (!esTeacher) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8 flex items-center justify-center">
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 max-w-md text-center">
          <p className="text-4xl mb-4">🔒</p>
          <h1 className="text-2xl font-bold text-white mb-2">Acceso Restringido</h1>
          <p className="text-neutral-400 mb-6">Esta sección es solo para docentes.</p>
          <Link to="/" className="inline-block bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-6 py-2 rounded-lg font-semibold transition">
            Volver al Inicio
          </Link>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
          <div className="flex items-center gap-3">
            <div className="p-3 bg-gradient-to-br from-emerald-600 to-emerald-700 rounded-lg">
              <CalendarCheck className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-4xl font-bold text-white">Asistencia</h1>
              <p className="text-neutral-400">Registra la asistencia diaria</p>
            </div>
          </div>

          <button
            onClick={guardarAsistencia}
            disabled={guardando || cargando || filas.length === 0}
            className="bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 disabled:opacity-50 disabled:cursor-not-allowed text-white px-6 py-3 rounded-lg font-semibold flex items-center justify-center gap-2 transition"
          >
            {guardando ? <Loader2 className="w-5 h-5 animate-spin" /> : <Save className="w-5 h-5" />}
            Guardar Asistencia
          </button>
        </div>
      </div>

      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 mb-6">
        <div className="grid grid-cols-1 md:grid-cols-[auto_auto] gap-4 md:items-end">
          <label className="block">
            <span className="text-sm font-semibold text-neutral-300">Fecha</span>
            <input
              type="date"
              value={fecha}
              onChange={(event) => setFecha(event.target.value)}
              className="mt-2 w-full bg-neutral-950 border border-neutral-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-primary-brand"
            />
          </label>

          <button
            onClick={cargarAsistencia}
            disabled={cargando || !fecha}
            className="bg-neutral-100 hover:bg-white disabled:opacity-50 disabled:cursor-not-allowed text-neutral-950 px-5 py-3 rounded-lg font-semibold flex items-center justify-center gap-2 transition"
          >
            {cargando ? <Loader2 className="w-5 h-5 animate-spin" /> : <Search className="w-5 h-5" />}
            Cargar Estudiantes
          </button>
        </div>
      </div>

      {error && (
        <div className="bg-danger/10 border border-danger/30 rounded-lg p-4 mb-6">
          <p className="text-danger font-semibold">{error}</p>
        </div>
      )}

      {mensaje && (
        <div className="bg-success/10 border border-success/30 rounded-lg p-4 mb-6">
          <p className="text-success font-semibold">{mensaje}</p>
        </div>
      )}

      {estudianteReporte && (
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 mb-6">
          <div className="flex items-center gap-2 mb-4">
            <BarChart3 className="w-5 h-5 text-primary-brand" />
            <h2 className="text-lg font-bold text-white">Reporte de {estudianteReporte.student_name}</h2>
          </div>

          {cargandoReporte || !reporte ? (
            <div className="flex items-center gap-2 text-neutral-400">
              <Loader2 className="w-4 h-4 animate-spin" />
              Cargando reporte
            </div>
          ) : (
            <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
              <div>
                <p className="text-xs text-neutral-500 uppercase">Total</p>
                <p className="text-2xl font-bold text-white">{reporte.total}</p>
              </div>
              <div>
                <p className="text-xs text-neutral-500 uppercase">Presentes</p>
                <p className="text-2xl font-bold text-success">{reporte.presentes}</p>
              </div>
              <div>
                <p className="text-xs text-neutral-500 uppercase">Ausentes</p>
                <p className="text-2xl font-bold text-danger">{reporte.ausentes}</p>
              </div>
              <div>
                <p className="text-xs text-neutral-500 uppercase">Tardanzas</p>
                <p className="text-2xl font-bold text-warning">{reporte.tardanzas}</p>
              </div>
              <div>
                <p className="text-xs text-neutral-500 uppercase">Asistencia</p>
                <p className="text-2xl font-bold text-primary-brand">{reporte.porcentaje_asistencia}%</p>
              </div>
            </div>
          )}
        </div>
      )}

      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
        {cargando ? (
          <div className="flex items-center justify-center py-12">
            <Loader2 className="w-8 h-8 text-primary-brand animate-spin" />
          </div>
        ) : !estudiantesCargados ? (
          <div className="p-12 text-center">
            <p className="text-neutral-400">Selecciona una fecha y pulsa Cargar Estudiantes.</p>
          </div>
        ) : filas.length === 0 ? (
          <div className="p-12 text-center">
            <p className="text-neutral-400">No hay estudiantes registrados.</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full min-w-[760px]">
              <thead>
                <tr className="border-b border-neutral-700/50 bg-neutral-900/50">
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Código</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Estudiante</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Email</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Estado</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Observación</th>
                  <th className="px-6 py-4 text-right font-semibold text-neutral-300">Reporte</th>
                </tr>
              </thead>
              <tbody>
                {filas.map((fila) => (
                  <tr key={fila.student_id} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition">
                    <td className="px-6 py-4 text-primary-brand font-bold">{getStudentCode(fila)}</td>
                    <td className="px-6 py-4 text-white font-semibold">{fila.student_name}</td>
                    <td className="px-6 py-4 text-neutral-300">{fila.email || "Sin email"}</td>
                    <td className="px-6 py-4">
                      <select
                        value={fila.estado || ""}
                        onChange={(event) => actualizarFila(fila.student_id, "estado", event.target.value)}
                        className="w-full bg-neutral-950 border border-neutral-700 text-white rounded-lg px-3 py-2 focus:outline-none focus:border-primary-brand"
                      >
                        <option value="">Sin registrar</option>
                        {Object.entries(estadoLabels).map(([value, label]) => (
                          <option key={value} value={value}>{label[0]} - {label}</option>
                        ))}
                      </select>
                    </td>
                    <td className="px-6 py-4">
                      <input
                        type="text"
                        value={fila.observacion || ""}
                        onChange={(event) => actualizarFila(fila.student_id, "observacion", event.target.value)}
                        className="w-full bg-neutral-950 border border-neutral-700 text-white rounded-lg px-3 py-2 focus:outline-none focus:border-primary-brand"
                        placeholder="Observación"
                      />
                    </td>
                    <td className="px-6 py-4 text-right">
                      <button
                        onClick={() => verReporte(fila)}
                        className="text-primary-brand hover:text-primary-300 font-semibold text-sm inline-flex items-center gap-2 transition"
                      >
                        <BarChart3 className="w-4 h-4" />
                        Ver reporte
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  )
}
