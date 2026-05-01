// Test Database Connection
const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

console.log('Testing Supabase connection...');
console.log('URL:', supabaseUrl ? 'Set' : 'Missing');
console.log('Key:', supabaseKey ? 'Set' : 'Missing');

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Missing Supabase credentials');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function testConnection() {
  try {
    // Test basic connection
    console.log('\n🔍 Testing basic connection...');
    const { data, error } = await supabase.from('users').select('count').limit(1);
    
    if (error) {
      console.error('❌ Connection failed:', error);
      return;
    }
    
    console.log('✅ Connection successful');
    
    // Check each table
    const tables = [
      { name: 'users', field: 'id' },
      { name: 'student_profiles', field: 'id' },
      { name: 'grade_scales', field: 'id' },
      { name: 'course_prerequisites', field: 'id' },
      { name: 'student_documents', field: 'id' },
      { name: 'student_organizations', field: 'id' },
      { name: 'medical_records', field: 'id' },
      { name: 'discipline_records', field: 'id' },
      { name: 'audit_logs', field: 'id' }
    ];
    
    console.log('\n📊 Checking table data...');
    
    for (const table of tables) {
      try {
        const { data: tableData, error: tableError } = await supabase
          .from(table.name)
          .select(table.field)
          .limit(5);
          
        if (tableError) {
          console.log(`❌ ${table.name}: Error - ${tableError.message}`);
        } else {
          console.log(`✅ ${table.name}: ${tableData.length} records`);
        }
      } catch (err) {
        console.log(`❌ ${table.name}: Failed - ${err.message}`);
      }
    }
    
  } catch (error) {
    console.error('❌ Test failed:', error);
  }
}

testConnection();
