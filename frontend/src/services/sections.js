import axios from "axios"

const API = "http://localhost:5000/api/secciones"

function auth() {
  const t = localStorage.getItem("acceso_token")
  return t ? { Authorization: `Bearer ${t}` } : {}
}

export const listarSecciones = () =>
  axios.get(API, { headers: auth() }).then(r => r.data || [])

export const crearSeccion = (data) =>
  axios.post(API, data, { headers: auth() }).then(r => r.data)

export const editarSeccion = (id, data) =>
  axios.put(`${API}/${id}`, data, { headers: auth() }).then(r => r.data)

export const eliminarSeccion = (id) =>
  axios.delete(`${API}/${id}`, { headers: auth() }).then(r => r.data)

export const obtenerEstudiantes = (id) =>
  axios.get(`${API}/${id}/estudiantes`, { headers: auth() }).then(r => r.data || [])

export const inscribirEstudiante = (id, student_id) =>
  axios.post(`${API}/${id}/estudiantes`, { student_id }, { headers: auth() }).then(r => r.data)

export const desinscribirEstudiante = (id, student_id) =>
  axios.delete(`${API}/${id}/estudiantes/${student_id}`, { headers: auth() }).then(r => r.data)

export const obtenerDocentes = (id) =>
  axios.get(`${API}/${id}/docentes`, { headers: auth() }).then(r => r.data || [])

export const asignarDocente = (id, teacher_id) =>
  axios.post(`${API}/${id}/docentes`, { teacher_id }, { headers: auth() }).then(r => r.data)

export const desasignarDocente = (id, teacher_id) =>
  axios.delete(`${API}/${id}/docentes/${teacher_id}`, { headers: auth() }).then(r => r.data)
