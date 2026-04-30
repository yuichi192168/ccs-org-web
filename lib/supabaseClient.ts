'use client'

import { createClient } from '@supabase/supabase-js'
import type { Database } from '@/types/database'

// Environment variables
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

// Validate environment variables
if (!supabaseUrl) {
  throw new Error('Missing NEXT_PUBLIC_SUPABASE_URL environment variable')
}

if (!supabaseAnonKey) {
  throw new Error('Missing NEXT_PUBLIC_SUPABASE_ANON_KEY environment variable')
}

// Create Supabase client
export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true,
  },
  realtime: {
    params: {
      eventsPerSecond: 10,
    },
  },
  global: {
    headers: {
      'x-application-name': 'ccs-org-web',
    },
  },
})

// Helper function to create a service role client for server-side operations
export function createServiceClient() {
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY
  
  if (!serviceRoleKey) {
    throw new Error('Missing SUPABASE_SERVICE_ROLE_KEY environment variable')
  }

  if (!supabaseUrl) {
    throw new Error('Missing NEXT_PUBLIC_SUPABASE_URL environment variable')
  }

  return createClient<Database>(supabaseUrl, serviceRoleKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
    global: {
      headers: {
        'x-admin-operation': 'true',
      },
    },
  })
}

// Helper function to create a server-side admin client with proper auth context
export function createAdminClient() {
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY
  
  if (!serviceRoleKey) {
    throw new Error('Missing SUPABASE_SERVICE_ROLE_KEY environment variable')
  }

  if (!supabaseUrl) {
    throw new Error('Missing NEXT_PUBLIC_SUPABASE_URL environment variable')
  }

  return createClient<Database>(supabaseUrl, serviceRoleKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
    global: {
      headers: {
        'x-admin-operation': 'true',
      },
    },
  })
}

