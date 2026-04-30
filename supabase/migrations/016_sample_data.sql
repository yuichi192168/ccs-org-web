-- Sample Data Migration
-- Migration: 016_sample_data.sql

-- =============================================
-- SAMPLE USERS
-- =============================================

-- Note: These users should be created through Supabase Auth first
-- Then their profiles can be created here
-- For now, we'll use placeholder UUIDs that should be replaced with actual auth.user IDs

-- Sample Admin User (UUID should be replaced with actual auth.user ID)
INSERT INTO public.users (id, system_id, name, email, role, status) VALUES
('00000000-0000-0000-0000-000000000001', 'ADMIN001', 'System Administrator', 'admin@ccs.edu', 'admin', 'active');

-- Sample Faculty Users
INSERT INTO public.users (id, system_id, name, email, role, status) VALUES
('00000000-0000-0000-0000-000000000002', 'FAC001', 'Dr. John Smith', 'john.smith@ccs.edu', 'faculty', 'active'),
('00000000-0000-0000-0000-000000000003', 'FAC002', 'Prof. Jane Doe', 'jane.doe@ccs.edu', 'faculty', 'active'),
('00000000-0000-0000-0000-000000000004', 'FAC003', 'Dr. Robert Johnson', 'robert.johnson@ccs.edu', 'faculty', 'active');

-- Sample Student Users
INSERT INTO public.users (id, system_id, name, email, role, status) VALUES
('00000000-0000-0000-0000-000000000005', 'STU001', 'Alice Williams', 'alice.williams@ccs.edu', 'student', 'active'),
('00000000-0000-0000-0000-000000000006', 'STU002', 'Bob Brown', 'bob.brown@ccs.edu', 'student', 'active'),
('00000000-0000-0000-0000-000000000007', 'STU003', 'Carol Davis', 'carol.davis@ccs.edu', 'student', 'active'),
('00000000-0000-0000-0000-000000000008', 'STU004', 'David Miller', 'david.miller@ccs.edu', 'student', 'active'),
('00000000-0000-0000-0000-000000000009', 'STU005', 'Emma Wilson', 'emma.wilson@ccs.edu', 'student', 'active');

-- =============================================
-- SAMPLE PROFILES
-- =============================================

-- Admin Profiles
INSERT INTO public.admin_profiles (id, user_id, admin_level, department) VALUES
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000001', 'system', 'IT Department');

-- Faculty Profiles
INSERT INTO public.faculty_profiles (id, user_id, employee_id, department, position, specialization, hire_date) VALUES
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000002', 'EMP001', 'Computer Science', 'Professor', 'Artificial Intelligence', '2020-01-15'),
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000003', 'EMP002', 'Computer Science', 'Associate Professor', 'Database Systems', '2019-08-20'),
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000004', 'EMP003', 'Information Technology', 'Assistant Professor', 'Web Development', '2021-06-10');

-- Student Profiles
INSERT INTO public.student_profiles (id, user_id, student_number, year_level, program, gpa, enrollment_status) VALUES
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000005', '2021001', 3, 'Computer Science', 3.75, 'enrolled'),
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000006', '2021002', 3, 'Computer Science', 3.50, 'enrolled'),
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000007', '2021003', 2, 'Information Technology', 3.80, 'enrolled'),
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000008', '2021004', 2, 'Information Technology', 3.60, 'enrolled'),
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000009', '2021005', 1, 'Computer Science', 3.90, 'enrolled');

-- =============================================
-- SAMPLE COURSES
-- =============================================

