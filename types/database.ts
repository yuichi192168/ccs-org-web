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
          employee_id: string
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
          employee_id: string
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
          employee_id?: string
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
          admin_level: 'super' | 'department' | 'system'
          department: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          admin_level: 'super' | 'department' | 'system'
          department?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          admin_level?: 'super' | 'department' | 'system'
          department?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      courses: {
        Row: {
          id: string
          course_code: string
          title: string
          description: string | null
          credits: number
          department: string
          semester: string
          academic_year: string
          faculty_id: string | null
          max_students: number
          is_active: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          course_code: string
          title: string
          description?: string | null
          credits: number
          department: string
          semester: string
          academic_year: string
          faculty_id?: string | null
          max_students?: number
          is_active?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          course_code?: string
          title?: string
          description?: string | null
          credits?: number
          department?: string
          semester?: string
          academic_year?: string
          faculty_id?: string | null
          max_students?: number
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
          enrollment_date: string
          status: 'enrolled' | 'dropped' | 'completed' | 'failed'
          final_grade: number | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          student_id: string
          course_id: string
          enrollment_date: string
          status?: 'enrolled' | 'dropped' | 'completed' | 'failed'
          final_grade?: number | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          student_id?: string
          course_id?: string
          enrollment_date?: string
          status?: 'enrolled' | 'dropped' | 'completed' | 'failed'
          final_grade?: number | null
          created_at?: string
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
          grade_letter: 'A' | 'B+' | 'B' | 'C+' | 'C' | 'D' | 'F' | null
          credits_earned: number | null
          gpa_points: number | null
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
          grade_letter?: 'A' | 'B+' | 'B' | 'C+' | 'C' | 'D' | 'F' | null
          credits_earned?: number | null
          gpa_points?: number | null
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
          grade_letter?: 'A' | 'B+' | 'B' | 'C+' | 'C' | 'D' | 'F' | null
          credits_earned?: number | null
          gpa_points?: number | null
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
          updated_at: string
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
          updated_at?: string
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
          updated_at?: string
        }
      }
      medical_records: {
        Row: {
          id: string
          student_id: string
          condition: string
          diagnosis: string | null
          treatment: string | null
          doctor_name: string | null
          hospital: string | null
          diagnosis_date: string | null
          is_chronic: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          student_id: string
          condition: string
          diagnosis?: string | null
          treatment?: string | null
          doctor_name?: string | null
          hospital?: string | null
          diagnosis_date?: string | null
          is_chronic?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          student_id?: string
          condition?: string
          diagnosis?: string | null
          treatment?: string | null
          doctor_name?: string | null
          hospital?: string | null
          diagnosis_date?: string | null
          is_chronic?: boolean
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
          session_type: 'academic' | 'personal' | 'career' | 'disciplinary'
          notes: string | null
          recommendations: string | null
          follow_up_required: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          student_id: string
          counselor_id?: string | null
          session_date: string
          session_type: 'academic' | 'personal' | 'career' | 'disciplinary'
          notes?: string | null
          recommendations?: string | null
          follow_up_required?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          student_id?: string
          counselor_id?: string | null
          session_date?: string
          session_type?: 'academic' | 'personal' | 'career' | 'disciplinary'
          notes?: string | null
          recommendations?: string | null
          follow_up_required?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      discipline_records: {
        Row: {
          id: string
          student_id: string
          incident_date: string
          offense: string
          severity: 'minor' | 'major' | 'severe'
          action_taken: string | null
          reported_by: string | null
          status: 'open' | 'closed' | 'appealed'
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          student_id: string
          incident_date: string
          offense: string
          severity: 'minor' | 'major' | 'severe'
          action_taken?: string | null
          reported_by?: string | null
          status?: 'open' | 'closed' | 'appealed'
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          student_id?: string
          incident_date?: string
          offense?: string
          severity?: 'minor' | 'major' | 'severe'
          action_taken?: string | null
          reported_by?: string | null
          status?: 'open' | 'closed' | 'appealed'
          created_at?: string
          updated_at?: string
        }
      }
      student_documents: {
        Row: {
          id: string
          student_id: string
          document_type: 'transcript' | 'certificate' | 'id' | 'medical' | 'other'
          document_name: string
          file_path: string
          file_size: number | null
          mime_type: string | null
          uploaded_at: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          student_id: string
          document_type: 'transcript' | 'certificate' | 'id' | 'medical' | 'other'
          document_name: string
          file_path: string
          file_size?: number | null
          mime_type?: string | null
          uploaded_at?: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          student_id?: string
          document_type?: 'transcript' | 'certificate' | 'id' | 'medical' | 'other'
          document_name?: string
          file_path?: string
          file_size?: number | null
          mime_type?: string | null
          uploaded_at?: string
          created_at?: string
          updated_at?: string
        }
      }
      student_organizations: {
        Row: {
          id: string
          name: string
          description: string | null
          advisor_id: string | null
          category: string
          max_members: number
          is_active: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          name: string
          description?: string | null
          advisor_id?: string | null
          category: string
          max_members?: number
          is_active?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string
          description?: string | null
          advisor_id?: string | null
          category?: string
          max_members?: number
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
          position: string
          joined_at: string
          left_at: string | null
          is_active: boolean
          updated_at: string
        }
        Insert: {
          id?: string
          organization_id: string
          student_id: string
          position?: string
          joined_at: string
          left_at?: string | null
          is_active?: boolean
          updated_at?: string
        }
        Update: {
          id?: string
          organization_id?: string
          student_id?: string
          position?: string
          joined_at?: string
          left_at?: string | null
          is_active?: boolean
          updated_at?: string
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
