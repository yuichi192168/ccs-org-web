// Comprehensive CRUD Testing Script
// This script tests all CRUD operations for the system modules

const BASE_URL = 'http://localhost:3000/api';

// Test data generators
const generateTestUser = () => ({
  name: `Test User ${Math.random().toString(36).substring(7)}`,
  email: `test${Math.random().toString(36).substring(7)}@example.com`,
  role: 'student',
  systemId: `SYS${Math.random().toString(36).substring(7).toUpperCase()}`,
  password: 'testPassword123!'
});

const generateTestStudentProfile = (userId) => ({
  userId,
  studentNumber: `STU${Math.random().toString(36).substring(7).toUpperCase()}`,
  yearLevel: Math.floor(Math.random() * 4) + 1,
  program: ['Computer Science', 'Engineering', 'Business', 'Medicine'][Math.floor(Math.random() * 4)],
  gpa: (Math.random() * 4).toFixed(2),
  enrollmentStatus: 'enrolled'
});

const generateTestFacultyProfile = (userId) => ({
  userId,
  employeeId: `EMP${Math.random().toString(36).substring(7).toUpperCase()}`,
  department: ['Computer Science', 'Engineering', 'Business', 'Medicine'][Math.floor(Math.random() * 4)],
  position: ['Professor', 'Associate Professor', 'Assistant Professor', 'Lecturer'][Math.floor(Math.random() * 4)],
  specialization: 'AI and Machine Learning',
  hireDate: new Date().toISOString().split('T')[0]
});

// Test utilities
const makeRequest = async (endpoint, options = {}) => {
  try {
    const response = await fetch(`${BASE_URL}${endpoint}`, {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers
      },
      ...options
    });
    
    const data = await response.json();
    return { success: response.ok, data, status: response.status };
  } catch (error) {
    console.error(`Request failed for ${endpoint}:`, error);
    return { success: false, error: error.message };
  }
};

// Test result tracking
const testResults = {
  users: { create: [], read: [], update: [], delete: [] },
  studentProfiles: { create: [], read: [], update: [], delete: [] },
  facultyProfiles: { create: [], read: [], update: [], delete: [] },
  courses: { create: [], read: [], update: [], delete: [] },
  enrollments: { create: [], read: [], update: [], delete: [] },
  notifications: { create: [], read: [], update: [], delete: [] }
};

