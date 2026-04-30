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
    console.log('GET /api/users - Request received')
    
    const { searchParams } = new URL(request.url)
    const role = searchParams.get('role')
    const limit = parseInt(searchParams.get('limit') || '25')
    const page = parseInt(searchParams.get('page') || '1')
    const sort = searchParams.get('sort') || 'name'
    const order = searchParams.get('order') || 'asc'
    const search = searchParams.get('search')?.toLowerCase()

    console.log('Query params:', { role, limit, page, sort, order, search })

    const supabase = createAdminClient()
    console.log('Supabase admin client created successfully')

    // Build query with server-side pagination and sorting
    let query = supabase
      .from('users')
      .select('*', { count: 'exact' })

    // Apply role filter
    if (role) {
      query = query.eq('role', role)
    }

    // Apply search filter
    if (search) {
      query = query.or(`name.ilike.%${search}%,email.ilike.%${search}%,system_id.ilike.%${search}%`)
    }

    // Apply sorting
    query = query.order(sort, { ascending: order === 'asc' })

    // Apply pagination
    const from = (page - 1) * limit
    const to = from + limit - 1
    query = query.range(from, to)

    console.log('Executing database query...')
    // Execute query
    const { data: users, error, count } = await query

    if (error) {
      console.error('Database query error:', error)
      return apiError('Failed to fetch users', 500, { details: error })
    }

    console.log('Query successful, users count:', users?.length)

    return apiSuccess({
      users: users || [],
      pagination: {
        page,
        limit,
        total: count || 0,
        totalPages: Math.ceil((count || 0) / limit)
      }
    })
  } catch (error) {
    console.error('Unexpected error in users API GET:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function POST(request: NextRequest) {
  try {
    console.log('POST /api/users - Request received')
    
    const body = await request.json()
    const { name, email, role, systemId, password } = body

    console.log('Request body:', { name, email, role, systemId })

    if (!name || !email || !role || !systemId) {
      return apiError('Missing required fields: name, email, role, systemId', 400)
    }

    const supabase = createAdminClient()
    console.log('Supabase admin client created successfully')

    // First, create user in auth.users
    console.log('Creating auth user...')
    const { data: authData, error: authError } = await supabase.auth.admin.createUser({
      email: email.toLowerCase(),
      password: password || 'tempPassword123!', // Generate or require password
      email_confirm: true,
      user_metadata: {
        name,
        role
      }
    })

    if (authError) {
      console.error('Auth user creation error:', authError)
      return apiError('Failed to create auth user', 500, { details: authError })
    }

    if (!authData.user) {
      console.error('No user data returned from auth creation')
      return apiError('Failed to create auth user - no user data returned', 500)
    }

    console.log('Auth user created successfully:', authData.user.id)

    // Then, create user in public.users table
    const supabaseAny = createAdminClient() as any
    console.log('Creating public user profile...')
    const { data: userData, error: userError } = await supabaseAny
      .from('users')
      .insert({
        id: authData.user.id,
        name,
        email: email.toLowerCase(),
        role,
        system_id: systemId,
        status: 'active'
      })
      .select()
      .single()

    if (userError) {
      console.error('Public user creation error:', userError)
      // If public.users creation fails, try to clean up auth user
      await supabase.auth.admin.deleteUser(authData.user.id)
      return apiError('Failed to create user profile', 500, { details: userError })
    }

    console.log('Public user profile created successfully')
    return apiSuccess(userData, 201)
  } catch (error) {
    console.error('Unexpected error in users API POST:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function PUT(request: NextRequest) {
  try {
    const body = await request.json()
    const { id, password, ...userUpdates } = body

    if (!id) {
      return apiError('User ID is required', 400)
    }

    const supabase = createAdminClient()

    // Update password in auth.users if provided
    if (password && password.trim()) {
      console.log('Updating user password in auth.users...')
      const { error: authError } = await supabase.auth.admin.updateUserById(
        id,
        { password: password.trim() }
      )

      if (authError) {
        console.error('Failed to update auth user password:', authError)
        return apiError('Failed to update user password', 500, { details: authError })
      }
    }

    // Update user profile in public.users table
    console.log('Updating user profile in public.users...')
    const { data, error } = await supabase
      .from('users')
      .update(userUpdates)
      .eq('id', id)
      .select()
      .single()

    if (error) {
      console.error('Failed to update user profile:', error)
      return apiError('Failed to update user profile', 500, { details: error })
    }

    console.log('User updated successfully')
    return apiSuccess(data)
  } catch (error) {
    console.error('Error updating user:', error)
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

    const supabase = createAdminClient()

    // First, delete from public.users table
    const { error: userError } = await supabase
      .from('users')
      .delete()
      .eq('id', id)

    if (userError) {
      return apiError('Failed to delete user profile', 500, { details: userError })
    }

    // Then, delete from auth.users
    const { error: authError } = await supabase.auth.admin.deleteUser(id)

    if (authError) {
      // Log the error but don't fail the operation since public user is already deleted
      console.error('Failed to delete auth user (but public user was deleted):', authError)
    }

    return apiSuccess({ message: 'User deleted successfully' })
  } catch (error) {
    console.error('Error deleting user:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}
