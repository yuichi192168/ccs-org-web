import { NextRequest } from 'next/server'
import { createAdminClient } from '@/lib/supabaseClient'

const supabase = createAdminClient()

export const runtime = 'nodejs'

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

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const role = searchParams.get('role')
    const limit = parseInt(searchParams.get('limit') || '25')
    const page = parseInt(searchParams.get('page') || '1')
    const sort = searchParams.get('sort') || '-createdAt'
    const search = searchParams.get('search')?.toLowerCase()

    const supabase = createServiceClient()

    // Get users from database
    const { data: users, error } = await supabase
      .from('users')
      .select('*')

    if (error) {
      return apiError('Failed to fetch users', 500, { details: error })
    }

    // Apply filters
    let filteredUsers = users || []

    // Filter by role
    if (role) {
      filteredUsers = filteredUsers.filter((user: any) => user.role === role)
    }

    // Search functionality
    if (search) {
      filteredUsers = filteredUsers.filter((user: any) => 
        user.name.toLowerCase().includes(search) ||
        user.email.toLowerCase().includes(search) ||
        user.system_id.toLowerCase().includes(search)
      )
    }

    // Sort functionality
    if (sort.startsWith('-')) {
      const field = sort.substring(1)
      filteredUsers.sort((a: any, b: any) => {
        const aVal = a[field]
        const bVal = b[field]
        if (aVal < bVal) return 1
        if (aVal > bVal) return -1
        return 0
      })
    } else {
      const field = sort
      filteredUsers.sort((a: any, b: any) => {
        const aVal = a[field]
        const bVal = b[field]
        if (aVal > bVal) return 1
        if (aVal < bVal) return -1
        return 0
      })
    }

    // Pagination
    const startIndex = (page - 1) * limit
    const endIndex = startIndex + limit
    const paginatedUsers = filteredUsers.slice(startIndex, endIndex)

    return apiSuccess({
      users: paginatedUsers,
      pagination: {
        page,
        limit,
        total: users.length,
        totalPages: Math.ceil(users.length / limit)
      }
    })
  } catch (error) {
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { name, email, role, systemId } = body

    if (!name || !email || !role || !systemId) {
      return apiError('Missing required fields: name, email, role, systemId', 400)
    }

    const { data, error } = await supabase
      .from('users')
      .insert({
        name,
        email: email.toLowerCase(),
        role,
        system_id: systemId,
        status: 'active'
      })
      .select()
      .single()

    if (error) {
      return apiError('Failed to create user', 500, { details: error })
    }

    return apiSuccess(data, 201)
  } catch (error) {
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function PUT(request: NextRequest) {
  try {
    const body = await request.json()
    const { id, ...updates } = body

    if (!id) {
      return apiError('User ID is required', 400)
    }

    const { data, error } = await supabase
      .from('users')
      .update(updates)
      .eq('id', id)
      .select()
      .single()

    if (error) {
      return apiError('Failed to update user', 500, { details: error })
    }

    return apiSuccess(data)
  } catch (error) {
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const id = searchParams.get('id')

    if (!id) {
      return apiError('User ID is required', 400)
    }

    const { error } = await supabase
      .from('users')
      .delete()
      .eq('id', id)

    if (error) {
      return apiError('Failed to delete user', 500, { details: error })
    }

    return apiSuccess({ message: 'User deleted successfully' })
  } catch (error) {
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}
