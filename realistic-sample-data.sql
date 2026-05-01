-- =====================================================
-- Comprehensive Realistic Sample Data for All Modules
-- CCS Organization Management System - Philippine Edition
-- Generated: May 1, 2026
-- =====================================================

-- Enable UUID extension for generating UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- DISABLE CONSTRAINTS TEMPORARILY
-- =====================================================
SET session_replication_role = 'replica';

-- Store constraint definitions and drop them temporarily
BEGIN;
ALTER TABLE admin_profiles DROP CONSTRAINT IF EXISTS admin_profiles_admin_level_check;
ALTER TABLE faculty_profiles DROP CONSTRAINT IF EXISTS faculty_profiles_position_check;
ALTER TABLE student_profiles DROP CONSTRAINT IF EXISTS student_profiles_enrollment_status_check;
ALTER TABLE enrollments DROP CONSTRAINT IF EXISTS enrollments_status_check;
ALTER TABLE notifications DROP CONSTRAINT IF EXISTS notifications_type_check;
ALTER TABLE notifications DROP CONSTRAINT IF EXISTS notifications_priority_check;
ALTER TABLE academic_history DROP CONSTRAINT IF EXISTS academic_history_grade_letter_check;
COMMIT;

-- =====================================================
-- 1. USERS TABLE - Core user accounts
-- =====================================================

-- Admin Users
INSERT INTO users (
    id, 
    email, 
    name, 
    role, 
    system_id, 
    status, 
    created_at, 
    joined_at, 
    last_login_at
) VALUES 
(
    '550e8400-e29b-41d4-a716-446655440001'::uuid,
    'admin@ccs.edu.ph',
    'Dr. Maria Santos',
    'admin',
    'ADMIN001',
    'active',
    '2024-01-15 08:00:00',
    '2024-01-15 08:00:00',
    '2026-05-01 07:30:00'
),
(
    '550e8400-e29b-41d4-a716-446655440002'::uuid,
    'registrar@ccs.edu.ph',
    'Juan Dela Cruz',
    'admin', 
    'ADMIN002',
    'active',
    '2024-01-20 09:15:00',
    '2024-01-20 09:15:00',
    '2026-05-01 08:45:00'
),
(
    '550e8400-e29b-41d4-a716-446655440003'::uuid,
    'it.admin@ccs.edu.ph',
    'Christine Reyes',
    'admin',
    'ADMIN003', 
    'active',
    '2024-02-01 10:30:00',
    '2024-02-01 10:30:00',
    '2026-04-30 16:20:00'
);

-- Faculty Users
INSERT INTO users (
    id,
    email,
    name,
    role,
    system_id,
    status,
    created_at,
    joined_at,
    last_login_at
) VALUES
(
    '550e8400-e29b-41d4-a716-446655440010'::uuid,
    'dr.fernando@ccs.edu.ph',
    'Dr. Fernando Mercado',
    'faculty',
    'FAC001',
    'active',
    '2024-01-10 11:00:00',
    '2024-01-10 11:00:00',
    '2026-05-01 09:15:00'
),
(
    '550e8400-e29b-41d4-a716-446655440011'::uuid,
    'prof.olivia@ccs.edu.ph',
    'Dr. Olivia Fernandez',
    'faculty',
    'FAC002',
    'active',
    '2024-01-12 14:30:00',
    '2024-01-12 14:30:00',
    '2026-04-29 15:45:00'
),
(
    '550e8400-e29b-41d4-a716-446655440012'::uuid,
    'dr.ramon@ccs.edu.ph',
    'Dr. Ramon Gonzales',
    'faculty',
    'FAC003',
    'active',
    '2024-01-15 09:00:00',
    '2024-01-15 09:00:00',
    '2026-05-01 10:30:00'
),
(
    '550e8400-e29b-41d4-a716-446655440013'::uuid,
    'prof.teresa@ccs.edu.ph',
    'Dr. Teresa Lim',
    'faculty',
    'FAC004',
    'active',
    '2024-02-01 13:15:00',
    '2024-02-01 13:15:00',
    '2026-04-30 11:20:00'
),
(
    '550e8400-e29b-41d4-a716-446655440014'::uuid,
    'dr.carlos@ccs.edu.ph',
    'Dr. Carlos Villanueva',
    'faculty',
    'FAC005',
    'active',
    '2024-02-10 10:45:00',
    '2024-02-10 10:45:00',
    '2026-04-28 14:30:00'
);

