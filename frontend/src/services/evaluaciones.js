import axios from "axios"

const API_URL = "http://localhost:5000/api/evaluaciones"

export async function obtenerEvaluacionesCriterio(criterio_id) {
  const response = await axios.get(`${API_URL}/criterio/${criterio_id}`)
  return response.data || []
}

export async function obtenerEvaluacionesEstudiante(estudiante_id, resultado_id) {
  const response = await axios.get(`${API_URL}/estudiante/${estudiante_id}/resultado/${resultado_id}`)
  return response.data || []
}

export async function obtenerCalificacionesEstudiante(estudiante_id) {
  const response = await axios.get(`${API_URL}/estudiante/${estudiante_id}`)
  return response.data || []
}

export async function crearEvaluacion(formData) {
  const response = await axios.post(API_URL, formData)
  return response.data[0] || response.data
}

export async function actualizarEvaluacion(evaluacion_id, formData) {
  const response = await axios.put(`${API_URL}/${evaluacion_id}`, formData)
  return response.data[0] || response.data
}

export async function eliminarEvaluacion(evaluacion_id) {
  await axios.delete(`${API_URL}/${evaluacion_id}`)
}

