import { NextRequest } from 'next/server'
import { createServiceClient } from '@/lib/supabaseClient'

export const runtime = 'nodejs'

const supabase = createServiceClient()

function apiError(message: string, status: number, details?: Record<string, unknown>) {
  return Response.json(
    {
      success: false,
      message,
      ...(details ? { details } : {}),
    },
    { status }
  )
}

function apiSuccess(data: unknown, status = 200) {
  return Response.json(
    {
      success: true,
      data,
    },
    { status }
  )
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()

    if (!body || typeof body !== 'object') {
      return apiError('Email and password are required.', 400)
    }

    const { email, password, role } = body

    if (!email || !password || !role) {
      return apiError('Email, password, and role are required.', 400)
    }

    // Authenticate with Supabase
    const { data: authData, error: authError } = await supabase.auth.signInWithPassword({
      email: email.toLowerCase(),
      password,
    })

    if (authError) {
      return apiError('Invalid email or password.', 401, { details: authError })
    }

    if (!authData.user) {
      return apiError('Authentication failed.', 401)
    }

    // Get user profile based on role
    let profile = null
    const userId = authData.user.id

    if (role === 'student') {
      const { data: studentProfile } = await supabase
        .from('student_profiles')
        .select('*')
        .eq('user_id', userId)
        .single()
      profile = studentProfile
    } else if (role === 'faculty') {
      const { data: facultyProfile } = await supabase
        .from('faculty_profiles')
        .select('*')
        .eq('user_id', userId)
        .single()
      profile = facultyProfile
    } else if (role === 'admin') {
      const { data: adminProfile } = await supabase
        .from('admin_profiles')
        .select('*')
        .eq('user_id', userId)
        .single()
      profile = adminProfile
    }

    return apiSuccess({
      user: {
        id: authData.user.id,
        email: authData.user.email!,
        name: authData.user.user_metadata?.name || authData.user.email!.split('@')[0],
        role: role as 'student' | 'faculty' | 'admin',
        systemId: authData.user.user_metadata?.system_id || `SYS-${role.toUpperCase()}-${authData.user.id?.slice(-6)}`,
        status: 'active',
        joinedAt: authData.user.created_at,
        lastLoginAt: new Date().toISOString(),
        createdAt: authData.user.created_at,
        updatedAt: authData.user.updated_at,
      },
      profile,
    })
  } catch (error) {
    return apiError(error instanceof Error ? error.message : 'Authentication failed', 500)
  }
}