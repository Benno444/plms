import { createClient } from '@/lib/supabase-server'
import { NextRequest, NextResponse } from 'next/server'

export async function GET(request: NextRequest) {
  const supabase = createClient()
  const { searchParams } = new URL(request.url)
  const limit = searchParams.get('limit') || '50'
  const offset = searchParams.get('offset') || '0'

  try {
    const { data: werkzeuge, error } = await supabase
      .from('werkzeuge')
      .select(`
        *,
        werkzeugtypen(name),
        aktueller_status(name),
        benutzer(name)
      `)
      .range(parseInt(offset), parseInt(offset) + parseInt(limit) - 1)
      .order('aktualisiert_am', { ascending: false })

    if (error) {
      console.error('Supabase error:', error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    return NextResponse.json({ 
      werkzeuge,
      total: werkzeuge?.length || 0 
    })
  } catch (error) {
    console.error('API error:', error)
    return NextResponse.json(
      { error: 'Fehler beim Laden der Werkzeuge' },
      { status: 500 }
    )
  }
}

export async function POST(request: NextRequest) {
  const supabase = createClient()
  
  try {
    const body = await request.json()
    
    const { data: werkzeug, error } = await supabase
      .from('werkzeuge')
      .insert([body])
      .select()
      .single()

    if (error) {
      console.error('Supabase error:', error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    return NextResponse.json(werkzeug, { status: 201 })
  } catch (error) {
    console.error('API error:', error)
    return NextResponse.json(
      { error: 'Fehler beim Erstellen des Werkzeugs' },
      { status: 500 }
    )
  }
}