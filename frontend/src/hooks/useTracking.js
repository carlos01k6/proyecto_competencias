import { useState, useEffect } from 'react'
import * as seguimientoService from '../services/tracking'

export function useSeguimiento(estudiante_id) {
  const [competencias, setCompetencias] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerProgreso = async () => {
    if (!estudiante_id) return
    setCargando(true)
    try {
      const data = await seguimientoService.obtenerProgresoCompetencias(estudiante_id)
      setCompetencias(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerProgreso()
  }, [estudiante_id])

  return {
    competencias,
    cargando,
    error,
    obtenerProgreso
  }
}
