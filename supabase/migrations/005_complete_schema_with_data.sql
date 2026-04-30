-- Complete Educational Management System Schema with Sample Data
-- This migration creates the full schema structure and inserts comprehensive sample data

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- TABLE DEFINITIONS
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

-- Student Profiles
CREATE TABLE IF NOT EXISTS public.student_profiles (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) UNIQUE NOT NULL,
    student_number TEXT UNIQUE NOT NULL,
    course TEXT NOT NULL,
    section TEXT NOT NULL,
    year_level TEXT NOT NULL,
    admission_date DATE NOT NULL,
    gpa DECIMAL(3,2) DEFAULT 0.00,
    units_completed INTEGER DEFAULT 0,
    units_enrolled INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Faculty Profiles
CREATE TABLE IF NOT EXISTS public.faculty_profiles (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) UNIQUE NOT NULL,
    employee_number TEXT UNIQUE NOT NULL,
    department TEXT NOT NULL,
    position TEXT NOT NULL,
    specialization TEXT,
    hire_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Admin Profiles
CREATE TABLE IF NOT EXISTS public.admin_profiles (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) UNIQUE NOT NULL,
    admin_level TEXT NOT NULL DEFAULT 'basic' CHECK (admin_level IN ('basic', 'super', 'system')),
    permissions TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Courses
CREATE TABLE IF NOT EXISTS public.courses (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    course_code TEXT UNIQUE NOT NULL,
    course_name TEXT NOT NULL,
    description TEXT,
    units INTEGER NOT NULL DEFAULT 3,
    department TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Course Prerequisites
CREATE TABLE IF NOT EXISTS public.course_prerequisites (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    prerequisite_course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(course_id, prerequisite_course_id)
);

-- Enrollments
CREATE TABLE IF NOT EXISTS public.enrollments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    student_id UUID REFERENCES public.student_profiles(id) ON DELETE CASCADE,
    course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    semester TEXT NOT NULL,
    academic_year TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'enrolled' CHECK (status IN ('enrolled', 'dropped', 'completed', 'failed')),
    grade DECIMAL(5,2),
    enrolled_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(student_id, course_id, semester, academic_year)
);