// Users Module Tests
async function testUsersCRUD() {
  console.log('\n🧪 Testing Users Module CRUD Operations');
  
  let createdUserId = null;
  
  // CREATE Tests
  console.log('\n📝 CREATE Tests');
  
  // Test 1: Valid user creation
  const testUser1 = generateTestUser();
  const createResult1 = await makeRequest('/users', {
    method: 'POST',
    body: JSON.stringify(testUser1)
  });
  
  testResults.users.create.push({
    test: 'Valid user creation',
    status: createResult1.success ? 'PASS' : 'FAIL',
    details: createResult1.success ? 'User created successfully' : createResult1.error || 'Failed to create user',
    data: createResult1.data
  });
  
  if (createResult1.success) {
    createdUserId = createResult1.data.data?.id;
  }
  
  // Test 2: Missing required fields
  const testUser2 = { name: 'Incomplete User' };
  const createResult2 = await makeRequest('/users', {
    method: 'POST',
    body: JSON.stringify(testUser2)
  });
  
  testResults.users.create.push({
    test: 'Missing required fields',
    status: !createResult2.success ? 'PASS' : 'FAIL',
    details: createResult2.success ? 'Should have failed with missing fields' : 'Correctly rejected incomplete data',
    data: createResult2.data
  });
  
  // Test 3: Duplicate email
  if (createdUserId) {
    const duplicateUser = { ...testUser1, email: testUser1.email, systemId: 'DIFFERENT_ID' };
    const createResult3 = await makeRequest('/users', {
      method: 'POST',
      body: JSON.stringify(duplicateUser)
    });
    
    testResults.users.create.push({
      test: 'Duplicate email validation',
      status: !createResult3.success ? 'PASS' : 'FAIL',
      details: createResult3.success ? 'Should have rejected duplicate email' : 'Correctly rejected duplicate email',
      data: createResult3.data
    });
  }
  
  // READ Tests
  console.log('\n📖 READ Tests');
  
  // Test 1: Get all users
  const readResult1 = await makeRequest('/users');
  testResults.users.read.push({
    test: 'Get all users',
    status: readResult1.success ? 'PASS' : 'FAIL',
    details: readResult1.success ? 'Users retrieved successfully' : 'Failed to retrieve users',
    data: readResult1.data
  });
  
  // Test 2: Filter by role
  const readResult2 = await makeRequest('/users?role=student');
  testResults.users.read.push({
    test: 'Filter by role',
    status: readResult2.success ? 'PASS' : 'FAIL',
    details: readResult2.success ? 'Role filtering works' : 'Role filtering failed',
    data: readResult2.data
  });
  
  // Test 3: Search functionality
  const readResult3 = await makeRequest('/users?search=test');
  testResults.users.read.push({
    test: 'Search functionality',
    status: readResult3.success ? 'PASS' : 'FAIL',
    details: readResult3.success ? 'Search works' : 'Search failed',
    data: readResult3.data
  });
  
  // Test 4: Pagination
  const readResult4 = await makeRequest('/users?page=1&limit=5');
  testResults.users.read.push({
    test: 'Pagination',
    status: readResult4.success ? 'PASS' : 'FAIL',
    details: readResult4.success ? 'Pagination works' : 'Pagination failed',
    data: readResult4.data
  });
  
  // UPDATE Tests
  console.log('\n✏️ UPDATE Tests');
  
  if (createdUserId) {
    // Test 1: Valid update
    const updateData = { name: 'Updated Name', status: 'inactive' };
    const updateResult1 = await makeRequest('/users', {
      method: 'PUT',
      body: JSON.stringify({ id: createdUserId, ...updateData })
    });
    
    testResults.users.update.push({
      test: 'Valid update',
      status: updateResult1.success ? 'PASS' : 'FAIL',
      details: updateResult1.success ? 'User updated successfully' : 'Failed to update user',
      data: updateResult1.data
    });
    
    // Test 2: Update password
    const passwordResult = await makeRequest('/users', {
      method: 'PUT',
      body: JSON.stringify({ id: createdUserId, password: 'newPassword123!' })
    });
    
    testResults.users.update.push({
      test: 'Password update',
      status: passwordResult.success ? 'PASS' : 'FAIL',
      details: passwordResult.success ? 'Password updated successfully' : 'Failed to update password',
      data: passwordResult.data
    });
    
    // Test 3: Update without ID
    const updateResult3 = await makeRequest('/users', {
      method: 'PUT',
      body: JSON.stringify({ name: 'No ID Update' })
    });
    
    testResults.users.update.push({
      test: 'Update without ID',
      status: !updateResult3.success ? 'PASS' : 'FAIL',
      details: updateResult3.success ? 'Should have failed without ID' : 'Correctly rejected update without ID',
      data: updateResult3.data
    });
  }
  
  // DELETE Tests
  console.log('\n🗑️ DELETE Tests');
  
  if (createdUserId) {
    // Test 1: Valid delete
    const deleteResult1 = await makeRequest(`/users?id=${createdUserId}`, {
      method: 'DELETE'
    });
    
    testResults.users.delete.push({
      test: 'Valid delete',
      status: deleteResult1.success ? 'PASS' : 'FAIL',
      details: deleteResult1.success ? 'User deleted successfully' : 'Failed to delete user',
      data: deleteResult1.data
    });
    
    // Test 2: Delete without ID
    const deleteResult2 = await makeRequest('/users', {
      method: 'DELETE'
    });
    
    testResults.users.delete.push({
      test: 'Delete without ID',
      status: !deleteResult2.success ? 'PASS' : 'FAIL',
      details: deleteResult2.success ? 'Should have failed without ID' : 'Correctly rejected delete without ID',
      data: deleteResult2.data
    });
    
    // Test 3: Delete non-existent user
    const deleteResult3 = await makeRequest('/users?id=00000000-0000-0000-0000-000000000000', {
      method: 'DELETE'
    });
    
    testResults.users.delete.push({
      test: 'Delete non-existent user',
      status: deleteResult3.success ? 'PASS' : 'FAIL', // Should succeed even if user doesn't exist
      details: deleteResult3.success ? 'Handled non-existent user gracefully' : 'Failed to handle non-existent user',
      data: deleteResult3.data
    });
  }
}

