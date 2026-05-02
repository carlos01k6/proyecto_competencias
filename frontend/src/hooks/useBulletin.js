import { useState, useEffect } from 'react'
import * as boletinService from '../services/bulletin'

export function useBoletinEstudiante(estudiante_id) {
  const [boletin, setBoletin] = useState(null)
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerBoletin = async () => {
    if (!estudiante_id) return
    setCargando(true)
    try {
      const data = await boletinService.generarBoletinEstudiante(estudiante_id)
      setBoletin(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerBoletin()
  }, [estudiante_id])

  return {
    boletin,
    cargando,
    error,
    obtenerBoletin
  }
}

export function useBoletinesGrupo() {
  const [boletines, setBoletines] = useState(null)
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerBoletines = async () => {
    setCargando(true)
    try {
      const data = await boletinService.obtenerBoletinesGrupo()
      setBoletines(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerBoletines()
  }, [])

  return {
    boletines,
    cargando,
    error,
    obtenerBoletines
  }
}