INSERT INTO public.courses (id, course_code, title, description, credits, department, semester, academic_year, faculty_id, max_students, is_active) VALUES
(uuid_generate_v4(), 'CS101', 'Introduction to Computer Science', 'Fundamental concepts of computer science and programming', 3, 'Computer Science', 'First', '2023-2024', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP001'), 50, true),
(uuid_generate_v4(), 'CS102', 'Data Structures and Algorithms', 'Advanced data structures and algorithm analysis', 4, 'Computer Science', 'First', '2023-2024', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP001'), 40, true),
(uuid_generate_v4(), 'CS201', 'Database Systems', 'Database design and management', 3, 'Computer Science', 'Second', '2023-2024', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP002'), 35, true),
(uuid_generate_v4(), 'IT101', 'Web Development Fundamentals', 'Introduction to web technologies and development', 3, 'Information Technology', 'First', '2023-2024', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP003'), 45, true),
(uuid_generate_v4(), 'IT201', 'Advanced Web Development', 'Modern web frameworks and applications', 4, 'Information Technology', 'Second', '2023-2024', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP003'), 30, true);

-- =============================================
-- SAMPLE COURSE PREREQUISITES
-- =============================================

INSERT INTO public.course_prerequisites (id, course_id, prerequisite_course_id) VALUES
(uuid_generate_v4(), (SELECT id FROM public.courses WHERE course_code = 'CS102'), (SELECT id FROM public.courses WHERE course_code = 'CS101')),
(uuid_generate_v4(), (SELECT id FROM public.courses WHERE course_code = 'CS201'), (SELECT id FROM public.courses WHERE course_code = 'CS101')),
(uuid_generate_v4(), (SELECT id FROM public.courses WHERE course_code = 'IT201'), (SELECT id FROM public.courses WHERE course_code = 'IT101'));

-- =============================================
-- SAMPLE ENROLLMENTS
-- =============================================

INSERT INTO public.enrollments (id, student_id, course_id, enrollment_date, status) VALUES
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021001'), (SELECT id FROM public.courses WHERE course_code = 'CS101'), '2023-08-15', 'active'),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021001'), (SELECT id FROM public.courses WHERE course_code = 'CS102'), '2023-08-15', 'active'),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021002'), (SELECT id FROM public.courses WHERE course_code = 'CS101'), '2023-08-15', 'active'),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021002'), (SELECT id FROM public.courses WHERE course_code = 'CS201'), '2023-08-15', 'active'),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021003'), (SELECT id FROM public.courses WHERE course_code = 'IT101'), '2023-08-15', 'active'),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021004'), (SELECT id FROM public.courses WHERE course_code = 'IT101'), '2023-08-15', 'active'),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021004'), (SELECT id FROM public.courses WHERE course_code = 'IT201'), '2023-08-15', 'active'),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021005'), (SELECT id FROM public.courses WHERE course_code = 'CS101'), '2023-08-15', 'active');

-- =============================================
-- SAMPLE ACADEMIC HISTORY
-- =============================================

INSERT INTO public.academic_history (id, student_id, course_id, semester, academic_year, grade, grade_letter, credits_earned, gpa_points) VALUES
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021001'), (SELECT id FROM public.courses WHERE course_code = 'CS101'), 'First', '2022-2023', 92.5, 'A', 3, 4.0),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021002'), (SELECT id FROM public.courses WHERE course_code = 'CS101'), 'First', '2022-2023', 88.0, 'B+', 3, 3.5),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021003'), (SELECT id FROM public.courses WHERE course_code = 'IT101'), 'First', '2022-2023', 91.0, 'A', 3, 4.0),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021004'), (SELECT id FROM public.courses WHERE course_code = 'IT101'), 'First', '2022-2023', 85.0, 'B', 3, 3.0);

-- =============================================
-- SAMPLE ATTENDANCE
-- =============================================

INSERT INTO public.attendance (id, student_id, course_id, date, status, remarks, recorded_by) VALUES
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021001'), (SELECT id FROM public.courses WHERE course_code = 'CS101'), '2023-08-21', 'present', null, (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP001')),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021001'), (SELECT id FROM public.courses WHERE course_code = 'CS102'), '2023-08-21', 'present', null, (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP001')),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021002'), (SELECT id FROM public.courses WHERE course_code = 'CS101'), '2023-08-21', 'late', '5 minutes late', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP001')),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021003'), (SELECT id FROM public.courses WHERE course_code = 'IT101'), '2023-08-21', 'present', null, (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP003')),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021004'), (SELECT id FROM public.courses WHERE course_code = 'IT101'), '2023-08-21', 'absent', 'No prior notification', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP003')),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021005'), (SELECT id FROM public.courses WHERE course_code = 'CS101'), '2023-08-22', 'excused', 'Medical appointment', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP001')),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021002'), (SELECT id FROM public.courses WHERE course_code = 'CS201'), '2023-08-22', 'present', null, (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP002')),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021003'), (SELECT id FROM public.courses WHERE course_code = 'IT101'), '2023-08-23', 'late', '10 minutes late', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP003')),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021004'), (SELECT id FROM public.courses WHERE course_code = 'IT201'), '2023-08-23', 'present', null, (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP003')),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021001'), (SELECT id FROM public.courses WHERE course_code = 'CS102'), '2023-08-24', 'excused', 'Family emergency', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP001'));

-- =============================================
-- SAMPLE STUDENT ORGANIZATIONS
-- =============================================

