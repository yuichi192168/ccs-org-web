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
    console.log('GET /api/student-documents - Request received')
    
    const { searchParams } = new URL(request.url)
    const limit = parseInt(searchParams.get('limit') || '25')
    const page = parseInt(searchParams.get('page') || '1')
    const sort = searchParams.get('sort') || 'uploaded_at'
    const order = searchParams.get('order') || 'desc'
    const search = searchParams.get('search')?.toLowerCase()
    const studentId = searchParams.get('studentId')

    console.log('Query params:', { limit, page, sort, order, search, studentId })

    const supabase = createAdminClient()

    // Build query with server-side pagination and sorting
    let query = supabase
      .from('student_documents')
      .select(`
        *,
        student_profiles!inner (
          id,
          student_number,
          users!inner (
            name,
            email
          )
        )
      `, { count: 'exact' })

    // Apply filters
    if (studentId) {
      query = query.eq('student_id', studentId)
    }

    // Apply search filter
    if (search) {
      query = query.or(`document_name.ilike.%${search}%,document_type.ilike.%${search}%`)
    }

    // Apply sorting
    query = query.order(sort, { ascending: order === 'asc' })

    // Apply pagination
    const from = (page - 1) * limit
    const to = from + limit - 1
    query = query.range(from, to)

    // Execute query
    const { data: documents, error, count } = await query

    if (error) {
      console.error('Database query error:', error)
      return apiError('Failed to fetch student documents', 500, { details: error })
    }

    console.log('Query successful, documents count:', documents?.length)

    return apiSuccess({
      documents: documents || [],
      pagination: {
        page,
        limit,
        total: count || 0,
        totalPages: Math.ceil((count || 0) / limit)
      }
    })
  } catch (error) {
    console.error('Unexpected error in student documents API GET:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function POST(request: NextRequest) {
  try {
    console.log('POST /api/student-documents - Request received')
    
    const body = await request.json()
    const { studentId, documentType, documentName, filePath, fileSize, mimeType } = body

    console.log('Request body:', { studentId, documentType, documentName, filePath, fileSize, mimeType })

    if (!studentId || !documentType || !documentName || !filePath) {
      return apiError('Missing required fields: studentId, documentType, documentName, filePath', 400)
    }

    const supabase = createAdminClient()

    const insertData: any = {
      student_id: studentId,
      document_type: documentType,
      document_name: documentName,
      file_path: filePath
    }

    if (fileSize) insertData.file_size = fileSize
    if (mimeType) insertData.mime_type = mimeType

    const { data, error } = await supabase
      .from('student_documents')
      .insert(insertData)
      .select()
      .single()

    if (error) {
      console.error('Student document creation error:', error)
      return apiError('Failed to create student document', 500, { details: error })
    }

    console.log('Student document created successfully')
    return apiSuccess(data, 201)
  } catch (error) {
    console.error('Unexpected error in student documents API POST:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function PUT(request: NextRequest) {
  try {
    const body = await request.json()
    const { id, ...updates } = body

    if (!id) {
      return apiError('Student document ID is required', 400)
    }

    const supabase = createAdminClient()

    const { data, error } = await supabase
      .from('student_documents')
      .update(updates as any)
      .eq('id', id)
      .select()
      .single()

    if (error) {
      return apiError('Failed to update student document', 500, { details: error })
    }

    return apiSuccess(data)
  } catch (error) {
    console.error('Error updating student document:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const id = searchParams.get('id')

    if (!id) {
      return apiError('Student document ID is required', 400)
    }

    const supabase = createAdminClient()

    const { error } = await supabase
      .from('student_documents')
      .delete()
      .eq('id', id)

    if (error) {
      return apiError('Failed to delete student document', 500, { details: error })
    }

    return apiSuccess({ message: 'Student document deleted successfully' })
  } catch (error) {
    console.error('Error deleting student document:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}
