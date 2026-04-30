// Mock data for the Academic Management System
// This provides comprehensive sample data for all entities

export interface MockUser {
  id: string
  systemId: string
  name: string
  email: string
  role: 'student' | 'faculty' | 'admin'
  status: 'active' | 'inactive' | 'suspended'
  joinedAt: string
  lastLoginAt: string | null
  createdAt: string
  updatedAt: string
}

export interface MockStudentProfile {
  id: string
  userId: string
  studentNumber: string
  course: string
  section: string
  yearLevel: string
  admissionDate: string
  gpa: number
  unitsCompleted: number
  unitsEnrolled: number
  createdAt: string
  updatedAt: string
}

export interface MockFacultyProfile {
  id: string
  userId: string
  employeeNumber: string
  department: string
  position: string
  specialization: string | null
  hireDate: string
  createdAt: string
  updatedAt: string
}

export interface MockAdminProfile {
  id: string
  userId: string
  adminLevel: 'basic' | 'super' | 'system'
  permissions: string[]
  createdAt: string
  updatedAt: string
}

export interface MockCourse {
  id: string
  courseCode: string
  courseName: string
  description: string | null
  units: number
  department: string
  isActive: boolean
  createdAt: string
  updatedAt: string
}

export interface MockEnrollment {
  id: string
  studentId: string
  courseId: string
  semester: string
  academicYear: string
  status: 'enrolled' | 'dropped' | 'completed' | 'failed'
  grade: number | null
  enrolledAt: string
  updatedAt: string
}

export interface MockAcademicHistory {
  id: string
  studentId: string
  courseId: string
  semester: string
  academicYear: string
  grade: number | null
  creditsEarned: number | null
  gpaImpact: number | null
  createdAt: string
  updatedAt: string
}

export interface MockNotification {
  id: string
  recipientId: string
  senderId: string | null
  title: string
  message: string
  type: 'info' | 'warning' | 'success' | 'error' | 'system'
  isRead: boolean
  priority: 'low' | 'normal' | 'high' | 'urgent'
  createdAt: string
  readAt: string | null
}

// Mock Users Data
export const mockUsers: MockUser[] = [
  {
    id: 'user-001',
    systemId: 'SYS-STU-001',
    name: 'John Smith',
    email: 'john.smith@campus.edu',
    role: 'student',
    status: 'active',
    joinedAt: '2023-08-15T00:00:00.000Z',
    lastLoginAt: '2024-04-30T10:00:00.000Z',
    createdAt: '2023-08-15T00:00:00.000Z',
    updatedAt: '2024-04-30T10:00:00.000Z'
  },
  {
    id: 'user-002',
    systemId: 'SYS-STU-002',
    name: 'Sarah Johnson',
    email: 'sarah.johnson@campus.edu',
    role: 'student',
    status: 'active',
    joinedAt: '2023-08-15T00:00:00.000Z',
    lastLoginAt: '2024-04-29T15:30:00.000Z',
    createdAt: '2023-08-15T00:00:00.000Z',
    updatedAt: '2024-04-29T15:30:00.000Z'
  },
  {
    id: 'user-003',
    systemId: 'SYS-FAC-001',
    name: 'Dr. Michael Chen',
    email: 'michael.chen@campus.edu',
    role: 'faculty',
    status: 'active',
    joinedAt: '2022-01-10T00:00:00.000Z',
    lastLoginAt: '2024-04-30T09:00:00.000Z',
    createdAt: '2022-01-10T00:00:00.000Z',
    updatedAt: '2024-04-30T09:00:00.000Z'
  },
  {
    id: 'user-004',
    systemId: 'SYS-FAC-002',
    name: 'Prof. Emily Rodriguez',
    email: 'emily.rodriguez@campus.edu',
    role: 'faculty',
    status: 'active',
    joinedAt: '2021-08-20T00:00:00.000Z',
    lastLoginAt: '2024-04-30T08:45:00.000Z',
    createdAt: '2021-08-20T00:00:00.000Z',
    updatedAt: '2024-04-30T08:45:00.000Z'
  },
  {
    id: 'user-005',
    systemId: 'SYS-ADM-001',
    name: 'System Administrator',
    email: 'admin@campus.edu',
    role: 'admin',
    status: 'active',
    joinedAt: '2020-01-01T00:00:00.000Z',
    lastLoginAt: '2024-04-30T07:00:00.000Z',
    createdAt: '2020-01-01T00:00:00.000Z',
    updatedAt: '2024-04-30T07:00:00.000Z'
  }
]

