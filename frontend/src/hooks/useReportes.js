import { useState } from "react"
import * as reportesService from "../services/reportes"

export function useReportes(docente_id) {
  const [reportes, setReportes] = useState([])
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)

  const obtenerReportes = async () => {
    if (!docente_id) return
    setCargando(true)
    try {
      const data = await reportesService.obtenerReportes(docente_id)
      setReportes(data)
      setError(null)
    } catch (err) {
      setError(err.message)
    } finally {
      setCargando(false)
    }
  }

  const generarReporteIndividual = async (formData) => {
    try {
      const nuevoReporte = await reportesService.generarReporteIndividual({
        ...formData,
        docente_id
      })
      setReportes([...reportes, nuevoReporte])
      return nuevoReporte
    } catch (err) {
      throw err
    }
  }

  const descargarPDF = (reporte) => {
    try {
      const link = document.createElement("a")
      link.href = reporte.pdf_url
      link.download = `${reporte.titulo}.pdf`
      link.click()
    } catch (err) {
      throw err
    }
  }

  const eliminarReporte = async (reporte_id) => {
    try {
      await reportesService.eliminarReporte(reporte_id)
      setReportes(reportes.filter(r => r.id !== reporte_id))
    } catch (err) {
      throw err
    }
  }

  return {
    reportes,
    cargando,
    error,
    generarReporteIndividual,
    descargarPDF,
    eliminarReporte,
    obtenerReportes
  }
}