INSERT INTO public.student_organizations (id, name, description, advisor_id, category, max_members, is_active) VALUES
(uuid_generate_v4(), 'Computer Science Club', 'A club for students interested in computer science and technology', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP001'), 'Academic', 50, true),
(uuid_generate_v4(), 'Web Development Society', 'Focus on modern web development technologies and practices', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP003'), 'Technical', 40, true),
(uuid_generate_v4(), 'Student Council', 'Student government organization representing student interests', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP002'), 'Leadership', 30, true);

-- =============================================
-- SAMPLE ORGANIZATION MEMBERSHIPS
-- =============================================

INSERT INTO public.organization_memberships (id, organization_id, student_id, position, joined_at, is_active) VALUES
(uuid_generate_v4(), (SELECT id FROM public.student_organizations WHERE name = 'Computer Science Club'), (SELECT id FROM public.student_profiles WHERE student_number = '2021001'), 'President', '2023-06-01', true),
(uuid_generate_v4(), (SELECT id FROM public.student_organizations WHERE name = 'Computer Science Club'), (SELECT id FROM public.student_profiles WHERE student_number = '2021002'), 'Member', '2023-06-01', true),
(uuid_generate_v4(), (SELECT id FROM public.student_organizations WHERE name = 'Web Development Society'), (SELECT id FROM public.student_profiles WHERE student_number = '2021003'), 'Vice President', '2023-06-01', true),
(uuid_generate_v4(), (SELECT id FROM public.student_organizations WHERE name = 'Web Development Society'), (SELECT id FROM public.student_profiles WHERE student_number = '2021004'), 'Member', '2023-06-01', true),
(uuid_generate_v4(), (SELECT id FROM public.student_organizations WHERE name = 'Student Council'), (SELECT id FROM public.student_profiles WHERE student_number = '2021005'), 'Member', '2023-06-01', true);

-- =============================================
-- SAMPLE NOTIFICATIONS
-- =============================================

INSERT INTO public.notifications (id, recipient_id, sender_id, title, message, type, priority) VALUES
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000001', 'Welcome to CCS!', 'Welcome to the Computer Science Society. Your account has been successfully created.', 'info', 'normal'),
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000002', 'Assignment Posted', 'A new assignment has been posted for CS101. Due date: September 15, 2023.', 'info', 'high'),
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000003', 'Meeting Reminder', 'Reminder: Web Development Society meeting tomorrow at 3:00 PM.', 'info', 'normal'),
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000001', 'System Maintenance', 'The system will be under maintenance this weekend from 10 PM to 2 AM.', 'warning', 'high');

-- =============================================
-- SAMPLE SYSTEM SETTINGS
-- =============================================

INSERT INTO public.system_settings (id, key, value, description, category, is_public) VALUES
(uuid_generate_v4(), 'academic_year', '2023-2024', 'Current academic year', 'academic', true),
(uuid_generate_v4(), 'current_semester', 'First', 'Current semester', 'academic', true),
(uuid_generate_v4(), 'max_enrollment_per_student', '6', 'Maximum number of courses a student can enroll in per semester', 'academic', true),
(uuid_generate_v4(), 'grading_scale', 'standard', 'Grading scale system used', 'academic', true),
(uuid_generate_v4(), 'system_maintenance_mode', 'false', 'Whether the system is in maintenance mode', 'system', false),
(uuid_generate_v4(), 'email_notifications_enabled', 'true', 'Whether email notifications are enabled', 'notifications', true);

-- =============================================
-- SAMPLE GRADE SCALES
-- =============================================

INSERT INTO public.grade_scales (id, name, description, min_score, max_score, grade_letter, grade_points, is_active) VALUES
(uuid_generate_v4(), 'Excellent', 'Outstanding performance', 90.0, 100.0, 'A', 4.0, true),
(uuid_generate_v4(), 'Very Good', 'Above average performance', 85.0, 89.99, 'B+', 3.5, true),
(uuid_generate_v4(), 'Good', 'Average performance', 80.0, 84.99, 'B', 3.0, true),
(uuid_generate_v4(), 'Satisfactory', 'Below average but passing', 75.0, 79.99, 'C+', 2.5, true),
(uuid_generate_v4(), 'Fair', 'Minimum passing grade', 70.0, 74.99, 'C', 2.0, true),
(uuid_generate_v4(), 'Poor', 'Below passing', 60.0, 69.99, 'D', 1.0, true),
(uuid_generate_v4(), 'Fail', 'Failing grade', 0.0, 59.99, 'F', 0.0, true);

-- =============================================
-- SAMPLE MEDICAL RECORDS
-- =============================================

INSERT INTO public.medical_records (id, student_id, condition, diagnosis, treatment, doctor_name, hospital, diagnosis_date, is_chronic) VALUES
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021001'), 'Asthma', 'Mild intermittent asthma', 'Inhaler as needed', 'Dr. Sarah Lee', 'City General Hospital', '2022-03-15', true),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021003'), 'Allergic Rhinitis', 'Seasonal allergies', 'Antihistamines during allergy season', 'Dr. Michael Chen', 'Allergy Clinic', '2023-05-20', false),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021005'), 'Myopia', 'Nearsightedness', 'Prescription glasses', 'Dr. Lisa Wong', 'Eye Care Center', '2023-02-10', true),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021002'), 'Tension Headaches', 'Stress-related headaches', 'Stress management techniques, pain relievers as needed', 'Dr. James Brown', 'Community Health Clinic', '2023-07-15', false);

