-- Row Level Security Policies for Academic Management System
-- These policies ensure users can only access appropriate data

-- Users table policies
-- Users can read their own profile
CREATE POLICY IF NOT EXISTS "Users can view own profile" ON users
    FOR SELECT USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY IF NOT EXISTS "Users can update own profile" ON users
    FOR UPDATE USING (auth.uid() = id);

-- Only admins can create users
CREATE POLICY IF NOT EXISTS "Admins can create users" ON users
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Only admins can delete users
CREATE POLICY IF NOT EXISTS "Admins can delete users" ON users
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Service role can bypass RLS for users table (for admin operations)
CREATE POLICY "Service role can bypass RLS for users" ON users
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM information_schema.table_privileges 
            WHERE table_name = 'users' 
            AND privilege_type = 'SELECT'
            AND grantee = CURRENT_USER
            AND grantor = 'service_role'
        )
    );

-- Only admins can delete users
CREATE POLICY IF NOT EXISTS "Admins can delete users" ON users
    FOR DELETE USING (
-- Student Profiles table policies
-- Students can view their own profile
CREATE POLICY IF NOT EXISTS "Students can view own profile" ON student_profiles
    FOR SELECT USING (auth.uid() = user_id);

-- Students can update their own profile
CREATE POLICY IF NOT EXISTS "Students can update own profile" ON student_profiles
    FOR UPDATE USING (auth.uid() = user_id);

-- Faculty and admins can view student profiles
CREATE POLICY IF NOT EXISTS "Faculty and admins can view student profiles" ON student_profiles
    FOR SELECT USING (
        auth.uid() = user_id OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Faculty and admins can update student profiles
CREATE POLICY IF NOT EXISTS "Faculty and admins can update student profiles" ON student_profiles
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Only admins can create student profiles
CREATE POLICY IF NOT EXISTS "Admins can create student profiles" ON student_profiles
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Only admins can delete student profiles
CREATE POLICY "Admins can delete student profiles" ON student_profiles
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Faculty Profiles table policies
-- Faculty can view their own profile
CREATE POLICY IF NOT EXISTS "Faculty can view own profile" ON faculty_profiles
    FOR SELECT USING (auth.uid() = user_id);

-- Faculty can update their own profile
CREATE POLICY IF NOT EXISTS "Faculty can update own profile" ON faculty_profiles
    FOR UPDATE USING (auth.uid() = user_id);

-- Admins can view all faculty profiles
CREATE POLICY IF NOT EXISTS "Admins can view all faculty profiles" ON faculty_profiles
    FOR SELECT USING (
        auth.uid() = user_id OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Admins can update faculty profiles
CREATE POLICY IF NOT EXISTS "Admins can update faculty profiles" ON faculty_profiles
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Only admins can create faculty profiles
CREATE POLICY IF NOT EXISTS "Admins can create faculty profiles" ON faculty_profiles
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Only admins can delete faculty profiles
CREATE POLICY "Admins can delete faculty profiles" ON faculty_profiles
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM admin_profiles 
            WHERE user_id = auth.uid()
        )
    );

-- Courses table policies
-- All authenticated users can view active courses
CREATE POLICY IF NOT EXISTS "Authenticated users can view active courses" ON courses
    FOR SELECT USING (is_active = true);

-- Faculty and admins can create courses
CREATE POLICY IF NOT EXISTS "Faculty and admins can create courses" ON courses
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Course creators can update their courses
CREATE POLICY IF NOT EXISTS "Course creators can update own courses" ON courses
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Course creators can delete their courses
CREATE POLICY "Course creators can delete own courses" ON courses
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Enrollments table policies
-- Students can view their own enrollments
CREATE POLICY "Students can view own enrollments" ON enrollments
    FOR SELECT USING (auth.uid() = student_id);

-- Faculty and admins can view all enrollments
CREATE POLICY "Faculty and admins can view all enrollments" ON enrollments
    FOR SELECT USING (
        auth.uid() = student_id OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Students can create their own enrollments
CREATE POLICY "Students can create own enrollments" ON enrollments
    FOR INSERT WITH CHECK (auth.uid() = student_id);

-- Faculty and admins can update enrollments
CREATE POLICY "Faculty and admins can update enrollments" ON enrollments
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Faculty and admins can delete enrollments
CREATE POLICY IF NOT EXISTS "Faculty and admins can delete enrollments" ON enrollments
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Academic History table policies
-- Students can view their own academic history
CREATE POLICY IF NOT EXISTS "Students can view own academic history" ON academic_history
    FOR SELECT USING (auth.uid() = student_id);

-- Faculty and admins can view all academic history
CREATE POLICY IF NOT EXISTS "Faculty and admins can view academic history" ON academic_history
    FOR SELECT USING (
        auth.uid() = student_id OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Faculty and admins can create academic history
CREATE POLICY IF NOT EXISTS "Faculty and admins can create academic history" ON academic_history
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Faculty and admins can update academic history
CREATE POLICY IF NOT EXISTS "Faculty and admins can update academic history" ON academic_history
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Faculty and admins can delete academic history
CREATE POLICY IF NOT EXISTS "Faculty and admins can delete academic history" ON academic_history
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role IN ('faculty', 'admin')
        )
    );

-- Notifications table policies
-- Users can view their own notifications
CREATE POLICY IF NOT EXISTS "Users can view own notifications" ON notifications
    FOR SELECT USING (auth.uid() = recipient_id);

-- Users can mark their own notifications as read
CREATE POLICY IF NOT EXISTS "Users can update own notifications" ON notifications
    FOR UPDATE USING (auth.uid() = recipient_id);

-- Any authenticated user can create notifications
CREATE POLICY IF NOT EXISTS "Authenticated users can create notifications" ON notifications
    FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

-- Users can delete their own notifications
CREATE POLICY "Users can delete own notifications" ON notifications
    FOR DELETE USING (auth.uid() = recipient_id);

-- Admin Profiles table policies
-- Admins can view their own admin profile
CREATE POLICY IF NOT EXISTS "Admins can view own profile" ON admin_profiles
    FOR SELECT USING (auth.uid() = user_id);

-- Admins can update their own admin profile
CREATE POLICY IF NOT EXISTS "Admins can update own profile" ON admin_profiles
    FOR UPDATE USING (auth.uid() = user_id);

-- Only system admins can create admin profiles
CREATE POLICY IF NOT EXISTS "System admins can create admin profiles" ON admin_profiles
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Only system admins can delete admin profiles
CREATE POLICY IF NOT EXISTS "System admins can delete admin profiles" ON admin_profiles
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );
