import { NextRequest } from 'next/server'
import { getMockUsers } from '@/lib/mock-data'

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

    let users = getMockUsers()

    // Filter by role
    if (role) {
      users = users.filter(user => user.role === role)
    }

    // Search functionality
    if (search) {
      users = users.filter(user => 
        user.name.toLowerCase().includes(search) ||
        user.email.toLowerCase().includes(search) ||
        user.systemId.toLowerCase().includes(search)
      )
    }

    // Sort functionality
    if (sort.startsWith('-')) {
      const field = sort.substring(1)
      users.sort((a, b) => {
        const aVal = (a as any)[field]
        const bVal = (b as any)[field]
        if (aVal < bVal) return 1
        if (aVal > bVal) return -1
        return 0
      })
    } else {
      const field = sort
      users.sort((a, b) => {
        const aVal = (a as any)[field]
        const bVal = (b as any)[field]
        if (aVal > bVal) return 1
        if (aVal < bVal) return -1
        return 0
      })
    }

    // Pagination
    const startIndex = (page - 1) * limit
    const endIndex = startIndex + limit
    const paginatedUsers = users.slice(startIndex, endIndex)

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
