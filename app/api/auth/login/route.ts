import { NextRequest } from 'next/server'
import { getMockUserByEmail, getMockStudentProfile, getMockFacultyProfile, getMockAdminProfile } from '@/lib/mock-data'

export const runtime = 'nodejs'

const demoPasswordAliases: Record<'student' | 'faculty' | 'admin', string[]> = {
  student: ['student123', 'demo-student-password'],
  faculty: ['faculty123', 'demo-faculty-password'],
  admin: ['admin123', 'demo-admin-password'],
}

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

function isValidPassword(inputPassword: string, userRole: string) {
  return demoPasswordAliases[userRole as keyof typeof demoPasswordAliases]?.includes(inputPassword) || false
}

export async function POST(request: NextRequest) {
  const body = await request.json().catch(() => null)

  if (!body || typeof body !== 'object') {
    return apiError('Email and password are required.', 400)
  }

  const email = typeof body.email === 'string' ? body.email.trim().toLowerCase() : ''
  const password = typeof body.password === 'string' ? body.password : ''
  const role = typeof body.role === 'string' ? body.role.trim().toLowerCase() : ''

  if (!email || !password || !role) {
    return apiError('Email, password, and role are required.', 400)
  }

  try {
    // Find user in mock data
    const user = getMockUserByEmail(email)
    
    if (!user || !isValidPassword(password, role)) {
      return apiError('Invalid email or password.', 401)
    }

    // Check if role matches
    if (user.role !== role) {
      return apiError('Invalid role for this user.', 401)
    }

    let profile = null

    if (role === 'student') {
      profile = getMockStudentProfile(user.id)
    } else if (role === 'faculty') {
      profile = getMockFacultyProfile(user.id)
    } else if (role === 'admin') {
      profile = getMockAdminProfile(user.id)
    }

    return apiSuccess({
      user: user,
      profile: profile,
    })
  } catch (error) {
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}