import axios from "axios"

const API_URL = "http://localhost:5000/api/evaluaciones"

function getAuthHeader() {
  const token = localStorage.getItem("acceso_token")
  return token ? { Authorization: `Bearer ${token}` } : {}
}

export async function obtenerEvaluacionesCriterio(criterio_id) {
  const response = await axios.get(`${API_URL}/criterio/${criterio_id}`, { headers: getAuthHeader() })
  return response.data || []
}

export async function obtenerEvaluacionesEstudiante(estudiante_id, resultado_id) {
  const response = await axios.get(`${API_URL}/estudiante/${estudiante_id}/resultado/${resultado_id}`, { headers: getAuthHeader() })
  return response.data || []
}

export async function obtenerCalificacionesEstudiante(estudiante_id) {
  const response = await axios.get(`${API_URL}/${estudiante_id}`, { headers: getAuthHeader() })
  return response.data || []
}

export async function crearEvaluacion(formData) {
  const response = await axios.post(API_URL, formData, { headers: getAuthHeader() })
  return response.data[0] || response.data
}

export async function actualizarEvaluacion(evaluacion_id, formData) {
  const payload = {
    ...formData,
    calificacion: formData.calificacion ?? formData.grade
  }
  const response = await axios.put(`${API_URL}/${evaluacion_id}`, payload, { headers: getAuthHeader() })
  return response.data[0] || response.data
}

export async function eliminarEvaluacion(evaluacion_id) {
  await axios.delete(`${API_URL}/${evaluacion_id}`, { headers: getAuthHeader() })
}