-- Student Users
INSERT INTO users (
    id,
    email,
    name,
    role,
    system_id,
    status,
    created_at,
    joined_at,
    last_login_at
) VALUES
(
    '550e8400-e29b-41d4-a716-446655440100'::uuid,
    'paulo.santos@student.ccs.edu.ph',
    'Paulo Santos',
    'student',
    'STU001',
    'active',
    '2024-08-15 16:00:00',
    '2024-08-15 16:00:00',
    '2026-05-01 12:00:00'
),
(
    '550e8400-e29b-41d4-a716-446655440101'::uuid,
    'rosario.garcia@student.ccs.edu.ph',
    'Rosario Garcia',
    'student',
    'STU002',
    'active',
    '2024-08-16 14:30:00',
    '2024-08-16 14:30:00',
    '2026-04-30 18:45:00'
),
(
    '550e8400-e29b-41d4-a716-446655440102'::uuid,
    'kevin.lim@student.ccs.edu.ph',
    'Kevin Lim',
    'student',
    'STU003',
    'active',
    '2024-08-17 11:00:00',
    '2024-08-17 11:00:00',
    '2026-05-01 09:30:00'
),
(
    '550e8400-e29b-41d4-a716-446655440103'::uuid,
    'maria.cruz@student.ccs.edu.ph',
    'Maria Cruz',
    'student',
    'STU004',
    'active',
    '2024-08-18 15:20:00',
    '2024-08-18 15:20:00',
    '2026-04-29 16:10:00'
),
(
    '550e8400-e29b-41d4-a716-446655440104'::uuid,
    'alex.navarro@student.ccs.edu.ph',
    'Alex Navarro',
    'student',
    'STU005',
    'active',
    '2024-08-19 09:45:00',
    '2024-08-19 09:45:00',
    '2026-05-01 13:20:00'
),
(
    '550e8400-e29b-41d4-a716-446655440105'::uuid,
    'emma.torres@student.ccs.edu.ph',
    'Emma Torres',
    'student',
    'STU006',
    'active',
    '2024-08-20 13:00:00',
    '2024-08-20 13:00:00',
    '2026-04-30 10:15:00'
),
(
    '550e8400-e29b-41d4-a716-446655440106'::uuid,
    'ryan.reyes@student.ccs.edu.ph',
    'Ryan Reyes',
    'student',
    'STU007',
    'active',
    '2024-08-21 10:30:00',
    '2024-08-21 10:30:00',
    '2026-04-28 15:00:00'
),
(
    '550e8400-e29b-41d4-a716-446655440107'::uuid,
    'olivia.roxas@student.ccs.edu.ph',
    'Olivia Roxas',
    'student',
    'STU008',
    'active',
    '2024-08-22 14:15:00',
    '2024-08-22 14:15:00',
    '2026-05-01 11:45:00'
);

-- =====================================================
-- 2. ADMIN_PROFILES TABLE - Admin user details
-- =====================================================

INSERT INTO admin_profiles (
    id,
    user_id,
    admin_level,
    department,
    created_at,
    updated_at
) VALUES
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440001'::uuid,
    'super_admin',
    'System Administration',
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440002'::uuid,
    'senior_admin',
    'Registrar Office',
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440003'::uuid,
    'junior_admin',
    'IT Department',
    NOW(),
    NOW()
);

-- =====================================================
-- 3. FACULTY_PROFILES TABLE - Faculty member details
-- =====================================================

