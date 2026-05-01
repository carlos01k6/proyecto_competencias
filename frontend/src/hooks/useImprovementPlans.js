import { useState } from 'react'
import * as improvementPlansService from '../services/improvement_plans'

export function useGenerarPlanMejora() {
  const [plan, setPlan] = useState(null)
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)
  const [exito, setExito] = useState(false)

  const generar = async (student_id) => {
    setCargando(true)
    setError(null)
    setExito(false)
    try {
      const data = await improvementPlansService.generarPlanMejora(student_id)
      setPlan(data.plan)
      setExito(true)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  return {
    plan,
    cargando,
    error,
    exito,
    generar
  }
}

export function useEstudiantesEnRiesgo() {
  const [estudiantes, setEstudiantes] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtener = async () => {
    setCargando(true)
    try {
      const data = await improvementPlansService.obtenerEstudiantesEnRiesgo()
      setEstudiantes(data.at_risk_students || [])
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  return {
    estudiantes,
    cargando,
    error,
    obtener
  }
}
