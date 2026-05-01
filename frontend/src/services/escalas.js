import axios from "axios"

const API_URL = "http://localhost:5000/api/escalas"

function getAuthHeader() {
  const token = localStorage.getItem("acceso_token")
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function obtenerEscalaActual() {
  const response = await axios.get(`${API_URL}/actual`)
  return response.data || {}
}

export async function convertirCalificacion(calificacion) {
  const response = await axios.get(`${API_URL}/convertir/${calificacion}`)
  return response.data || {}
}

export async function actualizarEscala(escala) {
  const response = await axios.post(`${API_URL}/actualizar`, { escala }, {
    headers: getAuthHeader()
  })
  return response.data || {}
}
