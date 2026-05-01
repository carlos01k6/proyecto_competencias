import axios from 'axios'

const API_URL = 'http://localhost:5000/api/config'

function getAuthHeader() {
  const token = localStorage.getItem('acceso_token')
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function obtenerConfiguraciones() {
  const response = await axios.get(API_URL, {
    headers: getAuthHeader()
  })
  return response.data || []
}

export async function obtenerConfiguracion(clave) {
  const response = await axios.get(`${API_URL}/${clave}`, {
    headers: getAuthHeader()
  })
  return response.data
}

export async function actualizarConfiguracion(clave, valor) {
  const response = await axios.put(`${API_URL}/${clave}`, { value: valor }, {
    headers: getAuthHeader()
  })
  return response.data
}

