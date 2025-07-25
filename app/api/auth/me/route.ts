import { NextRequest, NextResponse } from 'next/server'
import jwt from 'jsonwebtoken'

export async function GET(request: NextRequest) {
  try {
    // Token aus Cookie holen
    const token = request.cookies.get('auth-token')?.value

    if (!token) {
      return NextResponse.json(
        { authenticated: false },
        { status: 401 }
      )
    }

    // Token verifizieren
    const decoded = jwt.verify(token, process.env.NEXTAUTH_SECRET!) as any

    return NextResponse.json({
      authenticated: true,
      benutzer: {
        id: decoded.userId,
        name: decoded.name,
        rolle: decoded.rolle
      }
    })

  } catch (error) {
    console.error('Token-Verifikation fehlgeschlagen:', error)
    return NextResponse.json(
      { authenticated: false },
      { status: 401 }
    )
  }
}