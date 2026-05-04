import React from "react"
import { useParams, useNavigate } from "react-router-dom"
import { useEstudiantesCurso } from "../hooks/useCourseStudents"
import { getStudentCode } from "../utils/studentCode"
import { BookOpen, Users, ArrowLeft, Calendar } from "lucide-react"

export default function DetalleCursoPage() {
  const { cursoId } = useParams()
  const navigate = useNavigate()
  const { estudiantes, cargando } = useEstudiantesCurso(cursoId)

  // Datos del curso (en un caso real vendría de props o de una API)
  const cursoData = {
    id: cursoId,
    nombre: "Curso",
    codigo: "---",
    descripcion: "Cargando..."
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      {/* Header con botón volver */}
      <div className="mb-8">
        <button
          onClick={() => navigate(-1)}
          className="flex items-center gap-2 text-neutral-400 hover:text-white mb-6 transition"
        >
          <ArrowLeft className="w-5 h-5" />
          Volver
        </button>

        <div className="flex items-center gap-4">
          <div className="p-3 bg-gradient-to-br from-blue-600 to-blue-700 rounded-lg">
            <BookOpen className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">{cursoData.nombre}</h1>
            <p className="text-neutral-400">{cursoData.codigo}</p>
          </div>
        </div>
      </div>

      {/* Grid de 2 columnas */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Información del curso */}
        <div className="lg:col-span-1">
          <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
            <h2 className="text-lg font-bold text-white mb-4">Información del Curso</h2>
            
            <div className="space-y-4">
              <div>
                <p className="text-xs text-neutral-500 uppercase">Código</p>
                <p className="text-white font-semibold">{cursoData.codigo}</p>
              </div>
              
              <div>
                <p className="text-xs text-neutral-500 uppercase">Total Estudiantes</p>
                <p className="text-3xl font-bold text-primary-brand">{estudiantes.length}</p>
              </div>

              <div className="pt-4 border-t border-neutral-700">
                <p className="text-xs text-neutral-500 uppercase mb-2">Descripción</p>
                <p className="text-sm text-neutral-400">{cursoData.descripcion}</p>
              </div>
            </div>
          </div>
        </div>

        {/* Lista de estudiantes */}
        <div className="lg:col-span-2">
          <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
            <div className="flex items-center gap-2 mb-6">
              <Users className="w-5 h-5 text-primary-brand" />
              <h2 className="text-lg font-bold text-white">Estudiantes Inscritos</h2>
            </div>

            {cargando ? (
              <div className="flex items-center justify-center py-12">
                <div className="animate-spin">
                  <div className="w-8 h-8 border-4 border-neutral-700 border-t-primary-brand rounded-full"></div>
                </div>
              </div>
            ) : estudiantes.length === 0 ? (
              <div className="text-center py-12">
                <p className="text-neutral-400">No hay estudiantes inscritos en este curso</p>
              </div>
            ) : (
              <div className="space-y-2">
                {estudiantes.map((est) => (
                  <div
                    key={est.id}
                    className="bg-neutral-700/30 hover:bg-neutral-700/50 border border-neutral-700/50 rounded-lg p-4 transition flex items-center justify-between"
                  >
                    <div>
                      <p className="text-white font-semibold">{est.name || est.nombre || "Estudiante"}</p>
                      <p className="text-xs font-semibold text-primary-brand">{getStudentCode(est)}</p>
                      <p className="text-xs text-neutral-400">{est.email}</p>
                    </div>
                    <div className="text-right">
                      <p className="text-xs text-neutral-500">Inscrito</p>
                      <p className="text-xs text-neutral-400">
                        {est.fecha_matricula ? new Date(est.fecha_matricula).toLocaleDateString() : "---"}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}
