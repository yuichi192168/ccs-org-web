// Insert Missing Data Script
// This script inserts data for tables that are currently empty

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

// Main insertion function
async function insertMissingData() {
  console.log('🚀 Starting missing data insertion...');

  try {
    // Get existing data
    const { data: users } = await supabase.from('users').select('*');
    const { data: courses } = await supabase.from('courses').select('*');
    const { data: facultyProfiles } = await supabase.from('faculty_profiles').select('*');
    const { data: studentProfiles } = await supabase.from('student_profiles').select('*');

    console.log(`Found ${users?.length || 0} users, ${courses?.length || 0} courses, ${facultyProfiles?.length || 0} faculty, ${studentProfiles?.length || 0} students`);

    // 1. Insert Grade Scales (if empty)
    console.log('\n📝 Checking grade scales...');
    const { data: existingGrades } = await supabase.from('grade_scales').select('*');
    
    if (!existingGrades || existingGrades.length === 0) {
      console.log('Inserting grade scales...');
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
        await supabase
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
          });
      }
      console.log('✅ Grade scales inserted');
    } else {
      console.log('✅ Grade scales already exist');
    }

    // 2. Insert Student Organizations (if empty)
    console.log('\n📝 Checking student organizations...');
    const { data: existingOrgs } = await supabase.from('student_organizations').select('*');
    
    if (!existingOrgs || existingOrgs.length === 0) {
      console.log('Inserting student organizations...');
      const orgData = [
        { name: 'Computer Science Club', desc: 'A club for students interested in computer science, programming, and technology.', category: 'academic' },
        { name: 'Business Leaders Association', desc: 'Professional development organization focused on business skills.', category: 'professional' },
        { name: 'Engineering Society', desc: 'Student organization for engineering students to collaborate on projects.', category: 'academic' },
        { name: 'Student Government Association', desc: 'Representative body for student interests.', category: 'governance' },
        { name: 'International Students Club', desc: 'Cultural exchange organization supporting international students.', category: 'cultural' }
      ];

      for (let i = 0; i < orgData.length; i++) {
        const org = orgData[i];
        await supabase
          .from('student_organizations')
          .insert({
            id: generateUUID(),
            name: org.name,
            description: org.desc,
            category: org.category,
            advisor_id: facultyProfiles[i % facultyProfiles.length]?.id,
            max_members: 50,
            is_active: true
          });
      }
      console.log('✅ Student organizations inserted');
    } else {
      console.log('✅ Student organizations already exist');
    }

    // 3. Insert Student Documents (if empty)
    console.log('\n📝 Checking student documents...');
    const { data: existingDocs } = await supabase.from('student_documents').select('*');
    
    if (!existingDocs || existingDocs.length === 0) {
      console.log('Inserting student documents...');
      const docTypes = ['birth_certificate', 'transcript', 'passport', 'medical_record', 'identification'];
      const docNames = ['Birth Certificate', 'High School Transcript', 'Passport Copy', 'Medical Certificate', 'ID Card'];

      for (let i = 0; i < Math.min(5, studentProfiles.length); i++) {
        await supabase
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
          });
      }
      console.log('✅ Student documents inserted');
    } else {
      console.log('✅ Student documents already exist');
    }

    // 4. Insert Medical Records (if empty)
    console.log('\n📝 Checking medical records...');
    const { data: existingMedical } = await supabase.from('medical_records').select('*');
    
    if (!existingMedical || existingMedical.length === 0) {
      console.log('Inserting medical records...');
      const conditions = [
        { condition: 'Seasonal Allergies', diagnosis: 'Allergic rhinitis due to pollen sensitivity', doctor: 'Dr. Sarah Mitchell' },
        { condition: 'Asthma', diagnosis: 'Mild persistent asthma', doctor: 'Dr. James Chen' },
        { condition: 'Sports Injury', diagnosis: 'Sprained ankle - grade 1', doctor: 'Dr. Maria Rodriguez' },
        { condition: 'Vision Impairment', diagnosis: 'Myopia (nearsightedness)', doctor: 'Dr. Robert Kim' },
        { condition: 'Migraine Headaches', diagnosis: 'Episodic migraine without aura', doctor: 'Dr. Lisa Thompson' }
      ];

      for (let i = 0; i < Math.min(5, studentProfiles.length); i++) {
        const med = conditions[i];
        await supabase
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
          });
      }
      console.log('✅ Medical records inserted');
    } else {
      console.log('✅ Medical records already exist');
    }

    // 5. Insert Discipline Records (if empty)
    console.log('\n📝 Checking discipline records...');
    const { data: existingDiscipline } = await supabase.from('discipline_records').select('*');
    
    if (!existingDiscipline || existingDiscipline.length === 0) {
      console.log('Inserting discipline records...');
      const offenses = [
        { offense: 'Unauthorized use of university computer resources', severity: 'high', action: 'Warning letter, probation' },
        { offense: 'Plagiarism in assignment submission', severity: 'medium', action: 'Assignment grade reduced to zero' },
        { offense: 'Disruptive behavior in classroom', severity: 'low', action: 'Verbal warning' },
        { offense: 'Late submission of major project', severity: 'low', action: 'Grade penalty' }
      ];

      for (let i = 0; i < Math.min(4, studentProfiles.length); i++) {
        const disc = offenses[i];
        await supabase
          .from('discipline_records')
          .insert({
            id: generateUUID(),
            student_id: studentProfiles[i].id,
            incident_date: '2025-03-15',
            offense: disc.offense,
            severity: disc.severity,
            action_taken: disc.action,
            reported_by: facultyProfiles[i % facultyProfiles.length]?.id,
            status: 'resolved'
          });
      }
      console.log('✅ Discipline records inserted');
    } else {
      console.log('✅ Discipline records already exist');
    }

    // 6. Insert Audit Logs (if empty)
    console.log('\n📝 Checking audit logs...');
    const { data: existingAudit } = await supabase.from('audit_logs').select('*');
    
    if (!existingAudit || existingAudit.length === 0) {
      console.log('Inserting audit logs...');
      const adminUsers = users.filter(u => u.role === 'admin');
      const logTypes = [
        { action: 'INSERT', table: 'users', user: adminUsers[0] },
        { action: 'UPDATE', table: 'users', user: adminUsers[0] },
        { action: 'INSERT', table: 'courses', user: users.find(u => u.role === 'faculty') },
        { action: 'LOGIN_FAILED', table: 'users', user: null }
      ];

      for (const log of logTypes) {
        await supabase
          .from('audit_logs')
          .insert({
            id: generateUUID(),
            user_id: log.user ? log.user.id : null,
            action: log.action,
            table_name: log.table,
            ip_address: '192.168.1.100',
            user_agent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            created_at: new Date().toISOString()
          });
      }
      console.log('✅ Audit logs inserted');
    } else {
      console.log('✅ Audit logs already exist');
    }

    // 7. Insert Course Prerequisites (if empty)
    console.log('\n📝 Checking course prerequisites...');
    const { data: existingPrereqs } = await supabase.from('course_prerequisites').select('*');
    
    if (!existingPrereqs || existingPrereqs.length === 0 && courses && courses.length >= 2) {
      console.log('Inserting course prerequisites...');
      
      // Add some prerequisite relationships
      if (courses.length >= 2) {
        await supabase
          .from('course_prerequisites')
          .insert({
            id: generateUUID(),
            course_id: courses[1]?.id, // CS201
            prerequisite_course_id: courses[0]?.id // CS101
          });
      }
      
      console.log('✅ Course prerequisites inserted');
    } else {
      console.log('✅ Course prerequisites already exist');
    }

    console.log('\n🎉 Missing data insertion completed successfully!');

  } catch (error) {
    console.error('❌ Error during data insertion:', error);
    process.exit(1);
  }
}

// Run the script
insertMissingData().catch(console.error);
