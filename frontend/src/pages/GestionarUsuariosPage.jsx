import React, { useEffect, useState } from "react"
import { Users } from "lucide-react"
import * as usuariosService from "../services/usuarios"

export default function GestionarUsuariosPage() {
  const [usuarios, setUsuarios] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  useEffect(() => {
    const cargarUsuarios = async () => {
      setCargando(true)
      setError(null)

      try {
        const data = await usuariosService.obtenerUsuarios()
        setUsuarios(Array.isArray(data) ? data : [])
      } catch (err) {
        setUsuarios([])
        setError(err.response?.data?.error || err.message)
      } finally {
        setCargando(false)
      }
    }

    cargarUsuarios()
  }, [])

  const formatearFecha = (fecha) => {
    if (!fecha) return "Sin fecha"

    const date = new Date(fecha)
    if (Number.isNaN(date.getTime())) return "Sin fecha"

    return date.toLocaleDateString("es-ES", {
      year: "numeric",
      month: "long",
      day: "numeric"
    })
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-gradient-to-br from-emerald-600 to-emerald-700 rounded-lg">
            <Users className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Gestionar Usuarios</h1>
            <p className="text-neutral-400">Usuarios registrados en el sistema</p>
          </div>
        </div>
      </div>

      {error && (
        <div className="bg-danger/10 border border-danger/30 rounded-lg p-4 mb-6">
          <p className="text-danger font-semibold">Error: {error}</p>
        </div>
      )}

      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
        {cargando ? (
          <div className="py-12 text-center text-neutral-400">Cargando usuarios...</div>
        ) : usuarios.length === 0 ? (
          <div className="py-12 text-center text-neutral-400">Sin usuarios</div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="bg-neutral-900/50 border-b border-neutral-700/50">
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Email</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Nombre</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Rol</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Fecha Registro</th>
                </tr>
              </thead>
              <tbody>
                {usuarios.map((usuario) => (
                  <tr key={usuario.id || usuario.email} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition">
                    <td className="px-6 py-4 text-white font-semibold">{usuario.email || "N/A"}</td>
                    <td className="px-6 py-4 text-neutral-300">{usuario.nombre || "N/A"}</td>
                    <td className="px-6 py-4 text-neutral-300">{usuario.role || "N/A"}</td>
                    <td className="px-6 py-4 text-neutral-400">{formatearFecha(usuario.created_at)}</td>
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
