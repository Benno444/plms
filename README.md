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

### VS Code Setup

Das Projekt enthält optimierte VS Code-Einstellungen für eine bessere Entwicklererfahrung:

- Öffnen Sie `PLMS.code-workspace` für die beste Explorer-Organisation
- `node_modules` ist für eine saubere Seitenansicht ausgeblendet
- File Nesting ist aktiviert für verwandte Dateien
- Empfohlene Extensions werden automatisch vorgeschlagen

## 📁 Projektstruktur

```
PLMS/
├── .vscode/            # VS Code Workspace-Einstellungen
│   └── settings.json   # Explorer-Konfiguration
├── app/                # Next.js App Router
│   ├── globals.css     # Globale Styles
│   ├── layout.tsx      # Root Layout
│   ├── page.tsx        # Hauptseite
│   └── api/            # API-Routen
│       └── werkzeuge/  # Werkzeuge API
├── components/         # React Komponenten
│   ├── ToolCard.tsx    # Tool-Anzeige Komponente
│   └── WerkzeugeListe.tsx # Werkzeuge-Listen-Komponente
├── lib/                # Bibliotheken und Konfigurationen
│   ├── supabase.ts     # Supabase Client
│   ├── supabase-server.ts # Supabase Server
│   └── db/             # Datenbankschemas
├── types/              # TypeScript Typen
│   ├── database.types.ts # Datenbank-Typen
│   └── index.ts        # Tool- und User-Typen
├── utils/              # Utility-Funktionen
│   └── index.ts        # Formatierungs-Hilfsfunktionen
├── pages/              # Legacy Pages (falls benötigt)
├── public/             # Statische Assets
├── styles/             # Zusätzliche Styles
├── PLMS.code-workspace # VS Code Workspace-Konfiguration
└── README.md          # Projektdokumentation
```

## 🛠️ Technologie-Stack

- **Framework**: Next.js 14 mit App Router
- **Sprache**: TypeScript
- **Styling**: Tailwind CSS mit Porsche-Branding
- **UI**: React 18
- **Datenbank**: Supabase
- **IDE**: VS Code mit optimierten Einstellungen

## 💡 Entwicklungsumgebung

### VS Code-Features
- Automatische File Nesting für verwandte Dateien
- Optimierte Explorer-Sortierung
- Empfohlene Extensions (Tailwind CSS, TypeScript)
- Ausgeblendete `node_modules` für saubere Seitenansicht

### Empfohlene Extensions
- Tailwind CSS IntelliSense
- TypeScript und JavaScript Support

## 🏗️ Nächste Schritte

1. SQL-Datenbank Integration ✓
2. API-Routen für CRUD-Operationen ✓
3. Authentifizierung und Autorisierung
4. Tool-Verwaltungs-Interface
5. Reporting und Analytics

## 📝 Verfügbare Scripts

- `npm run dev` - Entwicklungsserver
- `npm run build` - Produktions-Build
- `npm run start` - Produktionsserver
- `npm run lint` - Code-Linting