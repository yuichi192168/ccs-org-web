-- Complete Database Setup for Educational Management System
-- Migration: 010_complete_database_setup.sql
-- This migration includes: Schema, RLS Policies, Triggers, and Sample Data

-- =============================================
-- EXTENSIONS AND INITIAL SETUP
-- =============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- TABLES
-- =============================================

-- Users table (extends auth.users)
CREATE TABLE IF NOT EXISTS public.users (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    system_id TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('student', 'faculty', 'admin')),
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_login_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Student Profiles table
CREATE TABLE IF NOT EXISTS public.student_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    student_number TEXT UNIQUE NOT NULL,
    year_level INTEGER CHECK (year_level BETWEEN 1 AND 6),
    program TEXT NOT NULL,
    gpa DECIMAL(3,2) CHECK (gpa BETWEEN 0.00 AND 4.00),
    enrollment_status TEXT DEFAULT 'enrolled' CHECK (enrollment_status IN ('enrolled', 'suspended', 'graduated', 'withdrawn')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Faculty Profiles table
CREATE TABLE IF NOT EXISTS public.faculty_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    employee_id TEXT UNIQUE NOT NULL,
    department TEXT NOT NULL,
    position TEXT NOT NULL,
    specialization TEXT,
    hire_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Admin Profiles table
CREATE TABLE IF NOT EXISTS public.admin_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    admin_level TEXT NOT NULL CHECK (admin_level IN ('super', 'department', 'system')),
    department TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Courses table
CREATE TABLE IF NOT EXISTS public.courses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_code TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    credits INTEGER NOT NULL CHECK (credits > 0),
    department TEXT NOT NULL,
    semester TEXT NOT NULL,
    academic_year TEXT NOT NULL,
    faculty_id UUID REFERENCES public.faculty_profiles(id),
    max_students INTEGER DEFAULT 50,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Course Prerequisites table
CREATE TABLE IF NOT EXISTS public.course_prerequisites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    prerequisite_course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(course_id, prerequisite_course_id)
);

-- Enrollments table
CREATE TABLE IF NOT EXISTS public.enrollments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID REFERENCES public.student_profiles(id) ON DELETE CASCADE,
    course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    enrollment_date DATE NOT NULL,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'dropped', 'completed', 'failed')),
    final_grade DECIMAL(5,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(student_id, course_id)
);

-- Academic History table
CREATE TABLE IF NOT EXISTS public.academic_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID REFERENCES public.student_profiles(id) ON DELETE CASCADE,
    course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    semester TEXT NOT NULL,
    academic_year TEXT NOT NULL,
    grade DECIMAL(5,2),
    grade_letter TEXT CHECK (grade_letter IN ('A', 'B+', 'B', 'C+', 'C', 'D', 'F')),
    credits_earned INTEGER,
    gpa_points DECIMAL(3,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Attendance table
CREATE TABLE IF NOT EXISTS public.attendance (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID REFERENCES public.student_profiles(id) ON DELETE CASCADE,
    course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('present', 'absent', 'late', 'excused')),
    remarks TEXT,
    recorded_by UUID REFERENCES public.faculty_profiles(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(student_id, course_id, date)
);

-- Medical Records table
CREATE TABLE IF NOT EXISTS public.medical_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID REFERENCES public.student_profiles(id) ON DELETE CASCADE,
    condition TEXT NOT NULL,
    diagnosis TEXT,
    treatment TEXT,
    doctor_name TEXT,
    hospital TEXT,
    diagnosis_date DATE,
    is_chronic BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Counseling Records table
CREATE TABLE IF NOT EXISTS public.counseling_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID REFERENCES public.student_profiles(id) ON DELETE CASCADE,
    counselor_id UUID REFERENCES public.faculty_profiles(id),
    session_date DATE NOT NULL,
    session_type TEXT NOT NULL CHECK (session_type IN ('academic', 'personal', 'career', 'disciplinary')),
    notes TEXT,
    recommendations TEXT,
    follow_up_required BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Discipline Records table
CREATE TABLE IF NOT EXISTS public.discipline_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID REFERENCES public.student_profiles(id) ON DELETE CASCADE,
    incident_date DATE NOT NULL,
    offense TEXT NOT NULL,
    severity TEXT NOT NULL CHECK (severity IN ('minor', 'major', 'severe')),
    action_taken TEXT,
    reported_by UUID REFERENCES public.faculty_profiles(id),
    status TEXT DEFAULT 'open' CHECK (status IN ('open', 'closed', 'appealed')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Student Documents table
CREATE TABLE IF NOT EXISTS public.student_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID REFERENCES public.student_profiles(id) ON DELETE CASCADE,
    document_type TEXT NOT NULL CHECK (document_type IN ('transcript', 'certificate', 'id', 'medical', 'other')),
    document_name TEXT NOT NULL,
    file_path TEXT NOT NULL,
    file_size INTEGER,
    mime_type TEXT,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Student Organizations table
CREATE TABLE IF NOT EXISTS public.student_organizations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    advisor_id UUID REFERENCES public.faculty_profiles(id),
    category TEXT NOT NULL,
    max_members INTEGER DEFAULT 50,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Organization Memberships table
CREATE TABLE IF NOT EXISTS public.organization_memberships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID REFERENCES public.student_organizations(id) ON DELETE CASCADE,
    student_id UUID REFERENCES public.student_profiles(id) ON DELETE CASCADE,
    position TEXT DEFAULT 'member',
    joined_at DATE NOT NULL,
    left_at DATE,
    is_active BOOLEAN DEFAULT true,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(organization_id, student_id)
);

-- Notifications table
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipient_id UUID NOT NULL,
    sender_id UUID,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('info', 'warning', 'success', 'error', 'system')),
    is_read BOOLEAN DEFAULT false,
    priority TEXT DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    read_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- System Settings table
