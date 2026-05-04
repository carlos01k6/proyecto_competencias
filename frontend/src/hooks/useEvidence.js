import { useState, useEffect } from "react"
import * as evidenciasService from "../services/evidence"

export function useEvidencias(actividad_id, studentId) {
  const [evidencias, setEvidencias] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerEvidencias = async () => {
    setCargando(true)
    try {
      const data = studentId
        ? await evidenciasService.obtenerEvidenciasEstudiante(studentId)
        : await evidenciasService.obtenerEvidencias(actividad_id)
      setEvidencias(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  const agregarEvidencia = async (formDataObj) => {
    try {
      const nuevaEvidencia = await evidenciasService.crearEvidencia(formDataObj)
      setEvidencias([...evidencias, nuevaEvidencia])
      return nuevaEvidencia
    } catch (err) {
      throw err
    }
  }

  const eliminarEvidencia = async (evidencia_id) => {
    try {
      await evidenciasService.eliminarEvidencia(evidencia_id)
      setEvidencias(evidencias.filter(e => e.id !== evidencia_id))
    } catch (err) {
      throw err
    }
  }

  useEffect(() => {
    obtenerEvidencias()
  }, [actividad_id, studentId])

  return {
    evidencias,
    cargando,
    error,
    agregarEvidencia,
    eliminarEvidencia,
    obtenerEvidencias
  }
}
