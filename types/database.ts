export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5"
  }
  public: {
    Tables: {
      academic_history: {
        Row: {
          academic_year: string
          course_id: string | null
          created_at: string | null
          credits_earned: number | null
          gpa_points: number | null
          grade: number | null
          grade_letter: string | null
          id: string
          semester: string
          student_id: string | null
          updated_at: string | null
        }
        Insert: {
          academic_year: string
          course_id?: string | null
          created_at?: string | null
          credits_earned?: number | null
          gpa_points?: number | null
          grade?: number | null
          grade_letter?: string | null
          id?: string
          semester: string
          student_id?: string | null
          updated_at?: string | null
        }
        Update: {
          academic_year?: string
          course_id?: string | null
          created_at?: string | null
          credits_earned?: number | null
          gpa_points?: number | null
          grade?: number | null
          grade_letter?: string | null
          id?: string
          semester?: string
          student_id?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "academic_history_course_id_fkey"
            columns: ["course_id"]
            isOneToOne: false
            referencedRelation: "courses"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "academic_history_student_id_fkey"
            columns: ["student_id"]
            isOneToOne: false
            referencedRelation: "student_profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      admin_profiles: {
        Row: {
          admin_level: string
          created_at: string | null
          department: string | null
          id: string
          updated_at: string | null
          user_id: string
        }
        Insert: {
          admin_level: string
          created_at?: string | null
          department?: string | null
          id?: string
          updated_at?: string | null
          user_id: string
        }
        Update: {
          admin_level?: string
          created_at?: string | null
          department?: string | null
          id?: string
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "admin_profiles_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: true
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      attendance: {
        Row: {
          course_id: string | null
          created_at: string | null
          date: string
          id: string
          recorded_by: string | null
          remarks: string | null
          status: string
          student_id: string | null
          updated_at: string | null
        }
        Insert: {
          course_id?: string | null
          created_at?: string | null
          date: string
          id?: string
          recorded_by?: string | null
          remarks?: string | null
          status: string
          student_id?: string | null
          updated_at?: string | null
        }
        Update: {
          course_id?: string | null
          created_at?: string | null
          date?: string
          id?: string
          recorded_by?: string | null
          remarks?: string | null
          status?: string
          student_id?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "attendance_course_id_fkey"
            columns: ["course_id"]
            isOneToOne: false
            referencedRelation: "courses"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "attendance_recorded_by_fkey"
            columns: ["recorded_by"]
            isOneToOne: false
            referencedRelation: "faculty_profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "attendance_student_id_fkey"
            columns: ["student_id"]
            isOneToOne: false
            referencedRelation: "student_profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      audit_logs: {
        Row: {
          action: string
          created_at: string | null
          id: string
          ip_address: unknown
          new_values: Json | null
          old_values: Json | null
          record_id: string | null
          table_name: string
          updated_at: string | null
          user_agent: string | null
          user_id: string | null
        }
        Insert: {
          action: string
          created_at?: string | null
          id?: string
          ip_address?: unknown
          new_values?: Json | null
          old_values?: Json | null
          record_id?: string | null
          table_name: string
          updated_at?: string | null
          user_agent?: string | null
          user_id?: string | null
        }
        Update: {
          action?: string
          created_at?: string | null
          id?: string
          ip_address?: unknown
          new_values?: Json | null
          old_values?: Json | null
          record_id?: string | null
          table_name?: string
          updated_at?: string | null
          user_agent?: string | null
          user_id?: string | null
        }
        Relationships: []
      }
      counseling_records: {
        Row: {
          counselor_id: string | null
          created_at: string | null
          follow_up_required: boolean | null
          id: string
          notes: string | null
          recommendations: string | null
          session_date: string
          session_type: string
          student_id: string | null
          updated_at: string | null
        }
        Insert: {
          counselor_id?: string | null
          created_at?: string | null
          follow_up_required?: boolean | null
          id?: string
          notes?: string | null
          recommendations?: string | null
          session_date: string
          session_type: string
          student_id?: string | null
          updated_at?: string | null
        }
        Update: {
          counselor_id?: string | null
          created_at?: string | null
          follow_up_required?: boolean | null
          id?: string
          notes?: string | null
          recommendations?: string | null
          session_date?: string
          session_type?: string
          student_id?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "counseling_records_counselor_id_fkey"
            columns: ["counselor_id"]
            isOneToOne: false
            referencedRelation: "faculty_profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "counseling_records_student_id_fkey"
            columns: ["student_id"]
            isOneToOne: false
            referencedRelation: "student_profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      course_prerequisites: {
        Row: {
          course_id: string | null
          created_at: string | null
          id: string
          prerequisite_course_id: string | null
          updated_at: string | null
        }
        Insert: {
          course_id?: string | null
          created_at?: string | null
          id?: string
          prerequisite_course_id?: string | null
          updated_at?: string | null
        }
        Update: {
          course_id?: string | null
          created_at?: string | null
          id?: string
          prerequisite_course_id?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "course_prerequisites_course_id_fkey"
            columns: ["course_id"]
            isOneToOne: false
            referencedRelation: "courses"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "course_prerequisites_prerequisite_course_id_fkey"
            columns: ["prerequisite_course_id"]
            isOneToOne: false
            referencedRelation: "courses"
            referencedColumns: ["id"]
          },
        ]
      }
      courses: {
        Row: {
          academic_year: string
          course_code: string
          created_at: string | null
          credits: number
          department: string
          description: string | null
          faculty_id: string | null
          id: string
          is_active: boolean | null
          max_students: number | null
          semester: string
          title: string
          updated_at: string | null
        }
        Insert: {
          academic_year: string
          course_code: string
          created_at?: string | null
          credits: number
          department: string
          description?: string | null
          faculty_id?: string | null
          id?: string
          is_active?: boolean | null
          max_students?: number | null
          semester: string
          title: string
          updated_at?: string | null
        }
        Update: {
          academic_year?: string
          course_code?: string
          created_at?: string | null
          credits?: number
          department?: string
          description?: string | null
          faculty_id?: string | null
          id?: string
          is_active?: boolean | null
          max_students?: number | null
          semester?: string
          title?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "courses_faculty_id_fkey"
            columns: ["faculty_id"]
            isOneToOne: false
            referencedRelation: "faculty_profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      discipline_records: {
        Row: {
          action_taken: string | null
          created_at: string | null
          id: string
          incident_date: string
          offense: string
          reported_by: string | null
          severity: string
          status: string | null
          student_id: string | null
          updated_at: string | null
        }
        Insert: {
          action_taken?: string | null
          created_at?: string | null
          id?: string
          incident_date: string
          offense: string
          reported_by?: string | null
          severity: string
          status?: string | null
          student_id?: string | null
          updated_at?: string | null
        }
        Update: {
          action_taken?: string | null
          created_at?: string | null
          id?: string
          incident_date?: string
          offense?: string
          reported_by?: string | null
          severity?: string
          status?: string | null
          student_id?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "discipline_records_reported_by_fkey"
            columns: ["reported_by"]
            isOneToOne: false
            referencedRelation: "faculty_profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "discipline_records_student_id_fkey"
            columns: ["student_id"]
            isOneToOne: false
            referencedRelation: "student_profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      enrollments: {
        Row: {
          course_id: string | null
          created_at: string | null
          enrollment_date: string
          final_grade: number | null
          id: string
          status: string | null
          student_id: string | null
          updated_at: string | null
        }
        Insert: {
          course_id?: string | null
          created_at?: string | null
          enrollment_date: string
          final_grade?: number | null
          id?: string
          status?: string | null
          student_id?: string | null
          updated_at?: string | null
        }
        Update: {
          course_id?: string | null
          created_at?: string | null
          enrollment_date?: string
          final_grade?: number | null
          id?: string
          status?: string | null
          student_id?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "enrollments_course_id_fkey"
            columns: ["course_id"]
            isOneToOne: false
            referencedRelation: "courses"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "enrollments_student_id_fkey"
            columns: ["student_id"]
            isOneToOne: false
            referencedRelation: "student_profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      faculty_profiles: {
        Row: {
          created_at: string | null
          department: string
          employee_id: string
          hire_date: string
          id: string
          position: string
          specialization: string | null
          updated_at: string | null
          user_id: string
        }
        Insert: {
          created_at?: string | null
          department: string
          employee_id: string
          hire_date: string
          id?: string
          position: string
          specialization?: string | null
          updated_at?: string | null
          user_id: string
        }
        Update: {
          created_at?: string | null
          department?: string
          employee_id?: string
          hire_date?: string
          id?: string
          position?: string
          specialization?: string | null
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "faculty_profiles_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: true
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      grade_scales: {
        Row: {
          created_at: string | null
          description: string | null
          grade_letter: string
          grade_points: number
          id: string
          is_active: boolean | null
          max_score: number
          min_score: number
          name: string
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          grade_letter: string
          grade_points: number
          id?: string
          is_active?: boolean | null
          max_score: number
          min_score: number
          name: string
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          description?: string | null
          grade_letter?: string
          grade_points?: number
          id?: string
          is_active?: boolean | null
          max_score?: number
          min_score?: number
          name?: string
          updated_at?: string | null
        }
        Relationships: []
      }
      medical_records: {
        Row: {
          condition: string
          created_at: string | null
          diagnosis: string | null
          diagnosis_date: string | null
          doctor_name: string | null
          hospital: string | null
          id: string
          is_chronic: boolean | null
          student_id: string | null
          treatment: string | null
          updated_at: string | null
        }
        Insert: {
          condition: string
          created_at?: string | null
          diagnosis?: string | null
          diagnosis_date?: string | null
          doctor_name?: string | null
          hospital?: string | null
          id?: string
          is_chronic?: boolean | null
          student_id?: string | null
          treatment?: string | null
          updated_at?: string | null
        }
        Update: {
          condition?: string
          created_at?: string | null
          diagnosis?: string | null
          diagnosis_date?: string | null
          doctor_name?: string | null
          hospital?: string | null
          id?: string
          is_chronic?: boolean | null
          student_id?: string | null
          treatment?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "medical_records_student_id_fkey"
            columns: ["student_id"]
            isOneToOne: false
            referencedRelation: "student_profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      notifications: {
        Row: {
          created_at: string | null
          id: string
          is_read: boolean | null
          message: string
          priority: string | null
          read_at: string | null
          recipient_id: string
          sender_id: string | null
          title: string
          type: string
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          id?: string
          is_read?: boolean | null
          message: string
          priority?: string | null
          read_at?: string | null
          recipient_id: string
          sender_id?: string | null
          title: string
          type: string
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          id?: string
          is_read?: boolean | null
          message?: string
          priority?: string | null
          read_at?: string | null
          recipient_id?: string
          sender_id?: string | null
          title?: string
          type?: string
          updated_at?: string | null
        }
        Relationships: []
      }
      organization_memberships: {
        Row: {
          id: string
          is_active: boolean | null
          joined_at: string
          left_at: string | null
          organization_id: string | null
          position: string | null
          student_id: string | null
          updated_at: string | null
        }
        Insert: {
          id?: string
          is_active?: boolean | null
          joined_at: string
          left_at?: string | null
          organization_id?: string | null
          position?: string | null
          student_id?: string | null
          updated_at?: string | null
        }
        Update: {
          id?: string
          is_active?: boolean | null
          joined_at?: string
          left_at?: string | null
          organization_id?: string | null
          position?: string | null
          student_id?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "organization_memberships_organization_id_fkey"
            columns: ["organization_id"]
            isOneToOne: false
            referencedRelation: "student_organizations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "organization_memberships_student_id_fkey"
            columns: ["student_id"]
            isOneToOne: false
            referencedRelation: "student_profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      student_documents: {
        Row: {
          created_at: string | null
          document_name: string
          document_type: string
          file_path: string
          file_size: number | null
          id: string
          mime_type: string | null
          student_id: string | null
          updated_at: string | null
          uploaded_at: string | null
        }
        Insert: {
          created_at?: string | null
          document_name: string
          document_type: string
          file_path: string
          file_size?: number | null
          id?: string
          mime_type?: string | null
          student_id?: string | null
          updated_at?: string | null
          uploaded_at?: string | null
        }
        Update: {
          created_at?: string | null
          document_name?: string
          document_type?: string
          file_path?: string
          file_size?: number | null
          id?: string
          mime_type?: string | null
          student_id?: string | null
          updated_at?: string | null
          uploaded_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "student_documents_student_id_fkey"
            columns: ["student_id"]
            isOneToOne: false
            referencedRelation: "student_profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      student_organizations: {
        Row: {
          advisor_id: string | null
          category: string
          created_at: string | null
          description: string | null
          id: string
          is_active: boolean | null
          max_members: number | null
          name: string
          updated_at: string | null
        }
        Insert: {
          advisor_id?: string | null
          category: string
          created_at?: string | null
          description?: string | null
          id?: string
          is_active?: boolean | null
          max_members?: number | null
          name: string
          updated_at?: string | null
        }
        Update: {
          advisor_id?: string | null
          category?: string
          created_at?: string | null
          description?: string | null
          id?: string
          is_active?: boolean | null
          max_members?: number | null
          name?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "student_organizations_advisor_id_fkey"
            columns: ["advisor_id"]
            isOneToOne: false
            referencedRelation: "faculty_profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      student_profiles: {
        Row: {
          created_at: string | null
          enrollment_status: string | null
          gpa: number | null
          id: string
          program: string
          student_number: string
          updated_at: string | null
          user_id: string
          year_level: number | null
        }
        Insert: {
          created_at?: string | null
          enrollment_status?: string | null
          gpa?: number | null
          id?: string
          program: string
          student_number: string
          updated_at?: string | null
          user_id: string
          year_level?: number | null
        }
        Update: {
          created_at?: string | null
          enrollment_status?: string | null
          gpa?: number | null
          id?: string
          program?: string
          student_number?: string
          updated_at?: string | null
          user_id?: string
          year_level?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "student_profiles_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: true
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      system_settings: {
        Row: {
          category: string
          created_at: string | null
          description: string | null
          id: string
          is_public: boolean | null
          key: string
          updated_at: string | null
          value: string
        }
        Insert: {
          category: string
          created_at?: string | null
          description?: string | null
          id?: string
          is_public?: boolean | null
          key: string
          updated_at?: string | null
          value: string
        }
        Update: {
          category?: string
          created_at?: string | null
          description?: string | null
          id?: string
          is_public?: boolean | null
          key?: string
          updated_at?: string | null
          value?: string
        }
        Relationships: []
      }
      users: {
        Row: {
          created_at: string | null
          email: string
          id: string
          joined_at: string | null
          last_login_at: string | null
          name: string
          role: string
          status: string
          system_id: string
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          email: string
          id: string
          joined_at?: string | null
          last_login_at?: string | null
          name: string
          role: string
          status?: string
          system_id: string
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          email?: string
          id?: string
          joined_at?: string | null
          last_login_at?: string | null
          name?: string
          role?: string
          status?: string
          system_id?: string
          updated_at?: string | null
        }
        Relationships: []
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
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {},
  },
} as const
