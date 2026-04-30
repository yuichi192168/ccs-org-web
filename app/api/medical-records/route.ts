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
    console.log('GET /api/medical-records - Request received')
    
    const { searchParams } = new URL(request.url)
    const limit = parseInt(searchParams.get('limit') || '25')
    const page = parseInt(searchParams.get('page') || '1')
    const sort = searchParams.get('sort') || 'diagnosis_date'
    const order = searchParams.get('order') || 'desc'
    const search = searchParams.get('search')?.toLowerCase()
    const studentId = searchParams.get('studentId')

    console.log('Query params:', { limit, page, sort, order, search, studentId })

    const supabase = createAdminClient()

    // Build query with server-side pagination and sorting
    let query = supabase
      .from('medical_records')
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
      query = query.or(`condition.ilike.%${search}%,diagnosis.ilike.%${search}%,treatment.ilike.%${search}%`)
    }

    // Apply sorting
    query = query.order(sort, { ascending: order === 'asc' })

    // Apply pagination
    const from = (page - 1) * limit
    const to = from + limit - 1
    query = query.range(from, to)

    // Execute query
    const { data: records, error, count } = await query

    if (error) {
      console.error('Database query error:', error)
      return apiError('Failed to fetch medical records', 500, { details: error })
    }

    console.log('Query successful, medical records count:', records?.length)

    return apiSuccess({
      records: records || [],
      pagination: {
        page,
        limit,
        total: count || 0,
        totalPages: Math.ceil((count || 0) / limit)
      }
    })
  } catch (error) {
    console.error('Unexpected error in medical records API GET:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function POST(request: NextRequest) {
  try {
    console.log('POST /api/medical-records - Request received')
    
    const body = await request.json()
    const { studentId, condition, diagnosis, treatment, doctorName, hospital, diagnosisDate, isChronic } = body

    console.log('Request body:', { studentId, condition, diagnosis, treatment, doctorName, hospital, diagnosisDate, isChronic })

    if (!studentId || !condition) {
      return apiError('Missing required fields: studentId, condition', 400)
    }

    const supabase = createAdminClient() as any

    const insertData: Record<string, any> = {
      student_id: studentId,
      condition
    }

    if (diagnosis) insertData.diagnosis = diagnosis
    if (treatment) insertData.treatment = treatment
    if (doctorName) insertData.doctor_name = doctorName
    if (hospital) insertData.hospital = hospital
    if (diagnosisDate) insertData.diagnosis_date = diagnosisDate
    if (isChronic !== undefined) insertData.is_chronic = isChronic

    const { data, error } = await supabase
      .from('medical_records')
      .insert(insertData)
      .select()
      .single()

    if (error) {
      console.error('Medical record creation error:', error)
      return apiError('Failed to create medical record', 500, { details: error })
    }

    console.log('Medical record created successfully')
    return apiSuccess(data, 201)
  } catch (error) {
    console.error('Unexpected error in medical records API POST:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function PUT(request: NextRequest) {
  try {
    const body = await request.json()
    const { id, ...updates } = body

    if (!id) {
      return apiError('Medical record ID is required', 400)
    }

    const supabase = createAdminClient() as any

    const { data, error } = await supabase
      .from('medical_records')
      .update(updates)
      .eq('id', id)
      .select()
      .single()

    if (error) {
      return apiError('Failed to update medical record', 500, { details: error })
    }

    return apiSuccess(data)
  } catch (error) {
    console.error('Error updating medical record:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const id = searchParams.get('id')

    if (!id) {
      return apiError('Medical record ID is required', 400)
    }

    const supabase = createAdminClient()

    const { error } = await supabase
      .from('medical_records')
      .delete()
      .eq('id', id)

    if (error) {
      return apiError('Failed to delete medical record', 500, { details: error })
    }

    return apiSuccess({ message: 'Medical record deleted successfully' })
  } catch (error) {
    console.error('Error deleting medical record:', error)
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}
