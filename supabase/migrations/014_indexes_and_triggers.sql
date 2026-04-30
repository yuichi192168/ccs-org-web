-- Indexes and Triggers Migration
-- Migration: 014_indexes_and_triggers.sql

-- =============================================
-- INDEXES FOR PERFORMANCE OPTIMIZATION
-- =============================================

-- Users table indexes
CREATE INDEX idx_users_email ON public.users(email);
CREATE INDEX idx_users_role ON public.users(role);
CREATE INDEX idx_users_status ON public.users(status);
CREATE INDEX idx_users_system_id ON public.users(system_id);

-- Student Profiles indexes
CREATE INDEX idx_student_profiles_user_id ON public.student_profiles(user_id);
CREATE INDEX idx_student_profiles_student_number ON public.student_profiles(student_number);
CREATE INDEX idx_student_profiles_program ON public.student_profiles(program);
CREATE INDEX idx_student_profiles_enrollment_status ON public.student_profiles(enrollment_status);

-- Faculty Profiles indexes
CREATE INDEX idx_faculty_profiles_user_id ON public.faculty_profiles(user_id);
CREATE INDEX idx_faculty_profiles_employee_id ON public.faculty_profiles(employee_id);
CREATE INDEX idx_faculty_profiles_department ON public.faculty_profiles(department);

-- Admin Profiles indexes
CREATE INDEX idx_admin_profiles_user_id ON public.admin_profiles(user_id);
CREATE INDEX idx_admin_profiles_admin_level ON public.admin_profiles(admin_level);

-- Courses indexes
CREATE INDEX idx_courses_course_code ON public.courses(course_code);
CREATE INDEX idx_courses_department ON public.courses(department);
CREATE INDEX idx_courses_faculty_id ON public.courses(faculty_id);
CREATE INDEX idx_courses_is_active ON public.courses(is_active);
CREATE INDEX idx_courses_semester ON public.courses(semester);
CREATE INDEX idx_courses_academic_year ON public.courses(academic_year);

-- Enrollments indexes
CREATE INDEX idx_enrollments_student_id ON public.enrollments(student_id);
CREATE INDEX idx_enrollments_course_id ON public.enrollments(course_id);
CREATE INDEX idx_enrollments_status ON public.enrollments(status);
CREATE INDEX idx_enrollments_enrollment_date ON public.enrollments(enrollment_date);

-- Academic History indexes
CREATE INDEX idx_academic_history_student_id ON public.academic_history(student_id);
CREATE INDEX idx_academic_history_course_id ON public.academic_history(course_id);
CREATE INDEX idx_academic_history_semester ON public.academic_history(semester);
CREATE INDEX idx_academic_history_academic_year ON public.academic_history(academic_year);

-- Attendance indexes
CREATE INDEX idx_attendance_student_id ON public.attendance(student_id);
CREATE INDEX idx_attendance_course_id ON public.attendance(course_id);
CREATE INDEX idx_attendance_date ON public.attendance(date);
CREATE INDEX idx_attendance_status ON public.attendance(status);

-- Medical Records indexes
CREATE INDEX idx_medical_records_student_id ON public.medical_records(student_id);
CREATE INDEX idx_medical_records_diagnosis_date ON public.medical_records(diagnosis_date);
CREATE INDEX idx_medical_records_is_chronic ON public.medical_records(is_chronic);

-- Counseling Records indexes
CREATE INDEX idx_counseling_records_student_id ON public.counseling_records(student_id);
CREATE INDEX idx_counseling_records_counselor_id ON public.counseling_records(counselor_id);
CREATE INDEX idx_counseling_records_session_date ON public.counseling_records(session_date);
CREATE INDEX idx_counseling_records_session_type ON public.counseling_records(session_type);

-- Discipline Records indexes
CREATE INDEX idx_discipline_records_student_id ON public.discipline_records(student_id);
CREATE INDEX idx_discipline_records_reported_by ON public.discipline_records(reported_by);
CREATE INDEX idx_discipline_records_incident_date ON public.discipline_records(incident_date);
CREATE INDEX idx_discipline_records_severity ON public.discipline_records(severity);
CREATE INDEX idx_discipline_records_status ON public.discipline_records(status);

-- Student Documents indexes
CREATE INDEX idx_student_documents_student_id ON public.student_documents(student_id);
CREATE INDEX idx_student_documents_document_type ON public.student_documents(document_type);
CREATE INDEX idx_student_documents_uploaded_at ON public.student_documents(uploaded_at);

-- Student Organizations indexes
CREATE INDEX idx_student_organizations_advisor_id ON public.student_organizations(advisor_id);
CREATE INDEX idx_student_organizations_category ON public.student_organizations(category);
CREATE INDEX idx_student_organizations_is_active ON public.student_organizations(is_active);

-- Organization Memberships indexes
CREATE INDEX idx_organization_memberships_organization_id ON public.organization_memberships(organization_id);
CREATE INDEX idx_organization_memberships_student_id ON public.organization_memberships(student_id);
CREATE INDEX idx_organization_memberships_is_active ON public.organization_memberships(is_active);

-- Notifications indexes
CREATE INDEX idx_notifications_recipient_id ON public.notifications(recipient_id);
CREATE INDEX idx_notifications_sender_id ON public.notifications(sender_id);
CREATE INDEX idx_notifications_is_read ON public.notifications(is_read);
CREATE INDEX idx_notifications_type ON public.notifications(type);
CREATE INDEX idx_notifications_priority ON public.notifications(priority);
CREATE INDEX idx_notifications_created_at ON public.notifications(created_at);

-- System Settings indexes
CREATE INDEX idx_system_settings_category ON public.system_settings(category);
CREATE INDEX idx_system_settings_key ON public.system_settings(key);
CREATE INDEX idx_system_settings_is_public ON public.system_settings(is_public);

-- Audit Logs indexes
CREATE INDEX idx_audit_logs_user_id ON public.audit_logs(user_id);
CREATE INDEX idx_audit_logs_created_at ON public.audit_logs(created_at);
CREATE INDEX idx_audit_logs_table_name ON public.audit_logs(table_name);
CREATE INDEX idx_audit_logs_action ON public.audit_logs(action);

-- Grade Scales indexes
CREATE INDEX idx_grade_scales_is_active ON public.grade_scales(is_active);
CREATE INDEX idx_grade_scales_grade_letter ON public.grade_scales(grade_letter);

-- =============================================
-- TRIGGER FUNCTIONS FOR UPDATED_AT
-- =============================================

-- Create generic updated_at trigger function
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create specific trigger functions for each table
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

-- =============================================
-- CREATE TRIGGERS FOR UPDATED_AT
-- =============================================

-- Create triggers for all tables
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
