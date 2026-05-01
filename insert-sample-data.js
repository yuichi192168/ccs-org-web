// Insert Sample Data Script
// This script inserts realistic sample data into all database tables

const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error('Missing Supabase credentials. Check your .env.local file.');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

// Helper function to generate UUID
function generateUUID() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

// Helper function to create user
async function createUser(email, name, role, systemId) {
  try {
    // Create auth user first
    const { data: authData, error: authError } = await supabase.auth.admin.createUser({
      email,
      password: 'tempPassword123!',
      email_confirm: true,
      user_metadata: { name, role }
    });

    if (authError) {
      console.error('Auth user creation error:', authError);
      return null;
    }

    // Create public user profile
    const { data: userData, error: userError } = await supabase
      .from('users')
      .insert({
        id: authData.user.id,
        name,
        email: email.toLowerCase(),
        role,
        system_id: systemId,
        status: 'active'
      })
      .select()
      .single();

    if (userError) {
      console.error('Public user creation error:', userError);
      return null;
    }

    return userData;
  } catch (error) {
    console.error('User creation error:', error);
    return null;
  }
}

// Main insertion function
async function insertSampleData() {
  console.log('🚀 Starting sample data insertion...');

  try {
    // 1. Create Users
    console.log('\n📝 Creating users...');
    
    const users = [];
    
    // Admin users
    const admin1 = await createUser('admin@ccs.edu', 'Dr. Sarah Johnson', 'admin', 'ADMIN001');
    const admin2 = await createUser('registrar@ccs.edu', 'Michael Chen', 'admin', 'ADMIN002');
    const admin3 = await createUser('it.admin@ccs.edu', 'Jennifer Martinez', 'admin', 'ADMIN003');
    
    // Faculty users
    const fac1 = await createUser('dr.roberts@ccs.edu', 'Dr. James Roberts', 'faculty', 'FAC001');
    const fac2 = await createUser('prof.williams@ccs.edu', 'Dr. Emily Williams', 'faculty', 'FAC002');
    const fac3 = await createUser('dr.anderson@ccs.edu', 'Dr. Michael Anderson', 'faculty', 'FAC003');
    const fac4 = await createUser('prof.taylor@ccs.edu', 'Dr. Lisa Taylor', 'faculty', 'FAC004');
    const fac5 = await createUser('dr.brown@ccs.edu', 'Dr. David Brown', 'faculty', 'FAC005');
    
    // Student users
    const stu1 = await createUser('john.smith@student.ccs.edu', 'John Smith', 'student', 'STU001');
    const stu2 = await createUser('maria.garcia@student.ccs.edu', 'Maria Garcia', 'student', 'STU002');
    const stu3 = await createUser('kevin.wang@student.ccs.edu', 'Kevin Wang', 'student', 'STU003');
    const stu4 = await createUser('sarah.johnson@student.ccs.edu', 'Sarah Johnson', 'student', 'STU004');
    const stu5 = await createUser('alex.rodriguez@student.ccs.edu', 'Alex Rodriguez', 'student', 'STU005');
    const stu6 = await createUser('emma.davis@student.ccs.edu', 'Emma Davis', 'student', 'STU006');
    const stu7 = await createUser('ryan.miller@student.ccs.edu', 'Ryan Miller', 'student', 'STU007');
    const stu8 = await createUser('olivia.chen@student.ccs.edu', 'Olivia Chen', 'student', 'STU008');

    users.push(admin1, admin2, admin3, fac1, fac2, fac3, fac4, fac5, stu1, stu2, stu3, stu4, stu5, stu6, stu7, stu8);
    
    const validUsers = users.filter(u => u !== null);
    console.log(`✅ Created ${validUsers.length} users`);

    // 2. Create Admin Profiles
    console.log('\n📝 Creating admin profiles...');
    const adminProfiles = [];
    for (let i = 0; i < 3; i++) {
      const admin = validUsers[i];
      const { data, error } = await supabase
        .from('admin_profiles')
        .insert({
          id: generateUUID(),
          user_id: admin.id,
          admin_level: i === 0 ? 'super_admin' : i === 1 ? 'senior_admin' : 'junior_admin',
          department: i === 0 ? 'System Administration' : i === 1 ? 'Registrar Office' : 'IT Department'
        })
        .select()
        .single();
      
      if (!error) adminProfiles.push(data);
    }
    console.log(`✅ Created ${adminProfiles.length} admin profiles`);

    // 3. Create Faculty Profiles
    console.log('\n📝 Creating faculty profiles...');
    const facultyProfiles = [];
    const departments = ['Computer Science', 'Mathematics', 'Engineering', 'Business', 'Medicine'];
    const positions = ['Professor', 'Associate Professor', 'Professor', 'Assistant Professor', 'Associate Professor'];
    const specializations = [
      'Artificial Intelligence, Machine Learning, Data Science',
      'Applied Mathematics, Statistics, Computational Theory',
      'Software Engineering, System Architecture, Cloud Computing',
      'Business Analytics, Marketing Research, Strategic Management',
      'Medical Informatics, Healthcare Systems, Biomedical Engineering'
    ];
    
    for (let i = 0; i < 5; i++) {
      const faculty = validUsers[i + 3];
      const { data, error } = await supabase
        .from('faculty_profiles')
        .insert({
          id: generateUUID(),
          user_id: faculty.id,
          employee_id: faculty.system_id,
          department: departments[i],
          position: positions[i],
          specialization: specializations[i],
          hire_date: '2020-01-15'
        })
        .select()
        .single();
      
      if (!error) facultyProfiles.push(data);
    }
    console.log(`✅ Created ${facultyProfiles.length} faculty profiles`);

    // 4. Create Student Profiles
    console.log('\n📝 Creating student profiles...');
    const studentProfiles = [];
    const programs = ['Computer Science', 'Business Administration', 'Computer Science', 'Business Administration', 'Computer Science', 'Engineering', 'Engineering', 'Medicine'];
    const gpas = [3.8, 3.6, 3.9, 3.4, 3.7, 3.5, 3.2, 3.6];
    
    for (let i = 0; i < 8; i++) {
      const student = validUsers[i + 8];
      const { data, error } = await supabase
        .from('student_profiles')
        .insert({
          id: generateUUID(),
          user_id: student.id,
          student_number: '2024' + student.system_id.substring(3),
          program: programs[i],
          year_level: i < 2 ? 4 : i < 5 ? 3 : i < 7 ? 2 : 1,
          gpa: gpas[i],
          enrollment_status: 'enrolled'
        })
        .select()
        .single();
      
      if (!error) studentProfiles.push(data);
    }
    console.log(`✅ Created ${studentProfiles.length} student profiles`);

    // 5. Create Courses
    console.log('\n📝 Creating courses...');
    const courses = [];
    const courseData = [
      { code: 'CS101', title: 'Introduction to Computer Science', credits: 3, dept: 'Computer Science', desc: 'Fundamental concepts of computer science including programming, algorithms, and data structures.' },
      { code: 'CS201', title: 'Data Structures and Algorithms', credits: 4, dept: 'Computer Science', desc: 'Advanced data structures including trees, graphs, and algorithm analysis.' },
      { code: 'MATH101', title: 'Calculus I', credits: 4, dept: 'Mathematics', desc: 'Differential and integral calculus with applications.' },
      { code: 'ENG101', title: 'Engineering Fundamentals', credits: 3, dept: 'Engineering', desc: 'Introduction to engineering principles, design, and problem-solving.' },
      { code: 'BUS101', title: 'Introduction to Business', credits: 3, dept: 'Business', desc: 'Fundamental concepts of business administration and management.' }
    ];

    for (let i = 0; i < courseData.length; i++) {
      const course = courseData[i];
      const { data, error } = await supabase
        .from('courses')
        .insert({
          id: generateUUID(),
          course_code: course.code,
          title: course.title,
          description: course.desc,
          credits: course.credits,
          department: course.dept,
          academic_year: '2024-2025',
          semester: 'Fall',
          faculty_id: facultyProfiles[i % facultyProfiles.length].id,
          max_students: 30,
          is_active: true
        })
        .select()
        .single();
      
      if (!error) courses.push(data);
    }
    console.log(`✅ Created ${courses.length} courses`);

    // 6. Create Grade Scales
    console.log('\n📝 Creating grade scales...');
    const gradeScales = [];
    const gradeData = [
      { name: 'Standard A+', letter: 'A+', points: 4.0, min: 97, max: 100 },
      { name: 'Standard A', letter: 'A', points: 4.0, min: 93, max: 96.99 },
      { name: 'Standard A-', letter: 'A-', points: 3.7, min: 90, max: 92.99 },
      { name: 'Standard B+', letter: 'B+', points: 3.3, min: 87, max: 89.99 },
      { name: 'Standard B', letter: 'B', points: 3.0, min: 83, max: 86.99 },
      { name: 'Standard B-', letter: 'B-', points: 2.7, min: 80, max: 82.99 },
      { name: 'Standard C+', letter: 'C+', points: 2.3, min: 77, max: 79.99 },
      { name: 'Standard C', letter: 'C', points: 2.0, min: 73, max: 76.99 },
      { name: 'Standard C-', letter: 'C-', points: 1.7, min: 70, max: 72.99 },
      { name: 'Standard D', letter: 'D', points: 1.0, min: 60, max: 69.99 },
      { name: 'Standard F', letter: 'F', points: 0.0, min: 0, max: 59.99 }
    ];

    for (const grade of gradeData) {
      const { data, error } = await supabase
        .from('grade_scales')
        .insert({
          id: generateUUID(),
          name: grade.name,
          grade_letter: grade.letter,
          grade_points: grade.points,
          min_score: grade.min,
          max_score: grade.max,
          description: `${grade.letter} grade`,
          is_active: true
        })
        .select()
        .single();
      
      if (!error) gradeScales.push(data);
    }
    console.log(`✅ Created ${gradeScales.length} grade scales`);

    // 7. Create Student Organizations
    console.log('\n📝 Creating student organizations...');
    const organizations = [];
    const orgData = [
      { name: 'Computer Science Club', desc: 'A club for students interested in computer science, programming, and technology.', category: 'academic' },
      { name: 'Business Leaders Association', desc: 'Professional development organization focused on business skills.', category: 'professional' },
      { name: 'Engineering Society', desc: 'Student organization for engineering students to collaborate on projects.', category: 'academic' },
      { name: 'Student Government Association', desc: 'Representative body for student interests.', category: 'governance' },
      { name: 'International Students Club', desc: 'Cultural exchange organization supporting international students.', category: 'cultural' }
    ];

    for (let i = 0; i < orgData.length; i++) {
      const org = orgData[i];
      const { data, error } = await supabase
        .from('student_organizations')
        .insert({
          id: generateUUID(),
          name: org.name,
          description: org.desc,
          category: org.category,
          advisor_id: facultyProfiles[i % facultyProfiles.length].id,
          max_members: 50,
          is_active: true
        })
        .select()
        .single();
      
      if (!error) organizations.push(data);
    }
    console.log(`✅ Created ${organizations.length} student organizations`);

    // 8. Create Student Documents
    console.log('\n📝 Creating student documents...');
    const documents = [];
    const docTypes = ['birth_certificate', 'transcript', 'passport', 'medical_record', 'identification'];
    const docNames = ['Birth Certificate', 'High School Transcript', 'Passport Copy', 'Medical Certificate', 'ID Card'];

    for (let i = 0; i < 5; i++) {
      const { data, error } = await supabase
        .from('student_documents')
        .insert({
          id: generateUUID(),
          student_id: studentProfiles[i].id,
          document_name: docNames[i],
          document_type: docTypes[i],
          file_path: `/uploads/student-documents/${docTypes[i]}_${studentProfiles[i].student_number}.pdf`,
          file_size: 500000,
          mime_type: 'application/pdf',
          uploaded_at: new Date().toISOString()
        })
        .select()
        .single();
      
      if (!error) documents.push(data);
    }
    console.log(`✅ Created ${documents.length} student documents`);

    // 9. Create Medical Records
    console.log('\n📝 Creating medical records...');
    const medicalRecords = [];
    const conditions = [
      { condition: 'Seasonal Allergies', diagnosis: 'Allergic rhinitis due to pollen sensitivity', doctor: 'Dr. Sarah Mitchell' },
      { condition: 'Asthma', diagnosis: 'Mild persistent asthma', doctor: 'Dr. James Chen' },
      { condition: 'Sports Injury', diagnosis: 'Sprained ankle - grade 1', doctor: 'Dr. Maria Rodriguez' },
      { condition: 'Vision Impairment', diagnosis: 'Myopia (nearsightedness)', doctor: 'Dr. Robert Kim' },
      { condition: 'Migraine Headaches', diagnosis: 'Episodic migraine without aura', doctor: 'Dr. Lisa Thompson' }
    ];

    for (let i = 0; i < 5; i++) {
      const med = conditions[i];
      const { data, error } = await supabase
        .from('medical_records')
        .insert({
          id: generateUUID(),
          student_id: studentProfiles[i].id,
          condition: med.condition,
          diagnosis: med.diagnosis,
          diagnosis_date: '2024-03-15',
          doctor_name: med.doctor,
          hospital: 'General Hospital',
          treatment: 'Standard treatment protocol',
          is_chronic: i < 3
        })
        .select()
        .single();
      
      if (!error) medicalRecords.push(data);
    }
    console.log(`✅ Created ${medicalRecords.length} medical records`);

    // 10. Create Discipline Records
    console.log('\n📝 Creating discipline records...');
    const disciplineRecords = [];
    const offenses = [
      { offense: 'Unauthorized use of university computer resources', severity: 'high', action: 'Warning letter, probation' },
      { offense: 'Plagiarism in assignment submission', severity: 'medium', action: 'Assignment grade reduced to zero' },
      { offense: 'Disruptive behavior in classroom', severity: 'low', action: 'Verbal warning' },
      { offense: 'Late submission of major project', severity: 'low', action: 'Grade penalty' }
    ];

    for (let i = 0; i < 4; i++) {
      const disc = offenses[i];
      const { data, error } = await supabase
        .from('discipline_records')
        .insert({
          id: generateUUID(),
          student_id: studentProfiles[i].id,
          incident_date: '2025-03-15',
          offense: disc.offense,
          severity: disc.severity,
          action_taken: disc.action,
          reported_by: facultyProfiles[i % facultyProfiles.length].id,
          status: 'resolved'
        })
        .select()
        .single();
      
      if (!error) disciplineRecords.push(data);
    }
    console.log(`✅ Created ${disciplineRecords.length} discipline records`);

    // 11. Create Audit Logs
    console.log('\n📝 Creating audit logs...');
    const auditLogs = [];
    const logTypes = [
      { action: 'INSERT', table: 'users', user: admin1 },
      { action: 'UPDATE', table: 'users', user: admin1 },
      { action: 'INSERT', table: 'courses', user: fac1 },
      { action: 'LOGIN_FAILED', table: 'users', user: null }
    ];

    for (const log of logTypes) {
      const { data, error } = await supabase
        .from('audit_logs')
        .insert({
          id: generateUUID(),
          user_id: log.user ? log.user.id : null,
          action: log.action,
          table_name: log.table,
          ip_address: '192.168.1.100',
          user_agent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          created_at: new Date().toISOString()
        })
        .select()
        .single();
      
      if (!error) auditLogs.push(data);
    }
    console.log(`✅ Created ${auditLogs.length} audit logs`);

    console.log('\n🎉 Sample data insertion completed successfully!');
    console.log('\n📊 Summary:');
    console.log(`- Users: ${validUsers.length}`);
    console.log(`- Admin Profiles: ${adminProfiles.length}`);
    console.log(`- Faculty Profiles: ${facultyProfiles.length}`);
    console.log(`- Student Profiles: ${studentProfiles.length}`);
    console.log(`- Courses: ${courses.length}`);
    console.log(`- Grade Scales: ${gradeScales.length}`);
    console.log(`- Student Organizations: ${organizations.length}`);
    console.log(`- Student Documents: ${documents.length}`);
    console.log(`- Medical Records: ${medicalRecords.length}`);
    console.log(`- Discipline Records: ${disciplineRecords.length}`);
    console.log(`- Audit Logs: ${auditLogs.length}`);

  } catch (error) {
    console.error('❌ Error during data insertion:', error);
    process.exit(1);
  }
}

// Run the script
insertSampleData().catch(console.error);