// Student Profiles Module Tests
async function testStudentProfilesCRUD() {
  console.log('\n🧪 Testing Student Profiles Module CRUD Operations');
  
  let createdUserId = null;
  let createdProfileId = null;
  
  // First create a user for the profile
  const testUser = generateTestUser();
  const userResult = await makeRequest('/users', {
    method: 'POST',
    body: JSON.stringify(testUser)
  });
  
  if (userResult.success) {
    createdUserId = userResult.data.data?.id;
  }
  
  // CREATE Tests
  console.log('\n📝 CREATE Tests');
  
  if (createdUserId) {
    // Test 1: Valid profile creation
    const testProfile1 = generateTestStudentProfile(createdUserId);
    const createResult1 = await makeRequest('/student-profiles', {
      method: 'POST',
      body: JSON.stringify(testProfile1)
    });
    
    testResults.studentProfiles.create.push({
      test: 'Valid profile creation',
      status: createResult1.success ? 'PASS' : 'FAIL',
      details: createResult1.success ? 'Profile created successfully' : 'Failed to create profile',
      data: createResult1.data
    });
    
    if (createResult1.success) {
      createdProfileId = createResult1.data.data?.id;
    }
    
    // Test 2: Missing required fields
    const testProfile2 = { userId: createdUserId };
    const createResult2 = await makeRequest('/student-profiles', {
      method: 'POST',
      body: JSON.stringify(testProfile2)
    });
    
    testResults.studentProfiles.create.push({
      test: 'Missing required fields',
      status: !createResult2.success ? 'PASS' : 'FAIL',
      details: createResult2.success ? 'Should have failed with missing fields' : 'Correctly rejected incomplete data',
      data: createResult2.data
    });
  }
  
  // READ Tests
  console.log('\n📖 READ Tests');
  
  // Test 1: Get all profiles
  const readResult1 = await makeRequest('/student-profiles');
  testResults.studentProfiles.read.push({
    test: 'Get all profiles',
    status: readResult1.success ? 'PASS' : 'FAIL',
    details: readResult1.success ? 'Profiles retrieved successfully' : 'Failed to retrieve profiles',
    data: readResult1.data
  });
  
  // Test 2: Search functionality
  const readResult2 = await makeRequest('/student-profiles?search=test');
  testResults.studentProfiles.read.push({
    test: 'Search functionality',
    status: readResult2.success ? 'PASS' : 'FAIL',
    details: readResult2.success ? 'Search works' : 'Search failed',
    data: readResult2.data
  });
  
  // UPDATE Tests
  console.log('\n✏️ UPDATE Tests');
  
  if (createdProfileId) {
    // Test 1: Valid update
    const updateData = { gpa: '3.8', yearLevel: 3 };
    const updateResult1 = await makeRequest('/student-profiles', {
      method: 'PUT',
      body: JSON.stringify({ id: createdProfileId, ...updateData })
    });
    
    testResults.studentProfiles.update.push({
      test: 'Valid update',
      status: updateResult1.success ? 'PASS' : 'FAIL',
      details: updateResult1.success ? 'Profile updated successfully' : 'Failed to update profile',
      data: updateResult1.data
    });
  }
  
  // DELETE Tests
  console.log('\n🗑️ DELETE Tests');
  
  if (createdProfileId) {
    // Test 1: Valid delete
    const deleteResult1 = await makeRequest(`/student-profiles?id=${createdProfileId}`, {
      method: 'DELETE'
    });
    
    testResults.studentProfiles.delete.push({
      test: 'Valid delete',
      status: deleteResult1.success ? 'PASS' : 'FAIL',
      details: deleteResult1.success ? 'Profile deleted successfully' : 'Failed to delete profile',
      data: deleteResult1.data
    });
  }
  
  // Clean up: Delete the test user
  if (createdUserId) {
    await makeRequest(`/users?id=${createdUserId}`, { method: 'DELETE' });
  }
}

