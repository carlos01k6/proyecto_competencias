import { useState, useEffect } from 'react'
import * as evaluacionesService from '../services/evaluations'

export function useEvaluaciones(resultado_id = null, estudiante_id = null) {
  const [evaluaciones, setEvaluaciones] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  // Obtener evaluaciones
  const obtenerEvaluaciones = async () => {
    if (!resultado_id || !estudiante_id) return
    setCargando(true)
    try {
      const data = await evaluacionesService.obtenerEvaluacionesEstudiante(estudiante_id, resultado_id)
      setEvaluaciones(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  // Agregar evaluación
  const agregarEvaluacion = async (formData) => {
    try {
      const nuevaEvaluacion = await evaluacionesService.crearEvaluacion({
        resultado_id,
        ...formData
      })
      setEvaluaciones([...evaluaciones, nuevaEvaluacion])
      return nuevaEvaluacion
    } catch (err) {
      throw err
    }
  }

  // Actualizar evaluación
  const actualizarEvaluacion = async (evaluacion_id, formData) => {
    try {
      const actualizada = await evaluacionesService.actualizarEvaluacion(evaluacion_id, formData)
      setEvaluaciones(evaluaciones.map(e => e.id === evaluacion_id ? actualizada : e))
      return actualizada
    } catch (err) {
      throw err
    }
  }

  // Eliminar evaluación
  const eliminarEvaluacion = async (evaluacion_id) => {
    try {
      await evaluacionesService.eliminarEvaluacion(evaluacion_id)
      setEvaluaciones(evaluaciones.filter(e => e.id !== evaluacion_id))
    } catch (err) {
      throw err
    }
  }

  useEffect(() => {
    obtenerEvaluaciones()
  }, [resultado_id, estudiante_id])

  return {
    evaluaciones,
    cargando,
    error,
    agregarEvaluacion,
    actualizarEvaluacion,
    eliminarEvaluacion,
    obtenerEvaluaciones
  }
}
