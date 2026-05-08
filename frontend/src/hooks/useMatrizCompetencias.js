import { useState, useEffect, useCallback } from 'react'
import axios from 'axios'

const BASE_URL = 'http://localhost:5000'
const headers = () => {
  const t = localStorage.getItem('acceso_token')
  return t ? { Authorization: `Bearer ${t}` } : {}
}

const NIVEL_COLOR = {
  incipiente:    '#ef4444',
  basico:        '#f97316',
  satisfactorio: '#eab308',
  avanzado:      '#22c55e',
}

export function useMatrizCompetencias({ docenteId, gradoId } = {}) {
  const [matriz, setMatriz] = useState(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  const cargar = useCallback(async () => {
    const url = gradoId
      ? `${BASE_URL}/api/matriz/grado/${gradoId}`
      : docenteId
        ? `${BASE_URL}/api/matriz/${docenteId}`
        : null
    if (!url) return
    setLoading(true)
    try {
      const res = await axios.get(url, { headers: headers() })
      setMatriz(res.data)
      setError(null)
    } catch (err) {
      setError(err.response?.data?.error || err.message)
    } finally {
      setLoading(false)
    }
  }, [docenteId, gradoId])

  useEffect(() => { cargar() }, [cargar])

  const getColor = (nivel) => NIVEL_COLOR[nivel] || '#6b7280'

  const exportarCSV = () => {
    if (!matriz) return
    const { estudiantes, competencias, matriz: filas } = matriz
    const header = ['Estudiante', ...competencias.map(c => c.nombre)]
    const rows = estudiantes.map((est, i) => [
      est.nombre,
      ...filas[i].map(c => c?.porcentaje != null ? `${c.porcentaje}%` : '—'),
    ])
    const csv = [header, ...rows].map(r => r.map(v => `"${v}"`).join(',')).join('\n')
    const blob = new Blob(['﻿' + csv], { type: 'text/csv;charset=utf-8;' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `matriz_competencias_${new Date().toISOString().slice(0, 10)}.csv`
    document.body.appendChild(a); a.click(); document.body.removeChild(a)
    URL.revokeObjectURL(url)
  }

  return { matriz, loading, error, refrescar: cargar, getColor, exportarCSV }
}
