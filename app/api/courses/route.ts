import { NextRequest } from 'next/server'
import { getMockCourses } from '@/lib/mock-data'

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
    const department = searchParams.get('department')
    const isActive = searchParams.get('active')
    const search = searchParams.get('search')?.toLowerCase()

    let courses = getMockCourses()

    // Filter by department
    if (department) {
      courses = courses.filter(course => course.department.toLowerCase() === department.toLowerCase())
    }

    // Filter by active status
    if (isActive !== null) {
      const active = isActive === 'true'
      courses = courses.filter(course => course.isActive === active)
    }

    // Search functionality
    if (search) {
      courses = courses.filter(course => 
        course.courseCode.toLowerCase().includes(search) ||
        course.courseName.toLowerCase().includes(search) ||
        (course.description && course.description.toLowerCase().includes(search))
      )
    }

    // Sort by course code
    courses.sort((a, b) => a.courseCode.localeCompare(b.courseCode))

    return apiSuccess(courses)
  } catch (error) {
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}
