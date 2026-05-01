import axios from 'axios'

const API_URL = 'http://localhost:5000/api/academic-periods'

function getAuthHeader() {
  const token = localStorage.getItem('acceso_token')
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function crearPeriodo(datos) {
  const response = await axios.post(`${API_URL}/crear`, datos, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function obtenerPeriodosPorTipo(tipo) {
  const response = await axios.get(`${API_URL}/por-tipo/${tipo}`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function obtenerConfiguracionPeriodos() {
  const response = await axios.get(`${API_URL}/configuracion`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function actualizarTipoPeriodo(tipo) {
  const response = await axios.put(`${API_URL}/tipo-periodo`, { tipo }, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

