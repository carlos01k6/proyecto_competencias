import { useState, useEffect } from 'react'
import competenciasService from '../services/competencias'

export const useCompetencias = () => {
  const [competencias, setCompetencias] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  const fetchCompetencias = async () => {
    console.log("🔵 DEBUG: fetchCompetencias iniciado")
    setLoading(true)
    try {
      const data = await competenciasService.getAll()
      console.log("🟢 DEBUG: datos recibidos:", data)
      setCompetencias(data)
      setError(null)
    } catch (err) {
      console.log("🔴 DEBUG: error:", err)
      setError(err.response?.data?.mensaje || 'Error al cargar competencias')
    } finally {
      setLoading(false)
    }
  }

  const agregarCompetencia = async (competencia) => {
    try {
      const nueva = await competenciasService.create(competencia)
      setCompetencias([...competencias, nueva])
      return nueva
    } catch (err) {
      throw err
    }
  }

  const actualizarCompetencia = async (id, competencia) => {
    try {
      const actualizada = await competenciasService.update(id, competencia)
      setCompetencias(competencias.map(c => c.id === id ? actualizada : c))
      return actualizada
    } catch (err) {
      throw err
    }
  }

  const eliminarCompetencia = async (id) => {
    try {
      await competenciasService.delete(id)
      setCompetencias(competencias.filter(c => c.id !== id))
    } catch (err) {
      throw err
    }
  }

  useEffect(() => {
    console.log("🟡 DEBUG: useEffect ejecutado")
    fetchCompetencias()
  }, [])

  return {
    competencias,
    loading,
    error,
    fetchCompetencias,
    agregarCompetencia,
    actualizarCompetencia,
    eliminarCompetencia
  }
}
