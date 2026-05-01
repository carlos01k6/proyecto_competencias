import axios from "axios"

const API_URL = "http://localhost:5000/api/excel"

function getAuthHeader() {
  const token = localStorage.getItem("acceso_token")
  return {
    Authorization: `Bearer ${token}`
  }
}

export async function exportarReporteEvaluacionExcel(formData) {
  try {
    const response = await axios.post(`${API_URL}/reporte-evaluacion`, formData, {
      headers: getAuthHeader(),
      responseType: "blob"
    })
    
    // Crear URL de descarga
    const url = window.URL.createObjectURL(new Blob([response.data]))
    const link = document.createElement("a")
    link.href = url
    link.setAttribute("download", `Evaluacion_${formData.nombre_estudiante}_${new Date().toLocaleDateString()}.xlsx`)
    document.body.appendChild(link)
    link.click()
    link.parentElement.removeChild(link)
    return true
  } catch (err) {
    throw err
  }
}


