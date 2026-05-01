import axios from 'axios'

const API_URL = 'http://localhost:5000/api/competencias'

const getToken = () => localStorage.getItem('acceso_token')

const competenciasService = {
  getAll: async () => {
    const response = await axios.get(API_URL, {
      headers: { Authorization: `Bearer ${getToken()}` }
    })
    return response.data
  },

  getById: async (id) => {
    const response = await axios.get(`${API_URL}/${id}`, {
      headers: { Authorization: `Bearer ${getToken()}` }
    })
    return response.data
  },

  create: async (competencia) => {
    const response = await axios.post(API_URL, competencia, {
      headers: { Authorization: `Bearer ${getToken()}` }
    })
    return response.data
  },

  update: async (id, competencia) => {
    const response = await axios.put(`${API_URL}/${id}`, competencia, {
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

export default competenciasService

