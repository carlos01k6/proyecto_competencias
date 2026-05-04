import axios from "axios"

const API_URL = "http://localhost:5000/api/actividades"

function getAuthHeader() {
  const token = localStorage.getItem("acceso_token")
  return token ? { Authorization: `Bearer ${token}` } : {}
}

export async function obtenerTodasActividades() {
  const response = await axios.get(API_URL)
  return response.data || []
}

export async function obtenerActividadesPorResultado(resultado_id) {
  const response = await axios.get(`${API_URL}/${resultado_id}`)
  return response.data || []
}

export async function crearActividad(formData) {
  const response = await axios.post(API_URL, formData, {
    headers: getAuthHeader()
  })
  return response.data[0] || response.data
}

export async function actualizarActividad(actividad_id, formData) {
  const response = await axios.put(`${API_URL}/${actividad_id}`, formData)
  return response.data[0] || response.data
}

export async function eliminarActividad(actividad_id) {
  await axios.delete(`${API_URL}/${actividad_id}`)
}

