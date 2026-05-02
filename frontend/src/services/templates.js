import axios from "axios"

const API_URL = "http://localhost:5000/api/plantillas"

function getAuthHeader() {
  const token = localStorage.getItem("acceso_token")
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function obtenerPlantillas() {
  const response = await axios.get(API_URL, {
    headers: getAuthHeader()
  })
  return response.data || []
}

export async function crearPlantilla(datos) {
  const response = await axios.post(API_URL, datos, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function obtenerPlantilla(plantillaId) {
  const response = await axios.get(`${API_URL}/${plantillaId}`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function actualizarPlantilla(plantillaId, datos) {
  const response = await axios.put(`${API_URL}/${plantillaId}`, datos, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function eliminarPlantilla(plantillaId) {
  const response = await axios.delete(`${API_URL}/${plantillaId}`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function aplicarPlantilla(plantillaId, competenciaId) {
  const response = await axios.get(`${API_URL}/${plantillaId}/aplicar/${competenciaId}`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

