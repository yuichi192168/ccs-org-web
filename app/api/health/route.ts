import { NextResponse } from 'next/server'
import { createAdminClient } from '@/lib/supabaseServer'

export const runtime = 'nodejs'

export async function GET() {
  try {
    console.log('Health check - Testing API connectivity')
    
    // Test environment variables
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
    const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY
    
    if (!supabaseUrl || !serviceKey) {
      return NextResponse.json({
        status: 'error',
        message: 'Missing environment variables',
        details: {
          hasSupabaseUrl: !!supabaseUrl,
          hasServiceKey: !!serviceKey
        }
      }, { status: 500 })
    }

    // Test Supabase connection
    const supabase = createAdminClient()
    
    // Simple test query
    const { data, error } = await supabase
      .from('users')
      .select('count')
      .limit(1)

    if (error) {
      console.error('Health check - Database error:', error)
      return NextResponse.json({
        status: 'error',
        message: 'Database connection failed',
        details: error
      }, { status: 500 })
    }

    console.log('Health check - Success')
    return NextResponse.json({
      status: 'success',
      message: 'API is healthy',
      timestamp: new Date().toISOString(),
      database: {
        connected: true,
        userCount: data?.length || 0
      }
    })

  } catch (error) {
    console.error('Health check - Unexpected error:', error)
    return NextResponse.json({
      status: 'error',
      message: 'Unexpected error',
      details: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 500 })
  }
}