-- Academic History
CREATE TABLE IF NOT EXISTS public.academic_history (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    student_id UUID REFERENCES public.student_profiles(id) ON DELETE CASCADE,
    course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    semester TEXT NOT NULL,
    academic_year TEXT NOT NULL,
    grade DECIMAL(5,2),
    credits_earned INTEGER,
    gpa_impact DECIMAL(5,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Attendance
CREATE TABLE IF NOT EXISTS public.attendance (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
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

-- Medical Records
CREATE TABLE IF NOT EXISTS public.medical_records (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    student_id UUID REFERENCES public.student_profiles(id) ON DELETE CASCADE,
    record_type TEXT NOT NULL,
    description TEXT NOT NULL,
    date_of_incident DATE,
    treatment TEXT,
    physician_name TEXT,
    is_confidential BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Counseling Records
CREATE TABLE IF NOT EXISTS public.counseling_records (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    student_id UUID REFERENCES public.student_profiles(id) ON DELETE CASCADE,
    counselor_id UUID REFERENCES public.faculty_profiles(id),
    session_date DATE NOT NULL,
    session_type TEXT NOT NULL,
    notes TEXT,
    follow_up_required BOOLEAN DEFAULT false,
    follow_up_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Discipline Records
CREATE TABLE IF NOT EXISTS public.discipline_records (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    student_id UUID REFERENCES public.student_profiles(id) ON DELETE CASCADE,
    incident_date DATE NOT NULL,
    incident_type TEXT NOT NULL,
    description TEXT NOT NULL,
    action_taken TEXT,
    severity TEXT NOT NULL CHECK (severity IN ('minor', 'major', 'severe')),
    reported_by UUID REFERENCES public.faculty_profiles(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Student Documents
CREATE TABLE IF NOT EXISTS public.student_documents (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    student_id UUID REFERENCES public.student_profiles(id) ON DELETE CASCADE,
    document_type TEXT NOT NULL,
    document_name TEXT NOT NULL,
    file_url TEXT NOT NULL,
    file_size BIGINT,
    mime_type TEXT,
    is_verified BOOLEAN DEFAULT false,
    verified_by UUID REFERENCES public.faculty_profiles(id),
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Student Organizations
CREATE TABLE IF NOT EXISTS public.student_organizations (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    advisor_id UUID REFERENCES public.faculty_profiles(id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Organization Memberships
CREATE TABLE IF NOT EXISTS public.organization_memberships (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    organization_id UUID REFERENCES public.student_organizations(id) ON DELETE CASCADE,
    student_id UUID REFERENCES public.student_profiles(id) ON DELETE CASCADE,
    position TEXT,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    left_at TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN DEFAULT true,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(organization_id, student_id)
);

-- Notifications
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    recipient_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('info', 'warning', 'success', 'error', 'system')),
    is_read BOOLEAN DEFAULT false,
    priority TEXT DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    read_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- System Settings
CREATE TABLE IF NOT EXISTS public.system_settings (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    value TEXT NOT NULL,
    description TEXT,
    category TEXT DEFAULT 'general',
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Audit Logs
CREATE TABLE IF NOT EXISTS public.audit_logs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    action TEXT NOT NULL,
    table_name TEXT,
    record_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Grade Scales
CREATE TABLE IF NOT EXISTS public.grade_scales (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
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

CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON public.users(role);
CREATE INDEX IF NOT EXISTS idx_student_profiles_student_number ON public.student_profiles(student_number);
CREATE INDEX IF NOT EXISTS idx_student_profiles_user_id ON public.student_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_faculty_profiles_employee_number ON public.faculty_profiles(employee_number);
CREATE INDEX IF NOT EXISTS idx_faculty_profiles_user_id ON public.faculty_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_courses_code ON public.courses(course_code);
CREATE INDEX IF NOT EXISTS idx_courses_active ON public.courses(is_active);
CREATE INDEX IF NOT EXISTS idx_enrollments_student_id ON public.enrollments(student_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_course_id ON public.enrollments(course_id);
CREATE INDEX IF NOT EXISTS idx_academic_history_student_id ON public.academic_history(student_id);
CREATE INDEX IF NOT EXISTS idx_academic_history_course_id ON public.academic_history(course_id);
CREATE INDEX IF NOT EXISTS idx_notifications_recipient_id ON public.notifications(recipient_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON public.notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id ON public.audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON public.audit_logs(created_at);

-- =============================================
-- TRIGGERS
-- =============================================

-- Drop all existing trigger functions first to avoid conflicts
DROP FUNCTION IF EXISTS public.handle_updated_at() CASCADE;
DROP FUNCTION IF EXISTS public.update_updated_at_column() CASCADE;
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

-- Create individual trigger functions for each table to avoid conditional logic
CREATE OR REPLACE FUNCTION public.handle_users_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_student_profiles_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'student_profiles' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_faculty_profiles_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'faculty_profiles' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_admin_profiles_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'admin_profiles' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_courses_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'courses' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_course_prerequisites_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'course_prerequisites' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_enrollments_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'enrollments' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_academic_history_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'academic_history' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_attendance_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'attendance' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_medical_records_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'medical_records' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_counseling_records_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'counseling_records' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_discipline_records_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'discipline_records' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_student_documents_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'student_documents' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_student_organizations_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'student_organizations' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_organization_memberships_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'organization_memberships' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_notifications_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if updated_at column exists before trying to update it
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'notifications' 
        AND column_name = 'updated_at' 
        AND table_schema = 'public'
    ) THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_system_settings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'system_settings' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_audit_logs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'audit_logs' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_grade_scales_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'grade_scales' AND column_name = 'updated_at' AND table_schema = 'public') THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at (drop existing if they exist)
DROP TRIGGER IF EXISTS handle_users_updated_at ON public.users;
CREATE TRIGGER handle_users_updated_at
    BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_users_updated_at();

DROP TRIGGER IF EXISTS handle_student_profiles_updated_at ON public.student_profiles;
CREATE TRIGGER handle_student_profiles_updated_at
    BEFORE UPDATE ON public.student_profiles
    FOR EACH ROW EXECUTE FUNCTION public.handle_student_profiles_updated_at();

DROP TRIGGER IF EXISTS handle_faculty_profiles_updated_at ON public.faculty_profiles;
CREATE TRIGGER handle_faculty_profiles_updated_at
    BEFORE UPDATE ON public.faculty_profiles
    FOR EACH ROW EXECUTE FUNCTION public.handle_faculty_profiles_updated_at();

DROP TRIGGER IF EXISTS handle_admin_profiles_updated_at ON public.admin_profiles;
CREATE TRIGGER handle_admin_profiles_updated_at
    BEFORE UPDATE ON public.admin_profiles
    FOR EACH ROW EXECUTE FUNCTION public.handle_admin_profiles_updated_at();

DROP TRIGGER IF EXISTS handle_courses_updated_at ON public.courses;
CREATE TRIGGER handle_courses_updated_at
    BEFORE UPDATE ON public.courses
    FOR EACH ROW EXECUTE FUNCTION public.handle_courses_updated_at();

DROP TRIGGER IF EXISTS handle_enrollments_updated_at ON public.enrollments;
CREATE TRIGGER handle_enrollments_updated_at
    BEFORE UPDATE ON public.enrollments
    FOR EACH ROW EXECUTE FUNCTION public.handle_enrollments_updated_at();

DROP TRIGGER IF EXISTS handle_academic_history_updated_at ON public.academic_history;
CREATE TRIGGER handle_academic_history_updated_at
    BEFORE UPDATE ON public.academic_history
    FOR EACH ROW EXECUTE FUNCTION public.handle_academic_history_updated_at();

DROP TRIGGER IF EXISTS handle_medical_records_updated_at ON public.medical_records;
CREATE TRIGGER handle_medical_records_updated_at
    BEFORE UPDATE ON public.medical_records
    FOR EACH ROW EXECUTE FUNCTION public.handle_medical_records_updated_at();

DROP TRIGGER IF EXISTS handle_counseling_records_updated_at ON public.counseling_records;
CREATE TRIGGER handle_counseling_records_updated_at
    BEFORE UPDATE ON public.counseling_records
    FOR EACH ROW EXECUTE FUNCTION public.handle_counseling_records_updated_at();

DROP TRIGGER IF EXISTS handle_discipline_records_updated_at ON public.discipline_records;
CREATE TRIGGER handle_discipline_records_updated_at
    BEFORE UPDATE ON public.discipline_records
    FOR EACH ROW EXECUTE FUNCTION public.handle_discipline_records_updated_at();

DROP TRIGGER IF EXISTS handle_student_documents_updated_at ON public.student_documents;
CREATE TRIGGER handle_student_documents_updated_at
    BEFORE UPDATE ON public.student_documents
    FOR EACH ROW EXECUTE FUNCTION public.handle_student_documents_updated_at();

DROP TRIGGER IF EXISTS handle_student_organizations_updated_at ON public.student_organizations;
CREATE TRIGGER handle_student_organizations_updated_at
    BEFORE UPDATE ON public.student_organizations
    FOR EACH ROW EXECUTE FUNCTION public.handle_student_organizations_updated_at();

DROP TRIGGER IF EXISTS handle_organization_memberships_updated_at ON public.organization_memberships;
CREATE TRIGGER handle_organization_memberships_updated_at
    BEFORE UPDATE ON public.organization_memberships
    FOR EACH ROW EXECUTE FUNCTION public.handle_organization_memberships_updated_at();

DROP TRIGGER IF EXISTS handle_system_settings_updated_at ON public.system_settings;
CREATE TRIGGER handle_system_settings_updated_at
    BEFORE UPDATE ON public.system_settings
    FOR EACH ROW EXECUTE FUNCTION public.handle_system_settings_updated_at();

DROP TRIGGER IF EXISTS handle_grade_scales_updated_at ON public.grade_scales;
CREATE TRIGGER handle_grade_scales_updated_at
    BEFORE UPDATE ON public.grade_scales
    FOR EACH ROW EXECUTE FUNCTION public.handle_grade_scales_updated_at();

DROP TRIGGER IF EXISTS handle_notifications_updated_at ON public.notifications;
CREATE TRIGGER handle_notifications_updated_at
    BEFORE UPDATE ON public.notifications
    FOR EACH ROW EXECUTE FUNCTION public.handle_notifications_updated_at();

DROP TRIGGER IF EXISTS handle_audit_logs_updated_at ON public.audit_logs;
CREATE TRIGGER handle_audit_logs_updated_at
    BEFORE UPDATE ON public.audit_logs
    FOR EACH ROW EXECUTE FUNCTION public.handle_audit_logs_updated_at();

DROP TRIGGER IF EXISTS handle_course_prerequisites_updated_at ON public.course_prerequisites;
CREATE TRIGGER handle_course_prerequisites_updated_at
    BEFORE UPDATE ON public.course_prerequisites
    FOR EACH ROW EXECUTE FUNCTION public.handle_course_prerequisites_updated_at();

DROP TRIGGER IF EXISTS handle_attendance_updated_at ON public.attendance;
CREATE TRIGGER handle_attendance_updated_at
    BEFORE UPDATE ON public.attendance
    FOR EACH ROW EXECUTE FUNCTION public.handle_attendance_updated_at();

-- =============================================
-- SAMPLE DATA INSERTION
-- =============================================

-- Step 1: Create auth.users entries (minimal for testing)
INSERT INTO auth.users (
    id, 
    email, 
    encrypted_password, 
    email_confirmed_at, 
    created_at, 
    updated_at, 
    last_sign_in_at,
    role
) VALUES
-- Students
('550e8400-e29b-41d4-a716-446655440001', 'john.smith@university.edu', crypt('password123', gen_salt('bf')), NOW(), NOW(), NOW(), NOW(), 'authenticated'),
('550e8400-e29b-41d4-a716-446655440002', 'jane.doe@university.edu', crypt('password123', gen_salt('bf')), NOW(), NOW(), NOW(), NOW(), 'authenticated'),
('550e8400-e29b-41d4-a716-446655440003', 'mike.johnson@university.edu', crypt('password123', gen_salt('bf')), NOW(), NOW(), NOW(), NOW(), 'authenticated'),
-- Faculty
('550e8400-e29b-41d4-a716-446655440004', 'sarah.williams@university.edu', crypt('password123', gen_salt('bf')), NOW(), NOW(), NOW(), NOW(), 'authenticated'),
('550e8400-e29b-41d4-a716-446655440005', 'robert.brown@university.edu', crypt('password123', gen_salt('bf')), NOW(), NOW(), NOW(), NOW(), 'authenticated'),
-- Admin
('550e8400-e29b-41d4-a716-446655440006', 'admin@university.edu', crypt('admin123', gen_salt('bf')), NOW(), NOW(), NOW(), NOW(), 'authenticated')
ON CONFLICT (id) DO NOTHING;

-- Step 2: Insert Users
INSERT INTO public.users (id, system_id, name, email, role, status, joined_at) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'SYS001', 'John Smith', 'john.smith@university.edu', 'student', 'active', '2023-08-15 09:00:00'),
('550e8400-e29b-41d4-a716-446655440002', 'SYS002', 'Jane Doe', 'jane.doe@university.edu', 'student', 'active', '2023-08-15 09:30:00'),
('550e8400-e29b-41d4-a716-446655440003', 'SYS003', 'Mike Johnson', 'mike.johnson@university.edu', 'student', 'active', '2023-08-15 10:00:00'),
('550e8400-e29b-41d4-a716-446655440004', 'FAC001', 'Dr. Sarah Williams', 'sarah.williams@university.edu', 'faculty', 'active', '2022-08-01 08:00:00'),
('550e8400-e29b-41d4-a716-446655440005', 'FAC002', 'Prof. Robert Brown', 'robert.brown@university.edu', 'faculty', 'active', '2021-08-01 08:00:00'),
('550e8400-e29b-41d4-a716-446655440006', 'ADM001', 'Admin User', 'admin@university.edu', 'admin', 'active', '2020-06-01 08:00:00')
ON CONFLICT (id) DO NOTHING;

-- Step 3: Insert Student Profiles
INSERT INTO public.student_profiles (id, user_id, student_number, course, section, year_level, admission_date, gpa, units_completed, units_enrolled) VALUES
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '2023001', 'Computer Science', 'A', '1st Year', '2023-08-15', 3.25, 24, 18),
('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', '2023002', 'Information Technology', 'B', '2nd Year', '2022-08-15', 3.45, 48, 21),
('660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', '2023003', 'Computer Science', 'A', '3rd Year', '2021-08-15', 3.78, 72, 15)
ON CONFLICT (id) DO NOTHING;

-- Step 4: Insert Faculty Profiles
INSERT INTO public.faculty_profiles (id, user_id, employee_number, department, position, specialization, hire_date) VALUES
('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440004', 'FAC2022001', 'Computer Science', 'Associate Professor', 'Artificial Intelligence', '2022-08-01'),
('770e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440005', 'FAC2021001', 'Information Technology', 'Professor', 'Database Systems', '2021-08-01')
ON CONFLICT (id) DO NOTHING;

-- Step 5: Insert Admin Profiles
INSERT INTO public.admin_profiles (id, user_id, admin_level, permissions) VALUES
('880e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440006', 'super', ARRAY['user_management', 'system_settings', 'academic_records', 'reports'])
ON CONFLICT (id) DO NOTHING;

-- Step 6: Insert Courses
INSERT INTO public.courses (id, course_code, course_name, description, units, department, is_active) VALUES
('990e8400-e29b-41d4-a716-446655440001', 'CS101', 'Introduction to Computer Science', 'Fundamental concepts of computer science and programming', 3, 'Computer Science', true),
('990e8400-e29b-41d4-a716-446655440002', 'CS102', 'Data Structures and Algorithms', 'Advanced data structures and algorithm analysis', 3, 'Computer Science', true),
('990e8400-e29b-41d4-a716-446655440003', 'IT201', 'Database Management Systems', 'Introduction to database design and SQL', 3, 'Information Technology', true),
('990e8400-e29b-41d4-a716-446655440004', 'CS301', 'Artificial Intelligence', 'Introduction to AI concepts and applications', 3, 'Computer Science', true),
('990e8400-e29b-41d4-a716-446655440005', 'IT202', 'Web Development', 'Modern web development technologies', 3, 'Information Technology', true),
('990e8400-e29b-41d4-a716-446655440006', 'CS201', 'Computer Networks', 'Fundamentals of computer networking', 3, 'Computer Science', true)
ON CONFLICT (id) DO NOTHING;

-- Step 7: Insert Course Prerequisites
INSERT INTO public.course_prerequisites (id, course_id, prerequisite_course_id) VALUES
('aa0e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440001'), -- CS102 requires CS101
('aa0e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440004', '990e8400-e29b-41d4-a716-446655440002'), -- CS301 requires CS102
('aa0e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440006', '990e8400-e29b-41d4-a716-446655440001') -- CS201 requires CS101
ON CONFLICT (course_id, prerequisite_course_id) DO NOTHING;

-- Step 8: Insert Enrollments
INSERT INTO public.enrollments (id, student_id, course_id, semester, academic_year, status, grade, enrolled_at) VALUES
('bb0e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440001', 'First Semester', '2023-2024', 'completed', 88, '2023-08-15 09:00:00'),
('bb0e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440002', 'Second Semester', '2023-2024', 'enrolled', NULL, '2024-01-15 09:00:00'),
('bb0e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440003', 'First Semester', '2023-2024', 'completed', 92, '2023-08-15 09:30:00'),
('bb0e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440004', 'First Semester', '2023-2024', 'enrolled', NULL, '2023-08-15 10:00:00'),
('bb0e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440005', 'First Semester', '2023-2024', 'enrolled', NULL, '2023-08-15 10:00:00')
ON CONFLICT (student_id, course_id, semester, academic_year) DO NOTHING;

-- Step 9: Insert Academic History
INSERT INTO public.academic_history (id, student_id, course_id, semester, academic_year, grade, credits_earned, gpa_impact) VALUES
('cc0e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440001', 'First Semester', '2023-2024', 88, 3, 3.00),
('cc0e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440003', 'First Semester', '2023-2024', 92, 3, 3.67)
ON CONFLICT (id) DO NOTHING;

-- Step 10: Insert Attendance Records
INSERT INTO public.attendance (id, student_id, course_id, date, status, remarks, recorded_by) VALUES
('dd0e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440001', '2023-08-21', 'present', NULL, '770e8400-e29b-41d4-a716-446655440001'),
('dd0e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440001', '2023-08-28', 'late', 'Arrived 10 minutes late', '770e8400-e29b-41d4-a716-446655440001'),
('dd0e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440003', '2023-08-22', 'present', NULL, '770e8400-e29b-41d4-a716-446655440002')
ON CONFLICT (student_id, course_id, date) DO NOTHING;

-- Step 11: Insert Medical Records
INSERT INTO public.medical_records (id, student_id, record_type, description, date_of_incident, treatment, physician_name, is_confidential) VALUES
('ee0e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', 'Check-up', 'Annual medical check-up', '2023-08-10', 'Routine examination completed', 'Dr. Alan Davis', true),
('ee0e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440002', 'Injury', 'Minor sprain during PE class', '2023-09-15', 'Rest and ice application recommended', 'Dr. Beth Clark', true)
ON CONFLICT (id) DO NOTHING;

-- Step 12: Insert Counseling Records
INSERT INTO public.counseling_records (id, student_id, counselor_id, session_date, session_type, notes, follow_up_required, follow_up_date) VALUES
('ff0e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', '2023-09-01', 'Academic Advising', 'Discussion about course selection for next semester', true, '2023-09-15'),
('ff0e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440002', '2023-08-20', 'Career Guidance', 'Exploring career options in IT field', false, NULL)
ON CONFLICT (id) DO NOTHING;

-- Step 13: Insert Discipline Records
INSERT INTO public.discipline_records (id, student_id, incident_date, incident_type, description, action_taken, severity, reported_by) VALUES
('001e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '2023-10-05', 'Tardiness', 'Repeated late arrivals to morning classes', 'Warning issued', 'minor', '770e8400-e29b-41d4-a716-446655440001')
ON CONFLICT (id) DO NOTHING;

-- Step 14: Insert Student Documents
INSERT INTO public.student_documents (id, student_id, document_type, document_name, file_url, file_size, mime_type, is_verified, verified_by, uploaded_at) VALUES
('002e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', 'Birth Certificate', 'birth_cert_john_smith.pdf', '/uploads/student-documents/birth_cert_john_smith.pdf', 245760, 'application/pdf', true, '770e8400-e29b-41d4-a716-446655440001', '2023-08-15 09:15:00'),
('002e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440002', 'Transcript', 'high_school_transcript_jane_doe.pdf', '/uploads/student-documents/high_school_transcript_jane_doe.pdf', 512000, 'application/pdf', true, '770e8400-e29b-41d4-a716-446655440002', '2023-08-15 09:45:00')
ON CONFLICT (id) DO NOTHING;

-- Step 15: Insert Student Organizations
INSERT INTO public.student_organizations (id, name, description, advisor_id, is_active) VALUES
('003e8400-e29b-41d4-a716-446655440001', 'Computer Science Club', 'Organization for CS students to explore technology and programming', '770e8400-e29b-41d4-a716-446655440001', true),
('003e8400-e29b-41d4-a716-446655440002', 'IT Society', 'Professional development organization for IT students', '770e8400-e29b-41d4-a716-446655440002', true)
ON CONFLICT (id) DO NOTHING;

-- Step 16: Insert Organization Memberships
INSERT INTO public.organization_memberships (id, organization_id, student_id, position, joined_at, is_active) VALUES
('004e8400-e29b-41d4-a716-446655440001', '003e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', 'Member', '2023-09-01 10:00:00', true),
('004e8400-e29b-41d4-a716-446655440002', '003e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440002', 'Treasurer', '2023-09-01 11:00:00', true)
ON CONFLICT (organization_id, student_id) DO NOTHING;

-- Step 17: Insert Notifications
INSERT INTO public.notifications (id, recipient_id, sender_id, title, message, type, is_read, priority, created_at) VALUES
('005e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440004', 'Welcome to CS101', 'Your enrollment in Introduction to Computer Science has been confirmed. Please check the course schedule.', 'info', false, 'normal', '2023-08-15 09:30:00'),
('005e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440005', 'Assignment Due', 'Database Management Systems Assignment 1 is due on Friday, September 1st.', 'warning', false, 'high', '2023-08-25 14:00:00'),
('005e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440006', 'System Maintenance', 'The system will be under maintenance this weekend from Saturday 10 PM to Sunday 2 AM.', 'system', true, 'low', '2023-08-28 16:00:00')
ON CONFLICT (id) DO NOTHING;

-- Step 18: Insert System Settings
INSERT INTO public.system_settings (id, key, value, description, category, is_public) VALUES
('006e8400-e29b-41d4-a716-446655440001', 'academic_year', '2023-2024', 'Current academic year', 'academic', true),
('006e8400-e29b-41d4-a716-446655440002', 'current_semester', 'First Semester', 'Current semester', 'academic', true),
('006e8400-e29b-41d4-a716-446655440003', 'max_units_per_semester', '24', 'Maximum units a student can enroll per semester', 'academic', true),
('006e8400-e29b-41d4-a716-446655440004', 'grading_system', 'percentage', 'Grading system type (percentage or gpa)', 'academic', true),
('006e8400-e29b-41d4-a716-446655440005', 'maintenance_mode', 'false', 'System maintenance mode status', 'system', false)
ON CONFLICT (key) DO NOTHING;

-- Step 19: Insert Grade Scales
INSERT INTO public.grade_scales (id, name, description, min_score, max_score, grade_letter, grade_points, is_active) VALUES
('007e8400-e29b-41d4-a716-446655440001', 'Excellent', 'Outstanding performance', 90, 100, 'A', 4.00, true),
('007e8400-e29b-41d4-a716-446655440002', 'Very Good', 'Above average performance', 85, 89.99, 'B+', 3.50, true),
('007e8400-e29b-41d4-a716-446655440003', 'Good', 'Average performance', 80, 84.99, 'B', 3.00, true),
('007e8400-e29b-41d4-a716-446655440004', 'Satisfactory', 'Below average but passing', 75, 79.99, 'C+', 2.50, true),
('007e8400-e29b-41d4-a716-446655440005', 'Passing', 'Minimum passing grade', 70, 74.99, 'C', 2.00, true),
('007e8400-e29b-41d4-a716-446655440006', 'Conditional', 'Conditional pass', 65, 69.99, 'D', 1.00, true),
('007e8400-e29b-41d4-a716-446655440007', 'Failed', 'Failing grade', 0, 64.99, 'F', 0.00, true)
ON CONFLICT (id) DO NOTHING;

-- Step 20: Insert Sample Audit Logs
INSERT INTO public.audit_logs (id, user_id, action, table_name, record_id, old_values, new_values, ip_address, user_agent, created_at) VALUES
('008e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'INSERT', 'enrollments', 'bb0e8400-e29b-41d4-a716-446655440001', NULL, '{"student_id": "660e8400-e29b-41d4-a716-446655440001", "course_id": "990e8400-e29b-41d4-a716-446655440001"}', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', '2023-08-15 09:00:00'),
('008e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440006', 'UPDATE', 'system_settings', '006e8400-e29b-41d4-a716-446655440001', '{"value": "2022-2023"}', '{"value": "2023-2024"}', '192.168.1.50', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36', '2023-08-01 08:00:00')
ON CONFLICT (id) DO NOTHING;

-- =============================================
-- UPDATE SAMPLE DATA FOR REALISM
-- =============================================

-- Update some timestamps to reflect realistic data
UPDATE public.users SET last_login_at = '2024-01-20 14:30:00' WHERE id = '550e8400-e29b-41d4-a716-446655440001';
UPDATE public.users SET last_login_at = '2024-01-19 16:45:00' WHERE id = '550e8400-e29b-41d4-a716-446655440002';
UPDATE public.users SET last_login_at = '2024-01-18 10:15:00' WHERE id = '550e8400-e29b-41d4-a716-446655440004';

-- Mark some notifications as read
UPDATE public.notifications SET is_read = true, read_at = '2023-08-15 10:00:00' WHERE id = '005e8400-e29b-41d4-a716-446655440003';

-- Complete full schema with comprehensive sample data
-- This migration creates the entire educational management system structure with realistic test data
