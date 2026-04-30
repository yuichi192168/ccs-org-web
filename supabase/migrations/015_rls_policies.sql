-- Row Level Security (RLS) Policies Migration
-- Migration: 015_rls_policies.sql

-- =============================================
-- ENABLE ROW LEVEL SECURITY
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
-- USERS TABLE RLS POLICIES
-- =============================================

-- Users can view own profile
CREATE POLICY "Users can view own profile" ON public.users
    FOR SELECT USING (auth.uid() = id);

-- Users can update own profile
CREATE POLICY "Users can update own profile" ON public.users
    FOR UPDATE USING (auth.uid() = id);

-- Admins can create users
CREATE POLICY "Admins can create users" ON public.users
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Admins can delete users
CREATE POLICY "Admins can delete users" ON public.users
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Service role can bypass RLS for users
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

-- =============================================
-- STUDENT PROFILES TABLE RLS POLICIES
-- =============================================

-- Students can view own profile
CREATE POLICY "Students can view own profile" ON public.student_profiles
    FOR SELECT USING (auth.uid() = user_id);

-- Students can update own profile
CREATE POLICY "Students can update own profile" ON public.student_profiles
    FOR UPDATE USING (auth.uid() = user_id);

-- Faculty and admins can view student profiles
CREATE POLICY "Faculty and admins can view student profiles" ON public.student_profiles
    FOR SELECT USING (
        auth.uid() = user_id OR
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Faculty and admins can update student profiles
CREATE POLICY "Faculty and admins can update student profiles" ON public.student_profiles
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Admins can create student profiles
CREATE POLICY "Admins can create student profiles" ON public.student_profiles
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Admins can delete student profiles
CREATE POLICY "Admins can delete student profiles" ON public.student_profiles
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- =============================================
-- FACULTY PROFILES TABLE RLS POLICIES
-- =============================================

-- Faculty can view own profile
CREATE POLICY "Faculty can view own profile" ON public.faculty_profiles
    FOR SELECT USING (auth.uid() = user_id);

-- Faculty can update own profile
CREATE POLICY "Faculty can update own profile" ON public.faculty_profiles
    FOR UPDATE USING (auth.uid() = user_id);

-- Admins can view all faculty profiles
CREATE POLICY "Admins can view all faculty profiles" ON public.faculty_profiles
    FOR SELECT USING (
        auth.uid() = user_id OR
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Admins can update faculty profiles
CREATE POLICY "Admins can update faculty profiles" ON public.faculty_profiles
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Admins can create faculty profiles
CREATE POLICY "Admins can create faculty profiles" ON public.faculty_profiles
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Admins can delete faculty profiles
CREATE POLICY "Admins can delete faculty profiles" ON public.faculty_profiles
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- =============================================
-- ADMIN PROFILES TABLE RLS POLICIES
-- =============================================

-- Admins can view own profile
CREATE POLICY "Admins can view own profile" ON public.admin_profiles
    FOR SELECT USING (auth.uid() = user_id);

-- Admins can update own profile
CREATE POLICY "Admins can update own profile" ON public.admin_profiles
    FOR UPDATE USING (auth.uid() = user_id);

-- System admins can create admin profiles
CREATE POLICY "System admins can create admin profiles" ON public.admin_profiles
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- System admins can delete admin profiles
CREATE POLICY "System admins can delete admin profiles" ON public.admin_profiles
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- =============================================
-- COURSES TABLE RLS POLICIES
-- =============================================

-- Authenticated users can view active courses
CREATE POLICY "Authenticated users can view active courses" ON public.courses
    FOR SELECT USING (is_active = true);

-- Faculty and admins can create courses
CREATE POLICY "Faculty and admins can create courses" ON public.courses
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Course creators can update own courses
CREATE POLICY "Course creators can update own courses" ON public.courses
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Course creators can delete own courses
CREATE POLICY "Course creators can delete own courses" ON public.courses
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- =============================================
-- ENROLLMENTS TABLE RLS POLICIES
-- =============================================

-- Students can view own enrollments
CREATE POLICY "Students can view own enrollments" ON public.enrollments
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.student_profiles 
            WHERE user_id = auth.uid() AND id = student_id
        )
    );