CREATE TABLE IF NOT EXISTS public.system_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    key TEXT UNIQUE NOT NULL,
    value TEXT NOT NULL,
    description TEXT,
    category TEXT NOT NULL,
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Audit Logs table
CREATE TABLE IF NOT EXISTS public.audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID,
    action TEXT NOT NULL,
    table_name TEXT NOT NULL,
    record_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Grade Scales table
CREATE TABLE IF NOT EXISTS public.grade_scales (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    min_score DECIMAL(5,2) NOT NULL,
    max_score DECIMAL(5,2) NOT NULL,
    grade_letter TEXT NOT NULL,
    grade_points DECIMAL(3,2) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- INDEXES
-- =============================================

-- Users table indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON public.users(role);
CREATE INDEX IF NOT EXISTS idx_users_status ON public.users(status);
CREATE INDEX IF NOT EXISTS idx_users_system_id ON public.users(system_id);

-- Student Profiles indexes
CREATE INDEX IF NOT EXISTS idx_student_profiles_user_id ON public.student_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_student_profiles_student_number ON public.student_profiles(student_number);
CREATE INDEX IF NOT EXISTS idx_student_profiles_program ON public.student_profiles(program);
CREATE INDEX IF NOT EXISTS idx_student_profiles_enrollment_status ON public.student_profiles(enrollment_status);

-- Faculty Profiles indexes
CREATE INDEX IF NOT EXISTS idx_faculty_profiles_user_id ON public.faculty_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_faculty_profiles_employee_id ON public.faculty_profiles(employee_id);
CREATE INDEX IF NOT EXISTS idx_faculty_profiles_department ON public.faculty_profiles(department);

-- Admin Profiles indexes
CREATE INDEX IF NOT EXISTS idx_admin_profiles_user_id ON public.admin_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_admin_profiles_admin_level ON public.admin_profiles(admin_level);

-- Courses indexes
CREATE INDEX IF NOT EXISTS idx_courses_course_code ON public.courses(course_code);
CREATE INDEX IF NOT EXISTS idx_courses_department ON public.courses(department);
CREATE INDEX IF NOT EXISTS idx_courses_faculty_id ON public.courses(faculty_id);
CREATE INDEX IF NOT EXISTS idx_courses_is_active ON public.courses(is_active);

-- Enrollments indexes
CREATE INDEX IF NOT EXISTS idx_enrollments_student_id ON public.enrollments(student_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_course_id ON public.enrollments(course_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_status ON public.enrollments(status);

-- Academic History indexes
CREATE INDEX IF NOT EXISTS idx_academic_history_student_id ON public.academic_history(student_id);
CREATE INDEX IF NOT EXISTS idx_academic_history_course_id ON public.academic_history(course_id);
CREATE INDEX IF NOT EXISTS idx_academic_history_semester ON public.academic_history(semester);

-- Attendance indexes
CREATE INDEX IF NOT EXISTS idx_attendance_student_id ON public.attendance(student_id);
CREATE INDEX IF NOT EXISTS idx_attendance_course_id ON public.attendance(course_id);
CREATE INDEX IF NOT EXISTS idx_attendance_date ON public.attendance(date);

-- Notifications indexes
CREATE INDEX IF NOT EXISTS idx_notifications_recipient_id ON public.notifications(recipient_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON public.notifications(is_read);

-- Audit Logs indexes
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id ON public.audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON public.audit_logs(created_at);

-- =============================================
-- TRIGGERS
-- =============================================

-- Drop existing trigger functions first
DROP FUNCTION IF EXISTS public.handle_users_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_student_profiles_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_faculty_profiles_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_admin_profiles_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_courses_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_course_prerequisites_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_enrollments_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_academic_history_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_attendance_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_medical_records_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_counseling_records_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_discipline_records_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_student_documents_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_student_organizations_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_organization_memberships_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_notifications_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_system_settings_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_audit_logs_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.handle_grade_scales_updated_at() CASCADE;

-- Create trigger functions for each table
CREATE OR REPLACE FUNCTION public.handle_users_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_student_profiles_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_faculty_profiles_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_admin_profiles_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_courses_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_course_prerequisites_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_enrollments_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_academic_history_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_attendance_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_medical_records_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_counseling_records_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_discipline_records_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_student_documents_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_student_organizations_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_organization_memberships_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_notifications_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_system_settings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_audit_logs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_grade_scales_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop existing triggers
DROP TRIGGER IF EXISTS handle_users_updated_at ON public.users;
DROP TRIGGER IF EXISTS handle_student_profiles_updated_at ON public.student_profiles;
DROP TRIGGER IF EXISTS handle_faculty_profiles_updated_at ON public.faculty_profiles;
DROP TRIGGER IF EXISTS handle_admin_profiles_updated_at ON public.admin_profiles;
DROP TRIGGER IF EXISTS handle_courses_updated_at ON public.courses;
DROP TRIGGER IF EXISTS handle_course_prerequisites_updated_at ON public.course_prerequisites;
DROP TRIGGER IF EXISTS handle_enrollments_updated_at ON public.enrollments;
DROP TRIGGER IF EXISTS handle_academic_history_updated_at ON public.academic_history;
DROP TRIGGER IF EXISTS handle_attendance_updated_at ON public.attendance;
DROP TRIGGER IF EXISTS handle_medical_records_updated_at ON public.medical_records;
DROP TRIGGER IF EXISTS handle_counseling_records_updated_at ON public.counseling_records;
DROP TRIGGER IF EXISTS handle_discipline_records_updated_at ON public.discipline_records;
DROP TRIGGER IF EXISTS handle_student_documents_updated_at ON public.student_documents;
DROP TRIGGER IF EXISTS handle_student_organizations_updated_at ON public.student_organizations;
DROP TRIGGER IF EXISTS handle_organization_memberships_updated_at ON public.organization_memberships;
DROP TRIGGER IF EXISTS handle_notifications_updated_at ON public.notifications;
DROP TRIGGER IF EXISTS handle_system_settings_updated_at ON public.system_settings;
DROP TRIGGER IF EXISTS handle_audit_logs_updated_at ON public.audit_logs;
DROP TRIGGER IF EXISTS handle_grade_scales_updated_at ON public.grade_scales;

-- Create triggers
CREATE TRIGGER handle_users_updated_at
    BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_users_updated_at();

CREATE TRIGGER handle_student_profiles_updated_at
    BEFORE UPDATE ON public.student_profiles
    FOR EACH ROW EXECUTE FUNCTION public.handle_student_profiles_updated_at();

CREATE TRIGGER handle_faculty_profiles_updated_at
    BEFORE UPDATE ON public.faculty_profiles
    FOR EACH ROW EXECUTE FUNCTION public.handle_faculty_profiles_updated_at();

CREATE TRIGGER handle_admin_profiles_updated_at
    BEFORE UPDATE ON public.admin_profiles
    FOR EACH ROW EXECUTE FUNCTION public.handle_admin_profiles_updated_at();

CREATE TRIGGER handle_courses_updated_at
    BEFORE UPDATE ON public.courses
    FOR EACH ROW EXECUTE FUNCTION public.handle_courses_updated_at();

CREATE TRIGGER handle_course_prerequisites_updated_at
    BEFORE UPDATE ON public.course_prerequisites
    FOR EACH ROW EXECUTE FUNCTION public.handle_course_prerequisites_updated_at();

CREATE TRIGGER handle_enrollments_updated_at
    BEFORE UPDATE ON public.enrollments
    FOR EACH ROW EXECUTE FUNCTION public.handle_enrollments_updated_at();

CREATE TRIGGER handle_academic_history_updated_at
    BEFORE UPDATE ON public.academic_history
    FOR EACH ROW EXECUTE FUNCTION public.handle_academic_history_updated_at();

CREATE TRIGGER handle_attendance_updated_at
    BEFORE UPDATE ON public.attendance
    FOR EACH ROW EXECUTE FUNCTION public.handle_attendance_updated_at();

CREATE TRIGGER handle_medical_records_updated_at
    BEFORE UPDATE ON public.medical_records
    FOR EACH ROW EXECUTE FUNCTION public.handle_medical_records_updated_at();

CREATE TRIGGER handle_counseling_records_updated_at
    BEFORE UPDATE ON public.counseling_records
    FOR EACH ROW EXECUTE FUNCTION public.handle_counseling_records_updated_at();

CREATE TRIGGER handle_discipline_records_updated_at
    BEFORE UPDATE ON public.discipline_records
    FOR EACH ROW EXECUTE FUNCTION public.handle_discipline_records_updated_at();

CREATE TRIGGER handle_student_documents_updated_at
    BEFORE UPDATE ON public.student_documents
    FOR EACH ROW EXECUTE FUNCTION public.handle_student_documents_updated_at();

CREATE TRIGGER handle_student_organizations_updated_at
    BEFORE UPDATE ON public.student_organizations
    FOR EACH ROW EXECUTE FUNCTION public.handle_student_organizations_updated_at();

CREATE TRIGGER handle_organization_memberships_updated_at
    BEFORE UPDATE ON public.organization_memberships
    FOR EACH ROW EXECUTE FUNCTION public.handle_organization_memberships_updated_at();

CREATE TRIGGER handle_notifications_updated_at
    BEFORE UPDATE ON public.notifications
    FOR EACH ROW EXECUTE FUNCTION public.handle_notifications_updated_at();

CREATE TRIGGER handle_system_settings_updated_at
    BEFORE UPDATE ON public.system_settings
    FOR EACH ROW EXECUTE FUNCTION public.handle_system_settings_updated_at();

CREATE TRIGGER handle_audit_logs_updated_at
    BEFORE UPDATE ON public.audit_logs
    FOR EACH ROW EXECUTE FUNCTION public.handle_audit_logs_updated_at();

CREATE TRIGGER handle_grade_scales_updated_at
    BEFORE UPDATE ON public.grade_scales
    FOR EACH ROW EXECUTE FUNCTION public.handle_grade_scales_updated_at();

-- =============================================
-- ROW LEVEL SECURITY (RLS)
-- =============================================

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.faculty_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.course_prerequisites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.academic_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.medical_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.counseling_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.discipline_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organization_memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.system_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.grade_scales ENABLE ROW LEVEL SECURITY;

-- =============================================
-- RLS POLICIES
-- =============================================

-- Drop existing policies first
DROP POLICY IF EXISTS "Users can view own profile" ON public.users;
DROP POLICY IF EXISTS "Users can update own profile" ON public.users;
DROP POLICY IF EXISTS "Admins can create users" ON public.users;
DROP POLICY IF EXISTS "Admins can delete users" ON public.users;
DROP POLICY IF EXISTS "Service role can bypass RLS for users" ON public.users;

-- Users table policies
CREATE POLICY "Users can view own profile" ON public.users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.users
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Admins can create users" ON public.users
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can delete users" ON public.users
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Service role can bypass RLS for users" ON public.users
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM information_schema.table_privileges 
            WHERE table_name = 'users' 
            AND privilege_type = 'SELECT'
            AND grantee = CURRENT_USER
            AND grantor = 'service_role'
        )
    );

-- Student Profiles policies
DROP POLICY IF EXISTS "Students can view own profile" ON public.student_profiles;
DROP POLICY IF EXISTS "Students can update own profile" ON public.student_profiles;
DROP POLICY IF EXISTS "Faculty and admins can view student profiles" ON public.student_profiles;
DROP POLICY IF EXISTS "Faculty and admins can update student profiles" ON public.student_profiles;
DROP POLICY IF EXISTS "Admins can create student profiles" ON public.student_profiles;
DROP POLICY IF EXISTS "Admins can delete student profiles" ON public.student_profiles;

CREATE POLICY "Students can view own profile" ON public.student_profiles
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Students can update own profile" ON public.student_profiles
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Faculty and admins can view student profiles" ON public.student_profiles
    FOR SELECT USING (
        auth.uid() = user_id OR
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

CREATE POLICY "Faculty and admins can update student profiles" ON public.student_profiles
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

CREATE POLICY "Admins can create student profiles" ON public.student_profiles
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can delete student profiles" ON public.student_profiles
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Faculty Profiles policies
DROP POLICY IF EXISTS "Faculty can view own profile" ON public.faculty_profiles;
DROP POLICY IF EXISTS "Faculty can update own profile" ON public.faculty_profiles;
DROP POLICY IF EXISTS "Admins can view all faculty profiles" ON public.faculty_profiles;
DROP POLICY IF EXISTS "Admins can update faculty profiles" ON public.faculty_profiles;
DROP POLICY IF EXISTS "Admins can create faculty profiles" ON public.faculty_profiles;
DROP POLICY IF EXISTS "Admins can delete faculty profiles" ON public.faculty_profiles;

CREATE POLICY "Faculty can view own profile" ON public.faculty_profiles
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Faculty can update own profile" ON public.faculty_profiles
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all faculty profiles" ON public.faculty_profiles
    FOR SELECT USING (
        auth.uid() = user_id OR
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

CREATE POLICY "Admins can update faculty profiles" ON public.faculty_profiles
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

CREATE POLICY "Admins can create faculty profiles" ON public.faculty_profiles
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can delete faculty profiles" ON public.faculty_profiles
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Admin Profiles policies
DROP POLICY IF EXISTS "Admins can view own profile" ON public.admin_profiles;
DROP POLICY IF EXISTS "Admins can update own profile" ON public.admin_profiles;
DROP POLICY IF EXISTS "System admins can create admin profiles" ON public.admin_profiles;
DROP POLICY IF EXISTS "System admins can delete admin profiles" ON public.admin_profiles;

CREATE POLICY "Admins can view own profile" ON public.admin_profiles
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Admins can update own profile" ON public.admin_profiles
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "System admins can create admin profiles" ON public.admin_profiles
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

CREATE POLICY "System admins can delete admin profiles" ON public.admin_profiles
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Courses policies
DROP POLICY IF EXISTS "Authenticated users can view active courses" ON public.courses;
DROP POLICY IF EXISTS "Faculty and admins can create courses" ON public.courses;
DROP POLICY IF EXISTS "Course creators can update own courses" ON public.courses;
DROP POLICY IF EXISTS "Course creators can delete own courses" ON public.courses;

CREATE POLICY "Authenticated users can view active courses" ON public.courses
    FOR SELECT USING (is_active = true);

CREATE POLICY "Faculty and admins can create courses" ON public.courses
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

CREATE POLICY "Course creators can update own courses" ON public.courses
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

CREATE POLICY "Course creators can delete own courses" ON public.courses
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Enrollments policies
DROP POLICY IF EXISTS "Students can view own enrollments" ON public.enrollments;
DROP POLICY IF EXISTS "Students can create own enrollments" ON public.enrollments;
DROP POLICY IF EXISTS "Faculty and admins can view all enrollments" ON public.enrollments;
DROP POLICY IF EXISTS "Faculty and admins can update enrollments" ON public.enrollments;
DROP POLICY IF EXISTS "Admins can create enrollments" ON public.enrollments;
DROP POLICY IF EXISTS "Faculty and admins can delete enrollments" ON public.enrollments;

CREATE POLICY "Students can view own enrollments" ON public.enrollments
    FOR SELECT USING (auth.uid() = (SELECT user_id FROM public.student_profiles WHERE id = student_id));

CREATE POLICY "Students can create own enrollments" ON public.enrollments
    FOR INSERT WITH CHECK (auth.uid() = (SELECT user_id FROM public.student_profiles WHERE id = student_id));

CREATE POLICY "Faculty and admins can view all enrollments" ON public.enrollments
    FOR SELECT USING (
        auth.uid() = (SELECT user_id FROM public.student_profiles WHERE id = student_id) OR
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

CREATE POLICY "Faculty and admins can update enrollments" ON public.enrollments
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

CREATE POLICY "Admins can create enrollments" ON public.enrollments
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Faculty and admins can delete enrollments" ON public.enrollments
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Academic History policies
DROP POLICY IF EXISTS "Students can view own academic history" ON public.academic_history;
DROP POLICY IF EXISTS "Faculty and admins can view academic history" ON public.academic_history;
DROP POLICY IF EXISTS "Faculty and admins can create academic history" ON public.academic_history;
DROP POLICY IF EXISTS "Faculty and admins can update academic history" ON public.academic_history;
DROP POLICY IF EXISTS "Faculty and admins can delete academic history" ON public.academic_history;

CREATE POLICY "Students can view own academic history" ON public.academic_history
    FOR SELECT USING (auth.uid() = (SELECT user_id FROM public.student_profiles WHERE id = student_id));

CREATE POLICY "Faculty and admins can view academic history" ON public.academic_history
    FOR SELECT USING (
        auth.uid() = (SELECT user_id FROM public.student_profiles WHERE id = student_id) OR
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

CREATE POLICY "Faculty and admins can create academic history" ON public.academic_history
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

CREATE POLICY "Faculty and admins can update academic history" ON public.academic_history
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

CREATE POLICY "Faculty and admins can delete academic history" ON public.academic_history
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Notifications policies
DROP POLICY IF EXISTS "Users can view own notifications" ON public.notifications;
DROP POLICY IF EXISTS "Users can update own notifications" ON public.notifications;
DROP POLICY IF EXISTS "Authenticated users can create notifications" ON public.notifications;
DROP POLICY IF EXISTS "Users can delete own notifications" ON public.notifications;

CREATE POLICY "Users can view own notifications" ON public.notifications
    FOR SELECT USING (auth.uid() = recipient_id);

CREATE POLICY "Users can update own notifications" ON public.notifications
    FOR UPDATE USING (auth.uid() = recipient_id);

CREATE POLICY "Authenticated users can create notifications" ON public.notifications
    FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Users can delete own notifications" ON public.notifications
    FOR DELETE USING (auth.uid() = recipient_id);

-- =============================================
-- SAMPLE DATA
-- =============================================

-- Step 1: Insert auth.users first (minimal records for testing)
INSERT INTO auth.users (id, email, email_confirmed_at, phone, phone_confirmed_at, last_sign_in_at, created_at, updated_at, user_metadata, app_metadata, is_anonymous)
VALUES 
('550e8400-e29b-41d4-a716-446655440001', 'admin@ccs.edu', NOW(), NULL, NULL, NOW(), NOW(), NOW(), '{"name": "System Administrator"}', '{"role": "admin"}', false),
('550e8400-e29b-41d4-a716-446655440002', 'faculty1@ccs.edu', NOW(), NULL, NULL, NOW(), NOW(), NOW(), '{"name": "Dr. Sarah Johnson"}', '{"role": "faculty"}', false),
('550e8400-e29b-41d4-a716-446655440003', 'faculty2@ccs.edu', NOW(), NULL, NULL, NOW(), NOW(), NOW(), '{"name": "Prof. Michael Chen"}', '{"role": "faculty"}', false),
('550e8400-e29b-41d4-a716-446655440004', 'student1@ccs.edu', NOW(), NULL, NULL, NOW(), NOW(), NOW(), '{"name": "John Smith"}', '{"role": "student"}', false),
('550e8400-e29b-41d4-a716-446655440005', 'student2@ccs.edu', NOW(), NULL, NULL, NOW(), NOW(), NOW(), '{"name": "Emily Davis"}', '{"role": "student"}', false),
('550e8400-e29b-41d4-a716-446655440006', 'student3@ccs.edu', NOW(), NULL, NULL, NOW(), NOW(), NOW(), '{"name": "Robert Wilson"}', '{"role": "student"}', false)
ON CONFLICT (id) DO NOTHING;

-- Step 2: Insert public.users
INSERT INTO public.users (id, system_id, name, email, role, status, joined_at, last_login_at, created_at, updated_at)
VALUES 
('550e8400-e29b-41d4-a716-446655440001', 'ADMIN-001', 'System Administrator', 'admin@ccs.edu', 'admin', 'active', '2023-01-01 09:00:00', NOW(), NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440002', 'FAC-001', 'Dr. Sarah Johnson', 'faculty1@ccs.edu', 'faculty', 'active', '2023-01-15 10:00:00', NOW(), NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440003', 'FAC-002', 'Prof. Michael Chen', 'faculty2@ccs.edu', 'faculty', 'active', '2023-01-16 11:00:00', NOW(), NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440004', 'STU-001', 'John Smith', 'student1@ccs.edu', 'student', 'active', '2023-08-15 08:00:00', NOW(), NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440005', 'STU-002', 'Emily Davis', 'student2@ccs.edu', 'student', 'active', '2023-08-16 09:00:00', NOW(), NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440006', 'STU-003', 'Robert Wilson', 'student3@ccs.edu', 'student', 'active', '2023-08-17 10:00:00', NOW(), NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Step 3: Insert Admin Profiles
INSERT INTO public.admin_profiles (id, user_id, admin_level, department, created_at, updated_at)
VALUES 
('560e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'super', 'IT Department', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Step 4: Insert Faculty Profiles
INSERT INTO public.faculty_profiles (id, user_id, employee_id, department, position, specialization, hire_date, created_at, updated_at)
VALUES 
('560e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', 'EMP-001', 'Computer Science', 'Associate Professor', 'Database Systems', '2020-08-01', NOW(), NOW()),
('560e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', 'EMP-002', 'Computer Science', 'Assistant Professor', 'Web Development', '2021-08-01', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Step 5: Insert Student Profiles
INSERT INTO public.student_profiles (id, user_id, student_number, year_level, program, gpa, enrollment_status, created_at, updated_at)
VALUES 
('560e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440004', '2023-001', 3, 'Computer Science', 3.75, 'enrolled', NOW(), NOW()),
('560e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440005', '2023-002', 2, 'Computer Science', 3.50, 'enrolled', NOW(), NOW()),
('560e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440006', '2023-003', 1, 'Computer Science', 3.25, 'enrolled', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Step 6: Insert Courses
INSERT INTO public.courses (id, course_code, title, description, credits, department, semester, academic_year, faculty_id, max_students, is_active, created_at, updated_at)
VALUES 
('570e8400-e29b-41d4-a716-446655440001', 'CS101', 'Introduction to Computer Science', 'Fundamental concepts of computer science and programming', 3, 'Computer Science', 'First Semester', '2023-2024', '560e8400-e29b-41d4-a716-446655440002', 50, true, NOW(), NOW()),
('570e8400-e29b-41d4-a716-446655440002', 'CS102', 'Database Management Systems', 'Relational database design and SQL', 3, 'Computer Science', 'First Semester', '2023-2024', '560e8400-e29b-41d4-a716-446655440002', 40, true, NOW(), NOW()),
('570e8400-e29b-41d4-a716-446655440003', 'CS103', 'Web Development', 'Modern web development technologies', 3, 'Computer Science', 'First Semester', '2023-2024', '560e8400-e29b-41d4-a716-446655440003', 45, true, NOW(), NOW()),
('570e8400-e29b-41d4-a716-446655440004', 'CS104', 'Data Structures and Algorithms', 'Advanced data structures and algorithm analysis', 4, 'Computer Science', 'Second Semester', '2023-2024', '560e8400-e29b-41d4-a716-446655440002', 35, true, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Step 7: Insert Enrollments
INSERT INTO public.enrollments (id, student_id, course_id, enrollment_date, status, created_at, updated_at)
VALUES 
('580e8400-e29b-41d4-a716-446655440001', '560e8400-e29b-41d4-a716-446655440004', '570e8400-e29b-41d4-a716-446655440001', '2023-08-20', 'active', NOW(), NOW()),
('580e8400-e29b-41d4-a716-446655440002', '560e8400-e29b-41d4-a716-446655440004', '570e8400-e29b-41d4-a716-446655440002', '2023-08-20', 'active', NOW(), NOW()),
('580e8400-e29b-41d4-a716-446655440003', '560e8400-e29b-41d4-a716-446655440005', '570e8400-e29b-41d4-a716-446655440001', '2023-08-21', 'active', NOW(), NOW()),
('580e8400-e29b-41d4-a716-446655440004', '560e8400-e29b-41d4-a716-446655440005', '570e8400-e29b-41d4-a716-446655440003', '2023-08-21', 'active', NOW(), NOW()),
('580e8400-e29b-41d4-a716-446655440005', '560e8400-e29b-41d4-a716-446655440006', '570e8400-e29b-41d4-a716-446655440001', '2023-08-22', 'active', NOW(), NOW())
ON CONFLICT (student_id, course_id) DO NOTHING;

-- Step 8: Insert Academic History
INSERT INTO public.academic_history (id, student_id, course_id, semester, academic_year, grade, grade_letter, credits_earned, gpa_points, created_at, updated_at)
VALUES 
('590e8400-e29b-41d4-a716-446655440001', '560e8400-e29b-41d4-a716-446655440004', '570e8400-e29b-41d4-a716-446655440001', 'First Semester', '2022-2023', 92.50, 'A', 3, 12.00, NOW(), NOW()),
('590e8400-e29b-41d4-a716-446655440002', '560e8400-e29b-41d4-a716-446655440004', '570e8400-e29b-41d4-a716-446655440002', 'First Semester', '2022-2023', 88.00, 'B+', 3, 10.50, NOW(), NOW()),
('590e8400-e29b-41d4-a716-446655440003', '560e8400-e29b-41d4-a716-446655440005', '570e8400-e29b-41d4-a716-446655440001', 'First Semester', '2022-2023', 85.50, 'B', 3, 9.00, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Step 9: Insert Attendance
INSERT INTO public.attendance (id, student_id, course_id, date, status, remarks, recorded_by, created_at, updated_at)
VALUES 
('600e8400-e29b-41d4-a716-446655440001', '560e8400-e29b-41d4-a716-446655440004', '570e8400-e29b-41d4-a716-446655440001', '2023-08-25', 'present', NULL, '560e8400-e29b-41d4-a716-446655440002', NOW(), NOW()),
('600e8400-e29b-41d4-a716-446655440002', '560e8400-e29b-41d4-a716-446655440004', '570e8400-e29b-41d4-a716-446655440002', '2023-08-26', 'present', NULL, '560e8400-e29b-41d4-a716-446655440002', NOW(), NOW()),
('600e8400-e29b-41d4-a716-446655440003', '560e8400-e29b-41d4-a716-446655440005', '570e8400-e29b-41d4-a716-446655440001', '2023-08-25', 'late', '5 minutes late', '560e8400-e29b-41d4-a716-446655440002', NOW(), NOW()),
('600e8400-e29b-41d4-a716-446655440004', '560e8400-e29b-41d4-a716-446655440006', '570e8400-e29b-41d4-a716-446655440001', '2023-08-25', 'absent', 'No excuse', '560e8400-e29b-41d4-a716-446655440002', NOW(), NOW())
ON CONFLICT (student_id, course_id, date) DO NOTHING;

-- Step 10: Insert Medical Records
INSERT INTO public.medical_records (id, student_id, condition, diagnosis, treatment, doctor_name, hospital, diagnosis_date, is_chronic, created_at, updated_at)
VALUES 
('610e8400-e29b-41d4-a716-446655440001', '560e8400-e29b-41d4-a716-446655440004', 'Asthma', 'Mild persistent asthma', 'Inhaler as needed', 'Dr. Smith', 'City General Hospital', '2022-03-15', true, NOW(), NOW()),
('610e8400-e29b-41d4-a716-446655440002', '560e8400-e29b-41d4-a716-446655440005', 'Allergies', 'Seasonal allergies', 'Antihistamines', 'Dr. Johnson', 'Allergy Clinic', '2023-04-20', false, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Step 11: Insert Counseling Records
INSERT INTO public.counseling_records (id, student_id, counselor_id, session_date, session_type, notes, recommendations, follow_up_required, created_at, updated_at)
VALUES 
('620e8400-e29b-41d4-a716-446655440001', '560e8400-e29b-41d4-a716-446655440004', '560e8400-e29b-41d4-a716-446655440002', '2023-09-01', 'academic', 'Student struggling with time management', 'Create study schedule', true, NOW(), NOW()),
('620e8400-e29b-41d4-a716-446655440002', '560e8400-e29b-41d4-a716-446655440005', '560e8400-e29b-41d4-a716-446655440002', '2023-09-15', 'personal', 'Stress management discussion', 'Consider stress reduction techniques', false, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Step 12: Insert Discipline Records
INSERT INTO public.discipline_records (id, student_id, incident_date, offense, severity, action_taken, reported_by, status, created_at, updated_at)
VALUES 
('630e8400-e29b-41d4-a716-446655440001', '560e8400-e29b-41d4-a716-446655440006', '2023-08-30', 'Late submission', 'minor', 'Warning issued', '560e8400-e29b-41d4-a716-446655440002', 'closed', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Step 13: Insert Student Documents
INSERT INTO public.student_documents (id, student_id, document_type, document_name, file_path, file_size, mime_type, uploaded_at, created_at, updated_at)
VALUES 
('640e8400-e29b-41d4-a716-446655440001', '560e8400-e29b-41d4-a716-446655440004', 'transcript', 'Official Transcript', '/uploads/student-documents/transcript_001.pdf', 245760, 'application/pdf', NOW(), NOW(), NOW()),
('640e8400-e29b-41d4-a716-446655440002', '560e8400-e29b-41d4-a716-446655440005', 'id', 'Student ID Card', '/uploads/student-documents/id_card_002.jpg', 153600, 'image/jpeg', NOW(), NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Step 14: Insert Student Organizations
INSERT INTO public.student_organizations (id, name, description, advisor_id, category, max_members, is_active, created_at, updated_at)
VALUES 
('650e8400-e29b-41d4-a716-446655440001', 'Computer Science Club', 'Promoting computer science education and activities', '560e8400-e29b-41d4-a716-446655440002', 'academic', 50, true, NOW(), NOW()),
('650e8400-e29b-41d4-a716-446655440002', 'Web Development Society', 'Learning modern web technologies', '560e8400-e29b-41d4-a716-446655440003', 'technical', 40, true, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Step 15: Insert Organization Memberships
INSERT INTO public.organization_memberships (id, organization_id, student_id, position, joined_at, left_at, is_active, updated_at)
VALUES 
('660e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '560e8400-e29b-41d4-a716-446655440004', 'president', '2023-08-20', NULL, true, NOW()),
('660e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440001', '560e8400-e29b-41d4-a716-446655440005', 'member', '2023-08-21', NULL, true, NOW()),
('660e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440002', '560e8400-e29b-41d4-a716-446655440004', 'member', '2023-08-22', NULL, true, NOW())
ON CONFLICT (organization_id, student_id) DO NOTHING;

-- Step 16: Insert Notifications
INSERT INTO public.notifications (id, recipient_id, sender_id, title, message, type, is_read, priority, created_at, read_at, updated_at)
VALUES 
('670e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', 'Welcome to CS101', 'Your enrollment in Introduction to Computer Science has been confirmed. Please check the course schedule.', 'info', false, 'normal', '2023-08-15 09:30:00', NULL, NOW()),
('670e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440003', 'Assignment Due', 'Database Management Systems Assignment 1 is due on Friday, September 1st.', 'warning', false, 'high', '2023-08-25 14:00:00', NULL, NOW()),
('670e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440001', 'System Maintenance', 'The system will be under maintenance this weekend from Saturday 10 PM to Sunday 2 AM.', 'system', true, 'low', '2023-08-28 16:00:00', '2023-08-28 16:30:00', NOW())
ON CONFLICT (id) DO NOTHING;

-- Step 17: Insert System Settings
INSERT INTO public.system_settings (id, key, value, description, category, is_public, created_at, updated_at)
VALUES 
('680e8400-e29b-41d4-a716-446655440001', 'current_semester', 'First Semester', 'Current semester', 'academic', true, NOW(), NOW()),
('680e8400-e29b-41d4-a716-446655440002', 'max_units_per_semester', '24', 'Maximum units a student can enroll per semester', 'academic', true, NOW(), NOW()),
('680e8400-e29b-41d4-a716-446655440003', 'grading_system', 'percentage', 'Grading system type (percentage or gpa)', 'academic', true, NOW(), NOW()),
('680e8400-e29b-41d4-a716-446655440004', 'maintenance_mode', 'false', 'System maintenance mode status', 'system', false, NOW(), NOW())
ON CONFLICT (key) DO NOTHING;

-- Step 18: Insert Grade Scales
INSERT INTO public.grade_scales (id, name, description, min_score, max_score, grade_letter, grade_points, is_active, created_at, updated_at)
VALUES 
('690e8400-e29b-41d4-a716-446655440001', 'Excellent', 'Outstanding performance', 90, 100, 'A', 4.00, true, NOW(), NOW()),
('690e8400-e29b-41d4-a716-446655440002', 'Very Good', 'Above average performance', 85, 89.99, 'B+', 3.50, true, NOW(), NOW()),
('690e8400-e29b-41d4-a716-446655440003', 'Good', 'Average performance', 80, 84.99, 'B', 3.00, true, NOW(), NOW()),
('690e8400-e29b-41d4-a716-446655440004', 'Satisfactory', 'Below average but passing', 75, 79.99, 'C+', 2.50, true, NOW(), NOW()),
('690e8400-e29b-41d4-a716-446655440005', 'Fair', 'Minimum passing performance', 70, 74.99, 'C', 2.00, true, NOW(), NOW()),
('690e8400-e29b-41d4-a716-446655440006', 'Poor', 'Below passing', 60, 69.99, 'D', 1.00, true, NOW(), NOW()),
('690e8400-e29b-41d4-a716-446655440007', 'Failure', 'Failing performance', 0, 59.99, 'F', 0.00, true, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- =============================================
-- COMPLETION
-- =============================================

-- Create a completion record
INSERT INTO public.audit_logs (id, user_id, action, table_name, record_id, new_values, created_at, updated_at)
VALUES 
('700e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'DATABASE_SETUP_COMPLETE', 'system', NULL, '{"message": "Complete database setup with schema, RLS policies, triggers, and sample data completed successfully"}', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;
