import React, { useEffect, useState } from "react"
import { FileCheck } from "lucide-react"
import * as rolesService from "../services/roles"

export default function RolesPermisoPage() {
  const [roles, setRoles] = useState([])
  const [permisos, setPermisos] = useState([])
  const [rolSeleccionado, setRolSeleccionado] = useState(null)
  const [cargandoRoles, setCargandoRoles] = useState(false)
  const [cargandoPermisos, setCargandoPermisos] = useState(false)
  const [error, setError] = useState(null)

  useEffect(() => {
    const cargarRoles = async () => {
      setCargandoRoles(true)
      setError(null)

      try {
        const data = await rolesService.obtenerRoles()
        setRoles(Array.isArray(data) ? data : [])
      } catch (err) {
        setRoles([])
        setError(err.response?.data?.error || err.message)
      } finally {
        setCargandoRoles(false)
      }
    }

    cargarRoles()
  }, [])

  const handleSeleccionarRol = async (rol) => {
    setRolSeleccionado(rol)
    setCargandoPermisos(true)
    setError(null)

    try {
      const data = await rolesService.obtenerPermisosRol(rol.id)
      setPermisos(Array.isArray(data) ? data : [])
      setRoles((prevRoles) =>
        prevRoles.map((item) =>
          item.id === rol.id ? { ...item, cantidad_permisos: Array.isArray(data) ? data.length : 0 } : item
        )
      )
    } catch (err) {
      setPermisos([])
      setError(err.response?.data?.error || err.message)
    } finally {
      setCargandoPermisos(false)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-gradient-to-br from-emerald-600 to-emerald-700 rounded-lg">
            <FileCheck className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Roles y Permisos</h1>
            <p className="text-neutral-400">Consulta permisos asignados por rol</p>
          </div>
        </div>
      </div>

      {error && (
        <div className="bg-danger/10 border border-danger/30 rounded-lg p-4 mb-6">
          <p className="text-danger font-semibold">Error: {error}</p>
        </div>
      )}

      <div className="grid grid-cols-1 xl:grid-cols-2 gap-6">
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
          {cargandoRoles ? (
            <div className="py-12 text-center text-neutral-400">Cargando roles...</div>
          ) : roles.length === 0 ? (
            <div className="py-12 text-center text-neutral-400">Sin roles</div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead>
                  <tr className="bg-neutral-900/50 border-b border-neutral-700/50">
                    <th className="px-6 py-4 text-left font-semibold text-neutral-300">Rol</th>
                    <th className="px-6 py-4 text-left font-semibold text-neutral-300">Descripción</th>
                    <th className="px-6 py-4 text-left font-semibold text-neutral-300">Cantidad Permisos</th>
                  </tr>
                </thead>
                <tbody>
                  {roles.map((rol) => (
                    <tr
                      key={rol.id}
                      onClick={() => handleSeleccionarRol(rol)}
                      className={`cursor-pointer border-b border-neutral-800/50 hover:bg-neutral-900/50 transition ${
                        rolSeleccionado?.id === rol.id ? "bg-primary-brand/10" : ""
                      }`}
                    >
                      <td className="px-6 py-4 text-white font-semibold">{rol.nombre || "N/A"}</td>
                      <td className="px-6 py-4 text-neutral-300">{rol.descripcion || "N/A"}</td>
                      <td className="px-6 py-4 text-primary-brand font-bold">{rol.cantidad_permisos ?? "-"}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>

        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
          <div className="p-6 border-b border-neutral-700/50">
            <h2 className="text-xl font-bold text-white">
              {rolSeleccionado ? `Permisos: ${rolSeleccionado.nombre}` : "Permisos"}
            </h2>
          </div>

          {cargandoPermisos ? (
            <div className="py-12 text-center text-neutral-400">Cargando permisos...</div>
          ) : !rolSeleccionado ? (
            <div className="py-12 text-center text-neutral-400">Selecciona un rol</div>
          ) : permisos.length === 0 ? (
            <div className="py-12 text-center text-neutral-400">Este rol no tiene permisos asignados</div>
          ) : (
            <table className="w-full">
              <thead>
                <tr className="bg-neutral-900/50 border-b border-neutral-700/50">
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Permiso</th>
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Acción</th>
                </tr>
              </thead>
              <tbody>
                {permisos.map((permiso) => (
                  <tr key={permiso.id || `${permiso.nombre}-${permiso.accion}`} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition">
                    <td className="px-6 py-4 text-white font-semibold">{permiso.nombre || "N/A"}</td>
                    <td className="px-6 py-4 text-neutral-300">{permiso.accion || "N/A"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </div>
  )
}
