-- Script zum Hinzufügen von Passwort-Funktionalität für PLMS
-- Dieses Script kann nach dem Ausführen des schema_deutsch.sql verwendet werden

-- Aktiviert die pgcrypto Extension für Password-Hashing
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Erstelle eine sichere Funktion zur Passwort-Validierung
CREATE OR REPLACE FUNCTION verify_password(input_password TEXT, stored_hash TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    -- Überprüfe das Passwort mit der crypt-Funktion
    -- crypt(input_password, stored_hash) sollte gleich stored_hash sein
    RETURN stored_hash = crypt(input_password, stored_hash);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Gebe der Funktion die nötigen Berechtigungen für die Anwendung
-- (falls du RLS (Row Level Security) verwendest)
GRANT EXECUTE ON FUNCTION verify_password(TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION verify_password(TEXT, TEXT) TO anon;

-- Aktualisiere die bestehenden Benutzer mit gehashten Passwörtern
UPDATE benutzer SET password_hash = crypt('andreas2025!', gen_salt('bf')) WHERE name = 'Andreas';
UPDATE benutzer SET password_hash = crypt('benno2025!', gen_salt('bf')) WHERE name = 'Benno';
UPDATE benutzer SET password_hash = crypt('daniel2025!', gen_salt('bf')) WHERE name = 'Daniel';
UPDATE benutzer SET password_hash = crypt('lee2025!', gen_salt('bf')) WHERE name = 'Lee';
UPDATE benutzer SET password_hash = crypt('luis2025!', gen_salt('bf')) WHERE name = 'Rainer';

-- Neue Admin-Benutzer hinzufügen mit gehashten Passwörtern
INSERT INTO benutzer (name, email, password_hash, rolle, aktiv) VALUES 
('Luis', 'luis@porsche.de', crypt('luis2025!', gen_salt('bf')), 'admin', true);

-- Bestätigung der hinzugefügten/aktualisierten Benutzer
SELECT id, name, email, rolle, aktiv, erstellt_am 
FROM benutzer 
ORDER BY erstellt_am DESC;

-- Kommentare zur Nutzung:
-- 1. Dieses Script nach dem schema_deutsch.sql ausführen
-- 2. Die Passwörter werden mit bcrypt gehashed (sicher)
-- 3. Die verify_password-Funktion wird von der NextJS-Anwendung verwendet
-- 4. Beispiel-Aufruf in der Anwendung:
--    const { data } = await supabase.rpc('verify_password', { 
--      input_password: 'luis2025!', 
--      stored_hash: '$2b$12$...' 
--    })
-- 5. Test der Passwort-Validierung (optional):
--    SELECT verify_password('luis2025!', password_hash) FROM benutzer WHERE name = 'Luis';