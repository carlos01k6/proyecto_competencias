import { useState, useEffect } from 'react'
import * as auditoriaService from '../services/audit'

export function useLogAuditoria(estudiante_id = null, fecha_desde = null, fecha_hasta = null) {
  const [log, setLog] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerLog = async () => {
    setCargando(true)
    try {
      const data = await auditoriaService.obtenerLogAuditoria(estudiante_id, 100, fecha_desde, fecha_hasta)
      setLog(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerLog()
  }, [estudiante_id, fecha_desde, fecha_hasta])

  return {
    log,
    cargando,
    error,
    obtenerLog
  }
}

export function useResumenDocente(docente_id) {
  const [resumen, setResumen] = useState(null)
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerResumen = async () => {
    if (!docente_id) return
    setCargando(true)
    try {
      const data = await auditoriaService.obtenerResumenDocente(docente_id)
      setResumen(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerResumen()
  }, [docente_id])

  return {
    resumen,
    cargando,
    error,
    obtenerResumen
  }
}

export async function registrarAuditoria(datos) {
  try {
    await auditoriaService.registrarAuditoria(datos)
  } catch (err) {
    console.error('Error registrando auditoría:', err)
  }
}
