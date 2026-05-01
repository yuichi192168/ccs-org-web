import { NextRequest } from 'next/server'
import { createAdminClient } from '@/lib/supabaseServer'
import type { Database } from '@/types/database'

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
    const supabase = createAdminClient()

    // Get total students
    const { count: students, error: studentsError } = await supabase
      .from('users')
      .select('*', { count: 'exact', head: true })
      .eq('role', 'student')
      .eq('status', 'active')

    if (studentsError) {
      console.error('Error counting students:', studentsError)
      throw studentsError
    }

    // Get total faculty
    const { count: faculty, error: facultyError } = await supabase
      .from('users')
      .select('*', { count: 'exact', head: true })
      .eq('role', 'faculty')
      .eq('status', 'active')

    if (facultyError) {
      console.error('Error counting faculty:', facultyError)
      throw facultyError
    }

    // Get total active courses
    const { count: courses, error: coursesError } = await supabase
      .from('courses')
      .select('*', { count: 'exact', head: true })
      .eq('is_active', true)

    if (coursesError) {
      console.error('Error counting courses:', coursesError)
      throw coursesError
    }

    // Get total active enrollments
    const { count: activeEnrollments, error: enrollmentsError } = await supabase
      .from('enrollments')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'enrolled')

    if (enrollmentsError) {
      console.error('Error counting enrollments:', enrollmentsError)
      throw enrollmentsError
    }

    // Calculate average GPA from academic history
    const { data: academicHistory, error: gpaError } = await supabase
      .from('academic_history')
      .select('gpa_points')
      .not('gpa_points', 'is', null)

    let averageGpa = 3.0 // Default value
    if (!gpaError && academicHistory && academicHistory.length > 0) {
      const totalGpaPoints = academicHistory.reduce((sum, record) => sum + (record.gpa_points || 0), 0)
      averageGpa = totalGpaPoints / academicHistory.length
    }

    // Get recent courses with enrollment data
    const { data: recentCoursesData, error: recentCoursesError } = await supabase
      .from('courses')
      .select(`
        id,
        course_code,
        enrollments!inner(
          id,
          status
        )
      `)
      .eq('is_active', true)
      .limit(5)

    let recentCourses = []
    if (!recentCoursesError && recentCoursesData) {
      recentCourses = recentCoursesData.map(course => ({
        id: course.id,
        code: course.course_code,
        enrolledCount: course.enrollments?.filter(e => e.status === 'enrolled').length || 0,
        capacity: 50, // Default capacity - could be fetched from courses table if max_students field exists
      }))
    }

    const overviewData = {
      stats: {
        students: students || 0,
        faculty: faculty || 0,
        courses: courses || 0,
        activeEnrollments: activeEnrollments || 0,
        averageGpa: Number(averageGpa.toFixed(2)),
      },
      recentCourses,
    }

    return apiSuccess(overviewData)
  } catch (error) {
    console.error('Dashboard overview API error:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}
