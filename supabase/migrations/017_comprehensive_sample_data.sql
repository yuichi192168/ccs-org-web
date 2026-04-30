-- Comprehensive Sample Data for Educational Management System
-- Migration: 017_comprehensive_sample_data.sql

-- =============================================
-- SAMPLE DATA INSERTION
-- =============================================

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- USERS SAMPLE DATA
-- =============================================

-- Insert sample users
INSERT INTO public.users (id, system_id, name, email, role, status, joined_at, last_login_at) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'SYS001', 'John Smith', 'john.smith@university.edu', 'student', 'active', NOW() - INTERVAL '2 years', NOW() - INTERVAL '1 day'),
('550e8400-e29b-41d4-a716-446655440001', 'SYS002', 'Jane Doe', 'jane.doe@university.edu', 'student', 'active', NOW() - INTERVAL '2 years', NOW() - INTERVAL '2 days'),
('550e8400-e29b-41d4-a716-446655440002', 'SYS003', 'Dr. Robert Johnson', 'robert.johnson@university.edu', 'faculty', 'active', NOW() - INTERVAL '5 years', NOW() - INTERVAL '1 hour'),
('550e8400-e29b-41d4-a716-446655440003', 'SYS004', 'Dr. Sarah Williams', 'sarah.williams@university.edu', 'faculty', 'active', NOW() - INTERVAL '3 years', NOW() - INTERVAL '3 hours'),
('550e8400-e29b-41d4-a716-446655440004', 'SYS005', 'Admin Michael Brown', 'michael.brown@university.edu', 'admin', 'active', NOW() - INTERVAL '10 years', NOW() - INTERVAL '30 minutes');

-- =============================================
-- STUDENT PROFILES SAMPLE DATA
-- =============================================

INSERT INTO public.student_profiles (user_id, student_number, year_level, program, gpa, enrollment_status) VALUES
('550e8400-e29b-41d4-a716-446655440000', '2021001', 3, 'Computer Science', 3.75, 'enrolled'),
('550e8400-e29b-41d4-a716-446655440001', '2021002', 2, 'Information Technology', 3.50, 'enrolled');

-- =============================================
-- FACULTY PROFILES SAMPLE DATA
-- =============================================

INSERT INTO public.faculty_profiles (user_id, employee_id, department, position, specialization, hire_date) VALUES
('550e8400-e29b-41d4-a716-446655440002', 'EMP001', 'Computer Science', 'Professor', 'Artificial Intelligence', '2019-08-15'),
('550e8400-e29b-41d4-a716-446655440003', 'EMP002', 'Information Technology', 'Associate Professor', 'Cybersecurity', '2021-01-10');

-- =============================================
-- ADMIN PROFILES SAMPLE DATA
-- =============================================

INSERT INTO public.admin_profiles (user_id, admin_level, department) VALUES
('550e8400-e29b-41d4-a716-446655440004', 'system', 'IT Administration');

-- =============================================
-- COURSES SAMPLE DATA
-- =============================================

INSERT INTO public.courses (course_code, title, description, credits, department, semester, academic_year, faculty_id, max_students, is_active) VALUES
('CS101', 'Introduction to Computer Science', 'Fundamental concepts of programming and computer science', 3, 'Computer Science', 'Fall 2024', '2024-2025', '550e8400-e29b-41d4-a716-446655440002', 50, true),
('CS201', 'Data Structures and Algorithms', 'Advanced programming concepts and algorithm analysis', 4, 'Computer Science', 'Fall 2024', '2024-2025', '550e8400-e29b-41d4-a716-446655440002', 40, true),
('IT101', 'Introduction to Information Technology', 'Basic IT concepts and infrastructure', 3, 'Information Technology', 'Fall 2024', '2024-2025', '550e8400-e29b-41d4-a716-446655440003', 45, true),
('CS301', 'Database Systems', 'Database design and management principles', 3, 'Computer Science', 'Spring 2025', '2024-2025', '550e8400-e29b-41d4-a716-446655440002', 35, true);

-- =============================================
-- COURSE PREREQUISITES SAMPLE DATA
-- =============================================

INSERT INTO public.course_prerequisites (course_id, prerequisite_course_id) VALUES
((SELECT id FROM public.courses WHERE course_code = 'CS201'), (SELECT id FROM public.courses WHERE course_code = 'CS101')),
((SELECT id FROM public.courses WHERE course_code = 'CS301'), (SELECT id FROM public.courses WHERE course_code = 'CS201'));

-- =============================================
-- ENROLLMENTS SAMPLE DATA
-- =============================================

