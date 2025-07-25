// Supabase Database Types für PLMS
export interface Database {
  public: {
    Tables: {
      werkzeuge: {
        Row: {
          id: string
          werkzeugnummer: string
          benennung: string
          werkzeugtyp_id: string | null
          publikationsstatus_id: string | null
          fahrzeugtyp_id: string | null
          baugruppe_id: string | null
          werkzeugkategorie_id: string | null
          lieferant_id: string | null
          risikostufe_id: string | null
          aktueller_status_id: string | null
          zugeordneter_benutzer_id: string | null
          anwendung: string | null
          bestellnummer: string | null
          laenge_mm: number | null
          breite_mm: number | null
          hoehe_mm: number | null
          hauptmaterial: string | null
          gu_relevanz: boolean
          mitnutzer: string | null
          bedarf_stueckzahl: number | null
          preisschaetzung_euro: number | null
          preis_serie_euro: number | null
          verkaufte_einheiten: number
          lagerbestand_sachsenheim: number
          erstellt_am: string
          aktualisiert_am: string
        }
        Insert: {
          id?: string
          werkzeugnummer: string
          benennung: string
          werkzeugtyp_id?: string | null
          publikationsstatus_id?: string | null
          fahrzeugtyp_id?: string | null
          baugruppe_id?: string | null
          werkzeugkategorie_id?: string | null
          lieferant_id?: string | null
          risikostufe_id?: string | null
          aktueller_status_id?: string | null
          zugeordneter_benutzer_id?: string | null
          anwendung?: string | null
          bestellnummer?: string | null
          laenge_mm?: number | null
          breite_mm?: number | null
          hoehe_mm?: number | null
          hauptmaterial?: string | null
          gu_relevanz?: boolean
          mitnutzer?: string | null
          bedarf_stueckzahl?: number | null
          preisschaetzung_euro?: number | null
          preis_serie_euro?: number | null
          verkaufte_einheiten?: number
          lagerbestand_sachsenheim?: number
          erstellt_am?: string
          aktualisiert_am?: string
        }
        Update: {
          id?: string
          werkzeugnummer?: string
          benennung?: string
          werkzeugtyp_id?: string | null
          publikationsstatus_id?: string | null
          fahrzeugtyp_id?: string | null
          baugruppe_id?: string | null
          werkzeugkategorie_id?: string | null
          lieferant_id?: string | null
          risikostufe_id?: string | null
          aktueller_status_id?: string | null
          zugeordneter_benutzer_id?: string | null
          anwendung?: string | null
          bestellnummer?: string | null
          laenge_mm?: number | null
          breite_mm?: number | null
          hoehe_mm?: number | null
          hauptmaterial?: string | null
          gu_relevanz?: boolean
          mitnutzer?: string | null
          bedarf_stueckzahl?: number | null
          preisschaetzung_euro?: number | null
          preis_serie_euro?: number | null
          verkaufte_einheiten?: number
          lagerbestand_sachsenheim?: number
          erstellt_am?: string
          aktualisiert_am?: string
        }
      }
      werkzeugtypen: {
        Row: {
          id: string
          name: string
          beschreibung: string | null
          erstellt_am: string
        }
        Insert: {
          id?: string
          name: string
          beschreibung?: string | null
          erstellt_am?: string
        }
        Update: {
          id?: string
          name?: string
          beschreibung?: string | null
          erstellt_am?: string
        }
      }
      aktueller_status: {
        Row: {
          id: string
          name: string
          beschreibung: string | null
          sortierung: number | null
          erstellt_am: string
        }
        Insert: {
          id?: string
          name: string
          beschreibung?: string | null
          sortierung?: number | null
          erstellt_am?: string
        }
        Update: {
          id?: string
          name?: string
          beschreibung?: string | null
          sortierung?: number | null
          erstellt_am?: string
        }
      }
      benutzer: {
        Row: {
          id: string
          name: string
          email: string | null
          rolle: string | null
          aktiv: boolean
          erstellt_am: string
        }
        Insert: {
          id?: string
          name: string
          email?: string | null
          rolle?: string | null
          aktiv?: boolean
          erstellt_am?: string
        }
        Update: {
          id?: string
          name?: string
          email?: string | null
          rolle?: string | null
          aktiv?: boolean
          erstellt_am?: string
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
  }
}