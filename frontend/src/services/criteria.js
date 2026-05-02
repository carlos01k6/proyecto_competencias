import axios from "axios"

const API_URL = "http://localhost:5000/api/criterios"

const getToken = () => localStorage.getItem("acceso_token")

const criteriosService = {
  getAll: async () => {
    const response = await axios.get(API_URL, {
      headers: { Authorization: `Bearer ${getToken()}` }
    })
    return response.data
  },
  getByResultado: async (resultado_id) => {
    const response = await axios.get(`${API_URL}/resultado/${resultado_id}`, {
      headers: { Authorization: `Bearer ${getToken()}` }
    })
    return response.data
  },
  create: async (criterio) => {
    const response = await axios.post(API_URL, criterio, {
      headers: { Authorization: `Bearer ${getToken()}` }
    })
    return response.data
  },
  update: async (id, criterio) => {
    const response = await axios.put(`${API_URL}/${id}`, criterio, {
      headers: { Authorization: `Bearer ${getToken()}` }
    })
    return response.data
  },
  delete: async (id) => {
    const response = await axios.delete(`${API_URL}/${id}`, {
      headers: { Authorization: `Bearer ${getToken()}` }
    })
    return response.data
  }
}

export default criteriosService
