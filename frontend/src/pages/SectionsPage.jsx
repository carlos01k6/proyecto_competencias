import React, { useEffect, useState } from "react"
import { LayoutGrid, Plus, Pencil, Trash2, Users, GraduationCap, X, UserPlus, UserMinus, User } from "lucide-react"
import * as svc from "../services/sections"
import axios from "axios"

const API = "http://localhost:5000/api"
const auth = () => {
  const t = localStorage.getItem("acceso_token")
  return t ? { Authorization: `Bearer ${t}` } : {}
}

const GRADOS = ["1ro", "2do", "3ro", "4to", "5to", "6to", "7mo", "8vo", "9no", "10mo", "11vo", "12vo"]
const LETRAS = ["A", "B", "C", "D", "E", "F", "G", "H"]
const EMPTY_FORM = { grade: "4to", letter: "A" }

export default function SectionsPage() {
  const [secciones, setSecciones] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const [todosUsuarios, setTodosUsuarios] = useState([])
  const [modalForm, setModalForm] = useState(null)
  const [form, setForm] = useState(EMPTY_FORM)
  const [guardando, setGuardando] = useState(false)
  const [msgForm, setMsgForm] = useState(null)

  const [modalMiembros, setModalMiembros] = useState(null)
  const [tabModal, setTabModal] = useState("estudiantes")
  const [inscritos, setInscritos] = useState([])
  const [docentes, setDocentes] = useState([])
  const [cargandoModal, setCargandoModal] = useState(false)
  const [selEstudiante, setSelEstudiante] = useState("")
  const [selDocente, setSelDocente] = useState("")
  const [msgModal, setMsgModal] = useState(null)

  const [confirmEliminar, setConfirmEliminar] = useState(null)
  const [eliminando, setEliminando] = useState(false)

  const cargar = async () => {
    setCargando(true); setError(null)
    try {
      const data = await svc.listarSecciones()
      setSecciones(Array.isArray(data) ? data : [])
    } catch (e) {
      setError(e.response?.data?.error || e.message)
    } finally { setCargando(false) }
  }

  useEffect(() => {
    cargar()
    axios.get(`${API}/usuarios`, { headers: auth() }).then(r => {
      setTodosUsuarios(Array.isArray(r.data) ? r.data : [])
    }).catch(() => {})
  }, [])

  const estudiantesList = todosUsuarios.filter(u => ["student", "estudiante"].includes((u.role || "").toLowerCase()))
  const docentesList = todosUsuarios.filter(u => ["teacher", "docente"].includes((u.role || "").toLowerCase()))

  // ── Modal crear / editar ──
  const abrirCrear = () => { setForm(EMPTY_FORM); setMsgForm(null); setModalForm("crear") }
  const abrirEditar = (s) => { setForm({ grade: s.grade, letter: s.letter }); setMsgForm(null); setModalForm(s) }

  const guardar = async () => {
    if (!form.grade || !form.letter) { setMsgForm({ tipo: "error", texto: "Grado y letra son requeridos" }); return }
    setGuardando(true); setMsgForm(null)
    try {
      if (modalForm === "crear") {
        await svc.crearSeccion(form)
      } else {
        await svc.editarSeccion(modalForm.id, form)
      }
      await cargar(); setModalForm(null)
    } catch (e) {
      setMsgForm({ tipo: "error", texto: e.response?.data?.error || e.message })
    } finally { setGuardando(false) }
  }

  // ── Modal miembros ──
  const abrirMiembros = async (seccion) => {
    setModalMiembros(seccion); setMsgModal(null)
    setSelEstudiante(""); setSelDocente(""); setTabModal("estudiantes")
    setCargandoModal(true)
    try {
      const [est, doc] = await Promise.all([svc.obtenerEstudiantes(seccion.id), svc.obtenerDocentes(seccion.id)])
      setInscritos(Array.isArray(est) ? est : [])
      setDocentes(Array.isArray(doc) ? doc : [])
    } catch { setInscritos([]); setDocentes([]) } finally { setCargandoModal(false) }
  }

  const inscribir = async () => {
    if (!selEstudiante) { setMsgModal({ tipo: "error", texto: "Selecciona un estudiante" }); return }
    try {
      await svc.inscribirEstudiante(modalMiembros.id, selEstudiante)
      setSelEstudiante(""); setMsgModal({ tipo: "ok", texto: "Estudiante inscrito" })
      const est = await svc.obtenerEstudiantes(modalMiembros.id)
      setInscritos(Array.isArray(est) ? est : [])
      cargar()
    } catch (e) { setMsgModal({ tipo: "error", texto: e.response?.data?.error || e.message }) }
  }

  const desinscribir = async (student_id) => {
    try {
      await svc.desinscribirEstudiante(modalMiembros.id, student_id)
      setInscritos(prev => prev.filter(e => e.id !== student_id)); cargar()
    } catch (e) { alert(e.response?.data?.error || e.message) }
  }

  const asignarDocente = async () => {
    if (!selDocente) { setMsgModal({ tipo: "error", texto: "Selecciona un docente" }); return }
    try {
      await svc.asignarDocente(modalMiembros.id, selDocente)
      setSelDocente(""); setMsgModal({ tipo: "ok", texto: "Docente asignado" })
      const doc = await svc.obtenerDocentes(modalMiembros.id)
      setDocentes(Array.isArray(doc) ? doc : [])
      cargar()
    } catch (e) { setMsgModal({ tipo: "error", texto: e.response?.data?.error || e.message }) }
  }

  const desasignarDocente = async (teacher_id) => {
    try {
      await svc.desasignarDocente(modalMiembros.id, teacher_id)
      setDocentes(prev => prev.filter(d => d.id !== teacher_id)); cargar()
    } catch (e) { alert(e.response?.data?.error || e.message) }
  }

  const handleEliminar = async () => {
    setEliminando(true)
    try {
      await svc.eliminarSeccion(confirmEliminar.id)
      setConfirmEliminar(null); await cargar()
    } catch (e) { alert(e.response?.data?.error || e.message) } finally { setEliminando(false) }
  }

  const noInscritos = estudiantesList.filter(e => !inscritos.some(i => i.id === e.id))
  const noAsignados = docentesList.filter(d => !docentes.some(a => a.id === d.id))

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">

      {/* Header */}
      <div className="mb-8 flex items-center justify-between gap-3">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-gradient-to-br from-violet-600 to-violet-700 rounded-lg">
            <LayoutGrid className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">Secciones</h1>
            <p className="text-neutral-400">{secciones.length} secciones registradas</p>
          </div>
        </div>
        <button onClick={abrirCrear}
          className="flex items-center gap-2 px-5 py-2.5 bg-gradient-to-r from-violet-600 to-violet-700 hover:from-violet-500 text-white rounded-xl font-semibold transition shadow-lg">
          <Plus className="w-4 h-4" /> Crear Sección
        </button>
      </div>

      {error && <div className="bg-red-500/10 border border-red-500/30 rounded-lg p-4 mb-6 text-red-400">{error}</div>}

      {/* Tabla */}
      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
        {cargando ? (
          <div className="py-12 text-center text-neutral-400">Cargando secciones...</div>
        ) : secciones.length === 0 ? (
          <div className="py-16 text-center">
            <LayoutGrid className="w-12 h-12 text-neutral-700 mx-auto mb-3" />
            <p className="text-neutral-400 mb-4">No hay secciones registradas</p>
            <button onClick={abrirCrear}
              className="px-4 py-2 bg-violet-600 hover:bg-violet-500 text-white rounded-lg text-sm font-semibold transition">
              Crear primera sección
            </button>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="bg-neutral-900/50 border-b border-neutral-700/50">
                  {["Sección", "Grado", "Letra", "Estudiantes", "Docentes", "Acciones"].map(h => (
                    <th key={h} className="px-5 py-4 text-left font-semibold text-neutral-300 text-sm">{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {secciones.map(sec => (
                  <tr key={sec.id} className="border-b border-neutral-800/50 hover:bg-neutral-900/40 transition">
                    <td className="px-5 py-4">
                      <span className="text-white font-bold text-lg">{sec.name}</span>
                    </td>
                    <td className="px-5 py-4 text-neutral-300">{sec.grade}</td>
                    <td className="px-5 py-4">
                      <span className="w-8 h-8 rounded-full bg-violet-500/20 text-violet-300 border border-violet-500/30 flex items-center justify-center font-bold text-sm">
                        {sec.letter}
                      </span>
                    </td>
                    <td className="px-5 py-4">
                      <span className="flex items-center gap-1.5 text-sm text-neutral-300">
                        <Users className="w-3.5 h-3.5 text-blue-400" />
                        {sec.total_estudiantes ?? 0}
                      </span>
                    </td>
                    <td className="px-5 py-4">
                      <span className="flex items-center gap-1.5 text-sm text-neutral-300">
                        <GraduationCap className="w-3.5 h-3.5 text-purple-400" />
                        {sec.total_docentes ?? 0}
                      </span>
                    </td>
                    <td className="px-5 py-4">
                      <div className="flex gap-2">
                        <button onClick={() => abrirEditar(sec)} title="Editar"
                          className="p-2 rounded-lg bg-neutral-700/50 hover:bg-neutral-700 text-neutral-300 transition">
                          <Pencil className="w-3.5 h-3.5" />
                        </button>
                        <button onClick={() => abrirMiembros(sec)} title="Gestionar miembros"
                          className="p-2 rounded-lg bg-blue-500/20 text-blue-400 hover:bg-blue-500/30 transition">
                          <Users className="w-3.5 h-3.5" />
                        </button>
                        <button onClick={() => setConfirmEliminar(sec)} title="Eliminar"
                          className="p-2 rounded-lg bg-red-500/20 text-red-400 hover:bg-red-500/30 transition">
                          <Trash2 className="w-3.5 h-3.5" />
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

      {/* ══ MODAL CREAR / EDITAR ══ */}
      {modalForm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
          <div className="bg-neutral-900 border border-neutral-700/50 rounded-2xl shadow-2xl w-full max-w-sm">
            <div className="flex items-center justify-between p-6 border-b border-neutral-700/50">
              <h2 className="text-lg font-bold text-white">{modalForm === "crear" ? "Crear Sección" : `Editar — ${modalForm.name}`}</h2>
              <button onClick={() => setModalForm(null)} className="text-neutral-400 hover:text-white"><X className="w-5 h-5" /></button>
            </div>
            <div className="p-6 space-y-4">
              {msgForm && (
                <div className={`rounded-lg px-4 py-3 text-sm ${msgForm.tipo === "ok" ? "bg-emerald-500/10 border border-emerald-500/30 text-emerald-300" : "bg-red-500/10 border border-red-500/30 text-red-400"}`}>
                  {msgForm.texto}
                </div>
              )}
              <div>
                <label className="block text-sm font-semibold text-neutral-300 mb-1.5">Grado <span className="text-red-400">*</span></label>
                <select value={form.grade} onChange={e => setForm(p => ({ ...p, grade: e.target.value }))}
                  className="w-full bg-neutral-800 border border-neutral-700 text-white rounded-lg px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-violet-500">
                  {GRADOS.map(g => <option key={g} value={g}>{g}</option>)}
                </select>
              </div>
              <div>
                <label className="block text-sm font-semibold text-neutral-300 mb-1.5">Letra / Sección <span className="text-red-400">*</span></label>
                <select value={form.letter} onChange={e => setForm(p => ({ ...p, letter: e.target.value }))}
                  className="w-full bg-neutral-800 border border-neutral-700 text-white rounded-lg px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-violet-500">
                  {LETRAS.map(l => <option key={l} value={l}>{l}</option>)}
                </select>
              </div>
              <div className="bg-neutral-800/50 rounded-lg px-4 py-2 text-center">
                <p className="text-neutral-400 text-xs mb-0.5">Vista previa</p>
                <p className="text-white font-bold text-2xl">{form.grade}{form.letter}</p>
              </div>
            </div>
            <div className="p-6 pt-0 flex gap-3">
              <button onClick={guardar} disabled={guardando}
                className="flex-1 bg-gradient-to-r from-violet-600 to-violet-700 hover:from-violet-500 disabled:opacity-50 text-white py-3 rounded-xl font-semibold transition">
                {guardando ? "Guardando..." : modalForm === "crear" ? "Crear Sección" : "Guardar Cambios"}
              </button>
              <button onClick={() => setModalForm(null)} className="px-5 py-3 bg-neutral-800 hover:bg-neutral-700 text-neutral-300 rounded-xl transition">
                Cancelar
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ══ MODAL MIEMBROS ══ */}
      {modalMiembros && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
          <div className="bg-neutral-900 border border-neutral-700/50 rounded-2xl shadow-2xl w-full max-w-lg max-h-[90vh] flex flex-col">
            <div className="flex items-center justify-between p-6 border-b border-neutral-700/50 flex-shrink-0">
              <div>
                <h2 className="text-lg font-bold text-white">Sección {modalMiembros.name}</h2>
                <p className="text-sm text-neutral-400">{inscritos.length} estudiantes · {docentes.length} docentes</p>
              </div>
              <button onClick={() => { setModalMiembros(null); cargar() }} className="text-neutral-400 hover:text-white"><X className="w-5 h-5" /></button>
            </div>

            <div className="flex border-b border-neutral-700/50 flex-shrink-0">
              {[{ id: "estudiantes", label: "Estudiantes", Icon: Users }, { id: "docentes", label: "Docentes", Icon: GraduationCap }].map(t => (
                <button key={t.id} onClick={() => { setTabModal(t.id); setMsgModal(null) }}
                  className={`flex-1 flex items-center justify-center gap-2 py-3 text-sm font-semibold transition ${tabModal === t.id ? "border-b-2 border-violet-500 text-violet-400" : "text-neutral-400 hover:text-white"}`}>
                  <t.Icon className="w-4 h-4" />{t.label}
                </button>
              ))}
            </div>

            <div className="p-6 overflow-y-auto flex-1 space-y-4">
              {msgModal && (
                <div className={`rounded-lg px-4 py-3 text-sm ${msgModal.tipo === "ok" ? "bg-emerald-500/10 border border-emerald-500/30 text-emerald-300" : "bg-red-500/10 border border-red-500/30 text-red-400"}`}>
                  {msgModal.texto}
                </div>
              )}

              {cargandoModal ? <p className="text-neutral-500 text-sm text-center py-4">Cargando...</p> : (

                tabModal === "estudiantes" ? (
                  <>
                    <div>
                      <p className="text-sm font-semibold text-neutral-300 mb-2">Inscribir estudiante</p>
                      <div className="flex gap-2">
                        <select value={selEstudiante} onChange={e => setSelEstudiante(e.target.value)}
                          className="flex-1 bg-neutral-800 border border-neutral-600 rounded-lg px-3 py-2 text-white text-sm focus:outline-none focus:border-violet-500">
                          <option value="">Selecciona estudiante…</option>
                          {noInscritos.map(e => <option key={e.id} value={e.id}>{e.nombre || e.name || e.email}</option>)}
                        </select>
                        <button onClick={inscribir} className="px-3 py-2 bg-violet-600 hover:bg-violet-500 text-white rounded-lg transition">
                          <UserPlus className="w-4 h-4" />
                        </button>
                      </div>
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-neutral-300 mb-2">Inscritos ({inscritos.length})</p>
                      {inscritos.length === 0 ? <p className="text-neutral-500 text-sm">Sin estudiantes inscritos</p> : (
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
                ) : (
                  <>
                    <div>
                      <p className="text-sm font-semibold text-neutral-300 mb-2">Asignar docente</p>
                      <div className="flex gap-2">
                        <select value={selDocente} onChange={e => setSelDocente(e.target.value)}
                          className="flex-1 bg-neutral-800 border border-neutral-600 rounded-lg px-3 py-2 text-white text-sm focus:outline-none focus:border-violet-500">
                          <option value="">Selecciona docente…</option>
                          {noAsignados.map(d => <option key={d.id} value={d.id}>{d.nombre || d.name || d.email}</option>)}
                        </select>
                        <button onClick={asignarDocente} className="px-3 py-2 bg-violet-600 hover:bg-violet-500 text-white rounded-lg transition">
                          <UserPlus className="w-4 h-4" />
                        </button>
                      </div>
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-neutral-300 mb-2">Asignados ({docentes.length})</p>
                      {docentes.length === 0 ? <p className="text-neutral-500 text-sm">Sin docentes asignados</p> : (
                        <div className="space-y-2">
                          {docentes.map(doc => (
                            <div key={doc.id} className="flex items-center justify-between bg-neutral-800/50 rounded-lg px-4 py-2.5">
                              <div className="flex items-center gap-2">
                                <div className="w-7 h-7 rounded-full bg-purple-600/30 flex items-center justify-center"><GraduationCap className="w-3.5 h-3.5 text-purple-400" /></div>
                                <div>
                                  <p className="text-sm text-white font-medium">{doc.name || doc.nombre || doc.email}</p>
                                  <p className="text-xs text-neutral-500">{doc.email}</p>
                                </div>
                              </div>
                              <button onClick={() => desasignarDocente(doc.id)} className="p-1 text-red-400 hover:text-red-300 transition"><UserMinus className="w-4 h-4" /></button>
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  </>
                )
              )}
            </div>
          </div>
        </div>
      )}

      {/* ══ MODAL ELIMINAR ══ */}
      {confirmEliminar && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
          <div className="bg-neutral-900 border border-neutral-700/50 rounded-2xl shadow-2xl w-full max-w-sm p-6">
            <div className="flex items-center gap-3 mb-4">
              <div className="p-2 bg-red-500/20 rounded-lg"><Trash2 className="w-5 h-5 text-red-400" /></div>
              <h2 className="text-xl font-bold text-white">Eliminar Sección</h2>
            </div>
            <p className="text-neutral-300 mb-2">¿Eliminar la sección <span className="text-white font-bold">{confirmEliminar.name}</span>?</p>
            <p className="text-neutral-500 text-sm mb-6">Se perderán todas las asignaciones de estudiantes y docentes. Esta acción no se puede deshacer.</p>
            <div className="flex gap-3">
              <button onClick={() => setConfirmEliminar(null)} disabled={eliminando}
                className="flex-1 px-4 py-2 border border-neutral-600 text-neutral-300 rounded-lg hover:bg-neutral-800 transition disabled:opacity-50">
                Cancelar
              </button>
              <button onClick={handleEliminar} disabled={eliminando}
                className="flex-1 px-4 py-2 bg-red-600 hover:bg-red-500 text-white font-semibold rounded-lg transition disabled:opacity-50">
                {eliminando ? "Eliminando..." : "Eliminar"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