// Faculty Profiles Module Tests
async function testFacultyProfilesCRUD() {
  console.log('\n🧪 Testing Faculty Profiles Module CRUD Operations');
  
  let createdUserId = null;
  let createdProfileId = null;
  
  // First create a user for the profile
  const testUser = { ...generateTestUser(), role: 'faculty' };
  const userResult = await makeRequest('/users', {
    method: 'POST',
    body: JSON.stringify(testUser)
  });
  
  if (userResult.success) {
    createdUserId = userResult.data.data?.id;
  }
  
  // CREATE Tests
  console.log('\n📝 CREATE Tests');
  
  if (createdUserId) {
    // Test 1: Valid profile creation
    const testProfile1 = generateTestFacultyProfile(createdUserId);
    const createResult1 = await makeRequest('/faculty-profiles', {
      method: 'POST',
      body: JSON.stringify(testProfile1)
    });
    
    testResults.facultyProfiles.create.push({
      test: 'Valid profile creation',
      status: createResult1.success ? 'PASS' : 'FAIL',
      details: createResult1.success ? 'Profile created successfully' : 'Failed to create profile',
      data: createResult1.data
    });
    
    if (createResult1.success) {
      createdProfileId = createResult1.data.data?.id;
    }
  }
  
  // READ Tests
  console.log('\n📖 READ Tests');
  
  // Test 1: Get all profiles
  const readResult1 = await makeRequest('/faculty-profiles');
  testResults.facultyProfiles.read.push({
    test: 'Get all profiles',
    status: readResult1.success ? 'PASS' : 'FAIL',
    details: readResult1.success ? 'Profiles retrieved successfully' : 'Failed to retrieve profiles',
    data: readResult1.data
  });
  
  // DELETE Tests
  console.log('\n🗑️ DELETE Tests');
  
  if (createdProfileId) {
    // Test 1: Valid delete
    const deleteResult1 = await makeRequest(`/faculty-profiles?id=${createdProfileId}`, {
      method: 'DELETE'
    });
    
    testResults.facultyProfiles.delete.push({
      test: 'Valid delete',
      status: deleteResult1.success ? 'PASS' : 'FAIL',
      details: deleteResult1.success ? 'Profile deleted successfully' : 'Failed to delete profile',
      data: deleteResult1.data
    });
  }
  
  // Clean up: Delete the test user
  if (createdUserId) {
    await makeRequest(`/users?id=${createdUserId}`, { method: 'DELETE' });
  }
}

// Courses Module Tests
async function testCoursesCRUD() {
  console.log('\n🧪 Testing Courses Module CRUD Operations');
  
  // READ Tests (only GET is implemented)
  console.log('\n📖 READ Tests');
  
  // Test 1: Get all courses
  const readResult1 = await makeRequest('/courses');
  testResults.courses.read.push({
    test: 'Get all courses',
    status: readResult1.success ? 'PASS' : 'FAIL',
    details: readResult1.success ? 'Courses retrieved successfully' : 'Failed to retrieve courses',
    data: readResult1.data
  });
  
  // Test 2: Filter by department
  const readResult2 = await makeRequest('/courses?department=Computer Science');
  testResults.courses.read.push({
    test: 'Filter by department',
    status: readResult2.success ? 'PASS' : 'FAIL',
    details: readResult2.success ? 'Department filtering works' : 'Department filtering failed',
    data: readResult2.data
  });
  
  // Test 3: Search functionality
  const readResult3 = await makeRequest('/courses?search=computer');
  testResults.courses.read.push({
    test: 'Search functionality',
    status: readResult3.success ? 'PASS' : 'FAIL',
    details: readResult3.success ? 'Search works' : 'Search failed',
    data: readResult3.data
  });
  
  // CREATE/UPDATE/DELETE Tests - These should fail as they're not implemented
  const createResult = await makeRequest('/courses', {
    method: 'POST',
    body: JSON.stringify({ courseCode: 'TEST101', courseName: 'Test Course' })
  });
  
  testResults.courses.create.push({
    test: 'Create operation (not implemented)',
    status: !createResult.success ? 'EXPECTED FAIL' : 'UNEXPECTED PASS',
    details: 'Create operation should not be implemented for mock data',
    data: createResult.data
  });
}

// Enrollments Module Tests
async function testEnrollmentsCRUD() {
  console.log('\n🧪 Testing Enrollments Module CRUD Operations');
  
  // READ Tests (only GET is implemented)
  console.log('\n📖 READ Tests');
  
  // Test 1: Get all enrollments
  const readResult1 = await makeRequest('/enrollments');
  testResults.enrollments.read.push({
    test: 'Get all enrollments',
    status: readResult1.success ? 'PASS' : 'FAIL',
    details: readResult1.success ? 'Enrollments retrieved successfully' : 'Failed to retrieve enrollments',
    data: readResult1.data
  });
  
  // Test 2: Filter by student
  const readResult2 = await makeRequest('/enrollments?studentId=1');
  testResults.enrollments.read.push({
    test: 'Filter by student',
    status: readResult2.success ? 'PASS' : 'FAIL',
    details: readResult2.success ? 'Student filtering works' : 'Student filtering failed',
    data: readResult2.data
  });
}

