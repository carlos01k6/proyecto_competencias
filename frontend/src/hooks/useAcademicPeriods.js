import { useState, useEffect } from 'react'
import * as academicPeriodsService from '../services/academic_periods'

export function useConfiguracionPeriodos() {
  const [configuracion, setConfiguracion] = useState(null)
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtener = async () => {
    setCargando(true)
    try {
      const data = await academicPeriodsService.obtenerConfiguracionPeriodos()
      setConfiguracion(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtener()
  }, [])

  return {
    configuracion,
    cargando,
    error,
    obtener
  }
}

export function useCrearPeriodo() {
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)
  const [exito, setExito] = useState(false)

  const crear = async (datos) => {
    setCargando(true)
    setError(null)
    setExito(false)
    try {
      await academicPeriodsService.crearPeriodo(datos)
      setExito(true)
    } catch (err) {
      setError(err.response?.data?.error || err.response?.data?.mensaje || err.message)
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

export function useActualizarTipoPeriodo() {
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)
  const [exito, setExito] = useState(false)

  const actualizar = async (tipo) => {
    setCargando(true)
    setError(null)
    setExito(false)
    try {
      await academicPeriodsService.actualizarTipoPeriodo(tipo)
      setExito(true)
    } catch (err) {
      setError(err.response?.data?.error || err.response?.data?.mensaje || err.message)
    } finally {
      setCargando(false)
    }
  }

  return {
    actualizar,
    cargando,
    error,
    exito
  }
}

export function usePeriodosPorTipo(tipo) {
  const [periodos, setPeriodos] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtener = async () => {
    if (!tipo) return
    setCargando(true)
    try {
      const data = await academicPeriodsService.obtenerPeriodosPorTipo(tipo)
      setPeriodos(data.periodos || [])
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtener()
  }, [tipo])

  return {
    periodos,
    cargando,
    error,
    obtener
  }
}
