import axios from "axios"

const API_URL = "http://localhost:5000/api/roles"

function getAuthHeader() {
  const token = localStorage.getItem("acceso_token")
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function obtenerRoles() {
  const response = await axios.get(API_URL, {
    headers: getAuthHeader()
  })
  return response.data || []
}

export async function obtenerPermisosRol(role_id) {
  const response = await axios.get(`${API_URL}/${role_id}/permisos`, {
    headers: getAuthHeader()
  })
  return response.data || []
}