INSERT INTO faculty_profiles (
    id,
    user_id,
    employee_id,
    department,
    position,
    specialization,
    hire_date,
    created_at,
    updated_at
) VALUES
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440010'::uuid,
    'FAC001',
    'Computer Science',
    'Associate Professor',
    'Artificial Intelligence, Machine Learning, Data Science',
    '2020-08-15',
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440011'::uuid,
    'FAC002',
    'Mathematics',
    'Assistant Professor',
    'Applied Mathematics, Statistics, Computational Theory',
    '2019-01-10',
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440012'::uuid,
    'FAC003',
    'Engineering',
    'Associate Professor',
    'Software Engineering, System Architecture, Cloud Computing',
    '2021-03-20',
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440013'::uuid,
    'FAC004',
    'Business',
    'Lecturer',
    'Business Analytics, Marketing Research, Strategic Management',
    '2022-09-01',
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440014'::uuid,
    'FAC005',
    'Information Technology',
    'Assistant Professor',
    'Information Systems, Database Management, Network Security',
    '2020-06-15',
    NOW(),
    NOW()
);

-- =====================================================
-- 4. STUDENT_PROFILES TABLE - Student academic details
-- =====================================================

INSERT INTO student_profiles (
    id,
    user_id,
    student_number,
    program,
    year_level,
    gpa,
    enrollment_status,
    created_at,
    updated_at
) VALUES
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440100'::uuid,
    '2024STU001',
    'Bachelor of Science in Computer Science',
    4,
    3.75,
    'enrolled',
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440101'::uuid,
    '2024STU002',
    'Bachelor of Science in Business Administration',
    4,
    3.60,
    'enrolled',
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440102'::uuid,
    '2024STU003',
    'Bachelor of Science in Computer Science',
    3,
    3.90,
    'enrolled',
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440103'::uuid,
    '2024STU004',
    'Bachelor of Science in Business Administration',
    3,
    3.40,
    'enrolled',
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440104'::uuid,
    '2024STU005',
    'Bachelor of Science in Computer Science',
    3,
    3.70,
    'enrolled',
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440105'::uuid,
    '2024STU006',
    'Bachelor of Science in Engineering',
    2,
    3.50,
    'enrolled',
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440106'::uuid,
    '2024STU007',
    'Bachelor of Science in Engineering',
    2,
    3.20,
    'enrolled',
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440107'::uuid,
    '2024STU008',
    'Bachelor of Science in Information Technology',
    1,
    3.60,
    'enrolled',
    NOW(),
    NOW()
);

-- =====================================================
-- 5. COURSES TABLE - Academic courses
-- =====================================================

