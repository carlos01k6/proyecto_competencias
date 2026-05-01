import { useState } from 'react'
import * as reEvaluationsService from '../services/re_evaluations'

export function useReevaluar() {
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)
  const [exito, setExito] = useState(false)

  const reevaluar = async (evaluation_id, datos) => {
    setCargando(true)
    setError(null)
    setExito(false)
    try {
      const result = await reEvaluationsService.reevaluar(evaluation_id, datos)
      setExito(true)
      return result
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  return {
    reevaluar,
    cargando,
    error,
    exito
  }
}

export function useCrearReevaluacion() {
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)
  const [exito, setExito] = useState(false)

  const crear = async (datos) => {
    setCargando(true)
    setError(null)
    setExito(false)
    try {
      const result = await reEvaluationsService.crearReevaluacion(datos)
      setExito(true)
      return result
    } catch (err) {
      setError(err.response?.data?.error || err.message)
      throw err
    } finally {
      setCargando(false)
    }
  }

  return {
    crear,
    cargando,
    error,
    exito
  }
}

export function useHistorialEvaluaciones(student_id) {
  const [historial, setHistorial] = useState(null)
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtener = async (criteria_id = null) => {
    if (!student_id) return
    setCargando(true)
    try {
      const data = await reEvaluationsService.obtenerHistorial(student_id, criteria_id)
      setHistorial(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  return {
    historial,
    cargando,
    error,
    obtener
  }
}

export function useDisponiblesReevaluar() {
  const [disponibles, setDisponibles] = useState(null)
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtener = async () => {
    setCargando(true)
    try {
      const data = await reEvaluationsService.obtenerDisponiblesReevaluar()
      setDisponibles(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  return {
    disponibles,
    cargando,
    error,
    obtener
  }
}

export function useCompararEvaluaciones(evaluation_id) {
  const [comparacion, setComparacion] = useState(null)
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtener = async () => {
    if (!evaluation_id) return
    setCargando(true)
    try {
      const data = await reEvaluationsService.compararEvaluaciones(evaluation_id)
      setComparacion(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  return {
    comparacion,
    cargando,
    error,
    obtener
  }
}
