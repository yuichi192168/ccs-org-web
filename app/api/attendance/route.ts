import { NextRequest, NextResponse } from 'next/server'
import { createAdminClient } from '@/lib/supabaseServer'
import type { Database } from '@/types/database'

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
    console.log('GET /api/attendance - Request received')
    
    const { searchParams } = new URL(request.url)
    const limit = parseInt(searchParams.get('limit') || '25')
    const page = parseInt(searchParams.get('page') || '1')
    const sort = searchParams.get('sort') || 'date'
    const order = searchParams.get('order') || 'desc'
    const search = searchParams.get('search')?.toLowerCase()
    const courseId = searchParams.get('courseId')
    const studentId = searchParams.get('studentId')

    console.log('Query params:', { limit, page, sort, order, search, courseId, studentId })

    const supabase = createAdminClient()

    // Build query with server-side pagination and sorting
    let query = supabase
      .from('attendance')
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
        courses!inner (
          id,
          course_code,
          title
        ),
        faculty_profiles (
          employee_id,
          users!inner (
            name
          )
        )
      `, { count: 'exact' })

    // Apply filters
    if (courseId) {
      query = query.eq('course_id', courseId)
    }
    if (studentId) {
      query = query.eq('student_id', studentId)
    }

    // Apply search filter
    if (search) {
      query = query.or(`status.ilike.%${search}%,remarks.ilike.%${search}%`)
    }

    // Apply sorting
    query = query.order(sort, { ascending: order === 'asc' })

    // Apply pagination
    const from = (page - 1) * limit
    const to = from + limit - 1
    query = query.range(from, to)

    // Execute query
    const { data: attendance, error, count } = await query

    if (error) {
      console.error('Database query error:', error)
      return apiError('Failed to fetch attendance records', 500, { details: error })
    }

    console.log('Query successful, attendance count:', attendance?.length)

    return apiSuccess({
      attendance: attendance || [],
      pagination: {
        page,
        limit,
        total: count || 0,
        totalPages: Math.ceil((count || 0) / limit)
      }
    })
  } catch (error) {
    console.error('Unexpected error in attendance API GET:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function POST(request: NextRequest) {
  try {
    console.log('POST /api/attendance - Request received')
    
    const body = await request.json()
    const { studentId, courseId, date, status, remarks, recordedBy } = body

    console.log('Request body:', { studentId, courseId, date, status, remarks, recordedBy })

    if (!studentId || !courseId || !date || !status) {
      return apiError('Missing required fields: studentId, courseId, date, status', 400)
    }

    const supabase = createAdminClient()

    const insertData = {
        student_id: studentId,
        course_id: courseId,
        date,
        status,
        remarks: remarks || null,
        recorded_by: recordedBy || null
      }

    const { data, error } = await supabase
      .from('attendance')
      .insert(insertData)
      .select()
      .single()

    if (error) {
      console.error('Attendance creation error:', error)
      return apiError('Failed to create attendance record', 500, { details: error })
    }

    console.log('Attendance record created successfully')
    return apiSuccess(data, 201)
  } catch (error) {
    console.error('Unexpected error in attendance API POST:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function PUT(request: NextRequest) {
  try {
    const body = await request.json()
    const { id, studentId, courseId, date, status, remarks, recordedBy } = body

    if (!id) {
      return apiError('Attendance record ID is required', 400)
    }

    const supabase = createAdminClient()

    // Build update object with only provided fields
    const updateData: any = {}
    if (studentId !== undefined) updateData.student_id = studentId
    if (courseId !== undefined) updateData.course_id = courseId
    if (date !== undefined) updateData.date = date
    if (status !== undefined) updateData.status = status
    if (remarks !== undefined) updateData.remarks = remarks
    if (recordedBy !== undefined) updateData.recorded_by = recordedBy

    const { data, error } = await supabase
      .from('attendance')
      .update(updateData)
      .eq('id', id)
      .select()
      .single()

    if (error) {
      return apiError('Failed to update attendance record', 500, { details: error })
    }

    return apiSuccess(data)
  } catch (error) {
    console.error('Error updating attendance record:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const id = searchParams.get('id')

    if (!id) {
      return apiError('Attendance record ID is required', 400)
    }

    const supabase = createAdminClient()

    const { error } = await supabase
      .from('attendance')
      .delete()
      .eq('id', id)

    if (error) {
      return apiError('Failed to delete attendance record', 500, { details: error })
    }

    return apiSuccess({ message: 'Attendance record deleted successfully' })
  } catch (error) {
    console.error('Error deleting attendance record:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}
