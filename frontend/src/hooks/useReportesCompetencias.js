import { useState, useEffect, useCallback } from 'react'
import axios from 'axios'

const BASE_URL = 'http://localhost:5000'
const headers = () => {
  const t = localStorage.getItem('acceso_token')
  return t ? { Authorization: `Bearer ${t}` } : {}
}

export function useReportesCompetencias() {
  const [comparativa, setComparativa] = useState([])
  const [criticas, setCriticas] = useState([])
  const [reporteCurso, setReporteCurso] = useState(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  const cargarComparativa = useCallback(async () => {
    setLoading(true)
    try {
      const [comp, crit] = await Promise.all([
        axios.get(`${BASE_URL}/api/reportes/comparativa-grados`, { headers: headers() }),
        axios.get(`${BASE_URL}/api/reportes/competencias-criticas`, { headers: headers() }),
      ])
      setComparativa(comp.data || [])
      setCriticas(crit.data || [])
      setError(null)
    } catch (err) {
      setError(err.response?.data?.error || err.message)
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => { cargarComparativa() }, [cargarComparativa])

  const cargarPorGrado = useCallback(async (gradoId) => {
    if (!gradoId) return
    setLoading(true)
    try {
      const res = await axios.get(`${BASE_URL}/api/reportes/competencias-por-grado/${gradoId}`, { headers: headers() })
      setReporteCurso(res.data)
      setError(null)
    } catch (err) {
      setError(err.response?.data?.error || err.message)
    } finally {
      setLoading(false)
    }
  }, [])

  return {
    comparativa,
    criticas,
    reporteCurso,
    loading,
    error,
    cargarPorGrado,
    refrescar: cargarComparativa,
  }
}
