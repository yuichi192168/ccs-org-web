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
    console.log('GET /api/course-prerequisites - Request received')
    
    const { searchParams } = new URL(request.url)
    const limit = parseInt(searchParams.get('limit') || '25')
    const page = parseInt(searchParams.get('page') || '1')
    const sort = searchParams.get('sort') || 'created_at'
    const order = searchParams.get('order') || 'desc'
    const courseId = searchParams.get('courseId')

    console.log('Query params:', { limit, page, sort, order, courseId })

    const supabase = createAdminClient() as any

    // Build query with server-side pagination and sorting
    let query = supabase
      .from('course_prerequisites')
      .select('*', { count: 'exact' })

    // Apply filters
    if (courseId) {
      query = query.eq('course_id', courseId)
    }

    // Apply sorting
    query = query.order(sort, { ascending: order === 'asc' })

    // Apply pagination
    const from = (page - 1) * limit
    const to = from + limit - 1
    query = query.range(from, to)

    // Execute query
    const { data: prerequisites, error, count } = await query

    if (error) {
      console.error('Database query error:', error)
      return apiError('Failed to fetch course prerequisites', 500, { details: error })
    }

    console.log('Query successful, prerequisites count:', prerequisites?.length)

    return apiSuccess({
      prerequisites: prerequisites || [],
      pagination: {
        page,
        limit,
        total: count || 0,
        totalPages: Math.ceil((count || 0) / limit)
      }
    })
  } catch (error) {
    console.error('Unexpected error in course prerequisites API GET:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function POST(request: NextRequest) {
  try {
    console.log('POST /api/course-prerequisites - Request received')
    
    const body = await request.json()
    const { courseId, prerequisiteCourseId } = body

    console.log('Request body:', { courseId, prerequisiteCourseId })

    if (!courseId || !prerequisiteCourseId) {
      return apiError('Missing required fields: courseId, prerequisiteCourseId', 400)
    }

    const supabase = createAdminClient() as any

    const { data, error } = await supabase
      .from('course_prerequisites')
      .insert({
        course_id: courseId,
        prerequisite_course_id: prerequisiteCourseId
      })
      .select()
      .single()

    if (error) {
      console.error('Course prerequisite creation error:', error)
      return apiError('Failed to create course prerequisite', 500, { details: error })
    }

    console.log('Course prerequisite created successfully')
    return apiSuccess(data, 201)
  } catch (error) {
    console.error('Unexpected error in course prerequisites API POST:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function PUT(request: NextRequest) {
  try {
    const body = await request.json()
    const { id, ...updates } = body

    if (!id) {
      return apiError('Course prerequisite ID is required', 400)
    }

    const supabase = createAdminClient() as any

    const { data, error } = await supabase
      .from('course_prerequisites')
      .update(updates)
      .eq('id', id)
      .select()
      .single()

    if (error) {
      return apiError('Failed to update course prerequisite', 500, { details: error })
    }

    return apiSuccess(data)
  } catch (error) {
    console.error('Error updating course prerequisite:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const id = searchParams.get('id')

    if (!id) {
      return apiError('Course prerequisite ID is required', 400)
    }

    const supabase = createAdminClient() as any

    const { error } = await supabase
      .from('course_prerequisites')
      .delete()
      .eq('id', id)

    if (error) {
      return apiError('Failed to delete course prerequisite', 500, { details: error })
    }

    return apiSuccess({ message: 'Course prerequisite deleted successfully' })
  } catch (error) {
    console.error('Error deleting course prerequisite:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}
