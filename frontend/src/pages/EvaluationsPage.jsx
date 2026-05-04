import React, { useState, useEffect } from "react"
import { useEvaluaciones } from "../hooks/useEvaluations"
import { useCompetencias } from "../hooks/useCompetencies"
import * as evaluacionesService from "../services/evaluations"
import TablaEvaluaciones from "../components/Evaluations/EvaluationsTable"
import FormularioCalificacion from "../components/Evaluations/GradeForm"
import { BarChart3 } from "lucide-react"

export default function EvaluacionesPage({ usuario }) {
  const [competenciaSeleccionada, setCompetenciaSeleccionada] = useState(null)
  const [estudianteSeleccionado, setEstudianteSeleccionado] = useState(null)
  const [criteriosDelResultado, setCriteriosDelResultado] = useState([])
  const [criterioSeleccionado, setCriterioSeleccionado] = useState(null)
  const [mostrarFormulario, setMostrarFormulario] = useState(false)
  const [estudiantes, setEstudiantes] = useState([])
  const [cargando, setCargando] = useState(false)
  const [misCalificaciones, setMisCalificaciones] = useState([])
  const [cargandoMisCalificaciones, setCargandoMisCalificaciones] = useState(false)
  const [errorMisCalificaciones, setErrorMisCalificaciones] = useState(null)
  const { competencias, loading: cargandoCompetencias, error: errorCompetencias } = useCompetencias()

  const { evaluaciones, agregarEvaluacion, actualizarEvaluacion, eliminarEvaluacion } = useEvaluaciones(
    competenciaSeleccionada?.id,
    estudianteSeleccionado?.id
  )

  const rolUsuario = usuario?.rol?.toLowerCase()
  const puedeCalificar = rolUsuario === "teacher" || rolUsuario === "admin"
  const esEstudiante = rolUsuario === "student"

  useEffect(() => {
    const cargarMisCalificaciones = async () => {
      if (!esEstudiante || !usuario?.id) return

      setCargandoMisCalificaciones(true)
      setErrorMisCalificaciones(null)

      try {
        const data = await evaluacionesService.obtenerCalificacionesEstudiante(usuario.id)
        setMisCalificaciones(Array.isArray(data) ? data : [])
      } catch (err) {
        setMisCalificaciones([])
        setErrorMisCalificaciones(err.response?.data?.error || err.message)
      } finally {
        setCargandoMisCalificaciones(false)
      }
    }

    cargarMisCalificaciones()
  }, [esEstudiante, usuario?.id])

  useEffect(() => {
    console.log("DEBUG competencias recibidas en EvaluacionesPage:", competencias)
    console.log("DEBUG ids de competencias:", (competencias || []).map(comp => comp.id))
    if (errorCompetencias) {
      console.error("DEBUG error competencias:", errorCompetencias)
    }
  }, [competencias, errorCompetencias])

  // Cargar estudiantes al montar
  useEffect(() => {
    const cargarDatos = async () => {
      setCargando(true)
      try {
        const token = localStorage.getItem("acceso_token")

        // Cargar estudiantes
        const estRes = await fetch("http://localhost:5000/api/estudiantes", {
          headers: { Authorization: `Bearer ${token}` }
        })
        const estudiantesData = await estRes.json()
        setEstudiantes(Array.isArray(estudiantesData) ? estudiantesData : [])
      } catch (err) {
        console.error("Error cargando datos:", err)
      } finally {
        setCargando(false)
      }
    }
    cargarDatos()
  }, [])

  const handleSeleccionarCompetencia = async (competencia) => {
    console.log("DEBUG competencia seleccionada:", competencia)
    setCompetenciaSeleccionada(competencia)
    setCriteriosDelResultado([])
    setMostrarFormulario(false)
    setCriterioSeleccionado(null)

    try {
      const token = localStorage.getItem("acceso_token")
      const response = await fetch(`http://localhost:5000/api/criterios?competencia_id=${competencia.id}`, {
        headers: { Authorization: `Bearer ${token}` }
      })
      const criterios = await response.json()
      console.log("DEBUG criterios recibidos:", criterios)
      setCriteriosDelResultado(Array.isArray(criterios) ? criterios : [])
    } catch (err) {
      console.error("Error al obtener criterios:", err)
    }
  }

  const handleCalificar = (criterio) => {
    const evaluacionExistente = evaluaciones.find(e => (e.criteria_id || e.criterio_id) === criterio.id)
    setCriterioSeleccionado({ ...criterio, evaluacionExistente })
    setMostrarFormulario(true)
  }

  const handleSubmitCalificacion = async (formData) => {
    try {
      const datosEvaluacion = {
        criteria_id: criterioSeleccionado.id,
        student_id: estudianteSeleccionado.id,
        activity_id: formData.actividad_id,
        grade: formData.calificacion,
        observation: formData.observacion,
        teacher_id: usuario?.id,
        evaluation_date: formData.fecha_evaluacion,
        learning_outcome_id: criterioSeleccionado.learning_outcome_id
      }

      if (criterioSeleccionado.evaluacionExistente) {
        await actualizarEvaluacion(criterioSeleccionado.evaluacionExistente.id, datosEvaluacion)
      } else {
        await agregarEvaluacion(datosEvaluacion)
      }

      setMostrarFormulario(false)
      setCriterioSeleccionado(null)
    } catch (err) {
      alert("Error: " + (err.response?.data?.error || err.message))
    }
  }

  const handleEliminar = async (evaluacion_id) => {
    if (window.confirm("¿Eliminar esta calificación?")) {
      try {
        await eliminarEvaluacion(evaluacion_id)
      } catch (err) {
        alert("Error: " + (err.response?.data?.error || err.message))
      }
    }
  }

  const calcularPromedioPonderado = () => {
    if (criteriosDelResultado.length === 0) return 0
    let sumaPonderada = 0
    let sumaPonderaciones = 0
    criteriosDelResultado.forEach(criterio => {
      const evaluacion = evaluaciones.find(e => (e.criteria_id || e.criterio_id) === criterio.id)
      if (evaluacion) {
        const calificacion = evaluacion.grade ?? evaluacion.calificacion
        const ponderacion = criterio.ponderacion || criterio.weighting || 0
        sumaPonderada += calificacion * (ponderacion / 100)
        sumaPonderaciones += ponderacion
      }
    })
    return sumaPonderaciones > 0 ? (sumaPonderada / (sumaPonderaciones / 100)).toFixed(2) : 0
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 p-6 md:p-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-4">
          <div className="p-3 bg-gradient-to-br from-blue-600 to-blue-700 rounded-lg">
            <BarChart3 className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-4xl font-bold text-white">
              {puedeCalificar ? "Calificar Estudiantes" : "Mis Calificaciones"}
            </h1>
            <p className="text-neutral-400">
              {puedeCalificar 
                ? "Evalúa a tus estudiantes por criterio" 
                : "Visualiza tus calificaciones y desempeño"}
            </p>
          </div>
        </div>
      </div>

      {/* VISTA DOCENTE/ADMIN - Calificar */}
      {puedeCalificar && (
        <div>
          {/* Selectores */}
          <form className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8" onSubmit={(e) => e.preventDefault()}>
            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
              <label className="block text-sm font-semibold text-white mb-3">
                Seleccionar Resultado/Competencia
              </label>
              <select
                value={competenciaSeleccionada?.id || ""}
                onChange={(e) => {
                  const competencia = competencias.find(comp => String(comp.id) === e.target.value)
                  console.log("DEBUG value seleccionado en dropdown:", e.target.value)
                  if (competencia) {
                    handleSeleccionarCompetencia(competencia)
                  } else {
                    setCompetenciaSeleccionada(null)
                    setCriteriosDelResultado([])
                  }
                }}
                disabled={cargandoCompetencias}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
              >
                <option value="">{cargandoCompetencias ? "Cargando competencias..." : "Selecciona una competencia"}</option>
                {(competencias || []).map(competencia => (
                  <option key={competencia.id} value={competencia.id}>
                    {competencia.nombre || competencia.name}
                  </option>
                ))}
              </select>
              {!cargandoCompetencias && (!competencias || competencias.length === 0) && (
                <p className="text-xs text-warning mt-2">No se recibieron competencias desde /api/competencias.</p>
              )}
            </div>

            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
              <label className="block text-sm font-semibold text-white mb-3">
                Seleccionar Estudiante
              </label>
              <select
                value={estudianteSeleccionado?.id || ""}
                onChange={(e) => {
                  const estudiante = estudiantes.find(est => est.id === e.target.value)
                  if (estudiante) setEstudianteSeleccionado(estudiante)
                }}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
              >
                <option value="">-- Seleccionar --</option>
                {estudiantes.map(est => (
                  <option key={est.id} value={est.id}>
                    {est.name || est.nombre}
                  </option>
                ))}
              </select>
            </div>
          </form>

          {/* Contenido principal */}
          {!competenciaSeleccionada || !estudianteSeleccionado ? (
            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-12 text-center">
              <p className="text-neutral-400 text-lg">Selecciona una competencia y un estudiante</p>
            </div>
          ) : mostrarFormulario && criterioSeleccionado ? (
            <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-8 mb-8">
              <div className="flex justify-between items-center mb-6">
                <h2 className="text-2xl font-bold text-white">Calificar: {criterioSeleccionado.nombre}</h2>
                <button
                  onClick={() => setMostrarFormulario(false)}
                  className="text-neutral-400 hover:text-neutral-200 text-2xl transition"
                >
                  ✕
                </button>
              </div>
              <FormularioCalificacion
                criterio={criterioSeleccionado}
                evaluacionExistente={criterioSeleccionado.evaluacionExistente}
                onSubmit={handleSubmitCalificacion}
                onCancel={() => setMostrarFormulario(false)}
              />
            </div>
          ) : (
            <div className="space-y-6">
              {/* Tabla de criterios para calificar */}
              <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl p-6">
                <h2 className="text-xl font-bold text-white mb-4">Criterios de Evaluación</h2>
                {criteriosDelResultado.length === 0 ? (
                  <p className="text-neutral-400">No hay criterios disponibles</p>
                ) : (
                  <TablaEvaluaciones
                    criterios={criteriosDelResultado}
                    evaluaciones={evaluaciones}
                    onCalificar={handleCalificar}
                    onEliminar={handleEliminar}
                    puedeEditar={puedeCalificar}
                  />
                )}
              </div>

              {/* Promedio ponderado */}
              {criteriosDelResultado.length > 0 && (
                <div className="bg-gradient-to-r from-primary-brand to-primary-600 rounded-2xl shadow-lg shadow-primary-brand/30 p-8 text-white overflow-hidden relative">
                  <div className="relative">
                    <h3 className="text-lg font-bold mb-2">Calificación Final (Promedio Ponderado)</h3>
                    <div className="text-5xl font-bold">{calcularPromedioPonderado()}</div>
                    <p className="text-primary-100 mt-2">Basado en las ponderaciones de cada criterio</p>
                  </div>
                </div>
              )}
            </div>
          )}
        </div>
      )}

      {/* VISTA ESTUDIANTE - Ver propias calificaciones */}
      {esEstudiante && (
        <div className="space-y-6">
          {usuario?.id && (
            <div className="rounded-lg bg-neutral-800/60 border border-neutral-700 p-4 flex flex-col md:flex-row md:items-center justify-between gap-3">
              <p className="text-neutral-300">Tu ID: <strong className="text-white">{usuario.id}</strong></p>
              <button onClick={() => navigator.clipboard.writeText(usuario.id)} className="bg-primary-brand hover:bg-primary-600 text-white px-4 py-2 rounded-lg font-semibold">
                Copiar ID
              </button>
            </div>
          )}

          {errorMisCalificaciones && (
            <div className="bg-danger/10 border border-danger/30 rounded-lg p-4">
              <p className="text-danger font-semibold">Error: {errorMisCalificaciones}</p>
            </div>
          )}

          <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl overflow-hidden">
            <div className="p-6 border-b border-neutral-700/50">
              <h2 className="text-xl font-bold text-white">Mis Evaluaciones</h2>
            </div>
            
            {cargandoMisCalificaciones ? (
              <div className="py-12 text-center text-neutral-400">Cargando calificaciones...</div>
            ) : misCalificaciones.length === 0 ? (
              <div className="py-12 text-center text-neutral-400">Sin calificaciones</div>
            ) : (
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="bg-neutral-900/50 border-b border-neutral-700/50">
                      <th className="px-6 py-4 text-left font-semibold text-neutral-300">Competencia</th>
                      <th className="px-6 py-4 text-left font-semibold text-neutral-300">Resultado</th>
                      <th className="px-6 py-4 text-left font-semibold text-neutral-300">Criterio</th>
                      <th className="px-6 py-4 text-left font-semibold text-neutral-300">Calificación</th>
                      <th className="px-6 py-4 text-left font-semibold text-neutral-300">Fecha</th>
                    </tr>
                  </thead>
                  <tbody>
                    {misCalificaciones.map((evaluacion, index) => (
                      <tr key={`${evaluacion.criteria_name}-${evaluacion.fecha}-${index}`} className="border-b border-neutral-800/50 hover:bg-neutral-900/50 transition">
                        <td className="px-6 py-4 text-white font-semibold">{evaluacion.competencia_name || "N/A"}</td>
                        <td className="px-6 py-4 text-neutral-300">{evaluacion.outcome_name || "N/A"}</td>
                        <td className="px-6 py-4 text-neutral-300">{evaluacion.criteria_name}</td>
                        <td className="px-6 py-4 text-primary-brand font-bold">{evaluacion.grade}/100</td>
                        <td className="px-6 py-4 text-neutral-400">
                          {evaluacion.fecha ? new Date(evaluacion.fecha).toLocaleDateString("es-ES") : "Sin fecha"}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>

          {/* Promedio general */}
          {misCalificaciones.length > 0 && (
            <div className="bg-gradient-to-r from-primary-brand to-primary-600 rounded-2xl shadow-lg shadow-primary-brand/30 p-8 text-white overflow-hidden relative">
              <div className="relative">
                <h3 className="text-lg font-bold mb-2">Tu Promedio General</h3>
                <div className="text-5xl font-bold">
                  {(misCalificaciones.reduce((sum, e) => sum + Number(e.grade || 0), 0) / misCalificaciones.length).toFixed(2)}
                </div>
                <p className="text-primary-100 mt-2">Basado en {misCalificaciones.length} evaluaciones</p>
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  )
}