// Mock Student Profiles
export const mockStudentProfiles: MockStudentProfile[] = [
  {
    id: 'student-profile-001',
    userId: 'user-001',
    studentNumber: 'STU-2023-001',
    course: 'Computer Science',
    section: 'A',
    yearLevel: '3',
    admissionDate: '2023-08-15T00:00:00.000Z',
    gpa: 3.75,
    unitsCompleted: 90,
    unitsEnrolled: 18,
    createdAt: '2023-08-15T00:00:00.000Z',
    updatedAt: '2024-04-30T10:00:00.000Z'
  },
  {
    id: 'student-profile-002',
    userId: 'user-002',
    studentNumber: 'STU-2023-002',
    course: 'Information Technology',
    section: 'B',
    yearLevel: '2',
    admissionDate: '2023-08-15T00:00:00.000Z',
    gpa: 3.45,
    unitsCompleted: 60,
    unitsEnrolled: 15,
    createdAt: '2023-08-15T00:00:00.000Z',
    updatedAt: '2024-04-29T15:30:00.000Z'
  }
]

// Mock Faculty Profiles
export const mockFacultyProfiles: MockFacultyProfile[] = [
  {
    id: 'faculty-profile-001',
    userId: 'user-003',
    employeeNumber: 'FAC-2022-001',
    department: 'Computer Science',
    position: 'Associate Professor',
    specialization: 'Web Development & Database Systems',
    hireDate: '2022-01-10T00:00:00.000Z',
    createdAt: '2022-01-10T00:00:00.000Z',
    updatedAt: '2024-04-30T09:00:00.000Z'
  },
  {
    id: 'faculty-profile-002',
    userId: 'user-004',
    employeeNumber: 'FAC-2021-002',
    department: 'Information Technology',
    position: 'Assistant Professor',
    specialization: 'Network Security & Cloud Computing',
    hireDate: '2021-08-20T00:00:00.000Z',
    createdAt: '2021-08-20T00:00:00.000Z',
    updatedAt: '2024-04-30T08:45:00.000Z'
  }
]

// Mock Admin Profiles
export const mockAdminProfiles: MockAdminProfile[] = [
  {
    id: 'admin-profile-001',
    userId: 'user-005',
    adminLevel: 'system',
    permissions: ['read', 'write', 'delete', 'admin', 'system_config'],
    createdAt: '2020-01-01T00:00:00.000Z',
    updatedAt: '2024-04-30T07:00:00.000Z'
  }
]

// Mock Courses Data
export const mockCourses: MockCourse[] = [
  {
    id: 'course-001',
    courseCode: 'CS101',
    courseName: 'Introduction to Computer Science',
    description: 'Fundamental concepts of computer science and programming',
    units: 3,
    department: 'Computer Science',
    isActive: true,
    createdAt: '2023-01-01T00:00:00.000Z',
    updatedAt: '2024-01-15T00:00:00.000Z'
  },
  {
    id: 'course-002',
    courseCode: 'CS102',
    courseName: 'Data Structures and Algorithms',
    description: 'Advanced data structures and algorithm analysis',
    units: 3,
    department: 'Computer Science',
    isActive: true,
    createdAt: '2023-01-01T00:00:00.000Z',
    updatedAt: '2024-01-15T00:00:00.000Z'
  },
  {
    id: 'course-003',
    courseCode: 'IT201',
    courseName: 'Web Development Fundamentals',
    description: 'Introduction to modern web development technologies',
    units: 3,
    department: 'Information Technology',
    isActive: true,
    createdAt: '2023-01-01T00:00:00.000Z',
    updatedAt: '2024-01-15T00:00:00.000Z'
  },
  {
    id: 'course-004',
    courseCode: 'IT202',
    courseName: 'Database Management Systems',
    description: 'Database design, implementation, and management',
    units: 3,
    department: 'Information Technology',
    isActive: true,
    createdAt: '2023-01-01T00:00:00.000Z',
    updatedAt: '2024-01-15T00:00:00.000Z'
  }
]

