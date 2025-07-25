-- PostgreSQL Datenbankschema für Werkzeugverwaltungssystem (PLMS)
-- Erstellt: 25. Juli 2025
-- 19 Tabellen insgesamt mit Haupttabelle 'werkzeuge' über UUID Fremdschlüssel verbunden
-- Verwendet UUID v4 für alle Primary Keys (global eindeutige IDs)
-- INKLUSIVE AUTHENTIFIZIERUNG mit sicheren gehashten Passwörtern

-- UUID und Crypto Extensions aktivieren
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================
-- AUTHENTIFIZIERUNGS-FUNKTIONEN
-- =============================================

-- Sichere Funktion zur Passwort-Validierung
CREATE OR REPLACE FUNCTION verify_password(input_password TEXT, stored_hash TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    -- Überprüfe das Passwort mit der crypt-Funktion
    -- crypt(input_password, stored_hash) sollte gleich stored_hash sein
    RETURN stored_hash = crypt(input_password, stored_hash);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Berechtigungen für die Funktion
GRANT EXECUTE ON FUNCTION verify_password(TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION verify_password(TEXT, TEXT) TO anon;

-- =============================================
-- REFERENZ-TABELLEN OHNE WERKZEUG-ABHÄNGIGKEITEN (14 Tabellen)
-- =============================================

-- 1. Werkzeugtypen
CREATE TABLE werkzeugtypen (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    beschreibung TEXT,
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Publikationsstatus
CREATE TABLE publikationsstatus (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL UNIQUE,
    beschreibung TEXT,
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Fahrzeugtypen (aus Prisma Fahrzeugdatenbank)
CREATE TABLE fahrzeugtypen (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bestelltyp VARCHAR(20) NOT NULL UNIQUE,
    beschreibung TEXT,
    markteinfuehrungstermin DATE,
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Baugruppen
CREATE TABLE baugruppen (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    beschreibung TEXT,
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Werkzeugkategorien
CREATE TABLE werkzeugkategorien (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100),
    beschreibung TEXT,
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Lieferanten
CREATE TABLE lieferanten (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    kontaktdaten TEXT,
    adresse TEXT,
    email VARCHAR(255),
    telefon VARCHAR(50),
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Risikostufen
CREATE TABLE risikostufen (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    stufe VARCHAR(20) NOT NULL UNIQUE,
    farbe VARCHAR(20) NOT NULL,
    beschreibung TEXT,
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. Technische Spezifikationen
CREATE TABLE technische_spezifikationen (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    beschreibung TEXT,
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Einheiten
CREATE TABLE einheiten (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    symbol VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    typ VARCHAR(50),
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10. Zeiteinheiten
CREATE TABLE zeiteinheiten (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(20) NOT NULL UNIQUE,
    beschreibung TEXT,
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11. Aktueller Status
CREATE TABLE aktueller_status (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    beschreibung TEXT,
    sortierung INTEGER,
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 12. KEFA Zuordnungen
CREATE TABLE kefa_zuordnungen (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL UNIQUE,
    beschreibung TEXT,
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 13. Benutzer (Bearbeiter)
CREATE TABLE benutzer (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    rolle VARCHAR(50),
    aktiv BOOLEAN DEFAULT TRUE,
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 14. Entwicklungsarten
CREATE TABLE entwicklungsarten (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL UNIQUE,
    beschreibung TEXT,
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- HAUPTTABELLE (1 Tabelle)
-- =============================================

-- 15. Werkzeuge (Haupttabelle)
CREATE TABLE werkzeuge (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Grundinformationen
    werkzeugnummer VARCHAR(100) NOT NULL UNIQUE,
    benennung VARCHAR(255) NOT NULL,
    werkzeugtyp_id UUID,
    publikationsstatus_id UUID,
    fahrzeugtyp_id UUID,
    baugruppe_id UUID,
    anwendung TEXT,
    werkzeugkategorie_id UUID,
    bestellnummer VARCHAR(100),
    lieferant_id UUID,
    
    -- Abmessungen
    laenge_mm DECIMAL(10,2),
    breite_mm DECIMAL(10,2),
    hoehe_mm DECIMAL(10,2),
    hauptmaterial VARCHAR(255),
    volumen_mm3 DECIMAL(15,2) GENERATED ALWAYS AS (laenge_mm * breite_mm * hoehe_mm) STORED,
    
    -- Risiko und Konformität
    gu_relevanz BOOLEAN DEFAULT FALSE,
    risikostufe_id UUID,
    
    -- Spezifikationen
    spezifikationsbedarf VARCHAR(20), -- 'ja', 'nein', 'evident'
    technische_spezifikation_id UUID,
    spezifikation_min DECIMAL(10,4),
    spezifikation_max DECIMAL(10,4),
    einheit_id UUID,
    bemerkung TEXT,
    
    -- Kalibrierung
    kalibrierungsbedarf BOOLEAN DEFAULT FALSE,
    kalibrierungsintervall INTEGER,
    zeiteinheit_id UUID,
    
    -- Status
    aktueller_status_id UUID,
    soll_status TEXT, -- Automatisch berechnet aus Prisma Daten
    mitnutzer TEXT,
    laendervarianten TEXT,
    plms_anforderungsnummer VARCHAR(100),
    plms_anforderungsdatum DATE,
    bedarf_stueckzahl INTEGER,
    kefa_zuordnung_id UUID,
    zugeordneter_benutzer_id UUID,
    nachfolger_verweis UUID,
    
    -- Entwicklungsbereich
    kontakt_entwicklungsdienstleister TEXT,
    kontakt_produktbeeinflusser TEXT,
    kontakt_entwickler TEXT,
    apos_nummer VARCHAR(100),
    bedienungsanleitung_vorhanden BOOLEAN DEFAULT FALSE,
    risikoanalyse_vorhanden BOOLEAN DEFAULT FALSE,
    technische_zeichnung_vorhanden BOOLEAN DEFAULT FALSE,
    entwicklungsart_id UUID,
    prototyp_vorhanden BOOLEAN DEFAULT FALSE,
    prototyp_zieltermin DATE,
    preisschaetzung_euro DECIMAL(12,2),
    
    -- Serienbereich
    erstmuster_vorhanden BOOLEAN DEFAULT FALSE,
    erstmuster_zieltermin DATE,
    erstmusterpruefung_io BOOLEAN DEFAULT FALSE,
    preis_serie_euro DECIMAL(12,2),
    geplanter_wareneingang DATE,
    serienausfallmuster_eingelagert BOOLEAN DEFAULT FALSE,
    verkaufte_einheiten INTEGER DEFAULT 0, -- Aus SAP PT1
    lagerbestand_sachsenheim INTEGER DEFAULT 0, -- Aus SAP PT1
    
    -- Zeitstempel
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    aktualisiert_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Fremdschlüssel-Beschränkungen
    FOREIGN KEY (werkzeugtyp_id) REFERENCES werkzeugtypen(id),
    FOREIGN KEY (publikationsstatus_id) REFERENCES publikationsstatus(id),
    FOREIGN KEY (fahrzeugtyp_id) REFERENCES fahrzeugtypen(id),
    FOREIGN KEY (baugruppe_id) REFERENCES baugruppen(id),
    FOREIGN KEY (werkzeugkategorie_id) REFERENCES werkzeugkategorien(id),
    FOREIGN KEY (lieferant_id) REFERENCES lieferanten(id),
    FOREIGN KEY (risikostufe_id) REFERENCES risikostufen(id),
    FOREIGN KEY (technische_spezifikation_id) REFERENCES technische_spezifikationen(id),
    FOREIGN KEY (einheit_id) REFERENCES einheiten(id),
    FOREIGN KEY (zeiteinheit_id) REFERENCES zeiteinheiten(id),
    FOREIGN KEY (aktueller_status_id) REFERENCES aktueller_status(id),
    FOREIGN KEY (kefa_zuordnung_id) REFERENCES kefa_zuordnungen(id),
    FOREIGN KEY (zugeordneter_benutzer_id) REFERENCES benutzer(id),
    FOREIGN KEY (entwicklungsart_id) REFERENCES entwicklungsarten(id),
    FOREIGN KEY (nachfolger_verweis) REFERENCES werkzeuge(id)
);

-- =============================================
-- TABELLEN DIE VON WERKZEUGEN ABHÄNGEN (4 Tabellen)
-- =============================================

-- 16. Produktkonformität
CREATE TABLE produktkonformitaet (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    werkzeug_id UUID,
    konformitaetstyp VARCHAR(100) NOT NULL,
    dateipfad VARCHAR(500),
    dateiname VARCHAR(255),
    upload_datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (werkzeug_id) REFERENCES werkzeuge(id) ON DELETE CASCADE
);

-- 17. Produktbilder
CREATE TABLE produktbilder (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    werkzeug_id UUID,
    dateipfad VARCHAR(500) NOT NULL,
    dateiname VARCHAR(255) NOT NULL,
    dateityp VARCHAR(10) NOT NULL,
    ist_katalogbild BOOLEAN DEFAULT FALSE,
    upload_datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (werkzeug_id) REFERENCES werkzeuge(id) ON DELETE CASCADE
);

-- 18. Entwicklungsdateien
CREATE TABLE entwicklungsdateien (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    werkzeug_id UUID,
    dateityp VARCHAR(50) NOT NULL,
    dateipfad VARCHAR(500) NOT NULL,
    dateiname VARCHAR(255) NOT NULL,
    beschreibung TEXT,
    upload_datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (werkzeug_id) REFERENCES werkzeuge(id) ON DELETE CASCADE
);

-- 19. Entwicklungsschleifen
CREATE TABLE entwicklungsschleifen (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    werkzeug_id UUID,
    schleifennummer INTEGER NOT NULL,
    beauftragungsdatei VARCHAR(500),
    testbilder TEXT,
    notizen TEXT,
    erstellt_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (werkzeug_id) REFERENCES werkzeuge(id) ON DELETE CASCADE
);

-- =============================================
-- TRIGGER FÜR AKTUALISIERT_AM
-- =============================================

CREATE OR REPLACE FUNCTION aktualisiere_aktualisiert_am_spalte()
RETURNS TRIGGER AS $$
BEGIN
    NEW.aktualisiert_am = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER aktualisiere_werkzeuge_aktualisiert_am BEFORE UPDATE ON werkzeuge
    FOR EACH ROW EXECUTE FUNCTION aktualisiere_aktualisiert_am_spalte();

-- =============================================
-- INITIAL-DATEN BEFÜLLUNG
-- =============================================

-- Werkzeugtypen
INSERT INTO werkzeugtypen (name) VALUES 
('Zubehör'),
('Ersatzteil'),
('Handelsübliches Werkzeug'),
('Porsche Spezialwerkzeug'),
('VW Spezialwerkzeug'),
('Werkstattausrüstung allgemein'),
('Werkstattausrüstung fahrzeugspezifisch');

-- Publikationsstatus
INSERT INTO publikationsstatus (name) VALUES 
('Entwicklung'),
('Freigabe'),
('Veröffentlichung'),
('Nicht mehr lieferbar'),
('Standby');

-- Baugruppen
INSERT INTO baugruppen (code, name) VALUES 
('0', 'Gesamtfahrzeug'),
('1', 'Motor'),
('2', 'Kraftstoff, Abgas, Motor-Elektrik'),
('3', 'Kraftübertragung'),
('4', 'Fahrwerk'),
('5', 'Karosserie'),
('6', 'Karosserie-Ausstattung außen'),
('7', 'Karosserie-Ausstattung innen'),
('8', 'Klimatisierung'),
('9', 'Elektrik');

-- Werkzeugkategorien
INSERT INTO werkzeugkategorien (code, name) VALUES 
('', 'Standard'),
('***', 'Spezial'),
('****', 'Kritisch'),
('HV', 'Hochvolt'),
('BP', 'Karosserieteile'),
('CLA', 'Klassifizierung A');

-- Risikostufen
INSERT INTO risikostufen (stufe, farbe) VALUES 
('grün', 'Grün'),
('gelb', 'Gelb'),
('rot', 'Rot');

-- Technische Spezifikationen
INSERT INTO technische_spezifikationen (name) VALUES 
('Drehmoment'),
('Druck'),
('Kraft (Zug-Druckkraft)'),
('Medienbeständigkeit'),
('Spannung'),
('Stromstärke'),
('Temperatur'),
('Tragfähigkeit'),
('Widerstand');

-- Einheiten
INSERT INTO einheiten (symbol, name, typ) VALUES 
('Nm', 'Newtonmeter', 'Drehmoment'),
('N', 'Newton', 'Kraft'),
('bar', 'Bar', 'Druck'),
('kg', 'Kilogramm', 'Masse'),
('V', 'Volt', 'Spannung'),
('A', 'Ampere', 'Stromstärke'),
('°C', 'Celsius', 'Temperatur'),
('Ohm', 'Ohm', 'Widerstand');

-- Zeiteinheiten
INSERT INTO zeiteinheiten (name) VALUES 
('Monate'),
('Jahre');

-- Aktueller Status
INSERT INTO aktueller_status (name, sortierung) VALUES 
('WA initiiert (Start)', 1),
('WA konstruiert', 2),
('Funktionsmuster bestellt', 3),
('Funktionsmuster vorhanden', 4),
('Funktionsmuster erprobt', 5),
('WA definiert, erprobt & freigegeben', 6),
('Angebote angefragt', 7),
('Lieferabruf erfolgt', 8),
('Rundschreiben erstellt', 9),
('Rundschreiben übersetzt', 10),
('WA für Märkte verfügbar', 11);

-- KEFA Zuordnungen
INSERT INTO kefa_zuordnungen (name) VALUES 
('Elektrik'),
('Fahrwerk'),
('Karosserie'),
('Antrieb');

-- Benutzer mit gehashten Passwörtern
INSERT INTO benutzer (name, email, password_hash, rolle, aktiv) VALUES 
('Andreas', 'andreas@porsche.de', crypt('andreas2025!', gen_salt('bf')), 'Benutzer', true),
('Benno', 'benno@porsche.de', crypt('benno2025!', gen_salt('bf')), 'Admin', true),
('Daniel', 'daniel@porsche.de', crypt('daniel2025!', gen_salt('bf')), 'Benutzer', true),
('Lee', 'lee@porsche.de', crypt('lee2025!', gen_salt('bf')), 'Benutzer', true),
('Rainer', 'rainer@porsche.de', crypt('rainer2025!', gen_salt('bf')), 'Benutzer', true),
('Luis', 'luis@porsche.de', crypt('luis2025!', gen_salt('bf')), 'Admin', true);

-- =============================================
-- INDIZES FÜR PERFORMANCE
-- =============================================

CREATE INDEX idx_werkzeuge_werkzeugnummer ON werkzeuge(werkzeugnummer);
CREATE INDEX idx_werkzeuge_benennung ON werkzeuge(benennung);
CREATE INDEX idx_werkzeuge_werkzeugtyp ON werkzeuge(werkzeugtyp_id);
CREATE INDEX idx_werkzeuge_status ON werkzeuge(aktueller_status_id);
CREATE INDEX idx_werkzeuge_lieferant ON werkzeuge(lieferant_id);
CREATE INDEX idx_werkzeuge_benutzer ON werkzeuge(zugeordneter_benutzer_id);
CREATE INDEX idx_produktbilder_werkzeug_id ON produktbilder(werkzeug_id);
CREATE INDEX idx_entwicklungsdateien_werkzeug_id ON entwicklungsdateien(werkzeug_id);
CREATE INDEX idx_entwicklungsschleifen_werkzeug_id ON entwicklungsschleifen(werkzeug_id);

-- =============================================
-- VIEWS FÜR HÄUFIGE ABFRAGEN
-- =============================================

-- Vollständige Werkzeuginformationen View
CREATE VIEW v_werkzeuge_vollstaendig AS
SELECT 
    w.*,
    wt.name as werkzeugtyp_name,
    ps.name as publikationsstatus_name,
    ft.bestelltyp as fahrzeugtyp,
    bg.name as baugruppe_name,
    wk.name as werkzeugkategorie_name,
    l.name as lieferant_name,
    rs.stufe as risikostufe,
    ts.name as technische_spezifikation_name,
    e.symbol as einheit_symbol,
    ze.name as zeiteinheit_name,
    ast.name as aktueller_status_name,
    kz.name as kefa_zuordnung_name,
    b.name as zugeordneter_benutzer_name,
    ea.name as entwicklungsart_name
FROM werkzeuge w
LEFT JOIN werkzeugtypen wt ON w.werkzeugtyp_id = wt.id
LEFT JOIN publikationsstatus ps ON w.publikationsstatus_id = ps.id
LEFT JOIN fahrzeugtypen ft ON w.fahrzeugtyp_id = ft.id
LEFT JOIN baugruppen bg ON w.baugruppe_id = bg.id
LEFT JOIN werkzeugkategorien wk ON w.werkzeugkategorie_id = wk.id
LEFT JOIN lieferanten l ON w.lieferant_id = l.id
LEFT JOIN risikostufen rs ON w.risikostufe_id = rs.id
LEFT JOIN technische_spezifikationen ts ON w.technische_spezifikation_id = ts.id
LEFT JOIN einheiten e ON w.einheit_id = e.id
LEFT JOIN zeiteinheiten ze ON w.zeiteinheit_id = ze.id
LEFT JOIN aktueller_status ast ON w.aktueller_status_id = ast.id
LEFT JOIN kefa_zuordnungen kz ON w.kefa_zuordnung_id = kz.id
LEFT JOIN benutzer b ON w.zugeordneter_benutzer_id = b.id
LEFT JOIN entwicklungsarten ea ON w.entwicklungsart_id = ea.id;

-- Werkzeuge mit Bildanzahl
CREATE VIEW v_werkzeuge_mit_bildern AS
SELECT 
    w.id,
    w.werkzeugnummer,
    w.benennung,
    COUNT(pb.id) as bildanzahl,
    COUNT(CASE WHEN pb.ist_katalogbild THEN 1 END) as katalogbild_anzahl
FROM werkzeuge w
LEFT JOIN produktbilder pb ON w.id = pb.werkzeug_id
GROUP BY w.id, w.werkzeugnummer, w.benennung;

-- =============================================
-- KOMMENTARE
-- =============================================

COMMENT ON TABLE werkzeuge IS 'Haupttabelle mit allen Werkzeuginformationen';
COMMENT ON COLUMN werkzeuge.volumen_mm3 IS 'Automatisch berechnet aus Länge × Breite × Höhe';
COMMENT ON COLUMN werkzeuge.verkaufte_einheiten IS 'Daten aus SAP PT1 Schnittstelle';
COMMENT ON COLUMN werkzeuge.lagerbestand_sachsenheim IS 'Lagerbestandsdaten aus SAP PT1 Schnittstelle';
COMMENT ON TABLE fahrzeugtypen IS 'Fahrzeugdaten aus Prisma Fahrzeugdatenbank';
COMMENT ON TABLE produktkonformitaet IS 'CE-Konformität, ElektroG, RoHS Dokumentation';
COMMENT ON TABLE entwicklungsdateien IS 'Speichert 3D-Daten (.step), Dokumentation (.pdf, .xlsm)';

-- =============================================
-- AUTHENTIFIZIERUNGS-KOMMENTARE
-- =============================================

COMMENT ON FUNCTION verify_password(TEXT, TEXT) IS 'Sichere Passwort-Validierung mit bcrypt - wird von der NextJS-Anwendung verwendet';
COMMENT ON COLUMN benutzer.password_hash IS 'Bcrypt-gehashtes Passwort - alle Testbenutzer haben das Passwort "luis2025!"';

-- =============================================
-- SETUP-BESTÄTIGUNG
-- =============================================

-- Zeige alle erstellten Benutzer zur Bestätigung
SELECT 'SETUP COMPLETE - Benutzer erstellt:' as status;
SELECT id, name, email, rolle, aktiv, erstellt_am 
FROM benutzer 
ORDER BY erstellt_am DESC;