-- =============================================
-- SAMPLE COUNSELING RECORDS
-- =============================================

INSERT INTO public.counseling_records (id, student_id, counselor_id, session_date, session_type, notes, recommendations, follow_up_required) VALUES
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021002'), (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP002'), '2023-09-01', 'academic', 'Student concerned about course load in CS201. Discussed time management strategies.', 'Consider dropping one elective course, join study group', true),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021005'), (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP002'), '2023-09-05', 'personal', 'First-year adjustment concerns. Provided resources for campus support services.', 'Attend orientation events, connect with peer mentor', false),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021001'), (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP002'), '2023-09-10', 'career', 'Exploring internship opportunities in AI/ML field.', 'Update resume, attend career fair next month', true),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021004'), (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP002'), '2023-09-12', 'disciplinary', 'Discussion regarding late assignment submissions.', 'Create assignment schedule, use calendar reminders', true);

-- =============================================
-- SAMPLE DISCIPLINE RECORDS
-- =============================================

INSERT INTO public.discipline_records (id, student_id, incident_date, offense, severity, action_taken, reported_by, status) VALUES
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021004'), '2023-08-25', 'Late submission of assignment', 'minor', 'Warning issued', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP003'), 'closed'),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021002'), '2023-09-05', 'Disruptive behavior in class', 'major', 'Probation for 2 weeks, mandatory counseling', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP001'), 'open'),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021003'), '2023-08-30', 'Plagiarism in assignment', 'severe', 'Course failure, academic probation', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP003'), 'appealed'),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021001'), '2023-09-08', 'Unauthorized absence from exam', 'major', 'Makeup exam allowed with 20% penalty', (SELECT id FROM public.faculty_profiles WHERE employee_id = 'EMP001'), 'closed');

-- =============================================
-- SAMPLE STUDENT DOCUMENTS
-- =============================================

INSERT INTO public.student_documents (id, student_id, document_type, document_name, file_path, file_size, mime_type, uploaded_at) VALUES
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021001'), 'transcript', 'Official_Transcript_2023.pdf', '/uploads/student-documents/transcripts/2021001_transcript.pdf', 245760, 'application/pdf', '2023-08-10'),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021002'), 'id', 'Student_ID_Card.jpg', '/uploads/student-documents/ids/2021002_id.jpg', 102400, 'image/jpeg', '2023-08-12'),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021003'), 'medical', 'Medical_Certificate.pdf', '/uploads/student-documents/medical/2021003_medical.pdf', 184320, 'application/pdf', '2023-08-15'),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021004'), 'certificate', 'Web_Development_Certificate.pdf', '/uploads/student-documents/certificates/2021004_web_cert.pdf', 156789, 'application/pdf', '2023-09-01'),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021005'), 'other', 'Resume_2023.docx', '/uploads/student-documents/resumes/2021005_resume.docx', 98765, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', '2023-09-05'),
(uuid_generate_v4(), (SELECT id FROM public.student_profiles WHERE student_number = '2021001'), 'transcript', 'High_School_Transcript.pdf', '/uploads/student-documents/transcripts/2021001_hs_transcript.pdf', 312456, 'application/pdf', '2023-08-11');

-- =============================================
-- SAMPLE AUDIT LOGS
-- =============================================

INSERT INTO public.audit_logs (id, user_id, action, table_name, record_id, old_values, new_values, ip_address, user_agent) VALUES
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000001', 'INSERT', 'users', '00000000-0000-0000-0000-000000000005', null, '{"system_id": "STU001", "name": "Alice Williams", "role": "student"}', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000002', 'UPDATE', 'courses', (SELECT id FROM public.courses WHERE course_code = 'CS101'), '{"max_students": 45}', '{"max_students": 50}', '192.168.1.101', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'),
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000005', 'INSERT', 'enrollments', (SELECT id FROM public.enrollments LIMIT 1), null, '{"student_id": "student_uuid", "course_id": "course_uuid", "status": "active"}', '192.168.1.102', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36'),
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000003', 'DELETE', 'organization_memberships', (SELECT id FROM public.organization_memberships LIMIT 1), '{"is_active": true}', null, '192.168.1.103', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15'),
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000004', 'UPDATE', 'student_profiles', (SELECT id FROM public.student_profiles WHERE student_number = '2021001'), '{"gpa": 3.75}', '{"gpa": 3.80}', '192.168.1.104', 'Mozilla/5.0 (Android 10; Mobile; rv:89.0) Gecko/89.0 Firefox/89.0'),
(uuid_generate_v4(), '00000000-0000-0000-0000-000000000001', 'INSERT', 'notifications', (SELECT id FROM public.notifications LIMIT 1), null, '{"title": "System Update", "type": "info"}', '192.168.1.105', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0');