// Mock Enrollments
export const mockEnrollments: MockEnrollment[] = [
  {
    id: 'enrollment-001',
    studentId: 'user-001',
    courseId: 'course-001',
    semester: 'Fall 2023',
    academicYear: '2023-2024',
    status: 'completed',
    grade: 92,
    enrolledAt: '2023-08-20T00:00:00.000Z',
    updatedAt: '2024-01-15T00:00:00.000Z'
  },
  {
    id: 'enrollment-002',
    studentId: 'user-001',
    courseId: 'course-002',
    semester: 'Spring 2024',
    academicYear: '2023-2024',
    status: 'enrolled',
    grade: null,
    enrolledAt: '2024-01-15T00:00:00.000Z',
    updatedAt: '2024-01-15T00:00:00.000Z'
  },
  {
    id: 'enrollment-003',
    studentId: 'user-002',
    courseId: 'course-003',
    semester: 'Spring 2024',
    academicYear: '2023-2024',
    status: 'enrolled',
    grade: null,
    enrolledAt: '2024-01-15T00:00:00.000Z',
    updatedAt: '2024-01-15T00:00:00.000Z'
  }
]

// Mock Academic History
export const mockAcademicHistory: MockAcademicHistory[] = [
  {
    id: 'history-001',
    studentId: 'user-001',
    courseId: 'course-001',
    semester: 'Fall 2023',
    academicYear: '2023-2024',
    grade: 92,
    creditsEarned: 3,
    gpaImpact: 3.7,
    createdAt: '2024-01-15T00:00:00.000Z',
    updatedAt: '2024-01-15T00:00:00.000Z'
  }
]

// Mock Notifications
export const mockNotifications: MockNotification[] = [
  {
    id: 'notification-001',
    recipientId: 'user-001',
    senderId: 'user-003',
    title: 'Assignment Posted',
    message: 'CS102 Assignment 3 has been posted. Due date: May 5, 2024.',
    type: 'info',
    isRead: false,
    priority: 'normal',
    createdAt: '2024-04-30T10:00:00.000Z',
    readAt: null
  },
  {
    id: 'notification-002',
    recipientId: 'user-002',
    senderId: 'user-004',
    title: 'Grade Posted',
    message: 'Your grade for IT201 has been posted. You scored 88%.',
    type: 'success',
    isRead: true,
    priority: 'normal',
    createdAt: '2024-04-29T14:00:00.000Z',
    readAt: '2024-04-29T15:00:00.000Z'
  },
  {
    id: 'notification-003',
    recipientId: 'user-003',
    senderId: 'user-005',
    title: 'System Maintenance',
    message: 'The system will be under maintenance on May 2, 2024 from 2:00 AM to 4:00 AM.',
    type: 'system',
    isRead: true,
    priority: 'high',
    createdAt: '2024-04-28T09:00:00.000Z',
    readAt: '2024-04-28T09:30:00.000Z'
  }
]

// Helper functions to get mock data
export function getMockUsers() {
  return mockUsers
}

export function getMockUserById(id: string) {
  return mockUsers.find(user => user.id === id)
}

export function getMockUserByEmail(email: string) {
  return mockUsers.find(user => user.email.toLowerCase() === email.toLowerCase())
}

export function getMockStudentProfile(userId: string) {
  return mockStudentProfiles.find(profile => profile.userId === userId)
}

export function getMockFacultyProfile(userId: string) {
  return mockFacultyProfiles.find(profile => profile.userId === userId)
}

export function getMockAdminProfile(userId: string) {
  return mockAdminProfiles.find(profile => profile.userId === userId)
}

export function getMockCourses() {
  return mockCourses
}

export function getMockCourseById(id: string) {
  return mockCourses.find(course => course.id === id)
}

export function getMockEnrollments(studentId?: string) {
  if (studentId) {
    return mockEnrollments.filter(enrollment => enrollment.studentId === studentId)
  }
  return mockEnrollments
}

export function getMockAcademicHistory(studentId: string) {
  return mockAcademicHistory.filter(history => history.studentId === studentId)
}

export function getMockNotifications(recipientId: string) {
  return mockNotifications.filter(notification => notification.recipientId === recipientId)
}
