import { useState, useEffect } from 'react'
import * as escalasService from '../services/scales'

export function useEscalaActual() {
  const [escala, setEscala] = useState('0-100')
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerEscala = async () => {
    setCargando(true)
    try {
      const data = await escalasService.obtenerEscalaActual()
      setEscala(data.escala || '0-100')
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerEscala()
  }, [])

  return {
    escala,
    cargando,
    error,
    obtenerEscala
  }
}

export function useConvertirCalificacion(calificacion) {
  const [convertida, setConvertida] = useState(null)
  const [cargando, setCargando] = useState(false)

  useEffect(() => {
    if (calificacion !== null && calificacion !== undefined) {
      setCargando(true)
      escalasService.convertirCalificacion(calificacion)
        .then(data => {
          setConvertida(data)
          setCargando(false)
        })
        .catch(err => {
          console.error(err)
          setCargando(false)
        })
    }
  }, [calificacion])

  return { convertida, cargando }
}

export function useActualizarEscala() {
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)
  const [exito, setExito] = useState(false)

  const actualizar = async (nuevaEscala) => {
    setCargando(true)
    setError(null)
    setExito(false)
    try {
      await escalasService.actualizarEscala(nuevaEscala)
      setExito(true)
    } catch (err) {
      setError(err.message)
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
