import axios from 'axios'

const API_URL = 'http://localhost:5000/api/resultados'

// Obtener token del localStorage
function getAuthHeader() {
  const token = localStorage.getItem('acceso_token')
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function obtenerResultadosPorCompetencia(competencia_id) {
  const response = await axios.get(`${API_URL}/${competencia_id}`, {
    headers: getAuthHeader()
  })
  return response.data || []
}

export async function obtenerTodosResultados() {
  const response = await axios.get(API_URL, {
    headers: getAuthHeader()
  })
  return response.data || []
}

export async function crearResultado(resultado) {
  const response = await axios.post(API_URL, resultado, {
    headers: getAuthHeader()
  })
  return response.data[0]
}

export async function actualizarResultado(id, resultado) {
  const response = await axios.put(`${API_URL}/${id}`, resultado, {
    headers: getAuthHeader()
  })
  return response.data[0]
}

export async function eliminarResultado(id) {
  await axios.delete(`${API_URL}/${id}`, {
    headers: getAuthHeader()
  })
}

