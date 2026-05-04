import { useState, useEffect } from "react"

export const useEstudiantes = (cursoID) => {
  const [estudiantes, setEstudiantes] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerEstudiantes = async () => {
    setCargando(true)
    try {
      const token = localStorage.getItem("acceso_token")
      const url = cursoID
        ? `http://localhost:5000/api/estudiantes/por-curso/${cursoID}`
        : "http://localhost:5000/api/estudiantes"
      const response = await fetch(
        url,
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
