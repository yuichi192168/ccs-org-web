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
    console.log('GET /api/faculty-profiles - Request received')
    
    const { searchParams } = new URL(request.url)
    const limit = parseInt(searchParams.get('limit') || '25')
    const page = parseInt(searchParams.get('page') || '1')
    const sort = searchParams.get('sort') || 'employee_id'
    const order = searchParams.get('order') || 'asc'
    const search = searchParams.get('search')?.toLowerCase()

    console.log('Query params:', { limit, page, sort, order, search })

    const supabase = createAdminClient()

    // Build query with server-side pagination and sorting
    let query = supabase
      .from('faculty_profiles')
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
      query = query.or(`employee_id.ilike.%${search}%,department.ilike.%${search}%,position.ilike.%${search}%`)
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
      return apiError('Failed to fetch faculty profiles', 500, { details: error })
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
    console.error('Unexpected error in faculty profiles API GET:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function POST(request: NextRequest) {
  try {
    console.log('POST /api/faculty-profiles - Request received')
    
    const body = await request.json()
    const { userId, employeeId, department, position, specialization, hireDate } = body

    console.log('Request body:', { userId, employeeId, department, position, specialization, hireDate })

    if (!userId || !employeeId || !department || !position || !hireDate) {
      return apiError('Missing required fields: userId, employeeId, department, position, hireDate', 400)
    }

    const supabase = createAdminClient() as any

    const { data, error } = await supabase
      .from('faculty_profiles')
      .insert({
        user_id: userId,
        employee_id: employeeId,
        department,
        position,
        specialization,
        hire_date: hireDate
      })
      .select()
      .single()

    if (error) {
      console.error('Faculty profile creation error:', error)
      return apiError('Failed to create faculty profile', 500, { details: error })
    }

    console.log('Faculty profile created successfully')
    return apiSuccess(data, 201)
  } catch (error) {
    console.error('Unexpected error in faculty profiles API POST:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function PUT(request: NextRequest) {
  try {
    const body = await request.json()
    const { id, ...updates } = body

    if (!id) {
      return apiError('Faculty profile ID is required', 400)
    }

    const supabase = createAdminClient() as any

    const { data, error } = await supabase
      .from('faculty_profiles')
      .update(updates)
      .eq('id', id)
      .select()
      .single()

    if (error) {
      return apiError('Failed to update faculty profile', 500, { details: error })
    }

    return apiSuccess(data)
  } catch (error) {
    console.error('Error updating faculty profile:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const id = searchParams.get('id')

    if (!id) {
      return apiError('Faculty profile ID is required', 400)
    }

    const supabase = createAdminClient()

    const { error } = await supabase
      .from('faculty_profiles')
      .delete()
      .eq('id', id)

    if (error) {
      return apiError('Failed to delete faculty profile', 500, { details: error })
    }

    return apiSuccess({ message: 'Faculty profile deleted successfully' })
  } catch (error) {
    console.error('Error deleting faculty profile:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}
