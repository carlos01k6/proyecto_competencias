import { useState, useEffect, useCallback, useRef } from 'react'
import axios from 'axios'

const BASE_URL = 'http://localhost:5000'

function getHeaders() {
  const token = localStorage.getItem('acceso_token')
  return token ? { Authorization: `Bearer ${token}` } : {}
}

export function useAlertas(docenteId) {
  const [alertas, setAlertas] = useState([])
  const [estadisticas, setEstadisticas] = useState({ total: 0, critico: 0, alto: 0, medio: 0, bajo: 0 })
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const mostrarLeidasRef = useRef(false)

  const cargar = useCallback(async (mostrarLeidas = false) => {
    if (!docenteId) return
    mostrarLeidasRef.current = mostrarLeidas
    setLoading(true)
    try {
      const [alertasRes, statsRes] = await Promise.all([
        axios.get(`${BASE_URL}/api/alertas/${docenteId}?mostrar_leidas=${mostrarLeidas}`, { headers: getHeaders() }),
        axios.get(`${BASE_URL}/api/alertas/estadisticas/${docenteId}`, { headers: getHeaders() }),
      ])
      setAlertas(alertasRes.data || [])
      setEstadisticas(statsRes.data || { total: 0, critico: 0, alto: 0, medio: 0, bajo: 0 })
      setError(null)
    } catch (err) {
      setError(err.response?.data?.error || err.message)
    } finally {
      setLoading(false)
    }
  }, [docenteId])

  useEffect(() => {
    cargar()
    const interval = setInterval(() => cargar(mostrarLeidasRef.current), 5 * 60 * 1000)
    return () => clearInterval(interval)
  }, [cargar])

  const marcarLeida = useCallback(async (alertaId) => {
    try {
      await axios.put(
        `${BASE_URL}/api/alertas/${alertaId}/marcar-leida`,
        { docente_id: docenteId },
        { headers: getHeaders() },
      )
      await cargar(mostrarLeidasRef.current)
    } catch (err) {
      console.error('Error marcando alerta como leída:', err)
    }
  }, [docenteId, cargar])

  const descargarCSV = useCallback((alertasData) => {
    const filas = [['Nombre', 'Competencia', '% Logro', 'Nivel', 'Tipo Alerta']]
    ;(alertasData || []).forEach(grupo => {
      ;(grupo.alertas || []).forEach(a => {
        filas.push([
          a.student_name,
          grupo.competency_name,
          a.porcentaje_logro,
          a.nivel_riesgo,
          a.tipo_alerta,
        ])
      })
    })
    const csv = filas.map(r => r.map(v => `"${String(v ?? '').replace(/"/g, '""')}"`).join(',')).join('\n')
    const blob = new Blob(['﻿' + csv], { type: 'text/csv;charset=utf-8;' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `alertas_desempeno_${new Date().toISOString().slice(0, 10)}.csv`
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    URL.revokeObjectURL(url)
  }, [])

  return { alertas, estadisticas, loading, error, marcarLeida, descargarCSV, refrescar: cargar }
}
