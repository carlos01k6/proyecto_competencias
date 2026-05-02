import { useState, useEffect } from "react"

export const useEstudiantesCurso = (cursoId) => {
  const [estudiantes, setEstudiantes] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerEstudiantes = async () => {
    console.log("🔵 useEstudiantesCurso - cursoId:", cursoId)
    if (!cursoId) {
      console.log("⚠️ Sin cursoId")
      return
    }
    
    setCargando(true)
    try {
      const token = localStorage.getItem("acceso_token")
      const url = `http://localhost:5000/api/estudiantes/curso/${cursoId}`
      console.log("📍 URL:", url)
      
      const response = await fetch(url, {
        headers: { Authorization: `Bearer ${token}` }
      })
      
      console.log("📊 Status:", response.status)
      const data = await response.json()
      console.log("🟢 Datos recibidos:", data)
      
      setEstudiantes(data || [])
      setError(null)
    } catch (err) {
      console.error("🔴 Error:", err)
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerEstudiantes()
  }, [cursoId])

  return { estudiantes, cargando, error, obtenerEstudiantes }
}
