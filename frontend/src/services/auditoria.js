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

export async function obtenerLogAuditoria(estudiante_id = null, limite = 100) {
  let url = `${API_URL}/log?limite=${limite}`
  if (estudiante_id) {
    url += `&estudiante_id=${estudiante_id}`
  }
  
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

