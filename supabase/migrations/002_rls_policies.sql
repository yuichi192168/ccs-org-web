-- Row Level Security (RLS) Policies
-- Migration: 002_rls_policies.sql

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

-- Users table policies
CREATE POLICY "Users can view own profile" ON public.users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Admins can view all users" ON public.users
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Users can update own profile" ON public.users
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Admins can update all users" ON public.users
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can insert users" ON public.users
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Student Profiles policies
CREATE POLICY "Students can view own profile" ON public.student_profiles
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Faculty can view student profiles" ON public.student_profiles
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.faculty_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can view all student profiles" ON public.student_profiles
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Students can update own profile" ON public.student_profiles
    FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Admins can manage student profiles" ON public.student_profiles
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Faculty Profiles policies
CREATE POLICY "Faculty can view own profile" ON public.faculty_profiles
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Faculty can view other faculty profiles" ON public.faculty_profiles
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.faculty_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can view all faculty profiles" ON public.faculty_profiles
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Faculty can update own profile" ON public.faculty_profiles
    FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Admins can manage faculty profiles" ON public.faculty_profiles
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Admin Profiles policies
CREATE POLICY "Admins can view own profile" ON public.admin_profiles
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Admins can view all admin profiles" ON public.admin_profiles
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can manage admin profiles" ON public.admin_profiles
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Courses policies (public read access)
CREATE POLICY "Everyone can view active courses" ON public.courses
    FOR SELECT USING (is_active = true);

CREATE POLICY "Faculty can view all courses" ON public.courses
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.faculty_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can manage courses" ON public.courses
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Course Prerequisites policies
CREATE POLICY "Everyone can view course prerequisites" ON public.course_prerequisites
    FOR SELECT USING (true);

CREATE POLICY "Admins can manage course prerequisites" ON public.course_prerequisites
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Enrollments policies
CREATE POLICY "Students can view own enrollments" ON public.enrollments
    FOR SELECT USING (
        student_id IN (
            SELECT id FROM public.student_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Faculty can view course enrollments" ON public.enrollments
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.faculty_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can view all enrollments" ON public.enrollments
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can manage enrollments" ON public.enrollments
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Academic History policies
CREATE POLICY "Students can view own academic history" ON public.academic_history
    FOR SELECT USING (
        student_id IN (
            SELECT id FROM public.student_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Faculty can view student academic history" ON public.academic_history
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.faculty_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can manage academic history" ON public.academic_history
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Attendance policies
CREATE POLICY "Students can view own attendance" ON public.attendance
    FOR SELECT USING (
        student_id IN (
            SELECT id FROM public.student_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Faculty can manage attendance" ON public.attendance
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.faculty_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can view all attendance" ON public.attendance
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Medical Records policies (highly restricted)
CREATE POLICY "Students can view own medical records" ON public.medical_records
    FOR SELECT USING (
        student_id IN (
            SELECT id FROM public.student_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can manage medical records" ON public.medical_records
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Counseling Records policies
CREATE POLICY "Students can view own counseling records" ON public.counseling_records
    FOR SELECT USING (
        student_id IN (
            SELECT id FROM public.student_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Counselors can manage counseling records" ON public.counseling_records
    FOR ALL USING (
        counselor_id IN (
            SELECT id FROM public.faculty_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can view all counseling records" ON public.counseling_records
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Discipline Records policies
CREATE POLICY "Students can view own discipline records" ON public.discipline_records
    FOR SELECT USING (
        student_id IN (
            SELECT id FROM public.student_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Faculty can manage discipline records" ON public.discipline_records
    FOR ALL USING (
        reported_by IN (
            SELECT id FROM public.faculty_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can manage discipline records" ON public.discipline_records
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Student Documents policies
CREATE POLICY "Students can view own documents" ON public.student_documents
    FOR SELECT USING (
        student_id IN (
            SELECT id FROM public.student_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Students can upload own documents" ON public.student_documents
    FOR INSERT WITH CHECK (
        student_id IN (
            SELECT id FROM public.student_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Faculty can verify documents" ON public.student_documents
    FOR UPDATE USING (
        verified_by IN (
            SELECT id FROM public.faculty_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can manage student documents" ON public.student_documents
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Student Organizations policies
CREATE POLICY "Everyone can view active organizations" ON public.student_organizations
    FOR SELECT USING (is_active = true);

CREATE POLICY "Organization members can view organization" ON public.student_organizations
    FOR SELECT USING (
        id IN (
            SELECT organization_id FROM public.organization_memberships
            WHERE student_id IN (
                SELECT id FROM public.student_profiles 
                WHERE user_id = auth.uid()
            )
            AND is_active = true
        )
    );

CREATE POLICY "Admins can manage organizations" ON public.student_organizations
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Organization Memberships policies
CREATE POLICY "Students can view own memberships" ON public.organization_memberships
    FOR SELECT USING (
        student_id IN (
            SELECT id FROM public.student_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Students can join organizations" ON public.organization_memberships
    FOR INSERT WITH CHECK (
        student_id IN (
            SELECT id FROM public.student_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Students can update own memberships" ON public.organization_memberships
    FOR UPDATE USING (
        student_id IN (
            SELECT id FROM public.student_profiles 
            WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can manage memberships" ON public.organization_memberships
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Notifications policies
CREATE POLICY "Users can view own notifications" ON public.notifications
    FOR SELECT USING (recipient_id = auth.uid());

CREATE POLICY "Users can update own notifications" ON public.notifications
    FOR UPDATE USING (recipient_id = auth.uid());

CREATE POLICY "System can send notifications" ON public.notifications
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Admins can send notifications" ON public.notifications
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- System Settings policies
CREATE POLICY "Everyone can view public settings" ON public.system_settings
    FOR SELECT USING (is_public = true);

CREATE POLICY "Admins can manage system settings" ON public.system_settings
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Audit Logs policies
CREATE POLICY "Users can view own audit logs" ON public.audit_logs
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Admins can view all audit logs" ON public.audit_logs
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Grade Scales policies
CREATE POLICY "Everyone can view active grade scales" ON public.grade_scales
    FOR SELECT USING (is_active = true);

CREATE POLICY "Admins can manage grade scales" ON public.grade_scales
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.admin_profiles 
            WHERE user_id = auth.uid()
        )
    );
