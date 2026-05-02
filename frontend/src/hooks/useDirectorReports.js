import { useState, useEffect } from 'react'
import * as reportesService from '../services/reports'

export function useReportesDirector() {
  const [competencias, setCompetencias] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerResumen = async () => {
    setCargando(true)
    try {
      const data = await reportesService.obtenerResumenCompetencias()
      setCompetencias(data)
      setError(null)
    } catch (err) {
      setError(err.message)
      setCompetencias([])
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerResumen()
  }, [])

  return {
    competencias,
    cargando,
    error,
    obtenerResumen
  }
}
