import { useState, useEffect } from 'react'
import * as configService from '../services/config'

export function useConfig() {
  const [configuraciones, setConfiguraciones] = useState({})
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  // Obtener todas las configuraciones
  const obtenerConfiguraciones = async () => {
    setCargando(true)
    try {
      const data = await configService.obtenerConfiguraciones()
      const configMap = Array.isArray(data)
        ? data.reduce((acc, item) => {
            acc[item.key] = {
              key: item.key,
              value: item.value,
              valor: item.value,
              tipo: typeof item.value === 'number' ? 'number' : item.value === 'true' || item.value === 'false' ? 'boolean' : 'text',
              descripcion: item.key
            }
            return acc
          }, {})
        : data
      setConfiguraciones(configMap)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  // Obtener una configuración específica
  const obtenerConfiguracion = async (clave) => {
    try {
      const data = await configService.obtenerConfiguracion(clave)
      return data
    } catch (err) {
      throw err
    }
  }

  // Actualizar una configuración
  const actualizarConfiguracion = async (clave, valor) => {
    try {
      const data = await configService.actualizarConfiguracion(clave, valor)
      setConfiguraciones({
        ...configuraciones,
        [clave]: {
          ...(configuraciones[clave] || {}),
          key: data.key || clave,
          value: data.value,
          valor: data.value
        }
      })
      return data
    } catch (err) {
      throw err
    }
  }

  useEffect(() => {
    obtenerConfiguraciones()
  }, [])

  return {
    configuraciones,
    cargando,
    error,
    obtenerConfiguracion,
    actualizarConfiguracion,
    obtenerConfiguraciones
  }
}