// Authentication helpers
export const auth = {
  // Sign up new user
  async signUp(email: string, password: string, metadata?: Record<string, any>) {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: metadata,
      },
    })
    return { data, error }
  },

  // Sign in user
  async signIn(email: string, password: string) {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    })
    return { data, error }
  },

  // Sign out user
  async signOut() {
    const { error } = await supabase.auth.signOut()
    return { error }
  },

  // Get current user
  async getCurrentUser() {
    const { data: { user }, error } = await supabase.auth.getUser()
    return { user, error }
  },

  // Get current session
  async getCurrentSession() {
    const { data: { session }, error } = await supabase.auth.getSession()
    return { session, error }
  },

  // Reset password
  async resetPassword(email: string) {
    const { data, error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/auth/reset-password`,
    })
    return { data, error }
  },

  // Update password
  async updatePassword(newPassword: string) {
    const { data, error } = await supabase.auth.updateUser({
      password: newPassword,
    })
    return { data, error }
  },

  // Listen to auth changes
  onAuthStateChange(callback: (event: any, session: any) => void) {
    return supabase.auth.onAuthStateChange(callback)
  },
}

// Database helpers
export const db = {
  // Users
  async getUser(userId: string) {
    const { data, error } = await supabase
      .from('users')
      .select('*')
      .eq('id', userId)
      .single()
    return { data, error }
  },

  async updateUser(userId: string, updates: any) {
    const { data, error } = await supabase
      .from('users')
      .update(updates as any)
      .eq('id', userId)
      .select()
      .single()
    return { data, error }
  },

  async createUser(userData: any) {
    const { data, error } = await supabase
      .from('users')
      .insert(userData as any)
      .select()
      .single()
    return { data, error }
  },

  async deleteUser(userId: string) {
    const { data, error } = await supabase
      .from('users')
      .delete()
      .eq('id', userId)
    return { data, error }
  },

  async getAllUsers() {
    const { data, error } = await supabase
      .from('users')
      .select('*')
      .order('created_at', { ascending: false })
    return { data, error }
  },

  // Student Profiles
  async getStudentProfile(userId: string) {
    const { data, error } = await supabase
      .from('student_profiles')
      .select('*')
      .eq('user_id', userId)
      .single()
    return { data, error }
  },

  async updateStudentProfile(profileId: string, updates: any) {
    const { data, error } = await supabase
      .from('student_profiles')
      .update(updates as any)
      .eq('id', profileId)
      .select()
      .single()
    return { data, error }
  },

  async createStudentProfile(profileData: any) {
    const { data, error } = await supabase
      .from('student_profiles')
      .insert(profileData as any)
      .select()
      .single()
    return { data, error }
  },

  async deleteStudentProfile(profileId: string) {
    const { data, error } = await supabase
      .from('student_profiles')
      .delete()
      .eq('id', profileId)
    return { data, error }
  },

  async getAllStudentProfiles() {
    const { data, error } = await supabase
      .from('student_profiles')
      .select('*')
      .order('created_at', { ascending: false })
    return { data, error }
  },

  // Faculty Profiles
  async getFacultyProfile(userId: string) {
    const { data, error } = await supabase
      .from('faculty_profiles')
      .select('*')
      .eq('user_id', userId)
      .single()
    return { data, error }
  },

  async updateFacultyProfile(profileId: string, updates: any) {
    const { data, error } = await supabase
      .from('faculty_profiles')
      .update(updates as any)
      .eq('id', profileId)
      .select()
      .single()
    return { data, error }
  },

  async createFacultyProfile(profileData: any) {
    const { data, error } = await supabase
      .from('faculty_profiles')
      .insert(profileData as any)
      .select()
      .single()
    return { data, error }
  },

  async deleteFacultyProfile(profileId: string) {
    const { data, error } = await supabase
      .from('faculty_profiles')
      .delete()
      .eq('id', profileId)
    return { data, error }
  },

  async getAllFacultyProfiles() {
    const { data, error } = await supabase
      .from('faculty_profiles')
      .select('*')
      .order('created_at', { ascending: false })
    return { data, error }
  },

  // Courses
  async getCourses() {
    const { data, error } = await supabase
      .from('courses')
      .select('*')
      .eq('is_active', true)
      .order('course_code')
    return { data, error }
  },

  async getCourse(courseId: string) {
    const { data, error } = await supabase
      .from('courses')
      .select('*')
      .eq('id', courseId)
      .single()
    return { data, error }
  },

  async createCourse(courseData: any) {
    const { data, error } = await supabase
      .from('courses')
      .insert(courseData as any)
      .select()
      .single()
    return { data, error }
  },

  async updateCourse(courseId: string, updates: any) {
    const { data, error } = await supabase
      .from('courses')
      .update(updates as any)
      .eq('id', courseId)
      .select()
      .single()
    return { data, error }
  },

  async deleteCourse(courseId: string) {
    const { data, error } = await supabase
      .from('courses')
      .delete()
      .eq('id', courseId)
    return { data, error }
  },

  // Enrollments
  async getStudentEnrollments(studentId: string) {
    const { data, error } = await supabase
      .from('enrollments')
      .select(`
        *,
        courses (*)
      `)
      .eq('student_id', studentId)
      .order('created_at', { ascending: false })
    return { data, error }
  },

  async getEnrollment(enrollmentId: string) {
    const { data, error } = await supabase
      .from('enrollments')
      .select('*')
      .eq('id', enrollmentId)
      .single()
    return { data, error }
  },

  async createEnrollment(enrollmentData: any) {
    const { data, error } = await supabase
      .from('enrollments')
      .insert(enrollmentData as any)
      .select()
      .single()
    return { data, error }
  },

  async updateEnrollment(enrollmentId: string, updates: any) {
    const { data, error } = await supabase
      .from('enrollments')
      .update(updates as any)
      .eq('id', enrollmentId)
      .select()
      .single()
    return { data, error }
  },

  async deleteEnrollment(enrollmentId: string) {
    const { data, error } = await supabase
      .from('enrollments')
      .delete()
      .eq('id', enrollmentId)
    return { data, error }
  },

  async getAllEnrollments() {
    const { data, error } = await supabase
      .from('enrollments')
      .select('*')
      .order('created_at', { ascending: false })
    return { data, error }
  },

  // Notifications
  async getUserNotifications(userId: string, limit = 10) {
    const { data, error } = await supabase
      .from('notifications')
      .select('*')
      .eq('recipient_id', userId)
      .order('created_at', { ascending: false })
      .limit(limit)
    return { data, error }
  },

  async getNotification(notificationId: string) {
    const { data, error } = await supabase
      .from('notifications')
      .select('*')
      .eq('id', notificationId)
      .single()
    return { data, error }
  },

  async createNotification(notificationData: any) {
    const { data, error } = await supabase
      .from('notifications')
      .insert(notificationData as any)
      .select()
      .single()
    return { data, error }
  },

  async updateNotification(notificationId: string, updates: any) {
    const { data, error } = await supabase
      .from('notifications')
      .update(updates as any)
      .eq('id', notificationId)
      .select()
      .single()
    return { data, error }
  },

  async markNotificationAsRead(notificationId: string) {
    const { data, error } = await supabase
      .from('notifications')
      .update({ is_read: true, read_at: new Date().toISOString() } as any)
      .eq('id', notificationId)
      .select()
      .single()
    return { data, error }
  },

  async deleteNotification(notificationId: string) {
    const { data, error } = await supabase
      .from('notifications')
      .delete()
      .eq('id', notificationId)
    return { data, error }
  },

  async getAllNotifications() {
    const { data, error } = await supabase
      .from('notifications')
      .select('*')
      .order('created_at', { ascending: false })
    return { data, error }
  },

  // Real-time subscriptions
  subscribeToNotifications(userId: string, callback: (payload: any) => void) {
    return supabase
      .channel(`notifications:${userId}`)
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'notifications',
          filter: `recipient_id=eq.${userId}`,
        },
        callback
      )
      .subscribe()
  },

  subscribeToEnrollments(studentId: string, callback: (payload: any) => void) {
    return supabase
      .channel(`enrollments:${studentId}`)
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'enrollments',
          filter: `student_id=eq.${studentId}`,
        },
        callback
      )
      .subscribe()
  },
}

// Storage helpers
export const storage = {
  async uploadFile(
    bucket: string,
    path: string,
    file: File,
    options?: { upsert?: boolean; cacheControl?: string }
  ) {
    const { data, error } = await supabase.storage
      .from(bucket)
      .upload(path, file, options)
    return { data, error }
  },

  async getPublicUrl(bucket: string, path: string) {
    const { data } = supabase.storage
      .from(bucket)
      .getPublicUrl(path)
    return data.publicUrl
  },

  async deleteFile(bucket: string, path: string) {
    const { error } = await supabase.storage
      .from(bucket)
      .remove([path])
    return { error }
  },
}

// Export default client
export default supabase
