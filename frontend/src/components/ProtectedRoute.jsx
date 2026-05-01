import React from "react"
import { Navigate } from "react-router-dom"

export default function ProtectedRoute({ children, usuario, requiredRoles = [] }) {
  if (!usuario) {
    return <Navigate to="/login" replace />
  }

  const userRol = usuario?.rol?.toLowerCase()

  if (requiredRoles.length > 0 && !requiredRoles.includes(userRol)) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 flex items-center justify-center p-4">
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8 max-w-md text-center">
          <p className="text-4xl mb-4">🔒</p>
          <h1 className="text-2xl font-bold text-white mb-2">Acceso Denegado</h1>
          <p className="text-neutral-400 mb-6">No tienes permiso para acceder a esta página.</p>
          <a href="/" className="inline-block bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-6 py-2 rounded-lg font-semibold transition">
            Volver al Inicio
          </a>
        </div>
      </div>
    )
  }

  return children
}