INSERT INTO courses (
    id,
    course_code,
    title,
    description,
    credits,
    department,
    academic_year,
    semester,
    faculty_id,
    max_students,
    is_active,
    created_at,
    updated_at
) VALUES
-- Computer Science Courses
(
    '650e8400-e29b-41d4-a716-446655440001'::uuid,
    'CS101',
    'Introduction to Computer Science',
    'Fundamental concepts of computer science including programming, algorithms, and data structures.',
    3,
    'Computer Science',
    '2024-2025',
    'First Semester',
    (SELECT id FROM faculty_profiles WHERE employee_id = 'FAC001' LIMIT 1),
    30,
    true,
    NOW(),
    NOW()
),
(
    '650e8400-e29b-41d4-a716-446655440002'::uuid,
    'CS201',
    'Data Structures and Algorithms',
    'Advanced data structures including trees, graphs, and algorithm analysis.',
    4,
    'Computer Science',
    '2024-2025',
    'First Semester',
    (SELECT id FROM faculty_profiles WHERE employee_id = 'FAC001' LIMIT 1),
    25,
    true,
    NOW(),
    NOW()
),
(
    '650e8400-e29b-41d4-a716-446655440003'::uuid,
    'CS301',
    'Machine Learning',
    'Introduction to machine learning algorithms, neural networks, and practical applications.',
    4,
    'Computer Science',
    '2024-2025',
    'Second Semester',
    (SELECT id FROM faculty_profiles WHERE employee_id = 'FAC001' LIMIT 1),
    20,
    true,
    NOW(),
    NOW()
),
-- Mathematics Courses
(
    '650e8400-e29b-41d4-a716-446655440004'::uuid,
    'MATH101',
    'Calculus I',
    'Differential and integral calculus with applications.',
    4,
    'Mathematics',
    '2024-2025',
    'First Semester',
    (SELECT id FROM faculty_profiles WHERE employee_id = 'FAC002' LIMIT 1),
    35,
    true,
    NOW(),
    NOW()
),
(
    '650e8400-e29b-41d4-a716-446655440005'::uuid,
    'MATH201',
    'Linear Algebra',
    'Vector spaces, matrices, linear transformations, and eigenvalues.',
    3,
    'Mathematics',
    '2024-2025',
    'Second Semester',
    (SELECT id FROM faculty_profiles WHERE employee_id = 'FAC002' LIMIT 1),
    30,
    true,
    NOW(),
    NOW()
),
-- Engineering Courses
(
    '650e8400-e29b-41d4-a716-446655440006'::uuid,
    'ENG101',
    'Engineering Fundamentals',
    'Introduction to engineering principles, design, and problem-solving.',
    3,
    'Engineering',
    '2024-2025',
    'First Semester',
    (SELECT id FROM faculty_profiles WHERE employee_id = 'FAC003' LIMIT 1),
    40,
    true,
    NOW(),
    NOW()
),
(
    '650e8400-e29b-41d4-a716-446655440007'::uuid,
    'ENG201',
    'Software Engineering',
    'Software development lifecycle, design patterns, and project management.',
    4,
    'Engineering',
    '2024-2025',
    'Second Semester',
    (SELECT id FROM faculty_profiles WHERE employee_id = 'FAC003' LIMIT 1),
    25,
    true,
    NOW(),
    NOW()
),
-- Business Courses
(
    '650e8400-e29b-41d4-a716-446655440008'::uuid,
    'BUS101',
    'Introduction to Business',
    'Fundamental concepts of business administration and management.',
    3,
    'Business',
    '2024-2025',
    'First Semester',
    (SELECT id FROM faculty_profiles WHERE employee_id = 'FAC004' LIMIT 1),
    45,
    true,
    NOW(),
    NOW()
),
(
    '650e8400-e29b-41d4-a716-446655440009'::uuid,
    'BUS201',
    'Business Analytics',
    'Data analysis and statistical methods for business decision-making.',
    3,
    'Business',
    '2024-2025',
    'Second Semester',
    (SELECT id FROM faculty_profiles WHERE employee_id = 'FAC004' LIMIT 1),
    30,
    true,
    NOW(),
    NOW()
);

-- =====================================================
-- 6. ENROLLMENTS TABLE - Student course enrollments
-- =====================================================

INSERT INTO enrollments (
    id,
    student_id,
    course_id,
    enrollment_date,
    status,
    final_grade,
    created_at,
    updated_at
) VALUES
-- Paulo Santos - Computer Science Year 4
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU001' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440001'::uuid,
    '2024-08-25',
    'enrolled',
    95.0,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU001' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440004'::uuid,
    '2024-08-25',
    'enrolled',
    88.0,
    NOW(),
    NOW()
),
-- Rosario Garcia - Business Administration Year 4
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU002' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440008'::uuid,
    '2024-08-25',
    'enrolled',
    92.0,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU002' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440009'::uuid,
    '2025-01-15',
    'enrolled',
    87.0,
    NOW(),
    NOW()
),
-- Kevin Lim - Computer Science Year 3
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU003' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440001'::uuid,
    '2024-08-25',
    'enrolled',
    96.0,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU003' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440002'::uuid,
    '2024-08-25',
    'enrolled',
    91.0,
    NOW(),
    NOW()
),
-- Maria Cruz - Business Administration Year 3
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU004' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440008'::uuid,
    '2024-08-25',
    'enrolled',
    NULL,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU004' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440004'::uuid,
    '2024-08-25',
    'enrolled',
    NULL,
    NOW(),
    NOW()
),
-- Alex Navarro - Computer Science Year 3
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU005' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440001'::uuid,
    '2024-08-25',
    'enrolled',
    NULL,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU005' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440004'::uuid,
    '2024-08-25',
    'enrolled',
    NULL,
    NOW(),
    NOW()
),
-- Emma Torres - Engineering Year 2
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU006' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440006'::uuid,
    '2024-08-25',
    'enrolled',
    NULL,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU006' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440004'::uuid,
    '2024-08-25',
    'enrolled',
    NULL,
    NOW(),
    NOW()
),
-- Ryan Reyes - Engineering Year 2
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU007' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440006'::uuid,
    '2024-08-25',
    'enrolled',
    NULL,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU007' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440004'::uuid,
    '2024-08-25',
    'enrolled',
    NULL,
    NOW(),
    NOW()
),
-- Olivia Roxas - Information Technology Year 1
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU008' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440001'::uuid,
    '2024-08-25',
    'enrolled',
    NULL,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU008' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440004'::uuid,
    '2024-08-25',
    'enrolled',
    NULL,
    NOW(),
    NOW()
);

