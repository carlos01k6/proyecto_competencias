import React, { useState } from "react"
import { Link, useLocation } from "react-router-dom"
import {
  Home, BookOpen, FileText, BarChart3, Award, CheckSquare, TrendingUp,
  ClipboardList, Settings, Calendar, ChevronDown, Zap, LogOut, Users,
  GraduationCap, FileCheck, CalendarCheck, Download, Bell, Grid3x3, LayoutGrid
} from "lucide-react"

export default function Sidebar({ usuario, onToggleExpand }) {
  const location = useLocation()
  const rol = usuario?.rol?.toLowerCase() || "student"
  const [expandido, setExpandido] = useState(false)
  const [expandedSections, setExpandedSections] = useState({})

  const handleToggle = (nuevoEstado) => {
    setExpandido(nuevoEstado)
    if (onToggleExpand) {
      onToggleExpand(nuevoEstado)
    }
  }

  const toggleSection = (title) => {
    setExpandedSections(prev => ({
      ...prev,
      [title]: !prev[title]
    }))
  }

  // ESTRUCTURA ADMIN
  const getAdminMenu = () => {
    return [
      {
        title: "Principal",
        icon: Home,
        color: "from-blue-500 to-blue-600",
        items: [
          { path: "/", label: "Dashboard", icon: Home }
        ]
      },
      {
        title: "Gestión Académica",
        icon: BookOpen,
        color: "from-purple-500 to-purple-600",
        items: [
          { path: "/competencias", label: "Competencias", icon: BookOpen },
          { path: "/rubricas", label: "Rúbricas Globales", icon: CheckSquare },
          { path: "/plantillas", label: "Plantillas", icon: FileCheck },
          { path: "/criterios", label: "Criterios", icon: Award },
          { path: "/escalas", label: "Escalas", icon: BarChart3 }
        ]
      },
      {
        title: "Cursos y Secciones",
        icon: BookOpen,
        color: "from-cyan-500 to-cyan-600",
        items: [
          { path: "/admin-cursos", label: "Cursos Registrados", icon: BookOpen },
          { path: "/secciones", label: "Secciones / Aulas", icon: LayoutGrid }
        ]
      },
      {
        title: "Usuarios",
        icon: Users,
        color: "from-emerald-500 to-emerald-600",
        items: [
          { path: "/users", label: "Gestionar Usuarios", icon: Users },
          { path: "/roles", label: "Roles y Permisos", icon: FileCheck }
        ]
      },
      {
        title: "Reportes",
        icon: BarChart3,
        color: "from-amber-500 to-amber-600",
        items: [
          { path: "/reportes-director", label: "Reportes Dirección", icon: BarChart3 },
          { path: "/reportes-competencias", label: "Análisis de Competencias", icon: BookOpen },
          { path: "/matriz-competencias", label: "Matriz por Grado", icon: Grid3x3 },
          { path: "/exportar", label: "Exportación", icon: Download },
          { path: "/auditoria", label: "Auditoría", icon: FileText }
        ]
      },
      {
        title: "Configuración",
        icon: Settings,
        color: "from-slate-500 to-slate-600",
        items: [
          { path: "/academic-periods", label: "Períodos Académicos", icon: Calendar },
          { path: "/config", label: "Configuración Sistema", icon: Settings }
        ]
      }
    ]
  }

  // ESTRUCTURA DOCENTE
  const getTeacherMenu = () => {
    return [
      {
        title: "Principal",
        icon: Home,
        color: "from-blue-500 to-blue-600",
        items: [
          { path: "/", label: "Dashboard", icon: Home },
          { path: "/alertas", label: "Alertas de Desempeño", icon: Bell }
        ]
      },
      {
        title: "Mis Cursos",
        icon: BookOpen,
        color: "from-purple-500 to-purple-600",
        items: [
          { path: "/mis-cursos", label: "Mis Cursos", icon: BookOpen },
          { path: "/mis-secciones", label: "Mis Secciones", icon: LayoutGrid },
          { path: "/estudiantes", label: "Mis Estudiantes", icon: Users }
        ]
      },
      {
        title: "Gestión Académica",
        icon: ClipboardList,
        color: "from-pink-500 to-pink-600",
        items: [
          { path: "/competencias", label: "Competencias", icon: BookOpen },
          { path: "/actividades", label: "Actividades", icon: ClipboardList },
          { path: "/criterios", label: "Criterios", icon: Award },
          { path: "/mis-rubricas", label: "Mis Rúbricas", icon: CheckSquare },
          { path: "/plantillas", label: "Plantillas", icon: FileCheck },
          { path: "/evidencias-proyecto", label: "Evidencias de Proyecto", icon: FileText }
        ]
      },
      {
        title: "Evaluación",
        icon: FileText,
        color: "from-emerald-500 to-emerald-600",
        items: [
          { path: "/evaluacion", label: "Evaluar Estudiantes", icon: FileText },
          { path: "/asistencia", label: "Asistencia", icon: CalendarCheck },
          { path: "/niveles", label: "Niveles de Logro", icon: Award },
          { path: "/re-evaluations", label: "Re-evaluaciones", icon: TrendingUp }
        ]
      },
      {
        title: "Seguimiento",
        icon: BarChart3,
        color: "from-amber-500 to-amber-600",
        items: [
          { path: "/grupo-seguimiento", label: "Progreso del Grupo", icon: BarChart3 },
          { path: "/matriz-competencias", label: "Matriz Competencias", icon: Grid3x3 },
          { path: "/improvement-plans", label: "Planes de Mejora", icon: ClipboardList },
          { path: "/boletin", label: "Boletines", icon: FileText },
          { path: "/exportar", label: "Exportación", icon: Download }
        ]
      },
      {
        title: "Recursos",
        icon: Settings,
        color: "from-slate-500 to-slate-600",
        items: [
          { path: "/evidencias", label: "Evidencias", icon: FileText },
          { path: "/retroalimentacion", label: "Retroalimentación", icon: ClipboardList }
        ]
      }
    ]
  }

  // ESTRUCTURA ESTUDIANTE
  const getStudentMenu = () => {
    return [
      {
        title: "Principal",
        icon: Home,
        color: "from-blue-500 to-blue-600",
        items: [
          { path: "/", label: "Dashboard", icon: Home }
        ]
      },
      {
        title: "Mi Aprendizaje",
        icon: BookOpen,
        color: "from-purple-500 to-purple-600",
        items: [
          { path: "/competencias", label: "Competencias", icon: BookOpen },
          { path: "/actividades", label: "Actividades", icon: ClipboardList },
          { path: "/evidencias", label: "Mis Evidencias", icon: FileText }
        ]
      },
      {
        title: "Mi Desempeño",
        icon: TrendingUp,
        color: "from-emerald-500 to-emerald-600",
        items: [
          { path: "/progresos", label: "Mi Progreso", icon: TrendingUp },
          { path: "/evaluacion", label: "Mis Calificaciones", icon: BarChart3 },
          { path: "/niveles", label: "Niveles de Logro", icon: Award }
        ]
      },
      {
        title: "Reportes",
        icon: BarChart3,
        color: "from-amber-500 to-amber-600",
        items: [
          { path: "/boletin", label: "Mi Boletín", icon: FileText }
        ]
      }
    ]
  }

  const getMenuSections = () => {
    if (rol === "admin") return getAdminMenu()
    if (rol === "teacher" || rol === "docente") return getTeacherMenu()
    return getStudentMenu()
  }

  const isActive = (path) => {
    return location.pathname === path
  }

  const sections = getMenuSections()

  const getRolInfo = () => {
    const roles = {
      admin: { emoji: "👨‍💼", text: "Administrador", color: "from-blue-600 to-blue-700" },
      teacher: { emoji: "👨‍🏫", text: "Docente", color: "from-purple-600 to-purple-700" },
      docente: { emoji: "👨‍🏫", text: "Docente", color: "from-purple-600 to-purple-700" },
      student: { emoji: "👨‍🎓", text: "Estudiante", color: "from-emerald-600 to-emerald-700" }
    }
    return roles[rol] || roles.student
  }

  const rolInfo = getRolInfo()

  return (
    <aside
      onMouseEnter={() => handleToggle(true)}
      onMouseLeave={() => handleToggle(false)}
      className={`fixed left-0 top-0 h-screen pt-20 transition-all duration-300 z-40 backdrop-blur-xl bg-neutral-950/95 border-r border-neutral-800/50 ${
        expandido ? "w-80" : "w-20"
      }`}
      style={{
        backgroundImage: "radial-gradient(circle at 0% 0%, rgba(59, 130, 246, 0.05) 0%, transparent 50%)"
      }}
    >
      <div className="flex flex-col h-full">
        {/* Header */}
        <div className="px-4 py-4 border-b border-neutral-800/50">
          <div className="flex items-center justify-between">
            {expandido && (
              <div className="flex items-center gap-2">
                <div className="p-2 bg-gradient-to-br from-primary-brand to-primary-600 rounded-lg">
                  <GraduationCap className="w-5 h-5 text-white" />
                </div>
                <div>
                  <p className="text-sm font-bold text-white">Politécnico</p>
                  <p className="text-xs text-neutral-500">Sistema de Competencias</p>
                </div>
              </div>
            )}
            <button
              onClick={() => handleToggle(!expandido)}
              className="p-2 hover:bg-neutral-800 rounded-lg transition text-neutral-400 hover:text-primary-brand ml-auto"
            >
              <ChevronDown className={`w-5 h-5 transition-transform ${expandido ? "rotate-180" : ""}`} />
            </button>
          </div>
        </div>

        {/* Rol Badge */}
        {expandido && (
          <div className={`mx-4 mt-4 mb-6 p-4 rounded-xl bg-gradient-to-r ${rolInfo.color}`}>
            <p className="text-xs font-bold text-white uppercase tracking-widest">{rolInfo.emoji}</p>
            <p className="text-sm font-bold text-white mt-1">{rolInfo.text}</p>
            <p className="text-xs text-white/80 mt-1">{usuario?.email}</p>
          </div>
        )}

        {/* Navigation */}
        <nav className="flex-1 overflow-y-auto scrollbar-thin scrollbar-thumb-neutral-700 scrollbar-track-transparent">
          <div className="px-2 py-4 space-y-2">
            {sections.map((section, idx) => {
              const SectionIcon = section.icon
              const isExpanded = expandedSections[section.title] !== false
              
              return (
                <div key={idx}>
                  {/* Section Header */}
                  {expandido && (
                    <button
                      onClick={() => toggleSection(section.title)}
                      className="w-full px-4 py-3 mb-2 rounded-lg flex items-center gap-3 hover:bg-neutral-800/50 transition group"
                    >
                      <div className={`p-2 rounded-lg bg-gradient-to-br ${section.color} group-hover:scale-110 transition`}>
                        <SectionIcon className="w-4 h-4 text-white" />
                      </div>
                      <div className="flex-1 text-left">
                        <p className="text-xs font-bold text-white uppercase tracking-wider">{section.title}</p>
                      </div>
                      <ChevronDown className={`w-4 h-4 text-neutral-500 transition ${isExpanded ? "rotate-180" : ""}`} />
                    </button>
                  )}

                  {/* Menu Items */}
                  {isExpanded && (
                    <div className={`space-y-1 ${expandido ? "ml-0 mb-4" : ""}`}>
                      {section.items.map((item) => {
                        const Icon = item.icon
                        const active = isActive(item.path)
                        
                        return (
                          <Link
                            key={item.path}
                            to={item.path}
                            className={`flex items-center gap-3 px-4 py-3 rounded-lg transition-all duration-200 group relative ${
                              active
                                ? "bg-gradient-to-r from-primary-brand to-primary-600 text-white shadow-lg shadow-primary-brand/20"
                                : "text-neutral-400 hover:text-neutral-100"
                            }`}
                            title={!expandido ? item.label : ""}
                          >
                            <Icon className={`flex-shrink-0 w-5 h-5 transition-transform ${active ? "text-white" : "group-hover:scale-110"}`} />

                            {expandido && (
                              <span className="flex-1 truncate text-sm font-medium">
                                {item.label}
                              </span>
                            )}

                            {expandido && active && (
                              <div className="w-2 h-2 bg-white rounded-full animate-pulse"></div>
                            )}
                          </Link>
                        )
                      })}
                    </div>
                  )}
                </div>
              )
            })}
          </div>
        </nav>

        {/* Footer */}
        {expandido && (
          <div className="px-4 py-4 border-t border-neutral-800/50 bg-gradient-to-t from-neutral-900/50 to-transparent backdrop-blur-sm">
            <div className="p-4 rounded-lg bg-neutral-800/30 border border-neutral-700/50">
              <div className="flex items-center gap-2 mb-2">
                <div className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse"></div>
                <p className="text-xs font-semibold text-neutral-300">Sistema Activo</p>
              </div>
              <p className="text-xs text-neutral-500">Evaluación por Competencias v1.0</p>
              <p className="text-xs text-neutral-600 mt-2 truncate">📧 {usuario?.email}</p>
            </div>
          </div>
        )}
      </div>
    </aside>
  )
}
