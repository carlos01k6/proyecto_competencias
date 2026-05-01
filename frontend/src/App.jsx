import React, { useState, useEffect } from 'react'
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import Layout from './components/Comun/Layout'
import Login from './pages/Login'
import Register from './pages/Register'
import Dashboard from './pages/Dashboard'
import CompetenciasPage from './pages/CompetenciasPage'
import ActividadesPage from './pages/ActividadesPage'
import EvidenciasPage from './pages/EvidenciasPage'
import EvaluacionesPage from './pages/EvaluacionesPage'
import ReportesPage from './pages/ReportesPage'
import ReportesDirectorPage from './pages/ReportesDirectorPage'
import EvidenciasProyectoPage from './pages/EvidenciasProyectoPage'
import NivelesPage from './pages/NivelesPage'
import EscalasPage from './pages/EscalasPage'
import RetroalimentacionPage from './pages/RetroalimentacionPage'
import AuditoriaPage from './pages/AuditoriaPage'
import BoletinPage from './pages/BoletinPage'
import ImprovementPlansPage from './pages/ImprovementPlansPage'
import GroupTrackingPage from './pages/GroupTrackingPage'
import AcademicPeriodsPage from './pages/AcademicPeriodsPage'
import ReEvaluationsPage from './pages/ReEvaluationsPage'
import PlantillasPage from './pages/PlantillasPage'
import RubricasPage from './pages/RubricasPage'
import RubricasGlobalesPage from './pages/RubricasGlobalesPage'
import MisCursosPage from './pages/MisCursosPage'
import DetalleCursoPage from "./pages/DetalleCursoPage"
import ConfigPage from './pages/ConfigPage'
import ProgresosPage from './pages/ProgresosPage'
import EstudiantesPage from "./pages/EstudiantesPage"
import CriteriosPage from './pages/CriteriosPage'
import GestionarUsuariosPage from './pages/GestionarUsuariosPage'
import RolesPermisoPage from './pages/RolesPermisoPage'
import AsistenciaPage from './pages/AsistenciaPage'
import ExportarPage from './pages/ExportarPage'

function ProtectedRoute({ children }) {
  const token = localStorage.getItem('acceso_token')
  return token ? children : <Navigate to="/login" />
}

function App() {
  const [usuario, setUsuario] = useState(null)
  useEffect(() => {
    const usuarioGuardado = localStorage.getItem('usuario')
    if (usuarioGuardado) {
      setUsuario(JSON.parse(usuarioGuardado))
    }
  }, [])

  return (
    <div className="bg-neutral-50 min-h-screen">
      <Router>
        <Routes>
          <Route path="/login" element={<Login setUsuario={setUsuario} />} />
          <Route path="/register" element={<Register />} />
          <Route
            path="/*"
            element={
              <ProtectedRoute>
                <Layout usuario={usuario}>
                  <Routes>
                    <Route path="/" element={<Dashboard usuario={usuario} />} />
                    <Route path="/competencias" element={<CompetenciasPage usuario={usuario} />} />
                    <Route path="/actividades" element={<ActividadesPage usuario={usuario} />} />
                    <Route path="/evidencias-proyecto" element={<EvidenciasProyectoPage usuario={usuario} />} />
                    <Route path="/evidencias" element={<EvidenciasPage usuario={usuario} />} />
                    <Route path="/niveles" element={<NivelesPage usuario={usuario} />} />
                    <Route path="/retroalimentacion" element={<RetroalimentacionPage usuario={usuario} />} />
                    <Route path="/auditoria" element={<AuditoriaPage usuario={usuario} />} />
                    <Route path="/boletin" element={<BoletinPage usuario={usuario} />} />
                    <Route path="/improvement-plans" element={<ImprovementPlansPage usuario={usuario} />} />
                    <Route path="/group-tracking" element={<GroupTrackingPage usuario={usuario} />} />
                    <Route path="/grupo-seguimiento" element={<GroupTrackingPage usuario={usuario} />} />
                    <Route path="/academic-periods" element={<AcademicPeriodsPage usuario={usuario} />} />
                    <Route path="/re-evaluations" element={<ReEvaluationsPage usuario={usuario} />} />
                    <Route path="/plantillas" element={<PlantillasPage usuario={usuario} />} />
                    <Route path="/rubricas" element={<RubricasGlobalesPage usuario={usuario} />} />
                    <Route path="/mis-rubricas" element={<RubricasPage usuario={usuario} />} />
                    <Route path="/mis-cursos" element={<MisCursosPage usuario={usuario} />} />
                    <Route path="/curso/:cursoId" element={<DetalleCursoPage usuario={usuario} />} />
                    <Route path="/evaluacion" element={<EvaluacionesPage usuario={usuario} />} />
                    <Route path="/reportes-director" element={<ReportesDirectorPage usuario={usuario} />} />
                    <Route path="/progresos" element={<ProgresosPage usuario={usuario} />} />
                    <Route path="/reportes" element={<ReportesPage usuario={usuario} />} />
                    <Route path="/escalas" element={<EscalasPage usuario={usuario} />} />
                    <Route path="/config" element={<ConfigPage usuario={usuario} />} />
                    <Route path="/estudiantes" element={<EstudiantesPage usuario={usuario} />} />
                    <Route path="/criterios" element={<CriteriosPage usuario={usuario} />} />
                    <Route path="/users" element={<GestionarUsuariosPage usuario={usuario} />} />
                    <Route path="/roles" element={<RolesPermisoPage usuario={usuario} />} />
                    <Route path="/asistencia" element={<AsistenciaPage usuario={usuario} />} />
                    <Route path="/exportar" element={<ExportarPage usuario={usuario} />} />
                  </Routes>
                </Layout>
              </ProtectedRoute>
            }
          />
        </Routes>
      </Router>
    </div>
  )
}

export default App
