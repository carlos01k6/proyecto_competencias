import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import Sidebar from './Sidebar'
import { LogOut, User, Bell, Settings, Menu } from 'lucide-react'

export default function Layout({ children, usuario }) {
  const navigate = useNavigate()
  const [sidebarExpandido, setSidebarExpandido] = useState(false)
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false)

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

          {/* Center - Search (opcional) */}
          <div className="hidden md:flex flex-1 max-w-md mx-8">
            <div className="w-full px-4 py-2 bg-neutral-800/30 rounded-lg border border-neutral-700/50 focus-within:border-primary-brand/50 transition">
              <input
                type="text"
                placeholder="Buscar..."
                className="w-full bg-transparent text-sm text-white placeholder-neutral-500 outline-none"
              />
            </div>
          </div>

          {/* Right - Actions */}
          <div className="flex items-center gap-4">
            {/* Notificaciones */}
            <button className="p-2 hover:bg-neutral-800 rounded-lg transition relative group hidden sm:block">
              <Bell className="w-5 h-5 text-neutral-400 group-hover:text-neutral-200" />
              <span className="absolute top-1 right-1 w-2 h-2 bg-danger rounded-full animate-pulse"></span>
            </button>

            {/* Settings */}
            <button className="p-2 hover:bg-neutral-800 rounded-lg transition hidden sm:block">
              <Settings className="w-5 h-5 text-neutral-400 hover:text-neutral-200" />
            </button>

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