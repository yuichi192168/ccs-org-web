// Database type definitions for Supabase
// Generated based on the schema in supabase/migrations/001_initial_schema.sql

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string
          system_id: string
          name: string
          email: string
          role: 'student' | 'faculty' | 'admin'
          status: 'active' | 'inactive' | 'suspended'
          joined_at: string
          last_login_at: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          system_id: string
          name: string
          email: string
          role: 'student' | 'faculty' | 'admin'
          status?: 'active' | 'inactive' | 'suspended'
          joined_at?: string
          last_login_at?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          system_id?: string
          name?: string
          email?: string
          role?: 'student' | 'faculty' | 'admin'
          status?: 'active' | 'inactive' | 'suspended'
          joined_at?: string
          last_login_at?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      student_profiles: {
        Row: {
          id: string
          user_id: string
          student_number: string
          year_level: number | null
          program: string
          gpa: number | null
          enrollment_status: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          student_number: string
          year_level?: number | null
          program: string
          gpa?: number | null
          enrollment_status?: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          student_number?: string
          year_level?: number | null
          program?: string
          gpa?: number | null
          enrollment_status?: string
          created_at?: string
          updated_at?: string
        }
      }
      faculty_profiles: {
        Row: {
          id: string
          user_id: string
          employee_number: string
          department: string
          position: string
          specialization: string | null
          hire_date: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          employee_number: string
          department: string
          position: string
          specialization?: string | null
          hire_date: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          employee_number?: string
          department?: string
          position?: string
          specialization?: string | null
          hire_date?: string
          created_at?: string
          updated_at?: string
        }
      }
      admin_profiles: {
        Row: {
          id: string
          user_id: string
          admin_level: 'basic' | 'super' | 'system'
          permissions: string[]
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          admin_level?: 'basic' | 'super' | 'system'
          permissions?: string[]
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          admin_level?: 'basic' | 'super' | 'system'
          permissions?: string[]
          created_at?: string
          updated_at?: string
        }
      }
      courses: {
        Row: {
          id: string
          course_code: string
          course_name: string
          description: string | null
          units: number
          department: string
          is_active: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          course_code: string
          course_name: string
          description?: string | null
          units?: number
          department: string
          is_active?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          course_code?: string
          course_name?: string
          description?: string | null
          units?: number
          department?: string
          is_active?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      course_prerequisites: {
        Row: {
          id: string
          course_id: string
          prerequisite_course_id: string
          created_at: string
        }
        Insert: {
          id?: string
          course_id: string
          prerequisite_course_id: string
          created_at?: string
        }
        Update: {
          id?: string
          course_id?: string
          prerequisite_course_id?: string
          created_at?: string
        }
      }
      enrollments: {
        Row: {
          id: string
          student_id: string
          course_id: string
          semester: string
          academic_year: string
          status: 'enrolled' | 'dropped' | 'completed' | 'failed'
          grade: number | null
          enrolled_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          student_id: string
          course_id: string
          semester: string
          academic_year: string
          status?: 'enrolled' | 'dropped' | 'completed' | 'failed'
          grade?: number | null
          enrolled_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          student_id?: string
          course_id?: string
          semester?: string
          academic_year?: string
          status?: 'enrolled' | 'dropped' | 'completed' | 'failed'
          grade?: number | null
          enrolled_at?: string
          updated_at?: string
        }
      }
      academic_history: {
        Row: {
          id: string
          student_id: string
          course_id: string
          semester: string
          academic_year: string
          grade: number | null
          credits_earned: number | null
          gpa_impact: number | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          student_id: string
          course_id: string
          semester: string
          academic_year: string
          grade?: number | null
          credits_earned?: number | null
          gpa_impact?: number | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          student_id?: string
          course_id?: string
          semester?: string
          academic_year?: string
          grade?: number | null
          credits_earned?: number | null
          gpa_impact?: number | null
          created_at?: string
          updated_at?: string
        }
      }
      attendance: {
        Row: {
          id: string
          student_id: string
          course_id: string
          date: string
          status: 'present' | 'absent' | 'late' | 'excused'
          remarks: string | null
          recorded_by: string | null
          created_at: string
        }
        Insert: {
          id?: string
          student_id: string
          course_id: string
          date: string
          status: 'present' | 'absent' | 'late' | 'excused'
          remarks?: string | null
          recorded_by?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          student_id?: string
          course_id?: string
          date?: string
          status?: 'present' | 'absent' | 'late' | 'excused'
          remarks?: string | null
          recorded_by?: string | null
          created_at?: string
        }
      }
      medical_records: {
        Row: {
          id: string
          student_id: string
          record_type: string
          description: string
          date_of_incident: string | null
          treatment: string | null
          physician_name: string | null
          is_confidential: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          student_id: string
          record_type: string
          description: string
          date_of_incident?: string | null
          treatment?: string | null
          physician_name?: string | null
          is_confidential?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          student_id?: string
          record_type?: string
          description?: string
          date_of_incident?: string | null
          treatment?: string | null
          physician_name?: string | null
          is_confidential?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      counseling_records: {
        Row: {
          id: string
          student_id: string
          counselor_id: string | null
          session_date: string
          session_type: string
          notes: string | null
          follow_up_required: boolean
          follow_up_date: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          student_id: string
          counselor_id?: string | null
          session_date: string
          session_type: string
          notes?: string | null
          follow_up_required?: boolean
          follow_up_date?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          student_id?: string
          counselor_id?: string | null
          session_date?: string
          session_type?: string
          notes?: string | null
          follow_up_required?: boolean
          follow_up_date?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      discipline_records: {
        Row: {
          id: string
          student_id: string
          incident_date: string
          incident_type: string
          description: string
          action_taken: string | null
          severity: 'minor' | 'major' | 'severe'
          reported_by: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          student_id: string
          incident_date: string
          incident_type: string
          description: string
          action_taken?: string | null
          severity: 'minor' | 'major' | 'severe'
          reported_by?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          student_id?: string
          incident_date?: string
          incident_type?: string
          description?: string
          action_taken?: string | null
          severity?: 'minor' | 'major' | 'severe'
          reported_by?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      student_documents: {
        Row: {
          id: string
          student_id: string
          document_type: string
          document_name: string
          file_url: string
          file_size: number | null
          mime_type: string | null
          is_verified: boolean
          verified_by: string | null
          uploaded_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          student_id: string
          document_type: string
          document_name: string
          file_url: string
          file_size?: number | null
          mime_type?: string | null
          is_verified?: boolean
          verified_by?: string | null
          uploaded_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          student_id?: string
          document_type?: string
          document_name?: string
          file_url?: string
          file_size?: number | null
          mime_type?: string | null
          is_verified?: boolean
          verified_by?: string | null
          uploaded_at?: string
          updated_at?: string
        }
      }
      student_organizations: {
        Row: {
          id: string
          name: string
          description: string | null
          advisor_id: string | null
          is_active: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          name: string
          description?: string | null
          advisor_id?: string | null
          is_active?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string
          description?: string | null
          advisor_id?: string | null
          is_active?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      organization_memberships: {
        Row: {
          id: string
          organization_id: string
          student_id: string
          position: string | null
          joined_at: string
          left_at: string | null
          is_active: boolean
        }
        Insert: {
          id?: string
          organization_id: string
          student_id: string
          position?: string | null
          joined_at?: string
          left_at?: string | null
          is_active?: boolean
        }
        Update: {
          id?: string
          organization_id?: string
          student_id?: string
          position?: string | null
          joined_at?: string
          left_at?: string | null
          is_active?: boolean
        }
      }
      notifications: {
        Row: {
          id: string
          recipient_id: string
          sender_id: string | null
          title: string
          message: string
          type: 'info' | 'warning' | 'success' | 'error' | 'system'
          is_read: boolean
          priority: 'low' | 'normal' | 'high' | 'urgent'
          created_at: string
          read_at: string | null
        }
        Insert: {
          id?: string
          recipient_id: string
          sender_id?: string | null
          title: string
          message: string
          type: 'info' | 'warning' | 'success' | 'error' | 'system'
          is_read?: boolean
          priority?: 'low' | 'normal' | 'high' | 'urgent'
          created_at?: string
          read_at?: string | null
        }
        Update: {
          id?: string
          recipient_id?: string
          sender_id?: string | null
          title?: string
          message?: string
          type?: 'info' | 'warning' | 'success' | 'error' | 'system'
          is_read?: boolean
          priority?: 'low' | 'normal' | 'high' | 'urgent'
          created_at?: string
          read_at?: string | null
        }
      }
      system_settings: {
        Row: {
          id: string
          key: string
          value: string
          description: string | null
          category: string
          is_public: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          key: string
          value: string
          description?: string | null
          category?: string
          is_public?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          key?: string
          value?: string
          description?: string | null
          category?: string
          is_public?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      audit_logs: {
        Row: {
          id: string
          user_id: string | null
          action: string
          table_name: string | null
          record_id: string | null
          old_values: Json | null
          new_values: Json | null
          ip_address: string | null
          user_agent: string | null
          created_at: string
        }
        Insert: {
          id?: string
          user_id?: string | null
          action: string
          table_name?: string | null
          record_id?: string | null
          old_values?: Json | null
          new_values?: Json | null
          ip_address?: string | null
          user_agent?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          user_id?: string | null
          action?: string
          table_name?: string | null
          record_id?: string | null
          old_values?: Json | null
          new_values?: Json | null
          ip_address?: string | null
          user_agent?: string | null
          created_at?: string
        }
      }
      grade_scales: {
        Row: {
          id: string
          name: string
          description: string | null
          min_score: number
          max_score: number
          grade_letter: string
          grade_points: number
          is_active: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          name: string
          description?: string | null
          min_score: number
          max_score: number
          grade_letter: string
          grade_points: number
          is_active?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string
          description?: string | null
          min_score?: number
          max_score?: number
          grade_letter?: string
          grade_points?: number
          is_active?: boolean
          created_at?: string
          updated_at?: string
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
  }
}
