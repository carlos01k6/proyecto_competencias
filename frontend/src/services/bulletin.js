import axios from "axios"

const API_URL = "http://localhost:5000/api/boletin"

function getAuthHeader() {
  const token = localStorage.getItem("acceso_token")
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function generarBoletinEstudiante(estudiante_id) {
  const response = await axios.get(`${API_URL}/estudiante/${estudiante_id}`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function obtenerBoletinesGrupo() {
  const response = await axios.get(`${API_URL}/grupo`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function obtenerBoletinCompetencia(competencia_id) {
  const response = await axios.get(`${API_URL}/competencia/${competencia_id}`, {
    headers: getAuthHeader()
  })
  return response.data || []
}
