import axios from 'axios'

const API_URL = 'http://localhost:5000/api/re-evaluations'

function getAuthHeader() {
  const token = localStorage.getItem('acceso_token')
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function reevaluar(evaluation_id, datos) {
  const response = await axios.post(`${API_URL}/reevaluar/${evaluation_id}`, datos, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function obtenerHistorial(student_id, criteria_id) {
  const url = criteria_id
    ? `${API_URL}/historial/${student_id}/${criteria_id}`
    : `${API_URL}/historial/${student_id}`
  const response = await axios.get(url, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function crearReevaluacion(datos) {
  const response = await axios.post(`${API_URL}/crear`, datos, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function obtenerDisponiblesReevaluar() {
  const response = await axios.get(`${API_URL}/disponibles-reevaluar`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function obtenerReevaluacionesDocente(docente_id) {
  const response = await axios.get(`${API_URL}/${docente_id}`, {
    headers: getAuthHeader()
  })
  return response.data || []
}

export async function completarReevaluacion(re_eval_id, datos) {
  const response = await axios.put(`${API_URL}/${re_eval_id}/completar`, datos, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function compararEvaluaciones(evaluation_id) {
  const response = await axios.get(`${API_URL}/comparar/${evaluation_id}`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

