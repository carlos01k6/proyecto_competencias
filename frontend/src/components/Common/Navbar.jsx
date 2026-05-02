import React from 'react'
import { useNavigate } from 'react-router-dom'

export default function Navbar({ usuario }) {
  const navigate = useNavigate()

  const handleLogout = () => {
    localStorage.removeItem('acceso_token')
    localStorage.removeItem('usuario')
    navigate('/login')
  }

  return (
    <nav className="bg-white border-b border-neutral-200 shadow-sm">
      <div className="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 bg-primary-brand rounded-lg flex items-center justify-center">
            <span className="text-white font-bold text-lg">E</span>
          </div>
          <h1 className="text-xl font-bold text-neutral-900">Evaluación por Competencias</h1>
        </div>
        
        <div className="flex items-center gap-6">
          <div className="text-right">
            <p className="font-semibold text-neutral-900">{usuario?.nombre || 'Usuario'}</p>
            <p className="text-sm text-neutral-600 capitalize">{usuario?.rol || 'Sin rol'}</p>
          </div>
          
          <button
            onClick={handleLogout}
            className="bg-danger hover:bg-red-700 text-white px-4 py-2 rounded-lg font-semibold transition"
          >
            Cerrar sesión
          </button>
        </div>
      </div>
    </nav>
  )
}