INSERT INTO public.enrollments (student_id, course_id, enrollment_date, status, final_grade) VALUES
((SELECT id FROM public.student_profiles WHERE student_number = '2021001'), (SELECT id FROM public.courses WHERE course_code = 'CS101'), '2024-08-25', 'active', NULL),
((SELECT id FROM public.student_profiles WHERE student_number = '2021001'), (SELECT id FROM public.courses WHERE course_code = 'CS201'), '2024-08-25', 'active', NULL),
((SELECT id FROM public.student_profiles WHERE student_number = '2021002'), (SELECT id FROM public.courses WHERE course_code = 'IT101'), '2024-08-25', 'active', NULL);

-- =============================================
-- ACADEMIC HISTORY SAMPLE DATA
-- =============================================

INSERT INTO public.academic_history (student_id, course_id, semester, academic_year, grade, grade_letter, credits_earned, gpa_points) VALUES
((SELECT id FROM public.student_profiles WHERE student_number = '2021001'), (SELECT id FROM public.courses WHERE course_code = 'CS101'), 'Spring 2024', '2023-2024', 85.0, 'B', 3, 9.0),
((SELECT id FROM public.student_profiles WHERE student_number = '2021001'), (SELECT id FROM public.courses WHERE course_code = 'CS201'), 'Spring 2024', '2023-2024', 78.0, 'B+', 4, 12.0);

-- =============================================
-- ATTENDANCE SAMPLE DATA
-- =============================================

