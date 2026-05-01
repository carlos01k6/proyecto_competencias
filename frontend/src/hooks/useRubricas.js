import { useState, useEffect } from "react"
import * as rubricasService from "../services/rubricas"

export function useMisRubricas() {
  const [rubricas, setRubricas] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerRubricas = async () => {
    console.log("🔵 useMisRubricas: Iniciando obtenerRubricas")
    setCargando(true)
    try {
      const token = localStorage.getItem("acceso_token")
      console.log("🔑 Token existe:", !!token)
      
      const data = await rubricasService.obtenerMisRubricas()
      console.log("🟢 Datos recibidos:", data)
      
      setRubricas(data)
      setError(null)
    } catch (err) {
      console.error("🔴 Error en useMisRubricas:", err)
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    console.log("🟡 useEffect ejecutado - llamando obtenerRubricas")
    obtenerRubricas()
  }, [])

  return {
    rubricas,
    cargando,
    error,
    obtenerRubricas
  }
}

export function useRubrica(rubrica_id) {
  const [rubrica, setRubrica] = useState(null)
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerRubrica = async () => {
    if (!rubrica_id) return
    setCargando(true)
    try {
      const data = await rubricasService.obtenerRubrica(rubrica_id)
      setRubrica(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerRubrica()
  }, [rubrica_id])

  return {
    rubrica,
    cargando,
    error,
    obtenerRubrica
  }
}

export function useCrearRubrica() {
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)
  const [exito, setExito] = useState(false)

  const crear = async (datos) => {
    setCargando(true)
    setError(null)
    setExito(false)
    try {
      await rubricasService.crearRubrica(datos)
      setExito(true)
    } catch (err) {
      setError(err.message)
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

export function useActualizarRubrica() {
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)
  const [exito, setExito] = useState(false)

  const actualizar = async (rubrica_id, datos) => {
    setCargando(true)
    setError(null)
    setExito(false)
    try {
      await rubricasService.actualizarRubrica(rubrica_id, datos)
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

export function useEliminarRubrica() {
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const eliminar = async (rubrica_id) => {
    setCargando(true)
    try {
      await rubricasService.eliminarRubrica(rubrica_id)
      return true
    } catch (err) {
      setError(err.message)
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

export function useRubricasPublicas() {
  const [rubricas, setRubricas] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerRubricas = async () => {
    setCargando(true)
    try {
      const data = await rubricasService.obtenerRubricasPublicas()
      setRubricas(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerRubricas()
  }, [])

  return {
    rubricas,
    cargando,
    error,
    obtenerRubricas
  }
}
