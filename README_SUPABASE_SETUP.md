# Supabase Setup Instructions

## Environment Variables

Create a `.env.local` file in your project root with the following variables:

```env
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=https://qupktootahlkpykqizlz.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF1cGt0b290YWhsa3B5a3Fpemx6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc1NTYzNDksImV4cCI6MjA5MzEzMjM0OX0.Ao0HmzE8GldDofh1hDcwORpUvCrRtiDlTi4vjuL5o0U
DATABASE_URL=postgresql://postgres:Ccs123@merry.pink1@db.qupktootahlkpykqizlz.supabase.co:5432/postgres

# Supabase Service Role Key (for server-side operations)
# Get this from your Supabase project settings > API > service_role (secret)
# SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here

# Optional: Additional environment variables
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXT_PUBLIC_APP_NAME=CCS Organization Web
```

## Installation

1. Install the Supabase client library:
```bash
pnpm add @supabase/supabase-js
```

2. Run the database migrations:
   - Go to your Supabase project dashboard
   - Navigate to SQL Editor
   - Run the migration files in `supabase/migrations/` in order:
     1. `001_initial_schema.sql`
     2. `002_rls_policies.sql`

## Database Schema

The database includes the following tables:
- `users` - User accounts linked to auth.users
- `student_profiles` - Student-specific information
- `faculty_profiles` - Faculty-specific information
- `admin_profiles` - Admin-specific information
- `courses` - Course catalog
- `enrollments` - Student course enrollments
- `academic_history` - Academic records
- `attendance` - Attendance tracking
- `medical_records` - Medical information (restricted access)
- `counseling_records` - Counseling sessions
- `discipline_records` - Disciplinary actions
- `student_documents` - File uploads
- `student_organizations` - Student clubs/organizations
- `notifications` - User notifications
- `system_settings` - Configuration settings
- `audit_logs` - Activity tracking
- `grade_scales` - Grading system

## Security Policies

Row Level Security (RLS) is enabled on all tables with the following access patterns:
- Users can only view/update their own data
- Faculty can view student data for their courses
- Admins have full access to all data
- Public data (courses, organizations) is readable by everyone

## Usage Examples

### Authentication
```typescript
import { auth } from '@/lib/supabaseClient'

// Sign in
const { data, error } = await auth.signIn(email, password)

// Get current user
const { user } = await auth.getCurrentUser()
```

### Database Operations
```typescript
import { db } from '@/lib/supabaseClient'

// Get student profile
const { data, error } = await db.getStudentProfile(userId)

// Get user notifications
const { data, error } = await db.getUserNotifications(userId)
```

### Real-time Subscriptions
```typescript
import { db } from '@/lib/supabaseClient'

// Subscribe to notifications
const subscription = db.subscribeToNotifications(userId, (payload) => {
  console.log('New notification:', payload)
})
```

## Next Steps

1. Set up your `.env.local` file
2. Install dependencies with `pnpm install`
3. Run database migrations in Supabase dashboard
4. Test the connection in your application
5. Implement authentication flows
6. Set up storage buckets for file uploads

## Notes

- The `@types/node` package is already included in devDependencies
- TypeScript errors will resolve after installing `@supabase/supabase-js`
- The service role key should be kept secure and only used server-side
- Consider using environment-specific configurations for production
