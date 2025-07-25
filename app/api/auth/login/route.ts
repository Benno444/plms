import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase-server'
import jwt from 'jsonwebtoken'

export async function POST(request: NextRequest) {
  try {
    const { name, password } = await request.json()

    if (!name || !password) {
      return NextResponse.json(
        { error: 'Name und Passwort sind erforderlich' },
        { status: 400 }
      )
    }

    const supabase = createClient()

    // Benutzer aus der Datenbank holen
    const { data: benutzer, error: userError } = await supabase
      .from('benutzer')
      .select('id, name, password_hash, email, rolle, aktiv')
      .eq('name', name)
      .eq('aktiv', true)
      .single()

    if (userError || !benutzer) {
      return NextResponse.json(
        { error: 'Ungültige Anmeldedaten' },
        { status: 401 }
      )
    }

    // Passwort mit PostgreSQL verify_password Funktion überprüfen
    const { data: passwordValid, error: passwordError } = await supabase
      .rpc('verify_password', {
        input_password: password,
        stored_hash: benutzer.password_hash
      })

    if (passwordError || !passwordValid) {
      return NextResponse.json(
        { error: 'Ungültige Anmeldedaten' },
        { status: 401 }
      )
    }

    // JWT Token erstellen
    const token = jwt.sign(
      {
        userId: benutzer.id,
        name: benutzer.name,
        rolle: benutzer.rolle
      },
      process.env.NEXTAUTH_SECRET!,
      { expiresIn: '24h' }
    )

    // Erfolgreiche Anmeldung
    const response = NextResponse.json({
      success: true,
      benutzer: {
        id: benutzer.id,
        name: benutzer.name,
        email: benutzer.email,
        rolle: benutzer.rolle
      }
    })

    // JWT Token als HTTP-Only Cookie setzen
    response.cookies.set({
      name: 'auth-token',
      value: token,
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 60 * 60 * 24 // 24 Stunden
    })

    return response

  } catch (error) {
    console.error('Login-Fehler:', error)
    return NextResponse.json(
      { error: 'Interner Server-Fehler' },
      { status: 500 }
    )
  }
}