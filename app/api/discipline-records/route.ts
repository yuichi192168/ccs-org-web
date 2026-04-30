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
    console.log('GET /api/discipline-records - Request received')
    
    const { searchParams } = new URL(request.url)
    const limit = parseInt(searchParams.get('limit') || '25')
    const page = parseInt(searchParams.get('page') || '1')
    const sort = searchParams.get('sort') || 'incident_date'
    const order = searchParams.get('order') || 'desc'
    const search = searchParams.get('search')?.toLowerCase()
    const studentId = searchParams.get('studentId')

    console.log('Query params:', { limit, page, sort, order, search, studentId })

    const supabase = createAdminClient() as any

    // Build query with server-side pagination and sorting
    let query = supabase
      .from('discipline_records')
      .select(`
        *,
        student_profiles!inner (
          id,
          student_number,
          users!inner (
            name,
            email
          )
        ),
        faculty_profiles (
          employee_id,
          users!inner (
            name
          )
        )
      `, { count: 'exact' })

    // Apply filters
    if (studentId) {
      query = query.eq('student_id', studentId)
    }

    // Apply search filter
    if (search) {
      query = query.or(`offense.ilike.%${search}%,action_taken.ilike.%${search}%,severity.ilike.%${search}%`)
    }

    // Apply sorting
    query = query.order(sort, { ascending: order === 'asc' })

    // Apply pagination
    const from = (page - 1) * limit
    const to = from + limit - 1
    query = query.range(from, to)

    // Execute query
    const { data: records, error, count } = await query

    if (error) {
      console.error('Database query error:', error)
      return apiError('Failed to fetch discipline records', 500, { details: error })
    }

    console.log('Query successful, discipline records count:', records?.length)

    return apiSuccess({
      records: records || [],
      pagination: {
        page,
        limit,
        total: count || 0,
        totalPages: Math.ceil((count || 0) / limit)
      }
    })
  } catch (error) {
    console.error('Unexpected error in discipline records API GET:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function POST(request: NextRequest) {
  try {
    console.log('POST /api/discipline-records - Request received')
    
    const body = await request.json()
    const { studentId, incidentDate, offense, severity, actionTaken, reportedBy } = body

    console.log('Request body:', { studentId, incidentDate, offense, severity, actionTaken, reportedBy })

    if (!studentId || !incidentDate || !offense || !severity) {
      return apiError('Missing required fields: studentId, incidentDate, offense, severity', 400)
    }

    const supabase = createAdminClient() as any

    const insertData: Record<string, any> = {
      student_id: studentId,
      incident_date: incidentDate,
      offense,
      severity
    }

    if (actionTaken) insertData.action_taken = actionTaken
    if (reportedBy) insertData.reported_by = reportedBy

    const { data, error } = await supabase
      .from('discipline_records')
      .insert(insertData)
      .select()
      .single()

    if (error) {
      console.error('Discipline record creation error:', error)
      return apiError('Failed to create discipline record', 500, { details: error })
    }

    console.log('Discipline record created successfully')
    return apiSuccess(data, 201)
  } catch (error) {
    console.error('Unexpected error in discipline records API POST:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function PUT(request: NextRequest) {
  try {
    const body = await request.json()
    const { id, ...updates } = body

    if (!id) {
      return apiError('Discipline record ID is required', 400)
    }

    const supabase = createAdminClient() as any

    const { data, error } = await supabase
      .from('discipline_records')
      .update(updates)
      .eq('id', id)
      .select()
      .single()

    if (error) {
      return apiError('Failed to update discipline record', 500, { details: error })
    }

    return apiSuccess(data)
  } catch (error) {
    console.error('Error updating discipline record:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const id = searchParams.get('id')

    if (!id) {
      return apiError('Discipline record ID is required', 400)
    }

    const supabase = createAdminClient() as any

    const { error } = await supabase
      .from('discipline_records')
      .delete()
      .eq('id', id)

    if (error) {
      return apiError('Failed to delete discipline record', 500, { details: error })
    }

    return apiSuccess({ message: 'Discipline record deleted successfully' })
  } catch (error) {
    console.error('Error deleting discipline record:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}
