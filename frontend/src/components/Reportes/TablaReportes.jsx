import React from 'react'
import * as excelService from '../../services/excel'

export default function TablaReportes({ reportes, onDescargar, onEliminar }) {
  const formatearFecha = (fecha) => {
    return new Date(fecha).toLocaleDateString('es-ES', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    })
  }

  const handleDescargarExcel = async (reporte) => {
    try {
      const datosExcel = {
        resultado_id: reporte.datos_json?.resultado_id,
        estudiante_id: reporte.datos_json?.estudiante_id,
        nombre_estudiante: reporte.titulo.split(' - ')[0] || 'Estudiante',
        nombre_resultado: reporte.titulo.split(' - ')[1] || 'Resultado'
      }
      
      await excelService.exportarReporteEvaluacionExcel(datosExcel)
      alert('✅ Archivo Excel descargado correctamente')
    } catch (err) {
      alert('Error al descargar Excel: ' + err.message)
    }
  }

  if (reportes.length === 0) {
    return (
      <div className="text-center text-neutral-500 py-8 bg-white rounded-lg shadow">
        <p className="text-lg">No hay reportes generados</p>
        <p className="text-sm mt-2">Genera tu primer reporte haciendo clic en el botón superior</p>
      </div>
    )
  }

  return (
    <div className="overflow-x-auto bg-white rounded-lg shadow">
      <table className="w-full">
        <thead>
          <tr className="bg-primary-brand text-white">
            <th className="px-6 py-3 text-left font-semibold">Título del Reporte</th>
            <th className="px-6 py-3 text-left font-semibold">Tipo</th>
            <th className="px-6 py-3 text-left font-semibold">Fecha Generación</th>
            <th className="px-6 py-3 text-center font-semibold">Calificación Final</th>
            <th className="px-6 py-3 text-center font-semibold">Acciones</th>
          </tr>
        </thead>
        <tbody>
          {reportes.map((reporte, index) => (
            <tr key={reporte.id} className={index % 2 === 0 ? 'bg-white' : 'bg-neutral-50'}>
              <td className="px-6 py-4 text-neutral-900 font-semibold">
                {reporte.titulo}
              </td>
              <td className="px-6 py-4">
                <span className="bg-secondary-100 text-secondary-700 px-3 py-1 rounded-full text-sm font-semibold capitalize">
                  {reporte.tipo}
                </span>
              </td>
              <td className="px-6 py-4 text-neutral-700">
                {formatearFecha(reporte.fecha_generacion)}
              </td>
              <td className="px-6 py-4 text-center">
                {reporte.datos_json?.promedio !== undefined ? (
                  <span className="text-lg font-bold text-primary-brand">
                    {reporte.datos_json.promedio}
                  </span>
                ) : (
                  <span className="text-neutral-500">N/A</span>
                )}
              </td>
              <td className="px-6 py-4 text-center space-x-2">
                <button
                  onClick={() => onDescargar(reporte)}
                  className="bg-success hover:bg-green-700 text-white px-3 py-1 rounded text-sm font-semibold transition"
                >
                  PDF
                </button>
                <button
                  onClick={() => handleDescargarExcel(reporte)}
                  className="bg-primary-brand hover:bg-primary-600 text-white px-3 py-1 rounded text-sm font-semibold transition"
                >
                  Excel
                </button>
                <button
                  onClick={() => onEliminar(reporte.id)}
                  className="bg-danger hover:bg-red-700 text-white px-3 py-1 rounded text-sm font-semibold transition"
                >
                  Eliminar
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
