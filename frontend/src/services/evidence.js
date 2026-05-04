import axios from "axios"

const API_URL = "http://localhost:5000/api/evidencias"

function getAuthHeader() {
  const token = localStorage.getItem("acceso_token")
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function obtenerEvidencias(actividad_id) {
  const url = actividad_id ? `${API_URL}/actividad/${actividad_id}` : API_URL
  const response = await axios.get(url, {
    headers: getAuthHeader()
  })
  return response.data || []
}

export async function obtenerEvidenciasEstudiante(studentId) {
  const response = await axios.get(`${API_URL}/estudiante/${studentId}`, {
    headers: getAuthHeader()
  })
  return response.data || []
}

export async function crearEvidencia(formData) {
  const response = await axios.post(API_URL, formData, {
    headers: {
      "Content-Type": "multipart/form-data",
      ...getAuthHeader()
    }
  })
  return response.data || {}
}

export async function descargarEvidencia(evidencia_id) {
  const response = await axios.get(`${API_URL}/${evidencia_id}/descargar`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function eliminarEvidencia(evidencia_id) {
  await axios.delete(`${API_URL}/${evidencia_id}`, {
    headers: getAuthHeader()
  })
}
