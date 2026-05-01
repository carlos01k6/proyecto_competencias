import axios from "axios"

const API_URL = "http://localhost:5000/api/retroalimentacion"

export async function obtenerTemplates() {
  const response = await axios.get(`${API_URL}/templates`)
  return response.data || {}
}

export async function obtenerFeedbackPersonalizado(calificacion) {
  const response = await axios.get(`${API_URL}/personalizado/${calificacion}`)
  return response.data || {}
}

export async function obtenerFeedbackPorCriterio(calificacion, criterioTipo) {
  const response = await axios.get(`${API_URL}/por-criterio/${calificacion}/${criterioTipo}`)
  return response.data || {}
}
