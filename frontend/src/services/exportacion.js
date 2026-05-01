import axios from "axios"

const API_URL = "http://localhost:5000/api/exportar"

function getAuthHeader() {
  const token = localStorage.getItem("acceso_token")
  return {
    Authorization: `Bearer ${token}`
  }
}

function crearParams({ tipo, periodo_id }) {
  const params = { tipo }
  if (periodo_id) params.periodo_id = periodo_id
  return params
}

function descargarBlob(blob, filename) {
  const url = window.URL.createObjectURL(blob)
  const link = document.createElement("a")
  link.href = url
  link.download = filename
  document.body.appendChild(link)
  link.click()
  link.remove()
  window.URL.revokeObjectURL(url)
}

export async function obtenerPreviewReporte(filtros) {
  const response = await axios.get(`${API_URL}/reportes/preview`, {
    headers: getAuthHeader(),
    params: crearParams(filtros)
  })
  return response.data || {}
}

export async function descargarReportePdf(filtros) {
  const response = await axios.get(`${API_URL}/reportes/pdf`, {
    headers: getAuthHeader(),
    params: crearParams(filtros),
    responseType: "blob"
  })
  descargarBlob(response.data, `reporte_${filtros.tipo || "competencia"}.pdf`)
}

export async function descargarReporteExcel(filtros) {
  const response = await axios.get(`${API_URL}/reportes/excel`, {
    headers: getAuthHeader(),
    params: crearParams(filtros),
    responseType: "blob"
  })
  descargarBlob(response.data, `reporte_${filtros.tipo || "competencia"}.xlsx`)
}

export async function descargarBoletinPdf(studentId) {
  const response = await axios.get(`${API_URL}/boletines/pdf/${studentId}`, {
    headers: getAuthHeader(),
    responseType: "blob"
  })
  descargarBlob(response.data, `boletin_${studentId}.pdf`)
}

export async function descargarBoletinExcel(studentId) {
  const response = await axios.get(`${API_URL}/boletines/excel/${studentId}`, {
    headers: getAuthHeader(),
    responseType: "blob"
  })
  descargarBlob(response.data, `boletin_${studentId}.xlsx`)
}
