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
    console.log('GET /api/audit-logs - Request received')
    
    const { searchParams } = new URL(request.url)
    const limit = parseInt(searchParams.get('limit') || '25')
    const page = parseInt(searchParams.get('page') || '1')
    const sort = searchParams.get('sort') || 'created_at'
    const order = searchParams.get('order') || 'desc'
    const search = searchParams.get('search')?.toLowerCase()

    console.log('Query params:', { limit, page, sort, order, search })

    const supabase = createAdminClient()

    // Build query with server-side pagination and sorting
    let query = supabase
      .from('audit_logs')
      .select(`
        *,
        users (
          name,
          email
        )
      `, { count: 'exact' })

    // Apply search filter
    if (search) {
      query = query.or(`action.ilike.%${search}%,table_name.ilike.%${search}%`)
    }

    // Apply sorting
    query = query.order(sort, { ascending: order === 'asc' })

    // Apply pagination
    const from = (page - 1) * limit
    const to = from + limit - 1
    query = query.range(from, to)

    // Execute query
    const { data: logs, error, count } = await query

    if (error) {
      console.error('Database query error:', error)
      return apiError('Failed to fetch audit logs', 500, { details: error })
    }

    console.log('Query successful, audit logs count:', logs?.length)

    return apiSuccess({
      logs: logs || [],
      pagination: {
        page,
        limit,
        total: count || 0,
        totalPages: Math.ceil((count || 0) / limit)
      }
    })
  } catch (error) {
    console.error('Unexpected error in audit logs API GET:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function POST(request: NextRequest) {
  try {
    console.log('POST /api/audit-logs - Request received')
    
    const body = await request.json()
    const { userId, action, tableName, recordId, oldValues, newValues, ipAddress, userAgent } = body

    console.log('Request body:', { userId, action, tableName, recordId })

    if (!action || !tableName) {
      return apiError('Missing required fields: action, tableName', 400)
    }

    const supabase = createAdminClient() as any

    const insertData: Record<string, any> = {
      action,
      table_name: tableName
    }

    if (userId) insertData.user_id = userId
    if (recordId) insertData.record_id = recordId
    if (oldValues) insertData.old_values = oldValues
    if (newValues) insertData.new_values = newValues
    if (ipAddress) insertData.ip_address = ipAddress
    if (userAgent) insertData.user_agent = userAgent

    const { data, error } = await supabase
      .from('audit_logs')
      .insert(insertData)
      .select()
      .single()

    if (error) {
      console.error('Audit log creation error:', error)
      return apiError('Failed to create audit log', 500, { details: error })
    }

    console.log('Audit log created successfully')
    return apiSuccess(data, 201)
  } catch (error) {
    console.error('Unexpected error in audit logs API POST:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function PUT(request: NextRequest) {
  try {
    const body = await request.json()
    const { id, ...updates } = body

    if (!id) {
      return apiError('Audit log ID is required', 400)
    }

    const supabase = createAdminClient() as any

    const { data, error } = await supabase
      .from('audit_logs')
      .update(updates)
      .eq('id', id)
      .select()
      .single()

    if (error) {
      return apiError('Failed to update audit log', 500, { details: error })
    }

    return apiSuccess(data)
  } catch (error) {
    console.error('Error updating audit log:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const id = searchParams.get('id')

    if (!id) {
      return apiError('Audit log ID is required', 400)
    }

    const supabase = createAdminClient()

    const { error } = await supabase
      .from('audit_logs')
      .delete()
      .eq('id', id)

    if (error) {
      return apiError('Failed to delete audit log', 500, { details: error })
    }

    return apiSuccess({ message: 'Audit log deleted successfully' })
  } catch (error) {
    console.error('Error deleting audit log:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}