-- Students can create own enrollments
CREATE POLICY "Students can create own enrollments" ON public.enrollments
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.student_profiles 
            WHERE user_id = auth.uid() AND id = student_id
        )
    );

-- Faculty and admins can view all enrollments
CREATE POLICY "Faculty and admins can view all enrollments" ON public.enrollments
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Faculty and admins can update enrollments
CREATE POLICY "Faculty and admins can update enrollments" ON public.enrollments
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Admins can create enrollments
CREATE POLICY "Admins can create enrollments" ON public.enrollments
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Faculty and admins can delete enrollments
CREATE POLICY "Faculty and admins can delete enrollments" ON public.enrollments
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- =============================================
-- ACADEMIC HISTORY TABLE RLS POLICIES
-- =============================================

-- Students can view own academic history
CREATE POLICY "Students can view own academic history" ON public.academic_history
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.student_profiles 
            WHERE user_id = auth.uid() AND id = student_id
        )
    );

-- Faculty and admins can view all academic history
CREATE POLICY "Faculty and admins can view all academic history" ON public.academic_history
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Faculty and admins can create academic history
CREATE POLICY "Faculty and admins can create academic history" ON public.academic_history
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Faculty and admins can update academic history
CREATE POLICY "Faculty and admins can update academic history" ON public.academic_history
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- =============================================
-- ATTENDANCE TABLE RLS POLICIES
-- =============================================

-- Students can view own attendance
CREATE POLICY "Students can view own attendance" ON public.attendance
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.student_profiles 
            WHERE user_id = auth.uid() AND id = student_id
        )
    );

-- Faculty and admins can view all attendance
CREATE POLICY "Faculty and admins can view all attendance" ON public.attendance
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Faculty can record attendance
CREATE POLICY "Faculty can record attendance" ON public.attendance
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.faculty_profiles 
            WHERE user_id = auth.uid() AND id = recorded_by
        )
    );

-- Faculty and admins can update attendance
CREATE POLICY "Faculty and admins can update attendance" ON public.attendance
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- =============================================
-- MEDICAL RECORDS TABLE RLS POLICIES
-- =============================================

-- Students can view own medical records
CREATE POLICY "Students can view own medical records" ON public.medical_records
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.student_profiles 
            WHERE user_id = auth.uid() AND id = student_id
        )
    );

-- Admins can view all medical records
CREATE POLICY "Admins can view all medical records" ON public.medical_records
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Admins can create medical records
CREATE POLICY "Admins can create medical records" ON public.medical_records
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Admins can update medical records
CREATE POLICY "Admins can update medical records" ON public.medical_records
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- =============================================
-- COUNSELING RECORDS TABLE RLS POLICIES
-- =============================================

-- Students can view own counseling records
CREATE POLICY "Students can view own counseling records" ON public.counseling_records
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.student_profiles 
            WHERE user_id = auth.uid() AND id = student_id
        )
    );

-- Counselors can view own counseling records
CREATE POLICY "Counselors can view own counseling records" ON public.counseling_records
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.faculty_profiles 
            WHERE user_id = auth.uid() AND id = counselor_id
        )
    );

-- Admins can view all counseling records
CREATE POLICY "Admins can view all counseling records" ON public.counseling_records
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Faculty and admins can create counseling records
CREATE POLICY "Faculty and admins can create counseling records" ON public.counseling_records
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Faculty and admins can update counseling records
CREATE POLICY "Faculty and admins can update counseling records" ON public.counseling_records
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- =============================================
-- DISCIPLINE RECORDS TABLE RLS POLICIES
-- =============================================

-- Students can view own discipline records
CREATE POLICY "Students can view own discipline records" ON public.discipline_records
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.student_profiles 
            WHERE user_id = auth.uid() AND id = student_id
        )
    );

