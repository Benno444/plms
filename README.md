# PLMS - Porsche Tool Management System

Ein modernes Tool Management System für Porsche, entwickelt mit Next.js und TypeScript.

## 🚀 Erste Schritte

### Installation

1. Dependencies installieren:
```bash
npm install
```

2. Entwicklungsserver starten:
```bash
npm run dev
```

3. Browser öffnen: [http://localhost:3000](http://localhost:3000)

## 📁 Projektstruktur

```
PLMS/
├── app/                 # Next.js App Router
│   ├── globals.css     # Globale Styles
│   ├── layout.tsx      # Root Layout
│   └── page.tsx        # Hauptseite
├── components/         # React Komponenten
│   └── ToolCard.tsx    # Tool-Anzeige Komponente
├── types/              # TypeScript Typen
│   └── index.ts        # Tool- und User-Typen
├── utils/              # Utility-Funktionen
│   └── index.ts        # Formatierungs-Hilfsfunktionen
├── lib/                # Bibliotheken und Konfigurationen
├── pages/              # Legacy Pages (falls benötigt)
├── public/             # Statische Assets
└── styles/             # Zusätzliche Styles
```

## 🛠️ Technologie-Stack

- **Framework**: Next.js 14 mit App Router
- **Sprache**: TypeScript
- **Styling**: Tailwind CSS mit Porsche-Branding
- **UI**: React 18

## 🏗️ Nächste Schritte

1. SQL-Datenbank Integration
2. API-Routen für CRUD-Operationen
3. Authentifizierung und Autorisierung
4. Tool-Verwaltungs-Interface
5. Reporting und Analytics

## 📝 Verfügbare Scripts

- `npm run dev` - Entwicklungsserver
- `npm run build` - Produktions-Build
- `npm run start` - Produktionsserver
- `npm run lint` - Code-Linting