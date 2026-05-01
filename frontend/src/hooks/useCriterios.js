import { useState, useEffect } from 'react'
import criteriosService from '../services/criterios'

export const useCriterios = (resultado_id) => {
  const [criterios, setCriterios] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  const fetchCriterios = async () => {
    setLoading(true)
    try {
      const data = resultado_id
        ? await criteriosService.getByResultado(resultado_id)
        : await criteriosService.getAll()
      setCriterios(data)
      setError(null)
    } catch (err) {
      setError(err.response?.data?.mensaje || 'Error al cargar criterios')
    } finally {
      setLoading(false)
    }
  }

  const agregarCriterio = async (criterio) => {
    try {
      const nuevo = await criteriosService.create(criterio)
      setCriterios([...criterios, nuevo])
      return nuevo
    } catch (err) {
      throw err
    }
  }

  const actualizarCriterio = async (id, criterio) => {
    try {
      const actualizado = await criteriosService.update(id, criterio)
      setCriterios(criterios.map(c => c.id === id ? actualizado : c))
      return actualizado
    } catch (err) {
      throw err
    }
  }

  const eliminarCriterio = async (id) => {
    try {
      await criteriosService.delete(id)
      setCriterios(criterios.filter(c => c.id !== id))
    } catch (err) {
      throw err
    }
  }

  useEffect(() => {
    fetchCriterios()
  }, [resultado_id])

  return {
    criterios,
    loading,
    cargando: loading,
    error,
    fetchCriterios,
    obtenerCriterios: fetchCriterios,
    agregarCriterio,
    actualizarCriterio,
    eliminarCriterio
  }
}

