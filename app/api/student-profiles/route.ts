import { NextRequest, NextResponse } from 'next/server'
import { createAdminClient } from '@/lib/supabaseServer'

export const runtime = 'nodejs'

function apiError(message: string, status: number, details?: Record<string, unknown>) {
  console.error('API Error:', { message, status, details })
  return NextResponse.json(
    {
      success: false,
      message,
      ...(details ? { details } : {}),
    },
    { status, headers: { 'Content-Type': 'application/json' } }
  )
}

function apiSuccess(data: unknown, status = 200) {
  return NextResponse.json(
    {
      success: true,
      data,
    },
    { status, headers: { 'Content-Type': 'application/json' } }
  )
}

export async function GET(request: NextRequest) {
  try {
    console.log('GET /api/student-profiles - Request received')
    
    const { searchParams } = new URL(request.url)
    const limit = parseInt(searchParams.get('limit') || '25')
    const page = parseInt(searchParams.get('page') || '1')
    const sort = searchParams.get('sort') || 'student_number'
    const order = searchParams.get('order') || 'asc'
    const search = searchParams.get('search')?.toLowerCase()

    console.log('Query params:', { limit, page, sort, order, search })

    const supabase = createAdminClient() as any

    // Build query with server-side pagination and sorting
    let query = supabase
      .from('student_profiles')
      .select(`
        *,
        users!inner (
          id,
          name,
          email,
          role,
          status
        )
      `, { count: 'exact' })

    // Apply search filter
    if (search) {
      query = query.or(`student_number.ilike.%${search}%,program.ilike.%${search}%`)
    }

    // Apply sorting
    query = query.order(sort, { ascending: order === 'asc' })

    // Apply pagination
    const from = (page - 1) * limit
    const to = from + limit - 1
    query = query.range(from, to)

    // Execute query
    const { data: profiles, error, count } = await query

    if (error) {
      console.error('Database query error:', error)
      return apiError('Failed to fetch student profiles', 500, { details: error })
    }

    console.log('Query successful, profiles count:', profiles?.length)

    return apiSuccess({
      profiles: profiles || [],
      pagination: {
        page,
        limit,
        total: count || 0,
        totalPages: Math.ceil((count || 0) / limit)
      }
    })
  } catch (error) {
    console.error('Unexpected error in student profiles API GET:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function POST(request: NextRequest) {
  try {
    console.log('POST /api/student-profiles - Request received')
    
    const body = await request.json()
    const { userId, studentNumber, yearLevel, program, gpa, enrollmentStatus } = body

    console.log('Request body:', { userId, studentNumber, yearLevel, program, gpa, enrollmentStatus })

    if (!userId || !studentNumber || !program) {
      return apiError('Missing required fields: userId, studentNumber, program', 400)
    }

    const supabase = createAdminClient() as any

    const { data, error } = await supabase
      .from('student_profiles')
      .insert({
        user_id: userId,
        student_number: studentNumber,
        year_level: yearLevel,
        program,
        gpa,
        enrollment_status: enrollmentStatus || 'enrolled'
      })
      .select()
      .single()

    if (error) {
      console.error('Student profile creation error:', error)
      return apiError('Failed to create student profile', 500, { details: error })
    }

    console.log('Student profile created successfully')
    return apiSuccess(data, 201)
  } catch (error) {
    console.error('Unexpected error in student profiles API POST:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function PUT(request: NextRequest) {
  try {
    const body = await request.json()
    const { id, ...updates } = body

    if (!id) {
      return apiError('Student profile ID is required', 400)
    }

    // Map camelCase to snake_case for database
    const dbUpdates: Record<string, any> = {}
    if (updates.yearLevel !== undefined) dbUpdates.year_level = updates.yearLevel
    if (updates.enrollmentStatus !== undefined) dbUpdates.enrollment_status = updates.enrollmentStatus
    if (updates.studentNumber !== undefined) dbUpdates.student_number = updates.studentNumber
    if (updates.gpa !== undefined) dbUpdates.gpa = updates.gpa
    if (updates.program !== undefined) dbUpdates.program = updates.program
    if (updates.userId !== undefined) dbUpdates.user_id = updates.userId

    console.log('Mapped updates for database:', dbUpdates)

    const supabase = createAdminClient() as any

    const { data, error } = await supabase
      .from('student_profiles')
      .update(dbUpdates)
      .eq('id', id)
      .select()
      .single()

    if (error) {
      console.error('Database update error:', error)
      return apiError('Failed to update student profile', 500, { details: error })
    }

    console.log('Student profile updated successfully')
    return apiSuccess(data)
  } catch (error) {
    console.error('Error updating student profile:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const id = searchParams.get('id')

    if (!id) {
      return apiError('Student profile ID is required', 400)
    }

    const supabase = createAdminClient() as any

    const { error } = await supabase
      .from('student_profiles')
      .delete()
      .eq('id', id)

    if (error) {
      return apiError('Failed to delete student profile', 500, { details: error })
    }

    return apiSuccess({ message: 'Student profile deleted successfully' })
  } catch (error) {
    console.error('Error deleting student profile:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}
