import axios from 'axios'

const API_URL = 'http://localhost:5000/api/auditoria'

function getAuthHeader() {
  const token = localStorage.getItem('acceso_token')
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function registrarAuditoria(datos) {
  const response = await axios.post(`${API_URL}/registrar`, datos, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function obtenerLogAuditoria(estudiante_id = null, limite = 100, fecha_desde = null, fecha_hasta = null) {
  let url = `${API_URL}/log?limite=${limite}`
  if (estudiante_id) url += `&student_id=${estudiante_id}`
  if (fecha_desde)   url += `&fecha_desde=${fecha_desde}`
  if (fecha_hasta)   url += `&fecha_hasta=${fecha_hasta}`

  const response = await axios.get(url, {
    headers: getAuthHeader()
  })
  return response.data || []
}

export async function obtenerResumenDocente(docente_id) {
  const response = await axios.get(`${API_URL}/resumen-docente/${docente_id}`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function ejecutarBackfill() {
  const response = await axios.post(`${API_URL}/backfill`, {}, {
    headers: getAuthHeader()
  })
  return response.data
}

