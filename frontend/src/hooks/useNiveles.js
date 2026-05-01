import { useState, useEffect } from 'react'
import * as nivelesService from '../services/niveles'

export function useNivelesEstudiante(estudiante_id) {
  const [niveles, setNiveles] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerNiveles = async () => {
    if (!estudiante_id) return
    setCargando(true)
    try {
      const data = await nivelesService.obtenerNivelesEstudiante(estudiante_id)
      setNiveles(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerNiveles()
  }, [estudiante_id])

  return {
    niveles,
    cargando,
    error,
    obtenerNiveles
  }
}

export function useNivelesCompetencia(competencia_id) {
  const [distribucion, setDistribucion] = useState(null)
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerNiveles = async () => {
    if (!competencia_id) return
    setCargando(true)
    try {
      const data = await nivelesService.obtenerNivelesCompetencia(competencia_id)
      setDistribucion(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerNiveles()
  }, [competencia_id])

  return {
    distribucion,
    cargando,
    error,
    obtenerNiveles
  }
}

export function useNivelCalificacion(calificacion) {
  const [nivel, setNivel] = useState(null)

  useEffect(() => {
    if (calificacion !== null && calificacion !== undefined) {
      nivelesService.obtenerNivelCalificacion(calificacion)
        .then(data => setNivel(data))
        .catch(err => console.error(err))
    }
  }, [calificacion])

  return nivel
}
