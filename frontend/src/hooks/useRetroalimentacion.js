import { useState, useEffect } from 'react'
import * as retroalimentacionService from '../services/retroalimentacion'

export function useTemplates() {
  const [templates, setTemplates] = useState({})
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  useEffect(() => {
    setCargando(true)
    retroalimentacionService.obtenerTemplates()
      .then(data => {
        setTemplates(data)
        setError(null)
      })
      .catch(err => {
        setError(err.message)
      })
      .finally(() => setCargando(false))
  }, [])

  return { templates, cargando, error }
}

export function useFeedbackPersonalizado(calificacion) {
  const [feedback, setFeedback] = useState(null)
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  useEffect(() => {
    if (calificacion !== null && calificacion !== undefined) {
      setCargando(true)
      retroalimentacionService.obtenerFeedbackPersonalizado(calificacion)
        .then(data => {
          setFeedback(data)
          setError(null)
        })
        .catch(err => {
          setError(err.message)
        })
        .finally(() => setCargando(false))
    }
  }, [calificacion])

  return { feedback, cargando, error }
}

export function useFeedbackPorCriterio(calificacion, criterioTipo) {
  const [feedback, setFeedback] = useState(null)
  const [cargando, setCargando] = useState(false)

  useEffect(() => {
    if (calificacion !== null && calificacion !== undefined && criterioTipo) {
      setCargando(true)
      retroalimentacionService.obtenerFeedbackPorCriterio(calificacion, criterioTipo)
        .then(data => {
          setFeedback(data)
        })
        .catch(err => {
          console.error(err)
        })
        .finally(() => setCargando(false))
    }
  }, [calificacion, criterioTipo])

  return { feedback, cargando }
}
