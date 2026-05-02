import { useState, useEffect } from 'react'
import * as evidenciasProyectoService from '../services/project_evidence'

export function useEvidenciasProyecto(actividad_id) {
  const [evidencias, setEvidencias] = useState({})
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerEvidencias = async () => {
    if (!actividad_id) return
    setCargando(true)
    try {
      const data = await evidenciasProyectoService.obtenerEvidenciasPorActividad(actividad_id)
      setEvidencias(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerEvidencias()
  }, [actividad_id])

  return {
    evidencias,
    cargando,
    error,
    obtenerEvidencias
  }
}

export function useActividadesResumen() {
  const [actividades, setActividades] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerActividades = async () => {
    setCargando(true)
    try {
      const data = await evidenciasProyectoService.obtenerActividadesResumen()
      setActividades(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerActividades()
  }, [])

  return {
    actividades,
    cargando,
    error,
    obtenerActividades
  }
}
