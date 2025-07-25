import WerkzeugeListe from '@/components/WerkzeugeListe'

export default function Home() {
  return (
    <main className="container mx-auto px-4 py-8">
      <header className="text-center mb-8">
        <h1 className="text-4xl font-bold text-gray-900 mb-2">
          PLMS
        </h1>
        <p className="text-xl text-gray-600">
          Porsche Tool Management System
        </p>
      </header>
      
      {/* Dashboard Übersicht */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h2 className="text-xl font-semibold mb-3 text-porsche-red">Tools verwalten</h2>
          <p className="text-gray-600">
            Werkzeuge hinzufügen, bearbeiten und verfolgen
          </p>
        </div>
        
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h2 className="text-xl font-semibold mb-3 text-porsche-red">Inventar</h2>
          <p className="text-gray-600">
            Überblick über verfügbare Tools und deren Status
          </p>
        </div>
        
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h2 className="text-xl font-semibold mb-3 text-porsche-red">Berichte</h2>
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