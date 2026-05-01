import axios from "axios"

const API_URL = "http://localhost:5000/api/group-tracking"

function getAuthHeader() {
  const token = localStorage.getItem("acceso_token")
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function obtenerProgresoGrupo(group_name) {
  const response = await axios.get(`${API_URL}/grupo/${group_name}`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function obtenerCompetenciaGrupo(competency_id) {
  const response = await axios.get(`${API_URL}/competencia-grupo/${competency_id}`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function obtenerResumenGrupos() {
  const response = await axios.get(`${API_URL}/resumen`, {
    headers: getAuthHeader()
  })
  return response.data || {}
}

export async function obtenerResumenDocente(docente_id) {
  const response = await axios.get(`${API_URL}/resumen/${docente_id}`, {
    headers: getAuthHeader()
  })
  return response.data || []
}
