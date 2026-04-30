import { NextRequest } from 'next/server'
import { mockAcademicHistory } from '@/lib/mock-data'

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
    const studentId = searchParams.get('studentId')
    const courseId = searchParams.get('courseId')
    const semester = searchParams.get('semester')

    // Get all academic history data
    let academicHistory = mockAcademicHistory

    // Filter by student
    if (studentId) {
      academicHistory = academicHistory.filter(history => history.studentId === studentId)
    }

    // Filter by course
    if (courseId) {
      academicHistory = academicHistory.filter(history => history.courseId === courseId)
    }

    // Filter by semester
    if (semester) {
      academicHistory = academicHistory.filter(history => 
        history.semester.toLowerCase().includes(semester.toLowerCase())
      )
    }

    // Sort by academic year and semester
    academicHistory.sort((a, b) => {
      const dateA = new Date(`${a.academicYear}-${a.semester}-01`).getTime()
      const dateB = new Date(`${b.academicYear}-${b.semester}-01`).getTime()
      return dateB - dateA
    })

    return apiSuccess(academicHistory)
  } catch (error) {
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}