// Notifications Module Tests
async function testNotificationsCRUD() {
  console.log('\n🧪 Testing Notifications Module CRUD Operations');
  
  // READ Tests
  console.log('\n📖 READ Tests');
  
  // Test 1: Get all notifications
  const readResult1 = await makeRequest('/notifications');
  testResults.notifications.read.push({
    test: 'Get all notifications',
    status: readResult1.success ? 'PASS' : 'FAIL',
    details: readResult1.success ? 'Notifications retrieved successfully' : 'Failed to retrieve notifications',
    data: readResult1.data
  });
  
  // Test 2: Filter by recipient
  const readResult2 = await makeRequest('/notifications?recipientId=1');
  testResults.notifications.read.push({
    test: 'Filter by recipient',
    status: readResult2.success ? 'PASS' : 'FAIL',
    details: readResult2.success ? 'Recipient filtering works' : 'Recipient filtering failed',
    data: readResult2.data
  });
  
  // POST Test (mark as read)
  const postResult = await makeRequest('/notifications', {
    method: 'POST',
    body: JSON.stringify({ notificationId: '1', isRead: true })
  });
  
  testResults.notifications.create.push({
    test: 'Mark notification as read',
    status: postResult.success ? 'PASS' : 'FAIL',
    details: postResult.success ? 'Notification marked as read successfully' : 'Failed to mark notification as read',
    data: postResult.data
  });
}

// Edge Case Tests
async function testEdgeCases() {
  console.log('\n🧪 Testing Edge Cases');
  
  // Test empty inputs
  const emptyResult = await makeRequest('/users', {
    method: 'POST',
    body: JSON.stringify({})
  });
  
  console.log('Empty input test:', emptyResult.success ? 'FAIL' : 'PASS');
  
  // Test invalid data types
  const invalidResult = await makeRequest('/users', {
    method: 'POST',
    body: JSON.stringify({ name: 123, email: 'invalid-email', role: null, systemId: '' })
  });
  
  console.log('Invalid data types test:', invalidResult.success ? 'FAIL' : 'PASS');
  
  // Test very long strings
  const longResult = await makeRequest('/users', {
    method: 'POST',
    body: JSON.stringify({
      name: 'a'.repeat(1000),
      email: 'test@example.com',
      role: 'student',
      systemId: 'a'.repeat(500)
    })
  });
  
  console.log('Long strings test:', longResult.success ? 'PASS' : 'FAIL');
}

// Generate Test Report
function generateTestReport() {
  console.log('\n📊 COMPREHENSIVE TEST REPORT');
  console.log('='.repeat(50));
  
  const modules = Object.keys(testResults);
  
  modules.forEach(module => {
    console.log(`\n🔍 ${module.toUpperCase()} MODULE`);
    console.log('-'.repeat(30));
    
    const operations = Object.keys(testResults[module]);
    
    operations.forEach(operation => {
      const tests = testResults[module][operation];
      if (tests.length > 0) {
        console.log(`\n${operation.toUpperCase()} Operations:`);
        
        tests.forEach(test => {
          const status = test.status === 'PASS' ? '✅' : test.status === 'FAIL' ? '🐞' : test.status === 'EXPECTED FAIL' ? '⚠️' : '❓';
          console.log(`  ${status} ${test.test}: ${test.details}`);
        });
      }
    });
  });
  
  // Summary
  console.log('\n📈 SUMMARY');
  console.log('='.repeat(30));
  
  let totalTests = 0;
  let passedTests = 0;
  let failedTests = 0;
  
  modules.forEach(module => {
    const operations = Object.keys(testResults[module]);
    operations.forEach(operation => {
      const tests = testResults[module][operation];
      totalTests += tests.length;
      tests.forEach(test => {
        if (test.status === 'PASS') passedTests++;
        else if (test.status === 'FAIL') failedTests++;
      });
    });
  });
  
  console.log(`Total Tests: ${totalTests}`);
  console.log(`Passed: ${passedTests} ✅`);
  console.log(`Failed: ${failedTests} 🐞`);
  console.log(`Success Rate: ${totalTests > 0 ? ((passedTests / totalTests) * 100).toFixed(1) : 0}%`);
}

// Main test runner
async function runAllTests() {
  console.log('🚀 Starting Comprehensive CRUD Tests');
  console.log('Testing all modules for complete CRUD functionality\n');
  
  try {
    await testUsersCRUD();
    await testStudentProfilesCRUD();
    await testFacultyProfilesCRUD();
    await testCoursesCRUD();
    await testEnrollmentsCRUD();
    await testNotificationsCRUD();
    await testEdgeCases();
    
    generateTestReport();
    
  } catch (error) {
    console.error('Test execution failed:', error);
  }
}

// Export for use in different environments
if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    runAllTests,
    testUsersCRUD,
    testStudentProfilesCRUD,
    testFacultyProfilesCRUD,
    testCoursesCRUD,
    testEnrollmentsCRUD,
    testNotificationsCRUD,
    testEdgeCases,
    generateTestReport,
    testResults
  };
}

// Run tests if this script is executed directly
if (typeof window === 'undefined' && typeof process !== 'undefined') {
  runAllTests();
}
