import React, { useEffect, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import axios from 'axios'
import Sidebar from './Sidebar'
import { LogOut, User, Bell, Settings, Menu, Search, X } from 'lucide-react'

const SECCIONES = [
  { nombre: 'Dashboard', desc: 'Panel principal', ruta: '/', roles: ['admin', 'teacher', 'docente', 'student'] },
  { nombre: 'Competencias', desc: 'Gestión de competencias académicas', ruta: '/competencias', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Actividades', desc: 'Gestión de actividades', ruta: '/actividades', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Criterios', desc: 'Criterios de evaluación', ruta: '/criterios', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Niveles de Logro', desc: 'Definir niveles de desempeño', ruta: '/niveles', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Escalas de Calificación', desc: 'Escalas numéricas de evaluación', ruta: '/escalas', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Evaluaciones', desc: 'Calificar estudiantes', ruta: '/evaluacion', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Re-evaluaciones', desc: 'Gestionar re-evaluaciones', ruta: '/re-evaluations', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Retroalimentación', desc: 'Feedback a estudiantes', ruta: '/retroalimentacion', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Rúbricas Globales', desc: 'Plantillas de rúbricas del sistema', ruta: '/rubricas', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Mis Rúbricas', desc: 'Rúbricas personales', ruta: '/mis-rubricas', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Plantillas', desc: 'Plantillas del sistema', ruta: '/plantillas', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Mis Cursos', desc: 'Cursos asignados', ruta: '/mis-cursos', roles: ['admin', 'teacher', 'docente', 'student'] },
  { nombre: 'Estudiantes', desc: 'Gestión de estudiantes', ruta: '/estudiantes', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Seguimiento de Grupo', desc: 'Seguimiento grupal de desempeño', ruta: '/group-tracking', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Asistencia', desc: 'Control de asistencia', ruta: '/asistencia', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Planes de Mejora', desc: 'Planes de mejoramiento estudiantil', ruta: '/improvement-plans', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Boletín', desc: 'Boletines estudiantiles', ruta: '/boletin', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Evidencias de Proyecto', desc: 'Evidencias de proyectos', ruta: '/evidencias-proyecto', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Evidencias', desc: 'Gestión de evidencias', ruta: '/evidencias', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Periodos Académicos', desc: 'Gestión de periodos académicos', ruta: '/academic-periods', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Reportes', desc: 'Reportes del sistema', ruta: '/reportes', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Reportes de Dirección', desc: 'Reportes para directivos', ruta: '/reportes-director', roles: ['admin'] },
  { nombre: 'Exportación', desc: 'Exportar datos del sistema', ruta: '/exportar', roles: ['admin', 'teacher', 'docente'] },
  { nombre: 'Auditoría', desc: 'Registro de actividad del sistema', ruta: '/auditoria', roles: ['admin'] },
  { nombre: 'Gestión de Usuarios', desc: 'Crear y administrar usuarios', ruta: '/users', roles: ['admin'] },
  { nombre: 'Roles y Permisos', desc: 'Gestionar roles del sistema', ruta: '/roles', roles: ['admin'] },
  { nombre: 'Configuración del Sistema', desc: 'Ajustes generales', ruta: '/config', roles: ['admin'] },
  { nombre: 'Mi Progreso', desc: 'Ver mi progreso académico', ruta: '/progresos', roles: ['student'] },
]

function useNotificaciones(studentId) {
  const [notificaciones, setNotificaciones] = useState([])
  const [mostrarModal, setMostrarModal] = useState(false)

  useEffect(() => {
    if (!studentId) {
      setNotificaciones([])
      return undefined
    }

    const cargar = async () => {
      try {
        const res = await axios.get(`/api/notificaciones/${studentId}`)
        setNotificaciones(res.data || [])
      } catch (error) {
        console.error('Error al cargar notificaciones:', error)
      }
    }

    cargar()
    const intervalo = setInterval(cargar, 30000)
    return () => clearInterval(intervalo)
  }, [studentId])

  const marcarLeida = async (notificacionId) => {
    await axios.put(`/api/notificaciones/${notificacionId}/leer`)
    setNotificaciones((actuales) => actuales.filter((n) => n.id !== notificacionId))
  }

  return {
    notificaciones,
    mostrarModal,
    setMostrarModal,
    marcarLeida,
  }
}

export default function Layout({ children, usuario }) {
  const navigate = useNavigate()
  const [sidebarExpandido, setSidebarExpandido] = useState(false)
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false)
  const [configAbierta, setConfigAbierta] = useState(false)
  const [busqueda, setBusqueda] = useState('')
  const [indiceSel, setIndiceSel] = useState(0)
  const refBusqueda = useRef(null)
  const {
    notificaciones,
    mostrarModal,
    setMostrarModal,
    marcarLeida,
  } = useNotificaciones(usuario?.id)

  const rol = usuario?.rol?.toLowerCase()
  const resultados = busqueda.trim().length > 0
    ? SECCIONES.filter(s =>
        s.roles.includes(rol) &&
        (s.nombre.toLowerCase().includes(busqueda.toLowerCase()) ||
         s.desc.toLowerCase().includes(busqueda.toLowerCase()))
      ).slice(0, 8)
    : []

  const irA = (ruta) => {
    setBusqueda('')
    navigate(ruta)
  }

  const onKeyDown = (e) => {
    if (!resultados.length) return
    if (e.key === 'ArrowDown') { e.preventDefault(); setIndiceSel(i => Math.min(i + 1, resultados.length - 1)) }
    if (e.key === 'ArrowUp')   { e.preventDefault(); setIndiceSel(i => Math.max(i - 1, 0)) }
    if (e.key === 'Enter')     { irA(resultados[indiceSel]?.ruta) }
    if (e.key === 'Escape')    { setBusqueda('') }
  }

  useEffect(() => { setIndiceSel(0) }, [busqueda])

  useEffect(() => {
    const handler = (e) => {
      if (refBusqueda.current && !refBusqueda.current.contains(e.target)) {
        setBusqueda('')
      }
    }
    document.addEventListener('mousedown', handler)
    return () => document.removeEventListener('mousedown', handler)
  }, [])

  const handleLogout = () => {
    localStorage.removeItem('acceso_token')
    localStorage.removeItem('usuario')
    navigate('/login')
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950">
      {/* Header Premium */}
      <header className="fixed top-0 left-0 right-0 h-20 bg-gradient-to-r from-neutral-950/95 to-neutral-900/95 border-b border-neutral-800/50 backdrop-blur-xl z-50">
        <div className="h-full px-4 sm:px-6 lg:px-8 flex items-center justify-between">
          {/* Left - Logo */}
          <div className="flex items-center gap-4">
            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="lg:hidden p-2 hover:bg-neutral-800 rounded-lg transition"
            >
              <Menu className="w-5 h-5 text-neutral-400" />
            </button>
            <div className="hidden sm:flex items-center gap-3">
              <div className="p-2 bg-gradient-to-br from-primary-brand to-primary-600 rounded-lg shadow-lg shadow-primary-brand/20">
                <span className="text-white font-bold text-lg">E</span>
              </div>
              <div>
                <p className="text-sm font-bold text-white">EduMax</p>
                <p className="text-xs text-neutral-500">Sistema Académico</p>
              </div>
            </div>
          </div>

          {/* Center - Search */}
          <div className="hidden md:flex flex-1 max-w-md mx-8 relative" ref={refBusqueda}>
            <div className="w-full flex items-center gap-2 px-4 py-2 bg-neutral-800/30 rounded-lg border border-neutral-700/50 focus-within:border-primary-brand/50 transition">
              <Search className="w-4 h-4 text-neutral-500 shrink-0" />
              <input
                type="text"
                value={busqueda}
                onChange={e => setBusqueda(e.target.value)}
                onKeyDown={onKeyDown}
                placeholder="Buscar sección..."
                className="w-full bg-transparent text-sm text-white placeholder-neutral-500 outline-none"
              />
              {busqueda && (
                <button onClick={() => setBusqueda('')}>
                  <X className="w-4 h-4 text-neutral-500 hover:text-neutral-300" />
                </button>
              )}
            </div>

            {resultados.length > 0 && (
              <div className="absolute top-full left-0 right-0 mt-2 bg-neutral-950 border border-neutral-700 rounded-lg shadow-2xl shadow-black/50 overflow-hidden z-50">
                {resultados.map((seccion, i) => (
                  <button
                    key={seccion.ruta}
                    onClick={() => irA(seccion.ruta)}
                    onMouseEnter={() => setIndiceSel(i)}
                    className={`w-full text-left px-4 py-3 flex flex-col gap-0.5 transition ${
                      i === indiceSel ? 'bg-primary-brand/20' : 'hover:bg-neutral-800/60'
                    }`}
                  >
                    <span className="text-sm font-medium text-white">{seccion.nombre}</span>
                    <span className="text-xs text-neutral-500">{seccion.desc}</span>
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Right - Actions */}
          <div className="flex items-center gap-4">
            {/* Notificaciones */}
            <div className="relative hidden sm:block">
              <button
                onClick={() => setMostrarModal(!mostrarModal)}
                className="p-2 hover:bg-neutral-800 rounded-lg transition relative group"
                title="Notificaciones"
              >
                <Bell className="w-5 h-5 text-neutral-400 group-hover:text-neutral-200" />
                {notificaciones.length > 0 && (
                  <span className="absolute -top-1 -right-1 bg-danger text-white rounded-full w-5 h-5 flex items-center justify-center text-xs font-bold">
                    {notificaciones.length}
                  </span>
                )}
              </button>

              {mostrarModal && (
                <div className="absolute right-0 mt-3 w-80 rounded-lg border border-neutral-700 bg-neutral-950 shadow-2xl shadow-black/40 overflow-hidden">
                  <div className="px-4 py-3 border-b border-neutral-800">
                    <p className="text-sm font-bold text-white">Notificaciones</p>
                    <p className="text-xs text-neutral-500">Avisos pendientes</p>
                  </div>

                  <div className="max-h-96 overflow-y-auto p-3 space-y-3">
                    {notificaciones.length === 0 ? (
                      <p className="py-6 text-center text-sm text-neutral-400">Sin notificaciones</p>
                    ) : (
                      notificaciones.map((notificacion) => (
                        <div key={notificacion.id} className="rounded-lg border border-neutral-800 bg-neutral-900/70 p-3">
                          <h4 className="text-sm font-bold text-white mb-1">{notificacion.titulo}</h4>
                          <p className="text-xs text-neutral-400 mb-3">{notificacion.mensaje}</p>
                          <button
                            onClick={() => marcarLeida(notificacion.id)}
                            className="bg-primary-brand hover:bg-primary-600 text-white border-0 px-3 py-1.5 rounded text-xs font-semibold transition"
                          >
                            Marcar como leida
                          </button>
                        </div>
                      ))
                    )}
                  </div>
                </div>
              )}
            </div>

            {/* Settings */}
            <div className="relative hidden sm:block">
              <button
                onClick={() => setConfigAbierta((abierta) => !abierta)}
                className="p-2 hover:bg-neutral-800 rounded-lg transition"
                title="Configuracion"
              >
                <Settings className="w-5 h-5 text-neutral-400 hover:text-neutral-200" />
              </button>

              {configAbierta && (
                <div className="absolute right-0 mt-3 w-72 rounded-lg border border-neutral-700 bg-neutral-950 shadow-2xl shadow-black/40 overflow-hidden">
                  <div className="px-4 py-3 border-b border-neutral-800">
                    <p className="text-sm font-bold text-white">Configuracion rapida</p>
                    <p className="text-xs text-neutral-500">
                      {usuario?.rol === 'student' ? 'Opciones de estudiante' :
                       usuario?.rol === 'teacher' ? 'Opciones de docente' : 'Opciones de administrador'}
                    </p>
                  </div>

                  <div className="p-2">
                    {(usuario?.rol === 'admin' || usuario?.rol === 'teacher' || usuario?.rol === 'docente') && (
                      <button
                        onClick={() => {
                          setConfigAbierta(false)
                          navigate('/academic-periods')
                        }}
                        className="w-full text-left px-3 py-2 rounded-lg text-sm text-neutral-300 hover:bg-neutral-800 hover:text-white transition"
                      >
                        Periodos academicos
                      </button>
                    )}

                    <button
                      onClick={() => {
                        setConfigAbierta(false)
                        navigate('/escalas')
                      }}
                      className="w-full text-left px-3 py-2 rounded-lg text-sm text-neutral-300 hover:bg-neutral-800 hover:text-white transition"
                    >
                      Escalas de calificacion
                    </button>

                    {usuario?.rol === 'admin' && (
                      <button
                        onClick={() => {
                          setConfigAbierta(false)
                          navigate('/config')
                        }}
                        className="w-full text-left px-3 py-2 rounded-lg text-sm text-neutral-300 hover:bg-neutral-800 hover:text-white transition"
                      >
                        Configuracion del sistema
                      </button>
                    )}

                    <button
                      onClick={() => {
                        setConfigAbierta(false)
                        navigate('/')
                      }}
                      className="w-full text-left px-3 py-2 rounded-lg text-sm text-neutral-300 hover:bg-neutral-800 hover:text-white transition"
                    >
                      Volver al dashboard
                    </button>
                  </div>
                </div>
              )}
            </div>

            {/* User Profile - Premium */}
            <div className="flex items-center gap-3 pl-4 border-l border-neutral-800">
              <div className="hidden sm:block text-right">
                <p className="text-sm font-semibold text-white truncate max-w-[150px]">
                  {usuario?.name || 'Usuario'}
                </p>
                <p className="text-xs text-neutral-500 capitalize">
                  {usuario?.rol === 'student' ? 'Estudiante' : 
                   usuario?.rol === 'teacher' ? 'Docente' : 'Administrador'}
                </p>
              </div>
              <div className="w-10 h-10 bg-gradient-to-br from-primary-brand to-primary-600 rounded-full flex items-center justify-center">
                <User className="w-5 h-5 text-white" />
              </div>
            </div>

            {/* Logout */}
            <button
              onClick={handleLogout}
              className="p-2 hover:bg-danger/10 rounded-lg transition text-neutral-400 hover:text-danger"
              title="Cerrar sesión"
            >
              <LogOut className="w-5 h-5" />
            </button>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <div className="flex pt-20">
        {/* Sidebar */}
        <Sidebar 
          usuario={usuario} 
          onToggleExpand={(estado) => setSidebarExpandido(estado)} 
        />

        {/* Content Area */}
        <main className={`flex-1 transition-all duration-300 ${sidebarExpandido ? 'ml-80' : 'ml-20'}`}>
          {/* Content Wrapper */}
          <div className="min-h-[calc(100vh-80px)]">
            {children}
          </div>

          {/* Footer Premium */}
          <footer className="border-t border-neutral-800/50 bg-gradient-to-r from-neutral-950/50 to-neutral-900/50 backdrop-blur-sm">
            <div className="px-6 py-8 md:px-8">
              <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-8">
                {/* About */}
                <div>
                  <h4 className="text-sm font-bold text-white mb-4">EduMax</h4>
                  <p className="text-sm text-neutral-500">
                    Sistema de evaluación por competencias automatizado para instituciones educativas.
                  </p>
                </div>

                {/* Links */}
                <div>
                  <h4 className="text-sm font-bold text-white mb-4">Producto</h4>
                  <ul className="space-y-2 text-sm text-neutral-500">
                    <li><a href="#" className="hover:text-primary-brand transition">Características</a></li>
                    <li><a href="#" className="hover:text-primary-brand transition">Precios</a></li>
                    <li><a href="#" className="hover:text-primary-brand transition">Documentación</a></li>
                  </ul>
                </div>

                {/* Support */}
                <div>
                  <h4 className="text-sm font-bold text-white mb-4">Soporte</h4>
                  <ul className="space-y-2 text-sm text-neutral-500">
                    <li><a href="#" className="hover:text-primary-brand transition">Centro de ayuda</a></li>
                    <li><a href="#" className="hover:text-primary-brand transition">Contacto</a></li>
                    <li><a href="#" className="hover:text-primary-brand transition">Estado del sistema</a></li>
                  </ul>
                </div>

                {/* Legal */}
                <div>
                  <h4 className="text-sm font-bold text-white mb-4">Legal</h4>
                  <ul className="space-y-2 text-sm text-neutral-500">
                    <li><a href="#" className="hover:text-primary-brand transition">Privacidad</a></li>
                    <li><a href="#" className="hover:text-primary-brand transition">Términos</a></li>
                    <li><a href="#" className="hover:text-primary-brand transition">Cookies</a></li>
                  </ul>
                </div>
              </div>

              {/* Bottom Bar */}
              <div className="border-t border-neutral-800/50 pt-6 flex flex-col sm:flex-row justify-between items-center">
                <p className="text-sm text-neutral-600">
                  © 2026 EduMax. Todos los derechos reservados.
                </p>
                <div className="flex items-center gap-4 mt-4 sm:mt-0">
                  <span className="text-sm text-neutral-600">v1.0</span>
                  <div className="flex items-center gap-1">
                    <div className="w-2 h-2 bg-success rounded-full animate-pulse"></div>
                    <span className="text-xs text-neutral-600">Sistema activo</span>
                  </div>
                </div>
              </div>
            </div>
          </footer>
        </main>
      </div>
    </div>
  )
}
