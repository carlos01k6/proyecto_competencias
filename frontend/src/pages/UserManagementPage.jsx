import React, { useEffect, useState } from "react"
import { Users, UserPlus, X, Trash2, Pencil } from "lucide-react"
import * as usuariosService from "../services/users"

const ROLES = [
  { value: "student", label: "Estudiante" },
  { value: "teacher", label: "Docente" },
  { value: "admin", label: "Administrador" },
]

const ROL_LABELS = { student: "Estudiante", teacher: "Docente", admin: "Administrador" }

const ROL_COLORS = {
  student: "bg-blue-500/20 text-blue-300 border border-blue-500/30",
  teacher: "bg-emerald-500/20 text-emerald-300 border border-emerald-500/30",
  admin: "bg-purple-500/20 text-purple-300 border border-purple-500/30",
}

const FORM_INITIAL = { name: "", email: "", password: "", role: "student" }

export default function GestionarUsuariosPage() {
  const [usuarios, setUsuarios] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)
  const [modalAbierto, setModalAbierto] = useState(false)
  const [form, setForm] = useState(FORM_INITIAL)
  const [guardando, setGuardando] = useState(false)
  const [errorModal, setErrorModal] = useState(null)
  const [eliminando, setEliminando] = useState(null)
  const [confirmEliminar, setConfirmEliminar] = useState(null)
  const [editando, setEditando] = useState(null)
  const [formEdit, setFormEdit] = useState({ name: "", role: "student" })
  const [guardandoEdit, setGuardandoEdit] = useState(false)
  const [errorEdit, setErrorEdit] = useState(null)

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

  useEffect(() => { cargarUsuarios() }, [])

  const formatearFecha = (fecha) => {
    if (!fecha) return "Sin fecha"
    const date = new Date(fecha)
    if (Number.isNaN(date.getTime())) return "Sin fecha"
    return date.toLocaleDateString("es-ES", { year: "numeric", month: "long", day: "numeric" })
  }

  const abrirModal = () => {
    setForm(FORM_INITIAL)
    setErrorModal(null)
    setModalAbierto(true)
  }

  const cerrarModal = () => {
    if (guardando) return
    setModalAbierto(false)
  }

  const handleChange = (e) => {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }))
  }

  const abrirEditar = (usuario) => {
    setFormEdit({ name: usuario.nombre || "", role: usuario.role || "student" })
    setErrorEdit(null)
    setEditando(usuario)
  }

  const handleEditar = async (e) => {
    e.preventDefault()
    if (!formEdit.name.trim()) { setErrorEdit("El nombre es requerido."); return }
    setGuardandoEdit(true)
    setErrorEdit(null)
    try {
      await usuariosService.editarUsuario(editando.id, formEdit)
      setEditando(null)
      await cargarUsuarios()
    } catch (err) {
      setErrorEdit(err.response?.data?.error || err.message)
    } finally {
      setGuardandoEdit(false)
    }
  }

  const handleEliminar = async (usuario) => {
    setEliminando(usuario.id)
    try {
      await usuariosService.eliminarUsuario(usuario.id)
      setConfirmEliminar(null)
      await cargarUsuarios()
    } catch (err) {
      alert(err.response?.data?.error || err.message)
    } finally {
      setEliminando(null)
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setErrorModal(null)
    if (!form.name.trim() || !form.email.trim() || !form.password.trim()) {
      setErrorModal("Todos los campos son requeridos.")
      return
    }
    if (form.password.length < 6) {
      setErrorModal("La contraseña debe tener al menos 6 caracteres.")
      return
    }
    setGuardando(true)
    try {
      await usuariosService.crearUsuario(form)
      setModalAbierto(false)
      await cargarUsuarios()
    } catch (err) {
      setErrorModal(err.response?.data?.error || err.message)
    } finally {
      setGuardando(false)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-gradient-to-br from-emerald-600 to-emerald-700 rounded-lg">
            <Users className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Gestionar Usuarios</h1>
            <p className="text-neutral-400">Usuarios registrados en el sistema</p>
          </div>
        </div>
        <button
          onClick={abrirModal}
          className="flex items-center gap-2 px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white font-semibold rounded-lg transition"
        >
          <UserPlus className="w-4 h-4" />
          Crear Usuario
        </button>
      </div>

      {error && (
        <div className="bg-red-500/10 border border-red-500/30 rounded-lg p-4 mb-6">
          <p className="text-red-400 font-semibold">Error: {error}</p>
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
                  <th className="px-6 py-4 text-left font-semibold text-neutral-300">Acciones</th>
                </tr>
              </thead>
              <tbody>
                {usuarios.map((usuario) => (
                  <tr key={usuario.id || usuario.email} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition">
                    <td className="px-6 py-4 text-white font-semibold">{usuario.email || "N/A"}</td>
                    <td className="px-6 py-4 text-neutral-300">{usuario.nombre || "N/A"}</td>
                    <td className="px-6 py-4">
                      <span className={`px-2 py-1 rounded-full text-xs font-semibold ${ROL_COLORS[usuario.role] || "bg-neutral-700 text-neutral-300"}`}>
                        {ROL_LABELS[usuario.role] || usuario.role || "N/A"}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-neutral-400">{formatearFecha(usuario.created_at)}</td>
                    <td className="px-6 py-4">
                      <div className="flex gap-2">
                        <button
                          onClick={() => abrirEditar(usuario)}
                          className="p-2 text-neutral-400 hover:text-white hover:bg-neutral-700 rounded-lg transition"
                          title="Editar usuario"
                        >
                          <Pencil className="w-4 h-4" />
                        </button>
                        <button
                          onClick={() => setConfirmEliminar(usuario)}
                          className="p-2 text-red-400 hover:text-red-300 hover:bg-red-500/10 rounded-lg transition"
                          title="Eliminar usuario"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Modal editar usuario */}
      {editando && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm">
          <div className="bg-neutral-900 border border-neutral-700/50 rounded-2xl shadow-2xl w-full max-w-md mx-4">
            <div className="flex items-center justify-between p-6 border-b border-neutral-700/50">
              <h2 className="text-xl font-bold text-white">Editar Usuario</h2>
              <button onClick={() => setEditando(null)} className="text-neutral-400 hover:text-white transition">
                <X className="w-5 h-5" />
              </button>
            </div>
            <form onSubmit={handleEditar} className="p-6 space-y-4">
              {errorEdit && (
                <div className="bg-red-500/10 border border-red-500/30 rounded-lg p-3">
                  <p className="text-red-400 text-sm">{errorEdit}</p>
                </div>
              )}
              <p className="text-neutral-400 text-sm">{editando.email}</p>
              <div>
                <label className="block text-sm font-medium text-neutral-300 mb-1">Nombre completo</label>
                <input
                  type="text"
                  value={formEdit.name}
                  onChange={e => setFormEdit(p => ({ ...p, name: e.target.value }))}
                  className="w-full bg-neutral-800 border border-neutral-600 rounded-lg px-4 py-2 text-white placeholder-neutral-500 focus:outline-none focus:border-emerald-500 transition"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-neutral-300 mb-1">Rol</label>
                <select
                  value={formEdit.role}
                  onChange={e => setFormEdit(p => ({ ...p, role: e.target.value }))}
                  className="w-full bg-neutral-800 border border-neutral-600 rounded-lg px-4 py-2 text-white focus:outline-none focus:border-emerald-500 transition"
                >
                  {ROLES.map(r => <option key={r.value} value={r.value}>{r.label}</option>)}
                </select>
              </div>
              <div className="flex gap-3 pt-2">
                <button type="button" onClick={() => setEditando(null)} disabled={guardandoEdit}
                  className="flex-1 px-4 py-2 border border-neutral-600 text-neutral-300 rounded-lg hover:bg-neutral-800 transition disabled:opacity-50">
                  Cancelar
                </button>
                <button type="submit" disabled={guardandoEdit}
                  className="flex-1 px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white font-semibold rounded-lg transition disabled:opacity-50">
                  {guardandoEdit ? "Guardando..." : "Guardar Cambios"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Modal confirmar eliminación */}
      {confirmEliminar && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm">
          <div className="bg-neutral-900 border border-neutral-700/50 rounded-2xl shadow-2xl w-full max-w-sm mx-4 p-6">
            <div className="flex items-center gap-3 mb-4">
              <div className="p-2 bg-red-500/20 rounded-lg">
                <Trash2 className="w-5 h-5 text-red-400" />
              </div>
              <h2 className="text-xl font-bold text-white">Eliminar Usuario</h2>
            </div>
            <p className="text-neutral-300 mb-2">
              ¿Estás seguro que deseas eliminar este usuario?
            </p>
            <p className="text-neutral-400 text-sm mb-6">
              <span className="text-white font-semibold">{confirmEliminar.nombre}</span> ({confirmEliminar.email})
              <br />Esta acción no se puede deshacer.
            </p>
            <div className="flex gap-3">
              <button
                onClick={() => setConfirmEliminar(null)}
                disabled={eliminando === confirmEliminar.id}
                className="flex-1 px-4 py-2 border border-neutral-600 text-neutral-300 rounded-lg hover:bg-neutral-800 transition disabled:opacity-50"
              >
                Cancelar
              </button>
              <button
                onClick={() => handleEliminar(confirmEliminar)}
                disabled={eliminando === confirmEliminar.id}
                className="flex-1 px-4 py-2 bg-red-600 hover:bg-red-500 text-white font-semibold rounded-lg transition disabled:opacity-50"
              >
                {eliminando === confirmEliminar.id ? "Eliminando..." : "Eliminar"}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Modal crear usuario */}
      {modalAbierto && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm">
          <div className="bg-neutral-900 border border-neutral-700/50 rounded-2xl shadow-2xl w-full max-w-md mx-4">
            <div className="flex items-center justify-between p-6 border-b border-neutral-700/50">
              <h2 className="text-xl font-bold text-white">Crear Usuario</h2>
              <button onClick={cerrarModal} className="text-neutral-400 hover:text-white transition">
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="p-6 space-y-4">
              {errorModal && (
                <div className="bg-red-500/10 border border-red-500/30 rounded-lg p-3">
                  <p className="text-red-400 text-sm">{errorModal}</p>
                </div>
              )}

              <div>
                <label className="block text-sm font-medium text-neutral-300 mb-1">Nombre completo</label>
                <input
                  type="text"
                  name="name"
                  value={form.name}
                  onChange={handleChange}
                  placeholder="Ej: Juan Pérez"
                  className="w-full bg-neutral-800 border border-neutral-600 rounded-lg px-4 py-2 text-white placeholder-neutral-500 focus:outline-none focus:border-emerald-500 transition"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-neutral-300 mb-1">Email</label>
                <input
                  type="email"
                  name="email"
                  value={form.email}
                  onChange={handleChange}
                  placeholder="usuario@ejemplo.com"
                  className="w-full bg-neutral-800 border border-neutral-600 rounded-lg px-4 py-2 text-white placeholder-neutral-500 focus:outline-none focus:border-emerald-500 transition"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-neutral-300 mb-1">Contraseña</label>
                <input
                  type="password"
                  name="password"
                  value={form.password}
                  onChange={handleChange}
                  placeholder="Mínimo 6 caracteres"
                  className="w-full bg-neutral-800 border border-neutral-600 rounded-lg px-4 py-2 text-white placeholder-neutral-500 focus:outline-none focus:border-emerald-500 transition"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-neutral-300 mb-1">Rol</label>
                <select
                  name="role"
                  value={form.role}
                  onChange={handleChange}
                  className="w-full bg-neutral-800 border border-neutral-600 rounded-lg px-4 py-2 text-white focus:outline-none focus:border-emerald-500 transition"
                >
                  {ROLES.map((r) => (
                    <option key={r.value} value={r.value}>{r.label}</option>
                  ))}
                </select>
              </div>

              <div className="flex gap-3 pt-2">
                <button
                  type="button"
                  onClick={cerrarModal}
                  disabled={guardando}
                  className="flex-1 px-4 py-2 border border-neutral-600 text-neutral-300 rounded-lg hover:bg-neutral-800 transition disabled:opacity-50"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  disabled={guardando}
                  className="flex-1 px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white font-semibold rounded-lg transition disabled:opacity-50"
                >
                  {guardando ? "Creando..." : "Crear Usuario"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  )
}
