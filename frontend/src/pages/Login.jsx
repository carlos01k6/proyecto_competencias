import React, { useState } from "react"
import { useNavigate, Link } from "react-router-dom"
import axios from "axios"
import { LogIn } from "lucide-react"

export default function Login({ setUsuario }) {
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const [error, setError] = useState("")
  const [loading, setLoading] = useState(false)
  const navigate = useNavigate()

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError("")
    setLoading(true)

    try {
      const response = await axios.post("http://localhost:5000/api/auth/login", {
        email,
        password
      })

      localStorage.setItem("acceso_token", response.data.acceso_token)
      localStorage.setItem("usuario", JSON.stringify(response.data.usuario))
      setUsuario(response.data.usuario)

      navigate("/")
    } catch (err) {
      setError(err.response?.data?.mensaje || "Error al iniciar sesión")
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-950 via-neutral-900 to-neutral-950 flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        <div className="bg-gradient-to-br from-neutral-800/50 to-neutral-900/50 border border-neutral-700/50 rounded-2xl shadow-2xl p-8">
          {/* Header */}
          <div className="text-center mb-8">
            <div className="flex justify-center mb-4">
              <div className="p-3 bg-gradient-to-br from-primary-brand to-primary-600 rounded-lg">
                <LogIn className="w-6 h-6 text-white" />
              </div>
            </div>
            <h1 className="text-3xl font-bold text-white mb-2">Evaluación por Competencias</h1>
            <p className="text-neutral-400">Plataforma Automatizada</p>
          </div>

          {error && (
            <div className="bg-danger/10 border border-danger/30 text-danger px-4 py-3 rounded-lg mb-6">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-5">
            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Correo electrónico
              </label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
                placeholder="tu@correo.com"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-white mb-2">
                Contraseña
              </label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full bg-neutral-800/50 border border-neutral-700 text-white rounded-lg px-4 py-3 placeholder-neutral-500 focus:outline-none focus:border-primary-brand focus:ring-2 focus:ring-primary-brand/20 transition"
                placeholder="••••••••"
              />
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-gradient-to-r from-primary-brand to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white font-semibold py-3 rounded-lg transition disabled:opacity-50"
            >
              {loading ? "Iniciando sesión..." : "Iniciar sesión"}
            </button>
          </form>

          <div className="mt-6 text-center">
            <p className="text-neutral-400">¿No tienes cuenta?
              <Link to="/register" className="text-primary-brand font-semibold hover:underline ml-1">
                Crear una
              </Link>
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}