-- =====================================================
-- 7. NOTIFICATIONS TABLE - System notifications
-- =====================================================

INSERT INTO notifications (
    id,
    recipient_id,
    sender_id,
    title,
    message,
    type,
    priority,
    is_read,
    read_at,
    created_at,
    updated_at
) VALUES
-- Academic notifications
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440100'::uuid,
    '550e8400-e29b-41d4-a716-446655440010'::uuid,
    'Assignment Due Reminder',
    'Your Machine Learning assignment is due tomorrow at 11:59 PM. Please ensure you submit it on time.',
    'academic',
    'high',
    false,
    NULL,
    '2026-05-01 09:00:00',
    '2026-05-01 09:00:00'
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440101'::uuid,
    '550e8400-e29b-41d4-a716-446655440013'::uuid,
    'Grade Posted',
    'Your Business Analytics midterm grades have been posted. You scored 87/100.',
    'academic',
    'medium',
    true,
    '2026-04-30 14:30:00',
    '2026-04-30 10:00:00',
    '2026-04-30 10:00:00'
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440102'::uuid,
    '550e8400-e29b-41d4-a716-446655440001'::uuid,
    'Registration Open',
    'Course registration for First Semester 2025 is now open. Please register by May 15.',
    'administrative',
    'high',
    false,
    NULL,
    '2026-05-01 08:00:00',
    '2026-05-01 08:00:00'
),
-- System notifications
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440010'::uuid,
    '550e8400-e29b-41d4-a716-446655440002'::uuid,
    'System Maintenance',
    'The system will be under maintenance this Sunday from 2:00 AM to 6:00 AM.',
    'system',
    'medium',
    true,
    '2026-04-29 16:00:00',
    '2026-04-29 12:00:00',
    '2026-04-29 12:00:00'
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440001'::uuid,
    '550e8400-e29b-41d4-a716-446655440001'::uuid,
    'Security Update',
    'New security features have been implemented. Please review the updated policies.',
    'security',
    'high',
    true,
    '2026-04-28 10:30:00',
    '2026-04-28 09:00:00',
    '2026-04-28 09:00:00'
),
-- Personal notifications
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440103'::uuid,
    '550e8400-e29b-41d4-a716-446655440011'::uuid,
    'Office Hours Reminder',
    'Professor Fernandez has office hours today from 2:00 PM to 4:00 PM in Room 301.',
    'personal',
    'low',
    false,
    NULL,
    '2026-05-01 11:00:00',
    '2026-05-01 11:00:00'
),
(
    uuid_generate_v4(),
    '550e8400-e29b-41d4-a716-446655440104'::uuid,
    '550e8400-e29b-41d4-a716-446655440003'::uuid,
    'Password Expiry',
    'Your password will expire in 7 days. Please update it to maintain access.',
    'security',
    'medium',
    false,
    NULL,
    '2026-04-30 15:00:00',
    '2026-04-30 15:00:00'
);

-- =====================================================
-- 8. GRADE_SCALES TABLE - Grading system configuration
-- =====================================================

