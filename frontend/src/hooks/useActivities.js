import { useState, useEffect } from 'react'
import * as actividadesService from '../services/activities'

export function useActividades(resultado_id = null) {
  const [actividades, setActividades] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  // Obtener actividades
  const obtenerActividades = async () => {
    setCargando(true)
    try {
      let data
      if (resultado_id) {
        // Si hay resultado_id, obtener actividades de ese resultado
        data = await actividadesService.obtenerActividadesPorResultado(resultado_id)
      } else {
        // Si no hay resultado_id, obtener TODAS las actividades
        data = await actividadesService.obtenerTodasActividades()
      }
      setActividades(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  // Agregar actividad
  const agregarActividad = async (formData) => {
    try {
      const nuevaActividad = await actividadesService.crearActividad({
        resultado_id,
        ...formData
      })
      setActividades([...actividades, nuevaActividad])
      return nuevaActividad
    } catch (err) {
      throw err
    }
  }

  // Actualizar actividad
  const actualizarActividad = async (actividad_id, formData) => {
    try {
      const actualizada = await actividadesService.actualizarActividad(actividad_id, formData)
      setActividades(actividades.map(a => a.id === actividad_id ? actualizada : a))
      return actualizada
    } catch (err) {
      throw err
    }
  }

  // Eliminar actividad
  const eliminarActividad = async (actividad_id) => {
    try {
      await actividadesService.eliminarActividad(actividad_id)
      setActividades(actividades.filter(a => a.id !== actividad_id))
    } catch (err) {
      throw err
    }
  }

  useEffect(() => {
    obtenerActividades()
  }, [resultado_id])

  return {
    actividades,
    cargando,
    error,
    agregarActividad,
    actualizarActividad,
    eliminarActividad,
    obtenerActividades
  }
}
