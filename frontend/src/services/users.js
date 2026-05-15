import axios from "axios"

const API_URL = "http://localhost:5000/api/usuarios"

function getAuthHeader() {
  const token = localStorage.getItem("acceso_token")
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function obtenerUsuarios() {
  const response = await axios.get(API_URL, {
    headers: getAuthHeader()
  })
  return response.data || []
}

export async function crearUsuario({ email, password, name, role }) {
  const response = await axios.post(API_URL, { email, password, name, role }, {
    headers: getAuthHeader()
  })
  return response.data
}

export async function editarUsuario(userId, { name, role }) {
  const response = await axios.put(`${API_URL}/${userId}`, { name, role }, {
    headers: getAuthHeader()
  })
  return response.data
}

export async function eliminarUsuario(userId) {
  const response = await axios.delete(`${API_URL}/${userId}`, {
    headers: getAuthHeader()
  })
  return response.data
}
