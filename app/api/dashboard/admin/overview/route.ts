import { NextRequest } from 'next/server'
import { mockUsers, mockCourses, mockEnrollments } from '@/lib/mock-data'

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
    // Calculate stats from mock data
    const students = mockUsers.filter(user => user.role === 'student').length
    const faculty = mockUsers.filter(user => user.role === 'faculty').length
    const courses = mockCourses.filter(course => course.isActive).length
    const activeEnrollments = mockEnrollments.filter(enrollment => enrollment.status === 'enrolled').length
    
    // Calculate average GPA (mock calculation)
    const completedEnrollments = mockEnrollments.filter(enrollment => enrollment.status === 'completed' && enrollment.grade)
    const averageGpa = completedEnrollments.length > 0 
      ? completedEnrollments.reduce((sum, enrollment) => sum + (enrollment.grade! / 25), 0) / completedEnrollments.length 
      : 3.0

    // Get recent courses with enrollment data
    const recentCourses = mockCourses.slice(0, 5).map(course => {
      const enrolledCount = mockEnrollments.filter(enrollment => 
        enrollment.courseId === course.id && enrollment.status === 'enrolled'
      ).length
      
      return {
        id: course.id,
        code: course.courseCode,
        enrolledCount,
        capacity: 50, // Default capacity
      }
    })

    const overviewData = {
      stats: {
        students,
        faculty,
        courses,
        activeEnrollments,
        averageGpa: Number(averageGpa.toFixed(2)),
      },
      recentCourses,
    }

    return apiSuccess(overviewData)
  } catch (error) {
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}
