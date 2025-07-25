'use client'

import { useState, useEffect } from 'react'
import WerkzeugeListe from '@/components/WerkzeugeListe'
import LoginForm from '@/components/LoginForm'

interface User {
  id: string
  name: string
  email?: string
  rolle: string
}

export default function Home() {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)
  const [showLogin, setShowLogin] = useState(false)

  // Prüfe beim Laden, ob Benutzer bereits angemeldet ist
  useEffect(() => {
    checkAuthStatus()
  }, [])

  const checkAuthStatus = async () => {
    try {
      const response = await fetch('/api/auth/me')
      if (response.ok) {
        const data = await response.json()
        if (data.authenticated) {
          setUser(data.benutzer)
        }
      }
    } catch (error) {
      console.log('Auth check failed:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleLogin = (success: boolean, userData?: User) => {
    if (success && userData) {
      setUser(userData)
      setShowLogin(false)
    }
  }

  const handleLogout = async () => {
    try {
      await fetch('/api/auth/logout', { method: 'POST' })
      setUser(null)
    } catch (error) {
      console.error('Logout failed:', error)
    }
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-xl">Lade...</div>
      </div>
    )
  }

  if (showLogin || !user) {
    return <LoginForm onLogin={handleLogin} />
  }

  return (
    <main className="container mx-auto px-4 py-8">
      <header className="text-center mb-8">
        <div className="flex justify-between items-center mb-4">
          <div></div>
          <div>
            <h1 className="text-4xl font-bold text-gray-900 mb-2">
              PLMS
            </h1>
            <p className="text-xl text-gray-600">
              Porsche Tool Management System
            </p>
          </div>
          <div className="text-right">
            <p className="text-sm text-gray-600 mb-2">
              Angemeldet als: <strong>{user.name}</strong>
            </p>
            <button
              onClick={handleLogout}
              className="px-4 py-2 text-sm bg-red-600 text-white rounded hover:bg-red-700"
            >
              Abmelden
            </button>
          </div>
        </div>
      </header>
      
      {/* Dashboard Übersicht */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h2 className="text-xl font-semibold mb-3 text-red-600">Tools verwalten</h2>
          <p className="text-gray-600">
            Werkzeuge hinzufügen, bearbeiten und verfolgen
          </p>
        </div>
        
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h2 className="text-xl font-semibold mb-3 text-red-600">Inventar</h2>
          <p className="text-gray-600">
            Überblick über verfügbare Tools und deren Status
          </p>
        </div>
        
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h2 className="text-xl font-semibold mb-3 text-red-600">Berichte</h2>
          <p className="text-gray-600">
            Auslastung und Performance-Kennzahlen
          </p>
        </div>
      </div>

      {/* Werkzeuge Liste */}
      <WerkzeugeListe />
    </main>
  )
}