import { useState, useEffect } from "react"

export const useEstudiantes = (cursoID) => {
  const [estudiantes, setEstudiantes] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerEstudiantes = async () => {
    if (!cursoID) return
    
    setCargando(true)
    try {
      const token = localStorage.getItem("acceso_token")
      const response = await fetch(
        `http://localhost:5000/api/estudiantes/por-curso/${cursoID}`,
        {
          headers: { Authorization: `Bearer ${token}` }
        }
      )
      const data = await response.json()
      setEstudiantes(data || [])
      setError(null)
    } catch (err) {
      setError(err.message)
      console.error(err)
    } finally {
      setCargando(false)
    }
  }

  useEffect(() => {
    obtenerEstudiantes()
  }, [cursoID])

  return { estudiantes, cargando, error, obtenerEstudiantes }
}
