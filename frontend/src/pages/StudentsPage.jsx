import React from "react"
import { useEstudiantes } from "../hooks/useStudents"
import { Users, Mail, Calendar } from "lucide-react"

export default function EstudiantesPage({ usuario }) {
  const rolUsuario = usuario?.rol?.toLowerCase()
  const esTeacher = rolUsuario === "teacher" || rolUsuario === "docente"

  const { estudiantes, cargando, error } = useEstudiantes()

  if (!esTeacher) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8 flex items-center justify-center">
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 max-w-md text-center">
          <p className="text-4xl mb-4">🔒</p>
          <h1 className="text-2xl font-bold text-white mb-2">Acceso Restringido</h1>
          <p className="text-neutral-400 mb-6">
            Esta sección es solo para docentes.
          </p>
          <a href="/" className="inline-block bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-6 py-2 rounded-lg font-semibold transition">
            Volver al Inicio
          </a>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="p-3 bg-gradient-to-br from-blue-600 to-blue-700 rounded-lg">
              <Users className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-4xl font-bold text-white">Mis Estudiantes</h1>
              <p className="text-neutral-400">Consulta los estudiantes asignados a tus cursos</p>
            </div>
          </div>
        </div>
      </div>

      {/* Tabla de Estudiantes */}
      <div>
        <div className="space-y-6">
          {/* Tabla */}
          <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
            {cargando ? (
              <div className="flex items-center justify-center py-12">
                <div className="animate-spin inline-block">
                  <div className="w-8 h-8 border-4 border-neutral-700 border-t-primary-brand rounded-full"></div>
                </div>
              </div>
            ) : error ? (
              <div className="p-6 text-center">
                <p className="text-danger">Error: {error}</p>
              </div>
            ) : estudiantes.length === 0 ? (
              <div className="p-12 text-center">
                <p className="text-neutral-400">No hay estudiantes registrados</p>
              </div>
            ) : (
              <table className="w-full">
                <thead>
                  <tr className="border-b border-neutral-700/50 bg-neutral-900/50">
                    <th className="px-6 py-4 text-left font-semibold text-neutral-300">Nombre</th>
                    <th className="px-6 py-4 text-left font-semibold text-neutral-300">Email</th>
                    <th className="px-6 py-4 text-left font-semibold text-neutral-300">Fecha Matrícula</th>
                  </tr>
                </thead>
                <tbody>
                  {estudiantes.map((est) => (
                    <tr key={est.id || est.student_id || est.email} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition group">
                      <td className="px-6 py-4 text-white font-semibold">{est.name || est.nombre || est.users?.name || "Sin nombre"}</td>
                      <td className="px-6 py-4 text-neutral-400 flex items-center gap-2">
                        <Mail className="w-4 h-4" />
                        {est.email || est.users?.email || "Sin email"}
                      </td>
                      <td className="px-6 py-4 text-neutral-400 flex items-center gap-2">
                        <Calendar className="w-4 h-4" />
                        {est.fecha_matricula ? new Date(est.fecha_matricula).toLocaleDateString() : "---"}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}
