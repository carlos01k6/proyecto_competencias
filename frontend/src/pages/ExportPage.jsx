import React, { useEffect, useMemo, useState } from "react"
import { Download, FileSpreadsheet, FileText, Loader2 } from "lucide-react"
import * as academicPeriodsService from "../services/academic_periods"
import * as exportacionService from "../services/export"

const tiposReporte = [
  { value: "competencia", label: "Competencia" },
  { value: "grado", label: "Grado" },
  { value: "asignatura", label: "Asignatura" }
]

export default function ExportarPage() {
  const [tipo, setTipo] = useState("competencia")
  const [periodoId, setPeriodoId] = useState("")
  const [periodos, setPeriodos] = useState([])
  const [preview, setPreview] = useState(null)
  const [cargandoPeriodos, setCargandoPeriodos] = useState(false)
  const [cargandoPreview, setCargandoPreview] = useState(false)
  const [descargando, setDescargando] = useState("")
  const [error, setError] = useState("")

  const filtros = useMemo(() => ({ tipo, periodo_id: periodoId }), [tipo, periodoId])

  useEffect(() => {
    const cargarPeriodos = async () => {
      setCargandoPeriodos(true)
      try {
        const data = await academicPeriodsService.obtenerConfiguracionPeriodos()
        setPeriodos(data.periodos || [])
      } catch (err) {
        setError(err.response?.data?.error || err.message)
      } finally {
        setCargandoPeriodos(false)
      }
    }

    cargarPeriodos()
  }, [])

  const cargarPreview = async () => {
    setCargandoPreview(true)
    setError("")
    try {
      const data = await exportacionService.obtenerPreviewReporte(filtros)
      setPreview(data)
    } catch (err) {
      setError(err.response?.data?.error || err.message)
      setPreview(null)
    } finally {
      setCargandoPreview(false)
    }
  }

  useEffect(() => {
    cargarPreview()
  }, [tipo, periodoId])

  const descargarPdf = async () => {
    setDescargando("pdf")
    setError("")
    try {
      await exportacionService.descargarReportePdf(filtros)
    } catch (err) {
      setError(err.response?.data?.error || err.message)
    } finally {
      setDescargando("")
    }
  }

  const descargarExcel = async () => {
    setDescargando("excel")
    setError("")
    try {
      await exportacionService.descargarReporteExcel(filtros)
    } catch (err) {
      setError(err.response?.data?.error || err.message)
    } finally {
      setDescargando("")
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-gradient-to-br from-blue-600 to-blue-700 rounded-lg">
            <Download className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Exportacion</h1>
            <p className="text-neutral-400">Descarga reportes institucionales en PDF o Excel</p>
          </div>
        </div>
      </div>

      {error && (
        <div className="bg-danger/10 border border-danger/30 rounded-lg p-4 mb-6">
          <p className="text-danger font-semibold">{error}</p>
        </div>
      )}

      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 mb-6">
        <div className="grid grid-cols-1 lg:grid-cols-[1fr_1fr_auto_auto] gap-4 lg:items-end">
          <label className="block">
            <span className="text-sm font-semibold text-neutral-300">Tipo de reporte</span>
            <select
              value={tipo}
              onChange={(event) => setTipo(event.target.value)}
              className="mt-2 w-full bg-neutral-950 border border-neutral-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-primary-brand"
            >
              {tiposReporte.map((opcion) => (
                <option key={opcion.value} value={opcion.value}>
                  {opcion.label}
                </option>
              ))}
            </select>
          </label>

          <label className="block">
            <span className="text-sm font-semibold text-neutral-300">Periodo academico</span>
            <select
              value={periodoId}
              onChange={(event) => setPeriodoId(event.target.value)}
              disabled={cargandoPeriodos}
              className="mt-2 w-full bg-neutral-950 border border-neutral-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-primary-brand"
            >
              <option value="">Todos los periodos</option>
              {periodos.map((periodo) => (
                <option key={periodo.id || periodo.key} value={periodo.id}>
                  {periodo.nombre || periodo.description || periodo.key}
                </option>
              ))}
            </select>
          </label>

          <button
            onClick={descargarPdf}
            disabled={descargando === "pdf" || cargandoPreview}
            className="bg-danger hover:bg-red-700 disabled:opacity-50 disabled:cursor-not-allowed text-white px-5 py-3 rounded-lg font-semibold flex items-center justify-center gap-2 transition"
          >
            {descargando === "pdf" ? <Loader2 className="w-5 h-5 animate-spin" /> : <FileText className="w-5 h-5" />}
            Descargar PDF
          </button>

          <button
            onClick={descargarExcel}
            disabled={descargando === "excel" || cargandoPreview}
            className="bg-emerald-600 hover:bg-emerald-700 disabled:opacity-50 disabled:cursor-not-allowed text-white px-5 py-3 rounded-lg font-semibold flex items-center justify-center gap-2 transition"
          >
            {descargando === "excel" ? <Loader2 className="w-5 h-5 animate-spin" /> : <FileSpreadsheet className="w-5 h-5" />}
            Descargar Excel
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 xl:grid-cols-[1fr_320px] gap-6">
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
          <div className="px-6 py-4 border-b border-neutral-700/50 flex items-center justify-between">
            <h2 className="text-xl font-bold text-white">Preview de datos</h2>
            {cargandoPreview && (
              <div className="flex items-center gap-2 text-neutral-400 text-sm">
                <Loader2 className="w-4 h-4 animate-spin" />
                Cargando
              </div>
            )}
          </div>

          {!preview || cargandoPreview ? (
            <div className="p-12 text-center text-neutral-400">Preparando datos de exportacion.</div>
          ) : (preview.filas || []).length === 0 ? (
            <div className="p-12 text-center text-neutral-400">No hay datos para exportar con estos filtros.</div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full min-w-[760px]">
                <thead>
                  <tr className="border-b border-neutral-700/50 bg-neutral-900/50">
                    <th className="px-6 py-4 text-left text-neutral-300 font-semibold">Nombre</th>
                    <th className="px-6 py-4 text-left text-neutral-300 font-semibold">Descripcion</th>
                    <th className="px-6 py-4 text-left text-neutral-300 font-semibold">Evaluaciones</th>
                    <th className="px-6 py-4 text-left text-neutral-300 font-semibold">Promedio</th>
                    <th className="px-6 py-4 text-left text-neutral-300 font-semibold">Nivel</th>
                  </tr>
                </thead>
                <tbody>
                  {(preview.filas || []).map((fila, index) => (
                    <tr key={`${fila.grupo}-${index}`} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition">
                      <td className="px-6 py-4 text-white font-semibold">{fila.grupo}</td>
                      <td className="px-6 py-4 text-neutral-400">{fila.descripcion || "N/A"}</td>
                      <td className="px-6 py-4 text-neutral-300">{fila.total_evaluaciones}</td>
                      <td className="px-6 py-4 text-primary-brand font-semibold">{fila.promedio}</td>
                      <td className="px-6 py-4 text-neutral-300">{fila.nivel}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>

        <aside className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 h-fit">
          <h2 className="text-xl font-bold text-white mb-4">Resumen</h2>
          {preview?.resumen ? (
            <div className="space-y-4">
              <div>
                <p className="text-xs uppercase text-neutral-500">Tipo</p>
                <p className="text-white font-semibold capitalize">{preview.resumen.tipo}</p>
              </div>
              <div>
                <p className="text-xs uppercase text-neutral-500">Periodo</p>
                <p className="text-white font-semibold">{preview.resumen.periodo}</p>
              </div>
              <div>
                <p className="text-xs uppercase text-neutral-500">Registros</p>
                <p className="text-white font-semibold">{preview.resumen.total_registros}</p>
              </div>
              <div>
                <p className="text-xs uppercase text-neutral-500">Evaluaciones</p>
                <p className="text-white font-semibold">{preview.resumen.total_evaluaciones}</p>
              </div>
              <div>
                <p className="text-xs uppercase text-neutral-500">Promedio general</p>
                <p className="text-3xl text-primary-brand font-bold">{preview.resumen.promedio_general}</p>
              </div>
            </div>
          ) : (
            <p className="text-neutral-400">Sin resumen disponible.</p>
          )}
        </aside>
      </div>
    </div>
  )
}
