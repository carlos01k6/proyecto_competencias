import React, { useEffect, useState } from "react"
import { LayoutGrid, Users, GraduationCap, User, ChevronDown, ChevronUp } from "lucide-react"
import axios from "axios"

const API = "http://localhost:5000/api"

function auth() {
  const t = localStorage.getItem("acceso_token")
  return t ? { Authorization: `Bearer ${t}` } : {}
}

export default function MisSecciones({ usuario }) {
  const [secciones, setSecciones] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)
  const [expandido, setExpandido] = useState(null)
  const [estudiantes, setEstudiantes] = useState({})
  const [cargandoEst, setCargandoEst] = useState({})

  useEffect(() => {
    if (!usuario?.id) return
    setCargando(true)
    setError(null)

    // Obtener todas las secciones y filtrar las del docente
    axios.get(`${API}/secciones`, { headers: auth() })
      .then(async (res) => {
        const todas = Array.isArray(res.data) ? res.data : []
        // Filtrar secciones donde el docente está asignado
        const misSeccionesIds = []
        await Promise.all(todas.map(async (sec) => {
          try {
            const r = await axios.get(`${API}/secciones/${sec.id}/docentes`, { headers: auth() })
            const docentes = Array.isArray(r.data) ? r.data : []
            if (docentes.some(d => d.id === usuario.id)) {
              misSeccionesIds.push(sec)
            }
          } catch { /* skip */ }
        }))
        setSecciones(misSeccionesIds)
      })
      .catch(e => setError(e.response?.data?.error || e.message))
      .finally(() => setCargando(false))
  }, [usuario?.id])

  const toggleSeccion = async (sec) => {
    if (expandido === sec.id) { setExpandido(null); return }
    setExpandido(sec.id)
    if (estudiantes[sec.id]) return
    setCargandoEst(p => ({ ...p, [sec.id]: true }))
    try {
      const r = await axios.get(`${API}/secciones/${sec.id}/estudiantes`, { headers: auth() })
      setEstudiantes(p => ({ ...p, [sec.id]: Array.isArray(r.data) ? r.data : [] }))
    } catch { setEstudiantes(p => ({ ...p, [sec.id]: [] })) }
    finally { setCargandoEst(p => ({ ...p, [sec.id]: false })) }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      <div className="mb-8 flex items-center gap-3">
        <div className="p-3 bg-gradient-to-br from-violet-600 to-violet-700 rounded-lg">
          <LayoutGrid className="w-6 h-6 text-white" />
        </div>
        <div>
          <h1 className="text-4xl font-bold text-white">Mis Secciones</h1>
          <p className="text-neutral-400">Secciones asignadas a tu cargo</p>
        </div>
      </div>

      {error && <div className="bg-red-500/10 border border-red-500/30 rounded-lg p-4 mb-6 text-red-400">{error}</div>}

      {cargando ? (
        <div className="py-12 text-center text-neutral-400">Cargando tus secciones...</div>
      ) : secciones.length === 0 ? (
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 text-center">
          <LayoutGrid className="w-12 h-12 text-neutral-700 mx-auto mb-3" />
          <p className="text-neutral-400">No tienes secciones asignadas.</p>
          <p className="text-neutral-500 text-sm mt-1">Contacta al administrador para que te asigne una sección.</p>
        </div>
      ) : (
        <div className="space-y-3">
          {secciones.map(sec => {
            const abierto = expandido === sec.id
            const lista = estudiantes[sec.id] || []
            return (
              <div key={sec.id} className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
                <button
                  onClick={() => toggleSeccion(sec)}
                  className="w-full px-6 py-5 flex items-center justify-between hover:bg-neutral-900/50 transition"
                >
                  <div className="flex items-center gap-4">
                    <div className="w-12 h-12 rounded-xl bg-violet-500/20 border border-violet-500/30 flex items-center justify-center">
                      <span className="text-violet-300 font-bold text-lg">{sec.name}</span>
                    </div>
                    <div className="text-left">
                      <p className="text-white font-bold text-lg">Sección {sec.name}</p>
                      <p className="text-neutral-400 text-sm">Grado {sec.grade} · Sección {sec.letter}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-4">
                    <span className="flex items-center gap-1.5 text-sm text-neutral-400">
                      <Users className="w-4 h-4 text-blue-400" />
                      {sec.total_estudiantes ?? 0} estudiantes
                    </span>
                    {abierto ? <ChevronUp className="w-5 h-5 text-neutral-400" /> : <ChevronDown className="w-5 h-5 text-neutral-400" />}
                  </div>
                </button>

                {abierto && (
                  <div className="px-6 pb-5 border-t border-neutral-800">
                    <p className="text-sm font-semibold text-neutral-300 mt-4 mb-3">
                      Estudiantes inscritos
                    </p>
                    {cargandoEst[sec.id] ? (
                      <p className="text-neutral-500 text-sm">Cargando...</p>
                    ) : lista.length === 0 ? (
                      <p className="text-neutral-500 text-sm">Sin estudiantes inscritos en esta sección.</p>
                    ) : (
                      <div className="grid grid-cols-1 md:grid-cols-2 gap-2">
                        {lista.map(est => (
                          <div key={est.id} className="flex items-center gap-3 bg-neutral-800/50 rounded-xl px-4 py-3">
                            <div className="w-8 h-8 rounded-full bg-neutral-700 flex items-center justify-center flex-shrink-0">
                              <User className="w-4 h-4 text-neutral-400" />
                            </div>
                            <div className="min-w-0">
                              <p className="text-sm text-white font-medium truncate">{est.name || est.nombre || "Sin nombre"}</p>
                              <p className="text-xs text-neutral-500 truncate">{est.email}</p>
                            </div>
                          </div>
                        ))}
                      </div>
                    )}
                  </div>
                )}
              </div>
            )
          })}
        </div>
      )}
    </div>
  )
}
