import { createClient } from '@supabase/supabase-js'
import type { Database } from '@/types/database'

// Server-side client - USE ONLY IN API ROUTES AND SERVER COMPONENTS
export const createServerClient = () => {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
  const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY
  
  if (!supabaseUrl) {
    console.error('Missing NEXT_PUBLIC_SUPABASE_URL environment variable')
    throw new Error('Missing NEXT_PUBLIC_SUPABASE_URL environment variable')
  }
  
  if (!supabaseServiceKey) {
    console.error('Missing SUPABASE_SERVICE_ROLE_KEY environment variable')
    throw new Error('Missing SUPABASE_SERVICE_ROLE_KEY environment variable')
  }
  
  try {
    return createClient<Database>(supabaseUrl, supabaseServiceKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false
      }
    })
  } catch (error) {
    console.error('Failed to create Supabase server client:', error)
    throw new Error(`Failed to create Supabase client: ${error instanceof Error ? error.message : 'Unknown error'}`)
  }
}

// For admin operations (bypasses RLS)
export const createAdminClient = () => {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
  const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY
  
  if (!supabaseUrl) {
    console.error('Missing NEXT_PUBLIC_SUPABASE_URL environment variable')
    throw new Error('Missing NEXT_PUBLIC_SUPABASE_URL environment variable')
  }
  
  if (!supabaseServiceKey) {
    console.error('Missing SUPABASE_SERVICE_ROLE_KEY environment variable')
    throw new Error('Missing SUPABASE_SERVICE_ROLE_KEY environment variable')
  }
  
  try {
    return createClient<Database>(supabaseUrl, supabaseServiceKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false
      },
      global: {
        headers: {
          'x-admin-operation': 'true',
        },
      },
    })
  } catch (error) {
    console.error('Failed to create Supabase admin client:', error)
    throw new Error(`Failed to create Supabase admin client: ${error instanceof Error ? error.message : 'Unknown error'}`)
  }
}
