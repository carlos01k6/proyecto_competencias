import React, { useState, useEffect } from 'react'
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import Layout from './components/Common/Layout'
import Login from './pages/Login'
import Register from './pages/Register'
import Dashboard from './pages/Dashboard'
import CompetenciasPage from './pages/CompetenciesPage'
import ActividadesPage from './pages/ActivitiesPage'
import EvidenciasPage from './pages/EvidencePage'
import EvaluacionesPage from './pages/EvaluationsPage'
import ReportesPage from './pages/ReportsPage'
import ReportesDirectorPage from './pages/DirectorReportsPage'
import EvidenciasProyectoPage from './pages/ProjectEvidencePage'
import NivelesPage from './pages/LevelsPage'
import EscalasPage from './pages/ScalesPage'
import RetroalimentacionPage from './pages/FeedbackPage'
import AuditoriaPage from './pages/AuditPage'
import BoletinPage from './pages/BulletinPage'
import ImprovementPlansPage from './pages/ImprovementPlansPage'
import GroupTrackingPage from './pages/GroupTrackingPage'
import AcademicPeriodsPage from './pages/AcademicPeriodsPage'
import ReEvaluationsPage from './pages/ReEvaluationsPage'
import PlantillasPage from './pages/TemplatesPage'
import RubricasPage from './pages/RubricsPage'
import RubricasGlobalesPage from './pages/GlobalRubricsPage'
import MisCursosPage from './pages/MyCoursesPage'
import DetalleCursoPage from "./pages/CourseDetailPage"
import ConfigPage from './pages/ConfigPage'
import ProgresosPage from './pages/ProgressesPage'
import EstudiantesPage from "./pages/StudentsPage"
import CriteriosPage from './pages/CriteriaPage'
import GestionarUsuariosPage from './pages/UserManagementPage'
import RolesPermisoPage from './pages/RolePermissionsPage'
import AsistenciaPage from './pages/AttendancePage'
import ExportarPage from './pages/ExportPage'

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
