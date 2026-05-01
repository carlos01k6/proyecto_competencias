import axios from 'axios'

const API_URL = 'http://localhost:5000/api/improvement-plans'

function getAuthHeader() {
  const token = localStorage.getItem('acceso_token')
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function generarPlanMejora(student_id) {
  const response = await axios.post(`${API_URL}/generar/${student_id}`, {}, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function obtenerEstudiantesEnRiesgo() {
  const response = await axios.get(`${API_URL}/estudiantes-en-riesgo`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

