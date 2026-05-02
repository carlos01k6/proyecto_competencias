import axios from "axios"

const API_URL = "http://localhost:5000/api/niveles"

function getAuthHeader() {
  const token = localStorage.getItem("acceso_token")
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function obtenerNivelCalificacion(calificacion) {
  const response = await axios.get(`${API_URL}/calificacion/${calificacion}`)
  return response.data || {}
}

export async function obtenerNivelesEstudiante(estudiante_id) {
  const response = await axios.get(`${API_URL}/estudiante/${estudiante_id}`, {
    headers: getAuthHeader()
  })
  return response.data || []
}

export async function obtenerNivelesCompetencia(competencia_id) {
  const response = await axios.get(`${API_URL}/competencia/${competencia_id}`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}
