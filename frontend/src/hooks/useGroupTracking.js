import { useState } from 'react'
import * as groupTrackingService from '../services/group_tracking'

export function useProgresoGrupo(group_name) {
  const [grupo, setGrupo] = useState(null)
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtener = async () => {
    if (!group_name) return
    setCargando(true)
    try {
      const data = await groupTrackingService.obtenerProgresoGrupo(group_name)
      setGrupo(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  const obtenerManual = async (nombre) => {
    setCargando(true)
    try {
      const data = await groupTrackingService.obtenerProgresoGrupo(nombre)
      setGrupo(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  return {
    grupo,
    cargando,
    error,
    obtener,
    obtenerManual
  }
}

export function useCompetenciaGrupo(competency_id) {
  const [competencia, setCompetencia] = useState(null)
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtener = async () => {
    if (!competency_id) return
    setCargando(true)
    try {
      const data = await groupTrackingService.obtenerCompetenciaGrupo(competency_id)
      setCompetencia(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  return {
    competencia,
    cargando,
    error,
    obtener
  }
}

export function useResumenGrupos() {
  const [resumen, setResumen] = useState(null)
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtener = async () => {
    setCargando(true)
    try {
      const data = await groupTrackingService.obtenerResumenGrupos()
      setResumen(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  return {
    resumen,
    cargando,
    error,
    obtener
  }
}
