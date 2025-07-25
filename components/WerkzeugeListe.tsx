'use client'

import { useState, useEffect } from 'react'
import { supabase } from '@/lib/supabase'
import { Database } from '@/types/database.types'

type Werkzeug = Database['public']['Tables']['werkzeuge']['Row'] & {
  werkzeugtypen?: { name: string } | null
  aktueller_status?: { name: string } | null
  benutzer?: { name: string } | null
}

export default function WerkzeugeListe() {
  const [werkzeuge, setWerkzeuge] = useState<Werkzeug[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    loadWerkzeuge()
  }, [])

  const loadWerkzeuge = async () => {
    try {
      setLoading(true)
      const { data, error } = await supabase
        .from('werkzeuge')
        .select(`
          *,
          werkzeugtypen(name),
          aktueller_status(name),
          benutzer(name)
        `)
        .limit(20)
        .order('aktualisiert_am', { ascending: false })

      if (error) throw error

      setWerkzeuge(data || [])
    } catch (error) {
      console.error('Fehler beim Laden der Werkzeuge:', error)
      setError('Fehler beim Laden der Werkzeuge')
    } finally {
      setLoading(false)
    }
  }

  const getStatusColor = (status: string | null) => {
    if (!status) return 'bg-gray-100 text-gray-800'
    
    switch (status.toLowerCase()) {
      case 'verfügbar':
      case 'available':
        return 'bg-green-100 text-green-800'
      case 'in verwendung':
      case 'in_use':
        return 'bg-blue-100 text-blue-800'
      case 'wartung':
      case 'maintenance':
        return 'bg-yellow-100 text-yellow-800'
      case 'ausgemustert':
      case 'retired':
        return 'bg-red-100 text-red-800'
      default:
        return 'bg-gray-100 text-gray-800'
    }
  }

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-porsche-red"></div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="bg-red-50 border border-red-200 rounded-lg p-4 text-red-700">
        {error}
      </div>
    )
  }

  return (
    <div className="space-y-4">
      <div className="flex justify-between items-center">
        <h2 className="text-2xl font-bold text-gray-900">
          Werkzeuge ({werkzeuge.length})
        </h2>
        <button 
          onClick={loadWerkzeuge}
          className="bg-porsche-red text-white px-4 py-2 rounded-lg hover:bg-red-700 transition-colors"
        >
          Aktualisieren
        </button>
      </div>

      {werkzeuge.length === 0 ? (
        <div className="text-center py-8 text-gray-500">
          Keine Werkzeuge gefunden. Möglicherweise ist die Datenbank noch nicht eingerichtet.
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {werkzeuge.map((werkzeug) => (
            <div key={werkzeug.id} className="bg-white p-4 rounded-lg shadow-md border hover:shadow-lg transition-shadow">
              <div className="flex justify-between items-start mb-2">
                <h3 className="text-lg font-semibold text-gray-900 truncate">
                  {werkzeug.benennung}
                </h3>
                <span className={`px-2 py-1 rounded-full text-xs font-medium ${getStatusColor(werkzeug.aktueller_status?.name || null)}`}>
                  {werkzeug.aktueller_status?.name || 'Unbekannt'}
                </span>
              </div>
              
              <div className="text-sm text-gray-600 space-y-1">
                <p><strong>Werkzeugnummer:</strong> {werkzeug.werkzeugnummer}</p>
                {werkzeug.werkzeugtypen?.name && (
                  <p><strong>Typ:</strong> {werkzeug.werkzeugtypen.name}</p>
                )}
                {werkzeug.benutzer?.name && (
                  <p><strong>Zugewiesen an:</strong> {werkzeug.benutzer.name}</p>
                )}
                {werkzeug.anwendung && (
                  <p><strong>Anwendung:</strong> {werkzeug.anwendung}</p>
                )}
                <p><strong>Lagerbestand:</strong> {werkzeug.lagerbestand_sachsenheim}</p>
              </div>
              
              <div className="mt-3 pt-3 border-t border-gray-200 text-xs text-gray-400">
                Aktualisiert: {new Date(werkzeug.aktualisiert_am).toLocaleDateString('de-DE')}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}