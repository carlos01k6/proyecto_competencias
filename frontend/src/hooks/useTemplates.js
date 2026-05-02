import { useEffect, useState } from "react"
import * as plantillasService from "../services/templates"

export function usePlantillas() {
  const [plantillas, setPlantillas] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerPlantillas = async () => {
    setCargando(true)
    try {
      const data = await plantillasService.obtenerPlantillas()
      setPlantillas(data)
      setError(null)
    } catch (err) {
      setError(err.response?.data?.error || err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerPlantillas()
  }, [])

  return {
    plantillas,
    cargando,
    error,
    obtenerPlantillas
  }
}

export function useGuardarPlantilla() {
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const crear = async (datos) => {
    setCargando(true)
    setError(null)
    try {
      return await plantillasService.crearPlantilla(datos)
    } catch (err) {
      const message = err.response?.data?.error || err.message
      setError(message)
      throw new Error(message)
    } finally {
      setCargando(false)
    }
  }

  const actualizar = async (plantillaId, datos) => {
    setCargando(true)
    setError(null)
    try {
      return await plantillasService.actualizarPlantilla(plantillaId, datos)
    } catch (err) {
      const message = err.response?.data?.error || err.message
      setError(message)
      throw new Error(message)
    } finally {
      setCargando(false)
    }
  }

  return {
    crear,
    actualizar,
    cargando,
    error
  }
}

export function useEliminarPlantilla() {
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const eliminar = async (plantillaId) => {
    setCargando(true)
    setError(null)
    try {
      await plantillasService.eliminarPlantilla(plantillaId)
      return true
    } catch (err) {
      setError(err.response?.data?.error || err.message)
      return false
    } finally {
      setCargando(false)
    }
  }

  return {
    eliminar,
    cargando,
    error
  }
}

export function useAplicarPlantilla() {
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const aplicar = async (plantillaId, competenciaId) => {
    setCargando(true)
    setError(null)
    try {
      return await plantillasService.aplicarPlantilla(plantillaId, competenciaId)
    } catch (err) {
      const message = err.response?.data?.error || err.message
      setError(message)
      throw new Error(message)
    } finally {
      setCargando(false)
    }
  }

  return {
    aplicar,
    cargando,
    error
  }
}