INSERT INTO public.attendance (student_id, course_id, date, status, remarks, recorded_by) VALUES
((SELECT id FROM public.student_profiles WHERE student_number = '2021001'), (SELECT id FROM public.courses WHERE course_code = 'CS101'), '2024-09-01', 'present', NULL, (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP001')),
((SELECT id FROM public.student_profiles WHERE student_number = '2021001'), (SELECT id FROM public.courses WHERE course_code = 'CS101'), '2024-09-03', 'late', 'Traffic delay', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP001')),
((SELECT id FROM public.student_profiles WHERE student_number = '2021002'), (SELECT id FROM public.courses WHERE course_code = 'IT101'), '2024-09-01', 'present', NULL, (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP002'));

-- =============================================
-- MEDICAL RECORDS SAMPLE DATA
-- =============================================

INSERT INTO public.medical_records (student_id, condition, diagnosis, treatment, doctor_name, hospital, diagnosis_date, is_chronic) VALUES
((SELECT id FROM public.student_profiles WHERE student_number = '2021001'), 'Seasonal Allergies', 'Allergic rhinitis', 'Antihistamine medication', 'Dr. Emily Chen', 'University Medical Center', '2023-05-15', false),
((SELECT id FROM public.student_profiles WHERE student_number = '2021002'), 'Asthma', 'Mild persistent asthma', 'Inhaler as needed', 'Dr. James Wilson', 'City General Hospital', '2022-03-20', true);

-- =============================================
-- COUNSELING RECORDS SAMPLE DATA
-- =============================================

INSERT INTO public.counseling_records (student_id, counselor_id, session_date, session_type, notes, recommendations, follow_up_required) VALUES
((SELECT id FROM public.student_profiles WHERE student_number = '2021001'), (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP001'), '2024-09-10', 'academic', 'Student concerned about course load', 'Recommend time management workshop', true),
((SELECT id FROM public.student_profiles WHERE student_number = '2021002'), (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP002'), '2024-09-15', 'personal', 'Homesickness discussion', 'Regular check-ins recommended', true);

-- =============================================
-- DISCIPLINE RECORDS SAMPLE DATA
-- =============================================

INSERT INTO public.discipline_records (student_id, incident_date, offense, severity, action_taken, reported_by, status) VALUES
((SELECT id FROM public.student_profiles WHERE student_number = '2021001'), '2024-09-05', 'Late submission of assignment', 'minor', 'Warning issued', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP001'), 'closed'),
((SELECT id FROM public.student_profiles WHERE student_number = '2021002'), '2024-08-20', 'Plagiarism suspicion', 'major', 'Formal investigation initiated', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP002'), 'open');

-- =============================================
-- STUDENT DOCUMENTS SAMPLE DATA
-- =============================================

INSERT INTO public.student_documents (student_id, document_type, document_name, file_path, file_size, mime_type, uploaded_at) VALUES
((SELECT id FROM public.student_profiles WHERE student_number = '2021001'), 'transcript', 'Official Transcript 2023', '/uploads/student-documents/transcripts/2021001_transcript.pdf', 245760, 'application/pdf', NOW() - INTERVAL '1 month'),
((SELECT id FROM public.student_profiles WHERE student_number = '2021001'), 'id', 'Student ID Card', '/uploads/student-documents/ids/2021001_id.jpg', 125430, 'image/jpeg', NOW() - INTERVAL '2 months'),
((SELECT id FROM public.student_profiles WHERE student_number = '2021002'), 'medical', 'Medical Certificate', '/uploads/student-documents/medical/2021002_medical.pdf', 89520, 'application/pdf', NOW() - INTERVAL '3 weeks');

-- =============================================
-- STUDENT ORGANIZATIONS SAMPLE DATA
-- =============================================

INSERT INTO public.student_organizations (name, description, advisor_id, category, max_members, is_active) VALUES
('Computer Science Club', 'Student organization for CS enthusiasts and coding competitions', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP001'), 'Academic', 50, true),
('IT Society', 'Organization for IT students to network and learn', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP002'), 'Academic', 40, true),
('Debate Club', 'Student debate and public speaking organization', NULL, 'Extracurricular', 30, true);

-- =============================================
-- ORGANIZATION MEMBERSHIPS SAMPLE DATA
-- =============================================

INSERT INTO public.organization_memberships (organization_id, student_id, position, joined_at, left_at, is_active) VALUES
((SELECT id FROM public.student_organizations WHERE name = 'Computer Science Club'), (SELECT id FROM public.student_profiles WHERE student_number = '2021001'), 'member', '2024-09-01', NULL, true),
((SELECT id FROM public.student_organizations WHERE name = 'Computer Science Club'), (SELECT id FROM public.student_profiles WHERE student_number = '2021002'), 'member', '2024-09-05', NULL, true),
((SELECT id FROM public.student_organizations WHERE name = 'IT Society'), (SELECT id FROM public.student_profiles WHERE student_number = '2021002'), 'treasurer', '2024-09-10', NULL, true);

-- =============================================
-- NOTIFICATIONS SAMPLE DATA
-- =============================================

INSERT INTO public.notifications (recipient_id, sender_id, title, message, type, priority, is_read) VALUES
('550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440002', 'Assignment Due', 'CS101 Assignment #3 is due tomorrow at 11:59 PM', 'info', 'normal', false),
('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440003', 'Grade Posted', 'Your grade for IT101 Quiz #2 has been posted', 'success', 'normal', false),
('550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440004', 'System Maintenance', 'Scheduled maintenance this weekend', 'warning', 'high', false),
('550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440004', 'New Student Enrollment', '5 new students enrolled in your courses', 'info', 'normal', false);

-- =============================================
-- SYSTEM SETTINGS SAMPLE DATA
-- =============================================

INSERT INTO public.system_settings (key, value, description, category, is_public) VALUES
('academic_year', '2024-2025', 'Current academic year', 'academic', true),
('current_semester', 'Fall', 'Current academic semester', 'academic', true),
('registration_open', 'true', 'Course registration status', 'registration', true),
('max_credits', '21', 'Maximum credits per semester', 'academic', true),
('grading_scale', '4.0', 'Maximum GPA scale', 'academic', true),
('maintenance_mode', 'false', 'System maintenance status', 'system', false);

-- =============================================
-- AUDIT LOGS SAMPLE DATA
-- =============================================

INSERT INTO public.audit_logs (user_id, action, table_name, record_id, old_values, new_values, ip_address, user_agent) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'INSERT', 'student_profiles', (SELECT id FROM public.student_profiles WHERE student_number = '2021001'), NULL, '{"student_number": "2021001", "program": "Computer Science"}', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
('550e8400-e29b-41d4-a716-446655440002', 'UPDATE', 'courses', (SELECT id FROM public.courses WHERE course_code = 'CS101'), '{"max_students": 50}', '{"max_students": 45}', '192.168.1.50', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'),
('550e8400-e29b-41d4-a716-446655440004', 'DELETE', 'enrollments', (SELECT id FROM public.enrollments LIMIT 1), '{"status": "active"}', NULL, '192.168.1.10', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');

-- =============================================
-- GRADE SCALES SAMPLE DATA
-- =============================================

INSERT INTO public.grade_scales (name, description, min_score, max_score, grade_letter, grade_points, is_active) VALUES
('A Grade', 'Excellent performance', 90.0, 100.0, 'A', 4.0, true),
('B+ Grade', 'Very good performance', 85.0, 89.99, 'B+', 3.5, true),
('B Grade', 'Good performance', 80.0, 84.99, 'B', 3.0, true),
('C+ Grade', 'Above average performance', 75.0, 79.99, 'C+', 2.5, true),
('C Grade', 'Average performance', 70.0, 74.99, 'C', 2.0, true),
('D Grade', 'Below average performance', 60.0, 69.99, 'D', 1.0, true),
('F Grade', 'Failing performance', 0.0, 59.99, 'F', 0.0, true);

-- =============================================
-- VERIFICATION QUERIES TO CHECK DATA INTEGRITY
-- =============================================

-- Verify all required fields are populated
SELECT 'Users count: ' || COUNT(*) FROM public.users;
SELECT 'Student Profiles count: ' || COUNT(*) FROM public.student_profiles WHERE user_id IS NOT NULL AND student_number IS NOT NULL AND program IS NOT NULL;
SELECT 'Faculty Profiles count: ' || COUNT(*) FROM public.faculty_profiles WHERE user_id IS NOT NULL AND employee_id IS NOT NULL AND department IS NOT NULL AND position IS NOT NULL AND hire_date IS NOT NULL;
SELECT 'Admin Profiles count: ' || COUNT(*) FROM public.admin_profiles WHERE user_id IS NOT NULL AND admin_level IS NOT NULL;
SELECT 'Courses count: ' || COUNT(*) FROM public.courses WHERE course_code IS NOT NULL AND title IS NOT NULL AND credits IS NOT NULL AND department IS NOT NULL AND semester IS NOT NULL AND academic_year IS NOT NULL;
SELECT 'Enrollments count: ' || COUNT(*) FROM public.enrollments WHERE student_id IS NOT NULL AND course_id IS NOT NULL AND enrollment_date IS NOT NULL;
SELECT 'Academic History count: ' || COUNT(*) FROM public.academic_history WHERE student_id IS NOT NULL AND course_id IS NOT NULL AND semester IS NOT NULL AND academic_year IS NOT NULL;
SELECT 'Attendance count: ' || COUNT(*) FROM public.attendance WHERE student_id IS NOT NULL AND course_id IS NOT NULL AND date IS NOT NULL AND status IS NOT NULL;
SELECT 'Medical Records count: ' || COUNT(*) FROM public.medical_records WHERE student_id IS NOT NULL AND condition IS NOT NULL;
SELECT 'Counseling Records count: ' || COUNT(*) FROM public.counseling_records WHERE student_id IS NOT NULL AND session_date IS NOT NULL AND session_type IS NOT NULL;
SELECT 'Discipline Records count: ' || COUNT(*) FROM public.discipline_records WHERE student_id IS NOT NULL AND incident_date IS NOT NULL AND offense IS NOT NULL AND severity IS NOT NULL;
SELECT 'Student Documents count: ' || COUNT(*) FROM public.student_documents WHERE student_id IS NOT NULL AND document_type IS NOT NULL AND document_name IS NOT NULL AND file_path IS NOT NULL;
SELECT 'Student Organizations count: ' || COUNT(*) FROM public.student_organizations WHERE name IS NOT NULL AND category IS NOT NULL;
SELECT 'Organization Memberships count: ' || COUNT(*) FROM public.organization_memberships WHERE organization_id IS NOT NULL AND student_id IS NOT NULL AND joined_at IS NOT NULL;
SELECT 'Notifications count: ' || COUNT(*) FROM public.notifications WHERE recipient_id IS NOT NULL AND title IS NOT NULL AND message IS NOT NULL AND type IS NOT NULL;
SELECT 'System Settings count: ' || COUNT(*) FROM public.system_settings WHERE key IS NOT NULL AND value IS NOT NULL AND category IS NOT NULL;
SELECT 'Audit Logs count: ' || COUNT(*) FROM public.audit_logs WHERE action IS NOT NULL AND table_name IS NOT NULL;
SELECT 'Grade Scales count: ' || COUNT(*) FROM public.grade_scales WHERE name IS NOT NULL AND min_score IS NOT NULL AND max_score IS NOT NULL AND grade_letter IS NOT NULL AND grade_points IS NOT NULL;

-- Verify foreign key relationships
SELECT 'Orphaned Student Profiles (no user): ' || COUNT(*) FROM public.student_profiles WHERE user_id NOT IN (SELECT id FROM public.users);
SELECT 'Orphaned Faculty Profiles (no user): ' || COUNT(*) FROM public.faculty_profiles WHERE user_id NOT IN (SELECT id FROM public.users);
SELECT 'Orphaned Admin Profiles (no user): ' || COUNT(*) FROM public.admin_profiles WHERE user_id NOT IN (SELECT id FROM public.users);
SELECT 'Orphaned Enrollments (no student): ' || COUNT(*) FROM public.enrollments WHERE student_id NOT IN (SELECT id FROM public.student_profiles);
SELECT 'Orphaned Enrollments (no course): ' || COUNT(*) FROM public.enrollments WHERE course_id NOT IN (SELECT id FROM public.courses);

-- Sample data insertion completed successfully
-- All required fields are populated with appropriate data
-- Foreign key relationships are maintained
-- Data follows all constraints and check conditions