INSERT INTO grade_scales (
    id,
    name,
    grade_letter,
    grade_points,
    min_score,
    max_score,
    description,
    is_active,
    created_at,
    updated_at
) VALUES
(
    uuid_generate_v4(),
    'Standard A+',
    'A+',
    4.0,
    97.0,
    100.0,
    'Excellent performance, outstanding achievement',
    true,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'Standard A',
    'A',
    4.0,
    93.0,
    96.99,
    'Excellent performance',
    true,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'Standard A-',
    'A-',
    3.7,
    90.0,
    92.99,
    'Very good performance',
    true,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'Standard B+',
    'B+',
    3.3,
    87.0,
    89.99,
    'Good performance',
    true,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'Standard B',
    'B',
    3.0,
    83.0,
    86.99,
    'Good performance',
    true,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'Standard B-',
    'B-',
    2.7,
    80.0,
    82.99,
    'Satisfactory performance',
    true,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'Standard C+',
    'C+',
    2.3,
    77.0,
    79.99,
    'Satisfactory performance',
    true,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'Standard C',
    'C',
    2.0,
    73.0,
    76.99,
    'Satisfactory performance',
    true,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'Standard C-',
    'C-',
    1.7,
    70.0,
    72.99,
    'Minimum passing grade',
    true,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'Standard D',
    'D',
    1.0,
    60.0,
    69.99,
    'Poor performance, passing',
    true,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'Standard F',
    'F',
    0.0,
    0.0,
    59.99,
    'Failing grade',
    true,
    NOW(),
    NOW()
);

-- =====================================================
-- 9. SYSTEM_SETTINGS TABLE - System configuration
-- =====================================================

INSERT INTO system_settings (
    id,
    key,
    value,
    category,
    description,
    is_public,
    created_at,
    updated_at
) VALUES
(
    uuid_generate_v4(),
    'academic_year',
    '2024-2025',
    'academic',
    'Current academic year',
    true,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'current_semester',
    'Second Semester',
    'academic',
    'Current semester',
    true,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'registration_deadline',
    '2025-05-15',
    'registration',
    'Course registration deadline',
    true,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'max_credits_per_semester',
    '21',
    'academic',
    'Maximum credits a student can take per semester',
    true,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'min_gpa_for_good_standing',
    '2.0',
    'academic',
    'Minimum GPA required for good academic standing',
    true,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'system_maintenance_schedule',
    'Sunday 2:00 AM - 6:00 AM',
    'system',
    'Weekly system maintenance window',
    true,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'password_expiry_days',
    '90',
    'security',
    'Number of days before password expires',
    false,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    'max_login_attempts',
    '5',
    'security',
    'Maximum failed login attempts before account lockout',
    false,
    NOW(),
    NOW()
);

-- =====================================================
-- 10. ACADEMIC_HISTORY TABLE - Student academic records
-- =====================================================

INSERT INTO academic_history (
    id,
    student_id,
    course_id,
    academic_year,
    semester,
    grade,
    grade_letter,
    credits_earned,
    gpa_points,
    created_at,
    updated_at
) VALUES
-- Paulo Santos
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU001' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440001'::uuid,
    '2024-2025',
    'First Semester',
    95.0,
    'A',
    3,
    9.00,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU001' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440004'::uuid,
    '2024-2025',
    'First Semester',
    88.0,
    'B+',
    4,
    9.90,
    NOW(),
    NOW()
),
-- Rosario Garcia
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU002' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440008'::uuid,
    '2024-2025',
    'First Semester',
    92.0,
    'A-',
    3,
    9.00,
    NOW(),
    NOW()
),
-- Kevin Lim
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU003' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440001'::uuid,
    '2024-2025',
    'First Semester',
    96.0,
    'A',
    3,
    9.00,
    NOW(),
    NOW()
),
(
    uuid_generate_v4(),
    (SELECT id FROM student_profiles WHERE student_number = '2024STU003' LIMIT 1),
    '650e8400-e29b-41d4-a716-446655440002'::uuid,
    '2024-2025',
    'First Semester',
    91.0,
    'A-',
    4,
    9.90,
    NOW(),
    NOW()
);

-- =====================================================
-- RE-ENABLE CONSTRAINTS
-- =====================================================
SET session_replication_role = 'origin';

-- Recreate constraints with updated definitions
BEGIN;
ALTER TABLE admin_profiles ADD CONSTRAINT admin_profiles_admin_level_check 
    CHECK (admin_level IN ('super_admin', 'senior_admin', 'junior_admin'));