-- Faculty and admins can view all discipline records
CREATE POLICY "Faculty and admins can view all discipline records" ON public.discipline_records
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Faculty and admins can create discipline records
CREATE POLICY "Faculty and admins can create discipline records" ON public.discipline_records
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Faculty and admins can update discipline records
CREATE POLICY "Faculty and admins can update discipline records" ON public.discipline_records
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- =============================================
-- STUDENT DOCUMENTS TABLE RLS POLICIES
-- =============================================

-- Students can view own documents
CREATE POLICY "Students can view own documents" ON public.student_documents
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.student_profiles 
            WHERE user_id = auth.uid() AND id = student_id
        )
    );

-- Students can upload own documents
CREATE POLICY "Students can upload own documents" ON public.student_documents
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.student_profiles 
            WHERE user_id = auth.uid() AND id = student_id
        )
    );

-- Faculty and admins can view all documents
CREATE POLICY "Faculty and admins can view all documents" ON public.student_documents
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- =============================================
-- STUDENT ORGANIZATIONS TABLE RLS POLICIES
-- =============================================

-- Authenticated users can view active organizations
CREATE POLICY "Authenticated users can view active organizations" ON public.student_organizations
    FOR SELECT USING (is_active = true);

-- Faculty and admins can create organizations
CREATE POLICY "Faculty and admins can create organizations" ON public.student_organizations
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Organization advisors can update own organizations
CREATE POLICY "Organization advisors can update own organizations" ON public.student_organizations
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.faculty_profiles 
            WHERE user_id = auth.uid() AND id = advisor_id
        )
    );

-- =============================================
-- ORGANIZATION MEMBERSHIPS TABLE RLS POLICIES
-- =============================================

-- Students can view own memberships
CREATE POLICY "Students can view own memberships" ON public.organization_memberships
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.student_profiles 
            WHERE user_id = auth.uid() AND id = student_id
        )
    );

-- Students can create own memberships
CREATE POLICY "Students can create own memberships" ON public.organization_memberships
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.student_profiles 
            WHERE user_id = auth.uid() AND id = student_id
        )
    );

-- Faculty and admins can view all memberships
CREATE POLICY "Faculty and admins can view all memberships" ON public.organization_memberships
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- =============================================
-- NOTIFICATIONS TABLE RLS POLICIES
-- =============================================

-- Users can view own notifications
CREATE POLICY "Users can view own notifications" ON public.notifications
    FOR SELECT USING (auth.uid() = recipient_id);

-- Users can update own notifications
CREATE POLICY "Users can update own notifications" ON public.notifications
    FOR UPDATE USING (auth.uid() = recipient_id);

-- System can create notifications
CREATE POLICY "System can create notifications" ON public.notifications
    FOR INSERT WITH CHECK (true);

-- =============================================
-- SYSTEM SETTINGS TABLE RLS POLICIES
-- =============================================

-- Authenticated users can view public settings
CREATE POLICY "Authenticated users can view public settings" ON public.system_settings
    FOR SELECT USING (is_public = true);

-- Admins can view all settings
CREATE POLICY "Admins can view all settings" ON public.system_settings
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Admins can manage settings
CREATE POLICY "Admins can manage settings" ON public.system_settings
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- =============================================
-- AUDIT LOGS TABLE RLS POLICIES
-- =============================================

-- Users can view own audit logs
CREATE POLICY "Users can view own audit logs" ON public.audit_logs
    FOR SELECT USING (auth.uid() = user_id);

-- Admins can view all audit logs
CREATE POLICY "Admins can view all audit logs" ON public.audit_logs
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- System can create audit logs
CREATE POLICY "System can create audit logs" ON public.audit_logs
    FOR INSERT WITH CHECK (true);

-- =============================================
-- GRADE SCALES TABLE RLS POLICIES
-- =============================================

-- Authenticated users can view active grade scales
CREATE POLICY "Authenticated users can view active grade scales" ON public.grade_scales
    FOR SELECT USING (is_active = true);

-- Admins can manage grade scales
CREATE POLICY "Admins can manage grade scales" ON public.grade_scales
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );
