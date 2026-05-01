import { useState, useEffect } from 'react'
import * as resultadosService from '../services/resultados'

export function useResultados(competencia_id) {
  const [resultados, setResultados] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerResultados = async () => {
    if (!competencia_id) {
      // Si no hay competencia_id, obtener todos los resultados
      setCargando(true)
      try {
        const data = await resultadosService.obtenerTodosResultados()
        setResultados(data)
        setError(null)
      } catch (err) {
        setError(err.message)
      } finally {
        setCargando(false)
      }
      return
    }

    // Si hay competencia_id, obtener por competencia
    setCargando(true)
    try {
      const data = await resultadosService.obtenerResultadosPorCompetencia(competencia_id)
      setResultados(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  const agregarResultado = async (formData) => {
    try {
      const nuevoResultado = await resultadosService.crearResultado(formData)
      setResultados([...resultados, nuevoResultado])
      return nuevoResultado
    } catch (err) {
      throw err
    }
  }

  const actualizarResultado = async (resultado_id, formData) => {
    try {
      const actualizado = await resultadosService.actualizarResultado(resultado_id, formData)
      setResultados(resultados.map(r => r.id === resultado_id ? actualizado : r))
      return actualizado
    } catch (err) {
      throw err
    }
  }

  const eliminarResultado = async (resultado_id) => {
    try {
      await resultadosService.eliminarResultado(resultado_id)
      setResultados(resultados.filter(r => r.id !== resultado_id))
    } catch (err) {
      throw err
    }
  }

  useEffect(() => {
    obtenerResultados()
  }, [competencia_id])

  return {
    resultados,
    cargando,
    error,
    agregarResultado,
    actualizarResultado,
    eliminarResultado,
    obtenerResultados
  }
}
