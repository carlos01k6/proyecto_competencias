import { useState, useEffect, useCallback } from 'react'
import axios from 'axios'

const BASE_URL = 'http://localhost:5000'
const headers = () => {
  const t = localStorage.getItem('acceso_token')
  return t ? { Authorization: `Bearer ${t}` } : {}
}

export function useHistorial(estudianteId) {
  const [historial, setHistorial] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  const cargar = useCallback(async () => {
    if (!estudianteId) return
    setLoading(true)
    try {
      const res = await axios.get(`${BASE_URL}/api/historial/${estudianteId}`, { headers: headers() })
      setHistorial(res.data || [])
      setError(null)
    } catch (err) {
      setError(err.response?.data?.error || err.message)
    } finally {
      setLoading(false)
    }
  }, [estudianteId])

  useEffect(() => { cargar() }, [cargar])

  const descargarCSV = () => {
    const rows = [['Fecha', 'Competencia', 'Calificación', '% Anterior', '% Actual', 'Cambio', 'Re-evaluación']]
    historial.forEach(h => {
      rows.push([
        h.fecha ? new Date(h.fecha).toLocaleDateString('es-ES') : '',
        h.competencia_nombre,
        h.calificacion,
        h.porcentaje_antes ?? '',
        h.porcentaje_despues,
        h.cambio ?? '',
        h.es_reevaluacion ? 'Sí' : 'No',
      ])
    })
    const csv = rows.map(r => r.map(v => `"${String(v ?? '').replace(/"/g, '""')}"`).join(',')).join('\n')
    const blob = new Blob(['﻿' + csv], { type: 'text/csv;charset=utf-8;' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `historial_${estudianteId?.slice(0, 8)}_${new Date().toISOString().slice(0, 10)}.csv`
    document.body.appendChild(a); a.click(); document.body.removeChild(a)
    URL.revokeObjectURL(url)
  }

  return { historial, loading, error, refrescar: cargar, descargarCSV }
}

export function useHistorialCompetencia(estudianteId, competenciaId) {
  const [data, setData] = useState(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    if (!estudianteId || !competenciaId) return
    setLoading(true)
    axios.get(`${BASE_URL}/api/historial/${estudianteId}/${competenciaId}`, { headers: headers() })
      .then(r => setData(r.data))
      .catch(() => setData(null))
      .finally(() => setLoading(false))
  }, [estudianteId, competenciaId])

  return { data, loading }
}
