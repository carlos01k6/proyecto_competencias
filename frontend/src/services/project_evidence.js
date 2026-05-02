import axios from 'axios'

const API_URL = 'http://localhost:5000/api/evidencias-proyecto'

function getAuthHeader() {
  const token = localStorage.getItem('acceso_token')
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function obtenerEvidenciasPorActividad(actividad_id) {
  const response = await axios.get(`${API_URL}/por-actividad/${actividad_id}`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function obtenerActividadesResumen() {
  const response = await axios.get(`${API_URL}/actividades-resumen`, {
    headers: getAuthHeader()
  })
  return response.data || []
}

