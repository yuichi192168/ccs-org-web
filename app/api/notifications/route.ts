import { NextRequest } from 'next/server'
import { mockNotifications } from '@/lib/mock-data'

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
    const recipientId = searchParams.get('recipientId')
    const type = searchParams.get('type')
    const isRead = searchParams.get('isRead')
    const priority = searchParams.get('priority')

    // Get all notifications data
    let notifications = mockNotifications

    // Filter by recipient
    if (recipientId) {
      notifications = notifications.filter(notification => notification.recipientId === recipientId)
    }

    // Filter by type
    if (type) {
      notifications = notifications.filter(notification => notification.type === type)
    }

    // Filter by read status
    if (isRead !== null) {
      const read = isRead === 'true'
      notifications = notifications.filter(notification => notification.isRead === read)
    }

    // Filter by priority
    if (priority) {
      notifications = notifications.filter(notification => notification.priority === priority)
    }

    // Sort by creation date (newest first)
    notifications.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())

    return apiSuccess(notifications)
  } catch (error) {
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { notificationId, isRead } = body

    if (!notificationId) {
      return apiError('Notification ID is required', 400)
    }

    // In a real implementation, this would update the database
    // For mock purposes, we'll just return success
    return apiSuccess({
      id: notificationId,
      isRead: isRead || true,
      readAt: new Date().toISOString()
    })
  } catch (error) {
    return apiError(error instanceof Error ? error.message : 'Unknown error', 500)
  }
}
