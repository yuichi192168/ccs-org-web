// Add Discipline Records
const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

const supabase = createClient(supabaseUrl, supabaseKey);

async function addDisciplineRecords() {
  console.log('🚀 Adding discipline records...');

  try {
    // Get existing students and faculty
    const { data: students } = await supabase.from('student_profiles').select('id, users(name)');
    const { data: faculty } = await supabase.from('faculty_profiles').select('id');

    if (!students || students.length === 0) {
      console.log('❌ No students found');
      return;
    }

    if (!faculty || faculty.length === 0) {
      console.log('❌ No faculty found');
      return;
    }

    const offenses = [
      { offense: 'Unauthorized use of university computer resources', severity: 'high', action: 'Warning letter, probation' },
      { offense: 'Plagiarism in assignment submission', severity: 'medium', action: 'Assignment grade reduced to zero' },
      { offense: 'Disruptive behavior in classroom', severity: 'low', action: 'Verbal warning' },
      { offense: 'Late submission of major project', severity: 'low', action: 'Grade penalty' }
    ];

    for (let i = 0; i < Math.min(4, students.length); i++) {
      const disc = offenses[i];
      const { data, error } = await supabase
        .from('discipline_records')
        .insert({
          id: `xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx`.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  }),
          student_id: students[i].id,
          incident_date: '2025-03-15',
          offense: disc.offense,
          severity: disc.severity,
          action_taken: disc.action,
          reported_by: faculty[i % faculty.length].id,
          status: 'resolved'
        })
        .select();

      if (error) {
        console.error(`❌ Error adding discipline record ${i}:`, error);
      } else {
        console.log(`✅ Added discipline record for ${students[i].users?.name}`);
      }
    }

    console.log('🎉 Discipline records added successfully!');

  } catch (error) {
    console.error('❌ Error adding discipline records:', error);
  }
}

addDisciplineRecords();
