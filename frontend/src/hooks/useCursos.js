import { useState, useEffect } from "react"

export const useCursos = (docente_id) => {
  const [cursos, setCursos] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerCursos = async () => {
    console.log("🔍 useCursos - docente_id recibido:", docente_id)
    
    if (!docente_id) {
      console.log("❌ Sin docente_id")
      setError("Sin ID de docente")
      return
    }

    setCargando(true)
    try {
      const token = localStorage.getItem("acceso_token")
      console.log("🔑 Token:", token ? "Existe" : "No existe")
      
      const url = `http://localhost:5000/api/cursos/docente/${docente_id}`
      console.log("📍 URL:", url)
      
      const response = await fetch(url, {
        headers: { Authorization: `Bearer ${token}` }
      })
      
      console.log("📊 Response status:", response.status)
      
      const data = await response.json()
      console.log("📦 Datos recibidos:", data)
      
      setCursos(data || [])
      setError(null)
    } catch (err) {
      console.error("🚨 Error:", err)
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerCursos()
  }, [docente_id])

  return { cursos, cargando, error, obtenerCursos }
}