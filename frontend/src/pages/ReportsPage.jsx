import React, { useState } from "react"
import { useReportes } from "../hooks/useReports"
import { BarChart3, Download, Filter, Calendar, TrendingUp } from "lucide-react"
import ReportesCompetenciasPage from "./ReportesCompetenciasPage"

export default function ReportesPage({ usuario }) {
  const { reportes, cargando, obtenerReportes } = useReportes()
  
  const [tipo, setTipo] = useState("general")
  const [fechaInicio, setFechaInicio] = useState("")
  const [fechaFin, setFechaFin] = useState("")
  const [tab, setTab] = useState("general")

  const rolUsuario = usuario?.rol?.toLowerCase()
  const esAdmin = rolUsuario === "admin"
  const esTeacher = rolUsuario === "teacher"
  const esStudent = rolUsuario === "student"

  const getStatsCards = () => {
    if (esAdmin) {
      return [
        { title: "Total Estudiantes", value: "145", color: "from-blue-600 to-blue-700" },
        { title: "Evaluaciones", value: "1,240", color: "from-purple-600 to-purple-700" },
        { title: "Promedio General", value: "78.5%", color: "from-emerald-600 to-emerald-700" },
        { title: "Completadas", value: "95%", color: "from-amber-600 to-amber-700" }
      ]
    }
    if (esTeacher) {
      return [
        { title: "Mis Estudiantes", value: "32", color: "from-blue-600 to-blue-700" },
        { title: "Evaluaciones Hechas", value: "84", color: "from-purple-600 to-purple-700" },
        { title: "Promedio del Grupo", value: "76.2%", color: "from-emerald-600 to-emerald-700" },
        { title: "Pendientes", value: "12", color: "from-amber-600 to-amber-700" }
      ]
    }
    return [
      { title: "Mi Promedio", value: "82.5%", color: "from-blue-600 to-blue-700" },
      { title: "Evaluaciones", value: "18", color: "from-purple-600 to-purple-700" },
      { title: "Competencias", value: "6", color: "from-emerald-600 to-emerald-700" },
      { title: "Nivel", value: "Intermedio", color: "from-amber-600 to-amber-700" }
    ]
  }

  const getReportTypes = () => {
    if (esAdmin) {
      return [
        { value: "general", label: "Reporte General" },
        { value: "competencias", label: "Por Competencias" },
        { value: "estudiantes", label: "Por Estudiantes" },
        { value: "docentes", label: "Por Docentes" }
      ]
    }
    if (esTeacher) {
      return [
        { value: "grupo", label: "Mi Grupo" },
        { value: "competencias", label: "Por Competencias" },
        { value: "estudiantes", label: "Estudiantes" }
      ]
    }
    return [
      { value: "personal", label: "Mi Desempeño" },
      { value: "competencias", label: "Por Competencia" }
    ]
  }

  const stats = getStatsCards()
  const reportTypes = getReportTypes()

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-4">
          <div className="p-3 bg-gradient-to-br from-emerald-600 to-emerald-700 rounded-lg">
            <BarChart3 className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Reportes</h1>
            <p className="text-neutral-400">
              {esAdmin && "Análisis y estadísticas de toda la institución"}
              {esTeacher && "Reportes de tu grupo y desempeño de estudiantes"}
              {esStudent && "Tu desempeño académico individual"}
            </p>
          </div>
        </div>
      </div>

      {/* Tabs */}
      {esAdmin && (
        <div className="flex gap-1 mb-8 p-1 bg-neutral-800/30 rounded-xl border border-neutral-700/30">
          <button
            onClick={() => setTab("general")}
            className={`px-4 py-2 rounded-lg text-sm font-semibold transition ${
              tab === "general" ? "bg-emerald-600 text-white" : "text-neutral-400 hover:text-white"
            }`}
          >
            Reportes Generales
          </button>
          <button
            onClick={() => setTab("competencias")}
            className={`px-4 py-2 rounded-lg text-sm font-semibold transition ${
              tab === "competencias" ? "bg-emerald-600 text-white" : "text-neutral-400 hover:text-white"
            }`}
          >
            Análisis de Competencias
          </button>
        </div>
      )}

      {tab === "competencias" && esAdmin ? (
        <ReportesCompetenciasPage usuario={usuario} />
      ) : (
        <>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            {stats.map((stat, idx) => (
              <div key={idx} className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 hover:border-primary-brand/30 transition">
                <div className={`w-10 h-10 rounded-lg bg-gradient-to-br ${stat.color} mb-3`}></div>
                <p className="text-neutral-400 text-sm mb-2">{stat.title}</p>
                <p className="text-3xl font-bold text-white">{stat.value}</p>
              </div>
            ))}
          </div>

      {/* Filtros */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
        <select
          value={tipo}
          onChange={(e) => setTipo(e.target.value)}
          className="px-4 py-3 bg-neutral-800/50 border border-neutral-700 rounded-lg text-white focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
        >
          {reportTypes.map((rt) => (
            <option key={rt.value} value={rt.value}>
              {rt.label}
            </option>
          ))}
        </select>

        <div className="flex gap-2">
          <input
            type="date"
            value={fechaInicio}
            onChange={(e) => setFechaInicio(e.target.value)}
            className="flex-1 px-4 py-3 bg-neutral-800/50 border border-neutral-700 rounded-lg text-white focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
            placeholder="Desde"
          />
          <input
            type="date"
            value={fechaFin}
            onChange={(e) => setFechaFin(e.target.value)}
            className="flex-1 px-4 py-3 bg-neutral-800/50 border border-neutral-700 rounded-lg text-white focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
            placeholder="Hasta"
          />
        </div>

        <button className="flex items-center justify-center gap-2 px-4 py-3 bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white rounded-lg font-semibold shadow-lg shadow-primary-brand/20 transition">
          <Download className="w-5 h-5" />
          Descargar Reporte
        </button>
      </div>

      {/* Contenido principal */}
      {cargando ? (
        <div className="flex items-center justify-center py-12">
          <div className="animate-spin inline-block">
            <div className="w-8 h-8 border-4 border-neutral-700 border-t-primary-brand rounded-full"></div>
          </div>
        </div>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {/* Gráfica 1 */}
          <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-lg font-bold text-white">
                {esAdmin && "Distribución por Competencia"}
                {esTeacher && "Desempeño de tu Grupo"}
                {esStudent && "Mi Progreso por Competencia"}
              </h3>
              <TrendingUp className="w-5 h-5 text-primary-brand" />
            </div>
            <div className="h-48 bg-neutral-900/50 rounded-lg flex items-center justify-center">
              <div className="text-center">
                <p className="text-neutral-500 mb-2">📊 Gráfica de datos</p>
                <p className="text-xs text-neutral-600">Los gráficos se cargarán con datos reales</p>
              </div>
            </div>
          </div>

          {/* Gráfica 2 */}
          <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-lg font-bold text-white">
                {esAdmin && "Calificaciones Generales"}
                {esTeacher && "Distribución de Calificaciones"}
                {esStudent && "Mis Calificaciones por Criterio"}
              </h3>
              <BarChart3 className="w-5 h-5 text-primary-brand" />
            </div>
            <div className="h-48 bg-neutral-900/50 rounded-lg flex items-center justify-center">
              <div className="text-center">
                <p className="text-neutral-500 mb-2">📈 Gráfica de datos</p>
                <p className="text-xs text-neutral-600">Los gráficos se cargarán con datos reales</p>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Tabla de datos */}
          <div className="mt-8 bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
            <h3 className="text-lg font-bold text-white mb-4">Detalles</h3>
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-neutral-700/50">
                    <th className="px-4 py-3 text-left font-semibold text-neutral-300">
                      {esAdmin && "Elemento"}
                      {esTeacher && "Estudiante"}
                      {esStudent && "Competencia"}
                    </th>
                    <th className="px-4 py-3 text-left font-semibold text-neutral-300">Evaluaciones</th>
                    <th className="px-4 py-3 text-left font-semibold text-neutral-300">Promedio</th>
                    <th className="px-4 py-3 text-left font-semibold text-neutral-300">Estado</th>
                  </tr>
                </thead>
                <tbody>
                  <tr className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition">
                    <td className="px-4 py-3 text-white font-semibold">Ejemplo</td>
                    <td className="px-4 py-3 text-neutral-400">15</td>
                    <td className="px-4 py-3 text-white font-semibold">78.5%</td>
                    <td className="px-4 py-3">
                      <span className="px-3 py-1 rounded-full text-xs font-semibold bg-success/20 text-success">
                        Satisfactorio
                      </span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <p className="text-xs text-neutral-500 mt-4">
              Los datos se mostrarán cuando haya evaluaciones registradas en el sistema
            </p>
          </div>
        </>
      )}
    </div>
  )
}
