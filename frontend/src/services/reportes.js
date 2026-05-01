import axios from 'axios'

const API_URL = 'http://localhost:5000/api/reportes'

function getAuthHeader() {
  const token = localStorage.getItem('acceso_token')
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function generarReporteIndividual(formData) {
  const response = await axios.post(`${API_URL}/individual`, formData)
  return response.data
}

export async function obtenerReportes(docente_id) {
  const response = await axios.get(API_URL, {
    params: { docente_id }
  })
  return response.data || []
}

export async function eliminarReporte(reporte_id) {
  await axios.delete(`${API_URL}/${reporte_id}`)
}

export async function obtenerResumenCompetencias() {
  const response = await axios.get(`${API_URL}/director/competencias`, {
    headers: getAuthHeader()
  })
  return response.data || []
}

export async function exportarReporteEvaluacionExcel(formData) {
  const response = await axios.post(`${API_URL}/reporte-evaluacion`, formData, {
    headers: getAuthHeader(),
    responseType: 'blob'
  })
  return response.data
}

