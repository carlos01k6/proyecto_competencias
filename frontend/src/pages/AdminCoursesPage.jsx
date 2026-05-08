import React, { useEffect, useState } from "react"
import {
  BookOpen, Users, X, UserPlus, UserMinus, ToggleLeft, ToggleRight,
  Plus, Pencil, Save, User, GraduationCap,
} from "lucide-react"
import axios from "axios"

const API = "http://localhost:5000/api"
const auth = () => {
  const t = localStorage.getItem("acceso_token")
  return t ? { Authorization: `Bearer ${t}` } : {}
}
const EMPTY = { nombre: "", codigo: "", descripcion: "", docente_id: "" }

export default function AdminCoursesPage() {
  const [cursos, setCursos] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)
  const [docentes, setDocentes] = useState([])
  const [estudiantes, setEstudiantes] = useState([])

  // Modal miembros
  const [modalCurso, setModalCurso] = useState(null)
  const [inscritos, setInscritos] = useState([])
  const [cargandoModal, setCargandoModal] = useState(false)
  const [msgModal, setMsgModal] = useState(null)
  const [studentIdSel, setStudentIdSel] = useState("")
  const [tabModal, setTabModal] = useState("estudiantes")

  // Modal crear/editar
  const [modalForm, setModalForm] = useState(null) // null | 'crear' | objeto curso
  const [form, setForm] = useState(EMPTY)
  const [guardando, setGuardando] = useState(false)
  const [msgForm, setMsgForm] = useState(null)

  const cargarCursos = async () => {
    setCargando(true); setError(null)
    try {
      const res = await axios.get(`${API}/cursos`, { headers: auth() })
      setCursos(Array.isArray(res.data) ? res.data : [])
    } catch (e) {
      setError(e.response?.data?.error || e.message)
    } finally { setCargando(false) }
  }

  useEffect(() => {
    cargarCursos()
    axios.get(`${API}/usuarios`, { headers: auth() }).then(res => {
      const lista = Array.isArray(res.data) ? res.data : []
      setDocentes(lista.filter(u => ["teacher", "docente"].includes((u.role || u.rol || "").toLowerCase())))
      setEstudiantes(lista.filter(u => ["student", "estudiante"].includes((u.role || u.rol || "").toLowerCase())))
    }).catch(() => {})
  }, [])

  const nombreDocente = (id) => {
    const d = docentes.find(d => d.id === id)
    return d ? (d.nombre || d.name || d.email) : "—"
  }

  const toggleEstado = async (curso) => {
    const nuevo = curso.estado === "activo" ? "inactivo" : "activo"
    try {
      await axios.put(`${API}/cursos/${curso.id}/estado`, { estado: nuevo }, { headers: auth() })
      setCursos(prev => prev.map(c => c.id === curso.id ? { ...c, estado: nuevo } : c))
    } catch (e) { alert(e.response?.data?.error || e.message) }
  }

  // ── Modal miembros ──
  const abrirMiembros = async (curso) => {
    setModalCurso(curso); setMsgModal(null); setStudentIdSel(""); setTabModal("estudiantes")
    setCargandoModal(true)
    try {
      const res = await axios.get(`${API}/cursos/${curso.id}/estudiantes`, { headers: auth() })
      setInscritos(Array.isArray(res.data) ? res.data : [])
    } catch { setInscritos([]) } finally { setCargandoModal(false) }
  }
  const cerrarMiembros = () => { setModalCurso(null); cargarCursos() }

  const inscribir = async () => {
    if (!studentIdSel) { setMsgModal({ tipo: "error", texto: "Selecciona un estudiante" }); return }
    setMsgModal(null)
    try {
      await axios.post(`${API}/cursos/${modalCurso.id}/inscribir`, { student_id: studentIdSel }, { headers: auth() })
      setMsgModal({ tipo: "ok", texto: "Estudiante inscrito" })
      setStudentIdSel("")
      const res = await axios.get(`${API}/cursos/${modalCurso.id}/estudiantes`, { headers: auth() })
      setInscritos(Array.isArray(res.data) ? res.data : [])
    } catch (e) { setMsgModal({ tipo: "error", texto: e.response?.data?.error || e.message }) }
  }

  const desinscribir = async (id) => {
    if (!window.confirm("¿Desinscribir este estudiante?")) return
    try {
      await axios.delete(`${API}/cursos/${modalCurso.id}/desinscribir/${id}`, { headers: auth() })
      setInscritos(prev => prev.filter(e => e.id !== id))
    } catch (e) { alert(e.response?.data?.error || e.message) }
  }

  const cambiarDocente = async (docenteId) => {
    try {
      await axios.put(`${API}/cursos/${modalCurso.id}`, { docente_id: docenteId || null }, { headers: auth() })
      setModalCurso(prev => ({ ...prev, docente_id: docenteId }))
      setMsgModal({ tipo: "ok", texto: "Docente actualizado" })
      cargarCursos()
    } catch (e) { setMsgModal({ tipo: "error", texto: e.response?.data?.error || e.message }) }
  }

  const noInscritos = estudiantes.filter(e => !inscritos.some(i => i.id === e.id))

  // ── Modal crear/editar ──
  const abrirCrear = () => { setForm(EMPTY); setMsgForm(null); setModalForm("crear") }
  const abrirEditar = (c) => {
    setForm({ nombre: c.nombre || "", codigo: c.codigo || "", descripcion: c.descripcion || "", docente_id: c.docente_id || "" })
    setMsgForm(null); setModalForm(c)
  }
  const cerrarForm = () => setModalForm(null)

  const guardar = async () => {
    if (!form.nombre.trim()) { setMsgForm({ tipo: "error", texto: "El nombre es requerido" }); return }
    setGuardando(true); setMsgForm(null)
    try {
      const payload = { ...form, docente_id: form.docente_id || null }
      if (modalForm === "crear") {
        await axios.post(`${API}/cursos`, payload, { headers: auth() })
      } else {
        await axios.put(`${API}/cursos/${modalForm.id}`, payload, { headers: auth() })
      }
      await cargarCursos(); cerrarForm()
    } catch (e) {
      setMsgForm({ tipo: "error", texto: e.response?.data?.error || e.message })
    } finally { setGuardando(false) }
  }

  const F = ({ label, required, children }) => (
    <div>
      <label className="block text-sm font-semibold text-neutral-300 mb-1.5">
        {label} {required && <span className="text-red-400">*</span>}
      </label>
      {children}
    </div>
  )

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">

      {/* Header */}
      <div className="mb-8 flex items-center justify-between gap-3">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-gradient-to-br from-cyan-600 to-cyan-700 rounded-lg">
            <BookOpen className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Cursos</h1>
            <p className="text-neutral-400">{cursos.length} cursos registrados</p>
          </div>
        </div>
        <button onClick={abrirCrear} className="flex items-center gap-2 px-5 py-2.5 bg-gradient-to-r from-cyan-600 to-cyan-700 hover:from-cyan-500 text-white rounded-xl font-semibold transition shadow-lg">
          <Plus className="w-4 h-4" /> Crear Curso
        </button>
      </div>

      {error && <div className="bg-red-500/10 border border-red-500/30 rounded-lg p-4 mb-6 text-red-400">{error}</div>}

      {/* Tabla */}
      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
        {cargando ? (
          <div className="py-12 text-center text-neutral-400">Cargando cursos...</div>
        ) : cursos.length === 0 ? (
          <div className="py-16 text-center">
            <BookOpen className="w-12 h-12 text-neutral-700 mx-auto mb-3" />
            <p className="text-neutral-400 mb-4">No hay cursos registrados</p>
            <button onClick={abrirCrear} className="px-4 py-2 bg-cyan-600 hover:bg-cyan-500 text-white rounded-lg text-sm font-semibold transition">Crear primer curso</button>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="bg-neutral-900/50 border-b border-neutral-700/50">
                  {['Curso', 'Código', 'Docente', 'Alumnos', 'Estado', 'Acciones'].map(h => (
                    <th key={h} className="px-5 py-4 text-left font-semibold text-neutral-300 text-sm">{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {cursos.map(curso => {
                  const activo = curso.estado === "activo" || curso.estado == null
                  return (
                    <tr key={curso.id} className="border-b border-neutral-800/50 hover:bg-neutral-900/40 transition">
                      <td className="px-5 py-4">
                        <p className="text-white font-semibold">{curso.nombre || "Sin nombre"}</p>
                        {curso.descripcion && <p className="text-neutral-500 text-xs mt-0.5 max-w-xs truncate">{curso.descripcion}</p>}
                      </td>
                      <td className="px-5 py-4 text-neutral-400 font-mono text-sm">{curso.codigo || "—"}</td>
                      <td className="px-5 py-4">
                        {curso.docente_id ? (
                          <span className="flex items-center gap-1.5 text-sm text-neutral-300">
                            <GraduationCap className="w-3.5 h-3.5 text-purple-400" />
                            {nombreDocente(curso.docente_id)}
                          </span>
                        ) : <span className="text-neutral-600 text-sm italic">Sin asignar</span>}
                      </td>
                      <td className="px-5 py-4 text-neutral-300 text-sm">{curso.total_estudiantes ?? "—"}</td>
                      <td className="px-5 py-4">
                        <span className={`px-2.5 py-1 rounded-full text-xs font-semibold ${activo ? "bg-emerald-500/20 text-emerald-300 border border-emerald-500/30" : "bg-neutral-700/50 text-neutral-400 border border-neutral-700"}`}>
                          {activo ? "Activo" : "Inactivo"}
                        </span>
                      </td>
                      <td className="px-5 py-4">
                        <div className="flex gap-2">
                          <button onClick={() => abrirEditar(curso)} title="Editar" className="p-2 rounded-lg bg-neutral-700/50 hover:bg-neutral-700 text-neutral-300 transition">
                            <Pencil className="w-3.5 h-3.5" />
                          </button>
                          <button onClick={() => toggleEstado(curso)} title={activo ? "Desactivar" : "Activar"} className={`p-2 rounded-lg transition ${activo ? "bg-red-500/20 text-red-400 hover:bg-red-500/30" : "bg-emerald-500/20 text-emerald-400 hover:bg-emerald-500/30"}`}>
                            {activo ? <ToggleRight className="w-3.5 h-3.5" /> : <ToggleLeft className="w-3.5 h-3.5" />}
                          </button>
                          <button onClick={() => abrirMiembros(curso)} title="Gestionar miembros" className="p-2 rounded-lg bg-blue-500/20 text-blue-400 hover:bg-blue-500/30 transition">
                            <Users className="w-3.5 h-3.5" />
                          </button>
                        </div>
                      </td>
                    </tr>
                  )
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* ══ MODAL CREAR / EDITAR ══ */}
      {modalForm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
          <div className="bg-neutral-900 border border-neutral-700/50 rounded-2xl shadow-2xl w-full max-w-md">
            <div className="flex items-center justify-between p-6 border-b border-neutral-700/50">
              <h2 className="text-lg font-bold text-white">{modalForm === "crear" ? "Crear Nuevo Curso" : `Editar — ${modalForm.nombre}`}</h2>
              <button onClick={cerrarForm} className="text-neutral-400 hover:text-white"><X className="w-5 h-5" /></button>
            </div>
            <div className="p-6 space-y-4">
              {msgForm && (
                <div className={`rounded-lg px-4 py-3 text-sm ${msgForm.tipo === "ok" ? "bg-emerald-500/10 border border-emerald-500/30 text-emerald-300" : "bg-red-500/10 border border-red-500/30 text-red-400"}`}>{msgForm.texto}</div>
              )}
              <F label="Nombre" required>
                <input value={form.nombre} onChange={e => setForm(p => ({ ...p, nombre: e.target.value }))} placeholder="Ej: Programación I" className="w-full bg-neutral-800 border border-neutral-700 text-white rounded-lg px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-cyan-500" />
              </F>
              <F label="Código">
                <input value={form.codigo} onChange={e => setForm(p => ({ ...p, codigo: e.target.value }))} placeholder="Ej: PROG-101" className="w-full bg-neutral-800 border border-neutral-700 text-white rounded-lg px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-cyan-500" />
              </F>
              <F label="Descripción">
                <textarea value={form.descripcion} onChange={e => setForm(p => ({ ...p, descripcion: e.target.value }))} rows={2} placeholder="Descripción opcional..." className="w-full bg-neutral-800 border border-neutral-700 text-white rounded-lg px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-cyan-500 resize-none" />
              </F>
              <F label="Docente asignado">
                <select value={form.docente_id} onChange={e => setForm(p => ({ ...p, docente_id: e.target.value }))} className="w-full bg-neutral-800 border border-neutral-700 text-white rounded-lg px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-cyan-500">
                  <option value="">— Sin asignar —</option>
                  {docentes.map(d => <option key={d.id} value={d.id}>{d.nombre || d.name || d.email}</option>)}
                </select>
              </F>
            </div>
            <div className="p-6 pt-0 flex gap-3">
              <button onClick={guardar} disabled={guardando} className="flex-1 flex items-center justify-center gap-2 bg-gradient-to-r from-cyan-600 to-cyan-700 hover:from-cyan-500 disabled:opacity-50 text-white py-3 rounded-xl font-semibold transition">
                <Save className="w-4 h-4" />{guardando ? "Guardando..." : modalForm === "crear" ? "Crear Curso" : "Guardar Cambios"}
              </button>
              <button onClick={cerrarForm} className="px-5 py-3 bg-neutral-800 hover:bg-neutral-700 text-neutral-300 rounded-xl transition">Cancelar</button>
            </div>
          </div>
        </div>
      )}

      {/* ══ MODAL MIEMBROS ══ */}
      {modalCurso && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
          <div className="bg-neutral-900 border border-neutral-700/50 rounded-2xl shadow-2xl w-full max-w-lg max-h-[90vh] flex flex-col">
            <div className="flex items-center justify-between p-6 border-b border-neutral-700/50 flex-shrink-0">
              <div>
                <h2 className="text-lg font-bold text-white">{modalCurso.nombre}</h2>
                <p className="text-sm text-neutral-400">{inscritos.length} estudiantes inscritos</p>
              </div>
              <button onClick={cerrarMiembros} className="text-neutral-400 hover:text-white"><X className="w-5 h-5" /></button>
            </div>

            <div className="flex border-b border-neutral-700/50 flex-shrink-0">
              {[{ id: "estudiantes", label: "Estudiantes", Icon: Users }, { id: "docente", label: "Docente", Icon: GraduationCap }].map(t => (
                <button key={t.id} onClick={() => setTabModal(t.id)} className={`flex-1 flex items-center justify-center gap-2 py-3 text-sm font-semibold transition ${tabModal === t.id ? "border-b-2 border-cyan-500 text-cyan-400" : "text-neutral-400 hover:text-white"}`}>
                  <t.Icon className="w-4 h-4" />{t.label}
                </button>
              ))}
            </div>

            <div className="p-6 overflow-y-auto flex-1 space-y-4">
              {msgModal && (
                <div className={`rounded-lg px-4 py-3 text-sm ${msgModal.tipo === "ok" ? "bg-emerald-500/10 border border-emerald-500/30 text-emerald-300" : "bg-red-500/10 border border-red-500/30 text-red-400"}`}>{msgModal.texto}</div>
              )}

              {tabModal === "estudiantes" && (
                <>
                  <div>
                    <p className="text-sm font-semibold text-neutral-300 mb-2">Inscribir estudiante</p>
                    <div className="flex gap-2">
                      <select value={studentIdSel} onChange={e => setStudentIdSel(e.target.value)} className="flex-1 bg-neutral-800 border border-neutral-600 rounded-lg px-3 py-2 text-white text-sm focus:outline-none focus:border-cyan-500">
                        <option value="">Selecciona estudiante…</option>
                        {noInscritos.map(e => <option key={e.id} value={e.id}>{e.nombre || e.name || e.email}</option>)}
                      </select>
                      <button onClick={inscribir} className="px-3 py-2 bg-cyan-600 hover:bg-cyan-500 text-white rounded-lg transition"><UserPlus className="w-4 h-4" /></button>
                    </div>
                  </div>
                  <div>
                    <p className="text-sm font-semibold text-neutral-300 mb-2">Inscritos</p>
                    {cargandoModal ? <p className="text-neutral-500 text-sm">Cargando...</p>
                      : inscritos.length === 0 ? <p className="text-neutral-500 text-sm">Sin estudiantes inscritos</p>
                      : (
                        <div className="space-y-2">
                          {inscritos.map(est => (
                            <div key={est.id} className="flex items-center justify-between bg-neutral-800/50 rounded-lg px-4 py-2.5">
                              <div className="flex items-center gap-2">
                                <div className="w-7 h-7 rounded-full bg-neutral-700 flex items-center justify-center"><User className="w-3.5 h-3.5 text-neutral-400" /></div>
                                <div>
                                  <p className="text-sm text-white font-medium">{est.name || est.nombre || est.email}</p>
                                  <p className="text-xs text-neutral-500">{est.email}</p>
                                </div>
                              </div>
                              <button onClick={() => desinscribir(est.id)} className="p-1 text-red-400 hover:text-red-300 transition"><UserMinus className="w-4 h-4" /></button>
                            </div>
                          ))}
                        </div>
                      )}
                  </div>
                </>
              )}

              {tabModal === "docente" && (
                <div>
                  <p className="text-sm font-semibold text-neutral-300 mb-3">Docente asignado actualmente</p>
                  <div className="bg-neutral-800/50 rounded-xl p-4 mb-5">
                    {modalCurso.docente_id ? (
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-full bg-purple-600/30 flex items-center justify-center"><GraduationCap className="w-5 h-5 text-purple-400" /></div>
                        <div>
                          <p className="font-semibold text-white">{nombreDocente(modalCurso.docente_id)}</p>
                          <p className="text-xs text-neutral-500">{docentes.find(d => d.id === modalCurso.docente_id)?.email}</p>
                        </div>
                      </div>
                    ) : <p className="text-neutral-500 italic text-sm">Sin docente asignado</p>}
                  </div>
                  <p className="text-sm font-semibold text-neutral-300 mb-2">Cambiar docente</p>
                  <select
                    defaultValue={modalCurso.docente_id || ""}
                    onChange={e => cambiarDocente(e.target.value)}
                    className="w-full bg-neutral-800 border border-neutral-700 text-white rounded-lg px-3 py-2.5 text-sm focus:outline-none focus:border-purple-500"
                  >
                    <option value="">— Sin asignar —</option>
                    {docentes.map(d => <option key={d.id} value={d.id}>{d.nombre || d.name || d.email}</option>)}
                  </select>
                  <p className="text-xs text-neutral-500 mt-1.5">El cambio se aplica al seleccionar el docente</p>
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
