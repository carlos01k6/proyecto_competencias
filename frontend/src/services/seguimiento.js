import axios from 'axios'

const API_URL = 'http://localhost:5000/api/seguimiento'

function getAuthHeader() {
  const token = localStorage.getItem('acceso_token')
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function obtenerProgresoCompetencias(estudiante_id) {
  const response = await axios.get(`${API_URL}/competencias/${estudiante_id}`, {
    headers: getAuthHeader()
  })
  return response.data || []
}

