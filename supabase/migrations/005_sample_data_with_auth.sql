-- Sample Data Insert Queries for Educational Management System
-- This migration creates auth.users first, then public.users data

-- Step 1: Create users in auth.users table (Supabase Auth)
-- Note: These are minimal auth.user records - in production, users would sign up through the auth system
-- For testing purposes, we're inserting directly into auth.users

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
('550e8400-e29b-41d4-a716-446655440006', 'admin@university.edu', crypt('admin123', gen_salt('bf')), NOW(), NOW(), NOW(), NOW(), 'authenticated');

-- Step 2: Insert corresponding records into public.users table
INSERT INTO public.users (id, system_id, name, email, role, status, joined_at) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'SYS001', 'John Smith', 'john.smith@university.edu', 'student', 'active', '2023-08-15 09:00:00'),
('550e8400-e29b-41d4-a716-446655440002', 'SYS002', 'Jane Doe', 'jane.doe@university.edu', 'student', 'active', '2023-08-15 09:30:00'),
('550e8400-e29b-41d4-a716-446655440003', 'SYS003', 'Mike Johnson', 'mike.johnson@university.edu', 'student', 'active', '2023-08-15 10:00:00'),
('550e8400-e29b-41d4-a716-446655440004', 'FAC001', 'Dr. Sarah Williams', 'sarah.williams@university.edu', 'faculty', 'active', '2022-08-01 08:00:00'),
('550e8400-e29b-41d4-a716-446655440005', 'FAC002', 'Prof. Robert Brown', 'robert.brown@university.edu', 'faculty', 'active', '2021-08-01 08:00:00'),
('550e8400-e29b-41d4-a716-446655440006', 'ADM001', 'Admin User', 'admin@university.edu', 'admin', 'active', '2020-06-01 08:00:00');

-- Step 3: Insert Student Profiles
INSERT INTO public.student_profiles (id, user_id, student_number, course, section, year_level, admission_date, gpa, units_completed, units_enrolled) VALUES
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '2023001', 'Computer Science', 'A', '1st Year', '2023-08-15', 3.25, 24, 18),
('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', '2023002', 'Information Technology', 'B', '2nd Year', '2022-08-15', 3.45, 48, 21),
('660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', '2023003', 'Computer Science', 'A', '3rd Year', '2021-08-15', 3.78, 72, 15);

-- Step 4: Insert Faculty Profiles
INSERT INTO public.faculty_profiles (id, user_id, employee_number, department, position, specialization, hire_date) VALUES
('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440004', 'FAC2022001', 'Computer Science', 'Associate Professor', 'Artificial Intelligence', '2022-08-01'),
('770e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440005', 'FAC2021001', 'Information Technology', 'Professor', 'Database Systems', '2021-08-01');

-- Step 5: Insert Admin Profiles
INSERT INTO public.admin_profiles (id, user_id, admin_level, permissions) VALUES
('880e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440006', 'super', ARRAY['user_management', 'system_settings', 'academic_records', 'reports']);

-- Step 6: Insert Courses
INSERT INTO public.courses (id, course_code, course_name, description, units, department, is_active) VALUES
('990e8400-e29b-41d4-a716-446655440001', 'CS101', 'Introduction to Computer Science', 'Fundamental concepts of computer science and programming', 3, 'Computer Science', true),
('990e8400-e29b-41d4-a716-446655440002', 'CS102', 'Data Structures and Algorithms', 'Advanced data structures and algorithm analysis', 3, 'Computer Science', true),
('990e8400-e29b-41d4-a716-446655440003', 'IT201', 'Database Management Systems', 'Introduction to database design and SQL', 3, 'Information Technology', true),
('990e8400-e29b-41d4-a716-446655440004', 'CS301', 'Artificial Intelligence', 'Introduction to AI concepts and applications', 3, 'Computer Science', true),
('990e8400-e29b-41d4-a716-446655440005', 'IT202', 'Web Development', 'Modern web development technologies', 3, 'Information Technology', true),
('990e8400-e29b-41d4-a716-446655440006', 'CS201', 'Computer Networks', 'Fundamentals of computer networking', 3, 'Computer Science', true);

-- Step 7: Insert Enrollments
INSERT INTO public.enrollments (id, student_id, course_id, semester, academic_year, status, grade, enrolled_at) VALUES
('bb0e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440001', 'First Semester', '2023-2024', 'completed', 88, '2023-08-15 09:00:00'),
('bb0e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440002', 'Second Semester', '2023-2024', 'enrolled', NULL, '2024-01-15 09:00:00'),
('bb0e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440003', 'First Semester', '2023-2024', 'completed', 92, '2023-08-15 09:30:00'),
('bb0e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440004', 'First Semester', '2023-2024', 'enrolled', NULL, '2023-08-15 10:00:00'),
('bb0e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440005', 'First Semester', '2023-2024', 'enrolled', NULL, '2023-08-15 10:00:00');

-- Step 8: Insert Academic History
INSERT INTO public.academic_history (id, student_id, course_id, semester, academic_year, grade, credits_earned, gpa_impact) VALUES
('cc0e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440001', 'First Semester', '2023-2024', 88, 3, 3.00),
('cc0e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440003', 'First Semester', '2023-2024', 92, 3, 3.67);

-- Step 9: Insert Notifications
INSERT INTO public.notifications (id, recipient_id, sender_id, title, message, type, is_read, priority, created_at) VALUES
('005e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440004', 'Welcome to CS101', 'Your enrollment in Introduction to Computer Science has been confirmed. Please check the course schedule.', 'info', false, 'normal', '2023-08-15 09:30:00'),
('005e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440005', 'Assignment Due', 'Database Management Systems Assignment 1 is due on Friday, September 1st.', 'warning', false, 'high', '2023-08-25 14:00:00'),
('005e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440006', 'System Maintenance', 'The system will be under maintenance this weekend from Saturday 10 PM to Sunday 2 AM.', 'system', true, 'low', '2023-08-28 16:00:00');

-- Update some timestamps to reflect realistic data
UPDATE public.users SET last_login_at = '2024-01-20 14:30:00' WHERE id = '550e8400-e29b-41d4-a716-446655440001';
UPDATE public.users SET last_login_at = '2024-01-19 16:45:00' WHERE id = '550e8400-e29b-41d4-a716-446655440002';
UPDATE public.users SET last_login_at = '2024-01-18 10:15:00' WHERE id = '550e8400-e29b-41d4-a716-446655440004';

-- Mark some notifications as read
UPDATE public.notifications SET is_read = true, read_at = '2023-08-15 10:00:00' WHERE id = '005e8400-e29b-41d4-a716-446655440003';

-- Complete sample data insertion for testing and demonstration purposes
-- This provides a comprehensive dataset covering all major functionalities of the system