ALTER TABLE faculty_profiles ADD CONSTRAINT faculty_profiles_position_check 
    CHECK (position IN ('Professor', 'Associate Professor', 'Assistant Professor', 'Lecturer', 'Instructor'));
ALTER TABLE student_profiles ADD CONSTRAINT student_profiles_enrollment_status_check 
    CHECK (enrollment_status IN ('enrolled', 'suspended', 'graduated', 'withdrawn'));
ALTER TABLE enrollments ADD CONSTRAINT enrollments_status_check 
    CHECK (status IN ('enrolled', 'completed', 'withdrawn', 'dropped'));
ALTER TABLE notifications ADD CONSTRAINT notifications_type_check 
    CHECK (type IN ('academic', 'administrative', 'system', 'personal', 'security'));
ALTER TABLE notifications ADD CONSTRAINT notifications_priority_check 
    CHECK (priority IN ('low', 'medium', 'high'));
ALTER TABLE academic_history ADD CONSTRAINT academic_history_grade_letter_check 
    CHECK (grade_letter IN ('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D', 'F'));
COMMIT;

-- =====================================================
-- Summary Statistics
-- =====================================================

-- Display summary of inserted data
DO $$
DECLARE
    user_count INTEGER;
    admin_count INTEGER;
    faculty_count INTEGER;
    student_count INTEGER;
    course_count INTEGER;
    enrollment_count INTEGER;
    notification_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO user_count FROM users;
    SELECT COUNT(*) INTO admin_count FROM users WHERE role = 'admin';
    SELECT COUNT(*) INTO faculty_count FROM users WHERE role = 'faculty';
    SELECT COUNT(*) INTO student_count FROM users WHERE role = 'student';
    SELECT COUNT(*) INTO course_count FROM courses;
    SELECT COUNT(*) INTO enrollment_count FROM enrollments;
    SELECT COUNT(*) INTO notification_count FROM notifications;
    
    RAISE NOTICE '=== Philippine College Sample Data Insertion Summary ===';
    RAISE NOTICE 'Total Users: %', user_count;
    RAISE NOTICE '  - Admins: %', admin_count;
    RAISE NOTICE '  - Faculty: %', faculty_count;
    RAISE NOTICE '  - Students: %', student_count;
    RAISE NOTICE 'Courses: %', course_count;
    RAISE NOTICE 'Enrollments: %', enrollment_count;
    RAISE NOTICE 'Notifications: %', notification_count;
    RAISE NOTICE '====================================================';
END $$;

-- =====================================================
-- Data Validation Queries
-- =====================================================

-- Verify foreign key relationships
SELECT 
    'Users' as table_name,
    COUNT(*) as count,
    COUNT(CASE WHEN role = 'admin' THEN 1 END) as admins,
    COUNT(CASE WHEN role = 'faculty' THEN 1 END) as faculty,
    COUNT(CASE WHEN role = 'student' THEN 1 END) as students
FROM users

UNION ALL

SELECT 
    'Admin Profiles' as table_name,
    COUNT(*) as count,
    0 as admins,
    0 as faculty,
    0 as students
FROM admin_profiles

UNION ALL

SELECT 
    'Faculty Profiles' as table_name,
    COUNT(*) as count,
    0 as admins,
    0 as faculty,
    0 as students
FROM faculty_profiles

UNION ALL

SELECT 
    'Student Profiles' as table_name,
    COUNT(*) as count,
    0 as admins,
    0 as faculty,
    0 as students
FROM student_profiles

UNION ALL

SELECT 
    'Courses' as table_name,
    COUNT(*) as count,
    0 as admins,
    0 as faculty,
    0 as students
FROM courses

UNION ALL

SELECT 
    'Enrollments' as table_name,
    COUNT(*) as count,
    0 as admins,
    0 as faculty,
    0 as students
FROM enrollments

UNION ALL

SELECT 
    'Notifications' as table_name,
    COUNT(*) as count,
    0 as admins,
    0 as faculty,
    0 as students
FROM notifications

ORDER BY table_name;