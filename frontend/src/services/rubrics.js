import axios from "axios"

const API_URL = "http://localhost:5000/api/rubricas"

function getAuthHeader() {
  const token = localStorage.getItem("acceso_token")
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function crearRubrica(datos) {
  const response = await axios.post(`${API_URL}/crear`, datos, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function obtenerMisRubricas() {
  const response = await axios.get(`${API_URL}/mis-rubricas`, {
    headers: getAuthHeader()
  })
  return response.data || []
}

export async function obtenerRubricasGlobales() {
  const response = await axios.get(`${API_URL}/globales`, {
    headers: getAuthHeader()
  })
  return response.data || []
}

export async function obtenerRubrica(rubrica_id) {
  const response = await axios.get(`${API_URL}/${rubrica_id}`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function actualizarRubrica(rubrica_id, datos) {
  const response = await axios.put(`${API_URL}/${rubrica_id}`, datos, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function obtenerRubricasPublicas() {
  const response = await axios.get(`${API_URL}/publicas`)
  return response.data || []
}

export async function eliminarRubrica(rubrica_id) {
  const response = await axios.delete(`${API_URL}/${rubrica_id}`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

