import React, { useState } from "react"
import { useNavigate, Link } from "react-router-dom"
import axios from "axios"
import { UserPlus } from "lucide-react"

const API_URL = "http://localhost:5000/api/auth"

export default function Register() {
  const navigate = useNavigate()
  const [formData, setFormData] = useState({
    nombre: "",
    email: "",
    password: "",
    confirmPassword: ""
  })
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState("")

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData({
      ...formData,
      [name]: value
    })
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError("")

    if (!formData.nombre || !formData.email || !formData.password) {
      setError("Completa todos los campos")
      return
    }

    if (formData.password !== formData.confirmPassword) {
      setError("Las contraseñas no coinciden")
      return
    }

    if (formData.password.length < 8) {
      setError("La contraseña debe tener al menos 8 caracteres")
      return
    }

    setCargando(true)
    try {
      const response = await axios.post(`${API_URL}/signup`, {
        nombre: formData.nombre,
        email: formData.email,
        password: formData.password
      })

      alert("✅ Registro exitoso. Ahora inicia sesión.")
      navigate("/login")
    } catch (err) {
      setError(err.response?.data?.mensaje || "Error en el registro")
    } finally {
      setCargando(false)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 flex items-center justify-center p-4">
      <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl shadow-2xl p-8 w-full max-w-md">
        {/* Header */}
        <div className="text-center mb-8">
          <div className="flex justify-center mb-4">
            <div className="p-3 bg-gradient-to-br from-primary-brand to-primary-600 rounded-lg">
              <UserPlus className="w-6 h-6 text-white" />
            </div>
          </div>
          <h1 className="text-3xl font-bold text-white">Registro</h1>
          <p className="text-neutral-400 mt-2">Crea tu cuenta como estudiante</p>
        </div>

        {error && (
          <div className="bg-danger/10 border border-danger/30 text-danger px-4 py-3 rounded-lg mb-6">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-5">
          <div>
            <label className="block text-sm font-semibold text-white mb-2">
              Nombre Completo
            </label>
            <input
              type="text"
              name="nombre"
              value={formData.nombre}
              onChange={handleChange}
              placeholder="Juan Pérez"
              disabled={cargando}
              className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-white mb-2">
              Correo Electrónico
            </label>
            <input
              type="email"
              name="email"
              value={formData.email}
              onChange={handleChange}
              placeholder="correo@ejemplo.com"
              disabled={cargando}
              className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-white mb-2">
              Contraseña
            </label>
            <input
              type="password"
              name="password"
              value={formData.password}
              onChange={handleChange}
              placeholder="••••••••"
              disabled={cargando}
              className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-white mb-2">
              Confirmar Contraseña
            </label>
            <input
              type="password"
              name="confirmPassword"
              value={formData.confirmPassword}
              onChange={handleChange}
              placeholder="••••••••"
              disabled={cargando}
              className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition disabled:opacity-50"
            />
          </div>

          <button
            type="submit"
            disabled={cargando}
            className="w-full bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white py-3 rounded-lg font-semibold transition disabled:opacity-50"
          >
            {cargando ? "Registrando..." : "Registrarse"}
          </button>
        </form>

        <div className="mt-6 text-center">
          <p className="text-neutral-400">
            ¿Ya tienes cuenta?{" "}
            <Link to="/login" className="text-primary-brand font-semibold hover:underline">
              Inicia sesión
            </Link>
          </p>
        </div>
      </div>
    </div>
  )
}
