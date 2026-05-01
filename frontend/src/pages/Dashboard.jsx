import React, { useState, useEffect } from "react"
import { useCompetencias } from "../hooks/useCompetencias"
import { useNavigate } from "react-router-dom"
import { useEvaluaciones } from "../hooks/useEvaluaciones"
import { useActividades } from "../hooks/useActividades"
import {
  BarChart3, TrendingUp, Users, BookOpen, Award, Clock,
  CheckCircle, AlertCircle, ArrowRight, Zap
} from "lucide-react"

export default function Dashboard({ usuario }) {
  const navigate = useNavigate()
  const rol = usuario?.rol?.toLowerCase() || "student"
  const usuarioID = usuario?.id

  // Hooks para traer datos reales
  const { competencias, loading: compLoading } = useCompetencias()
  const { evaluaciones, loading: evalLoading } = useEvaluaciones()
  const { actividades, loading: actLoading } = useActividades()

  const [stats, setStats] = useState([])
  const [loading, setLoading] = useState(true)

  // Calcular estadísticas según el rol y datos reales
  useEffect(() => {
    if (compLoading || evalLoading || actLoading) {
      setLoading(true)
      return
    }

    let newStats = []

    if (rol === "admin") {
      newStats = [
        { 
          icon: Users, 
          label: "Total Competencias", 
          value: competencias.length || "0", 
          color: "from-blue-600 to-blue-700", 
          change: "En el sistema" 
        },
        { 
          icon: BookOpen, 
          label: "Actividades", 
          value: actividades.length || "0", 
          color: "from-purple-600 to-purple-700", 
          change: "Creadas" 
        },
        { 
          icon: BarChart3, 
          label: "Evaluaciones", 
          value: evaluaciones.length || "0", 
          color: "from-emerald-600 to-emerald-700", 
          change: "Registradas" 
        },
        { 
          icon: Award, 
          label: "Criterios", 
          value: "Varios", 
          color: "from-amber-600 to-amber-700", 
          change: "Por competencia" 
        }
      ]
    } else if (rol === "teacher" || rol === "docente") {
      const misCompetencias = competencias.filter(c => c.docente_id === usuarioID) || []
      const misActividades = actividades.filter(a => a.docente_id === usuarioID) || []
      
      newStats = [
        { 
          icon: Users, 
          label: "Mis Competencias", 
          value: misCompetencias.length || "0", 
          color: "from-blue-600 to-blue-700", 
          change: "Activas" 
        },
        { 
          icon: BookOpen, 
          label: "Mis Actividades", 
          value: misActividades.length || "0", 
          color: "from-purple-600 to-purple-700", 
          change: "Creadas" 
        },
        { 
          icon: BarChart3, 
          label: "Evaluaciones", 
          value: evaluaciones.length || "0", 
          color: "from-emerald-600 to-emerald-700", 
          change: "Este período" 
        },
        { 
          icon: Clock, 
          label: "Estado", 
          value: "Activo", 
          color: "from-amber-600 to-amber-700", 
          change: "Sistema operativo" 
        }
      ]
    } else {
      newStats = [
        { 
          icon: BookOpen, 
          label: "Mis Competencias", 
          value: competencias.length || "0", 
          color: "from-blue-600 to-blue-700", 
          change: "Disponibles" 
        },
        { 
          icon: BarChart3, 
          label: "Evaluaciones", 
          value: evaluaciones.length || "0", 
          color: "from-emerald-600 to-emerald-700", 
          change: "Realizadas" 
        },
        { 
          icon: Clock, 
          label: "Actividades", 
          value: actividades.length || "0", 
          color: "from-purple-600 to-purple-700", 
          change: "En progreso" 
        },
        { 
          icon: Award, 
          label: "Nivel", 
          value: "Básico", 
          color: "from-amber-600 to-amber-700", 
          change: "En desarrollo" 
        }
      ]
    }

    setStats(newStats)
    setLoading(false)
  }, [competencias, evaluaciones, actividades, rol, usuarioID])

  const getGreeting = () => {
    const hora = new Date().getHours()
    if (hora < 12) return "¡Buenos días!"
    if (hora < 18) return "¡Buenas tardes!"
    return "¡Buenas noches!"
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 flex items-center justify-center">
        <div className="animate-spin">
          <div className="w-12 h-12 border-4 border-neutral-700 border-t-primary-brand rounded-full"></div>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950">
      <section className="relative px-6 py-16 md:px-8 md:py-20 overflow-hidden">
        <div className="absolute inset-0 opacity-50" style={{
          backgroundImage: "radial-gradient(circle at 0% 0%, rgba(59, 130, 246, 0.15) 0%, transparent 50%)",
        }}></div>

        <div className="relative max-w-7xl mx-auto">
          <div className="mb-12">
            <div className="inline-flex items-center gap-2 px-4 py-2 bg-primary-brand/10 border border-primary-brand/30 rounded-full mb-4">
              <Zap className="w-4 h-4 text-primary-brand" />
              <span className="text-sm font-semibold text-primary-brand">Bienvenido de vuelta</span>
            </div>

            <h1 className="text-5xl md:text-6xl font-bold text-white mb-4 leading-tight">
              {getGreeting()}{" "}
              <span className="bg-gradient-to-r from-primary-brand to-secondary-500 bg-clip-text text-transparent">
                {usuario?.name?.split(" ")[0] || "Usuario"}
              </span>
            </h1>

            <p className="text-xl text-neutral-400 max-w-2xl">
              {rol === "admin" && "Administra tu institución educativa y supervisa el desempeño académico"}
              {(rol === "teacher" || rol === "docente") && "Gestiona tus competencias, evalúa estudiantes y genera reportes"}
              {rol === "student" && "Sigue tu progreso académico y completa tus actividades de aprendizaje"}
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {stats.map((stat, idx) => {
              const Icon = stat.icon
              return (
                <div
                  key={idx}
                  className="group relative bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6 hover:border-primary-brand/30 transition-all duration-300 overflow-hidden"
                >
                  <div className={`absolute inset-0 opacity-0 group-hover:opacity-10 bg-gradient-to-br ${stat.color} transition-opacity duration-300`}></div>

                  <div className="relative">
                    <div className={`w-12 h-12 rounded-lg bg-gradient-to-br ${stat.color} flex items-center justify-center mb-4 group-hover:scale-110 transition-transform`}>
                      <Icon className="w-6 h-6 text-white" />
                    </div>

                    <p className="text-neutral-400 text-sm mb-2">{stat.label}</p>
                    <p className="text-3xl font-bold text-white mb-2">{stat.value}</p>

                    <div className="flex items-center gap-2">
                      <TrendingUp className="w-4 h-4 text-success" />
                      <span className="text-xs text-neutral-500">{stat.change}</span>
                    </div>
                  </div>
                </div>
              )
            })}
          </div>
        </div>
      </section>

      <section className="px-6 md:px-8 pb-20 max-w-7xl mx-auto">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          <div className="lg:col-span-2 space-y-8">
            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8 hover:border-neutral-700 transition-all">
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-xl font-bold text-white flex items-center gap-2">
                  <BookOpen className="w-5 h-5 text-primary-brand" />
                  Competencias Activas
                </h2>
                <a href="/competencias" className="text-primary-brand hover:text-primary-500 text-sm font-semibold flex items-center gap-1">
                  Ver todas <ArrowRight className="w-4 h-4" />
                </a>
              </div>

              <div className="space-y-4">
                {competencias.slice(0, 3).map((comp, idx) => (
                  <div key={idx} className="flex items-start gap-4 p-4 bg-neutral-900/50 rounded-lg hover:bg-neutral-900/70 transition">
                    <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-primary-brand to-primary-600 flex items-center justify-center flex-shrink-0">
                      <BookOpen className="w-5 h-5 text-white" />
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-white font-semibold text-sm">{comp.nombre}</p>
                      <p className="text-neutral-500 text-xs">{comp.asignatura}</p>
                    </div>
                    <span className="text-neutral-600 text-xs flex-shrink-0">Activa</span>
                  </div>
                ))}
                {competencias.length === 0 && (
                  <p className="text-neutral-500 text-sm text-center py-4">No hay competencias disponibles</p>
                )}
              </div>
            </div>

            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8">
              <h2 className="text-xl font-bold text-white mb-6">Accesos Rápidos</h2>

              <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
                {[
                  { name: "Mi Progreso", icon: TrendingUp, path: rol === "student" ? "/progresos" : "/grupo-seguimiento" },
                  { name: "Evaluaciones", icon: BarChart3, path: "/evaluacion" },
                  { name: "Reportes", icon: FileText, path: rol === "admin" ? "/reportes-director" : "/reportes" },
                  { name: "Competencias", icon: BookOpen, path: "/competencias" },
                  { name: "Actividades", icon: ClipboardList, path: "/actividades" },
                  { name: "Ayuda", icon: AlertCircle, path: "/config" },
                ].map((item, idx) => {
                  const Icon = item.icon
                  return (
                    <button
                      key={idx}
                      onClick={() => navigate(item.path)}
                      className="p-4 bg-neutral-900/50 hover:bg-neutral-900/80 border border-neutral-700/50 hover:border-primary-brand/50 rounded-lg transition-all group"
                    >
                      <Icon className="w-5 h-5 text-neutral-400 group-hover:text-primary-brand mb-2" />
                      <p className="text-xs font-semibold text-neutral-300 group-hover:text-white">{item.name}</p>
                    </button>
                  )
                })}
              </div>
            </div>
          </div>

          <div className="space-y-8">
            <div className="bg-gradient-to-br from-primary-600 to-primary-700 rounded-2xl p-8 text-white overflow-hidden relative">
              <div className="absolute inset-0 opacity-10" style={{
                backgroundImage: "url(\"data:image/svg+xml,%3Csvg width=%2760%27 height=%2760%27 viewBox=%270 0 60 60%27 xmlns=%27http://www.w3.org/2000/svg%27%3E%3Cg fill=%27none%27 fill-rule=%27evenodd%27%3E%3Cg fill=%27%23ffffff%27 fill-opacity=%270.1%27%3E%3Cpath d=%27M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z%27/%3E%3C/g%3E%3C/g%3E%3C/svg%3E\")"
              }}></div>

              <div className="relative">
                <h3 className="text-lg font-bold mb-4">Mis Actividades</h3>
                <div className="space-y-3">
                  {actividades.slice(0, 2).map((act, idx) => (
                    <div key={idx} className="bg-white/10 backdrop-blur-sm rounded-lg p-3 border border-white/20">
                      <p className="font-semibold text-sm">{act.titulo}</p>
                      <p className="text-xs text-white/70">En progreso</p>
                    </div>
                  ))}
                  {actividades.length === 0 && (
                    <p className="text-xs text-white/70">No hay actividades</p>
                  )}
                </div>
              </div>
            </div>

            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8">
              <h3 className="text-lg font-bold text-white mb-4">Estado del Sistema</h3>
              <div className="space-y-3">
                <div className="flex items-center justify-between p-3 bg-neutral-900/50 rounded-lg">
                  <span className="text-sm text-neutral-300">Sistema</span>
                  <div className="flex items-center gap-2">
                    <div className="w-2 h-2 bg-success rounded-full animate-pulse"></div>
                    <span className="text-xs font-semibold text-success">Operativo</span>
                  </div>
                </div>
                <div className="flex items-center justify-between p-3 bg-neutral-900/50 rounded-lg">
                  <span className="text-sm text-neutral-300">Base de datos</span>
                  <div className="flex items-center gap-2">
                    <div className="w-2 h-2 bg-success rounded-full animate-pulse"></div>
                    <span className="text-xs font-semibold text-success">Conectado</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}

const ClipboardList = ({ className }) => (
  <svg className={className} fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
  </svg>
)

const FileText = ({ className }) => (
  <svg className={className} fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
  </svg>
)
