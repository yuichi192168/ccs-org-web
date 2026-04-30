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
    console.log('GET /api/organizations - Request received')
    
    const { searchParams } = new URL(request.url)
    const limit = parseInt(searchParams.get('limit') || '25')
    const page = parseInt(searchParams.get('page') || '1')
    const sort = searchParams.get('sort') || 'name'
    const order = searchParams.get('order') || 'asc'
    const search = searchParams.get('search')?.toLowerCase()

    console.log('Query params:', { limit, page, sort, order, search })

    const supabase = createAdminClient()

    // Build query with server-side pagination and sorting
    let query = supabase
      .from('student_organizations')
      .select(`
        *,
        faculty_profiles (
          employee_id,
          users!inner (
            name
          )
        )
      `, { count: 'exact' })

    // Apply search filter
    if (search) {
      query = query.or(`name.ilike.%${search}%,description.ilike.%${search}%,category.ilike.%${search}%`)
    }

    // Apply sorting
    query = query.order(sort, { ascending: order === 'asc' })

    // Apply pagination
    const from = (page - 1) * limit
    const to = from + limit - 1
    query = query.range(from, to)

    // Execute query
    const { data: organizations, error, count } = await query

    if (error) {
      console.error('Database query error:', error)
      return apiError('Failed to fetch organizations', 500, { details: error })
    }

    console.log('Query successful, organizations count:', organizations?.length)

    return apiSuccess({
      organizations: organizations || [],
      pagination: {
        page,
        limit,
        total: count || 0,
        totalPages: Math.ceil((count || 0) / limit)
      }
    })
  } catch (error) {
    console.error('Unexpected error in organizations API GET:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function POST(request: NextRequest) {
  try {
    console.log('POST /api/organizations - Request received')
    
    const body = await request.json()
    const { name, description, advisorId, category, maxMembers } = body

    console.log('Request body:', { name, description, advisorId, category, maxMembers })

    if (!name || !category) {
      return apiError('Missing required fields: name, category', 400)
    }

    const supabase = createAdminClient()

    const insertData: any = {
      name,
      category
    }

    if (description) insertData.description = description
    if (advisorId) insertData.advisor_id = advisorId
    if (maxMembers) insertData.max_members = maxMembers

    const { data, error } = await supabase
      .from('student_organizations')
      .insert(insertData)
      .select()
      .single()

    if (error) {
      console.error('Organization creation error:', error)
      return apiError('Failed to create organization', 500, { details: error })
    }

    console.log('Organization created successfully')
    return apiSuccess(data, 201)
  } catch (error) {
    console.error('Unexpected error in organizations API POST:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function PUT(request: NextRequest) {
  try {
    const body = await request.json()
    const { id, ...updates } = body

    if (!id) {
      return apiError('Organization ID is required', 400)
    }

    const supabase = createAdminClient()

    const { data, error } = await supabase
      .from('student_organizations')
      .update(updates as any)
      .eq('id', id)
      .select()
      .single()

    if (error) {
      return apiError('Failed to update organization', 500, { details: error })
    }

    return apiSuccess(data)
  } catch (error) {
    console.error('Error updating organization:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const id = searchParams.get('id')

    if (!id) {
      return apiError('Organization ID is required', 400)
    }

    const supabase = createAdminClient()

    const { error } = await supabase
      .from('student_organizations')
      .delete()
      .eq('id', id)

    if (error) {
      return apiError('Failed to delete organization', 500, { details: error })
    }

    return apiSuccess({ message: 'Organization deleted successfully' })
  } catch (error) {
    console.error('Error deleting organization:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}
