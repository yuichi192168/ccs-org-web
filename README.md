# CCS Organization Web - Educational Management System

A comprehensive educational management system built with Next.js 15, TypeScript, and Supabase. This system handles student enrollment, course management, academic records, and administrative functions for educational institutions.

## Features

- **User Management**: Role-based authentication (Student, Faculty, Admin)
- **Student Profiles**: Academic records, enrollment tracking, GPA calculation
- **Faculty Management**: Course assignment, attendance tracking, grade management
- **Course Catalog**: Course listings, prerequisites, scheduling
- **Academic Records**: Transcript generation, grade history
- **Document Management**: File uploads for student documents
- **Real-time Notifications**: Live updates for important events
- **Audit Logging**: Complete activity tracking
- **Secure Storage**: Row-level security for data protection

## Technology Stack

- **Frontend**: Next.js 15.2.8, React 18.3.1, TypeScript
- **Backend**: Supabase (PostgreSQL, Auth, Storage, Real-time)
- **UI Components**: Radix UI, TailwindCSS 4.2.0, shadcn/ui
- **State Management**: React Hooks, Supabase Real-time
- **Deployment**: Vercel (recommended), Netlify, AWS
- **Package Manager**: pnpm 10.29.2

## Prerequisites

- Node.js 18-20 (recommended: 20.x)
- pnpm 10.29.2
- Supabase account and project
- Git

## Quick Start

### 1. Clone and Install

```bash
git clone <repository-url>
cd ccs-org-web
pnpm install
```

### 2. Environment Setup

Copy the environment template and configure your variables:

```bash
cp .env.local.example .env.local
```

Edit `.env.local` with your Supabase credentials:

```env
# Supabase Configuration
# Application Configuration
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXT_PUBLIC_APP_NAME=CCS Organization Web
```

### 3. Database Setup

Run the database migrations in your Supabase dashboard:

1. Go to your Supabase project dashboard
2. Navigate to **SQL Editor**
3. Run `supabase/migrations/001_initial_schema.sql`
4. Run `supabase/migrations/002_rls_policies.sql`

### 4. Start Development Server

```bash
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Database Schema

### Core Tables

- **users**: User accounts linked to Supabase Auth
- **student_profiles**: Student academic information
- **faculty_profiles**: Faculty employment details
- **admin_profiles**: Administrative user settings
- **courses**: Course catalog and descriptions
- **enrollments**: Student course registrations
- **academic_history**: Historical academic records
- **attendance**: Attendance tracking system
- **notifications**: User notification system
- **audit_logs**: System activity logging

### Security Model

- **Row Level Security** enabled on all tables
- **Role-based access control** (Student, Faculty, Admin)
- **Data isolation** between users
- **Public data** for courses and organizations
- **Restricted access** for sensitive information (medical, disciplinary records)

## Development

### Project Structure

```
ccs-org-web/
|-- app/                    # Next.js App Router
|   |-- api/               # API routes
|   |-- globals.css        # Global styles
|   |-- layout.tsx         # Root layout
|   `-- page.tsx           # Home page
|-- components/            # React components
|-- lib/                   # Utility libraries
|   |-- supabaseClient.ts  # Supabase client setup
|   `-- utils.ts          # Helper functions
|-- supabase/              # Database migrations
|   |-- migrations/
|   |   |-- 001_initial_schema.sql
|   |   `-- 002_rls_policies.sql
|   `-- seed.sql          # Sample data (optional)
|-- types/                 # TypeScript definitions
|   `-- database.ts       # Database types
`-- public/               # Static assets
```

### Available Scripts

```bash
# Development
pnpm dev              # Start development server
pnpm build            # Build for production
pnpm start            # Start production server
pnpm lint             # Run ESLint

# Database (requires Supabase CLI)
supabase db reset     # Reset database
supabase db push      # Push migrations
supabase db diff      # Show schema changes
```

### API Routes

The application uses Next.js App Router API routes:

- `/api/auth/*` - Authentication endpoints
- `/api/dashboard/*` - User dashboard data
- `/api/enrollments/*` - Course enrollment management
- `/api/notifications/*` - Notification system
- `/api/uploads/*` - File upload handling

### Authentication

The system uses Supabase Auth with custom metadata for roles:

```typescript
// Sign up with role
await auth.signUp(email, password, {
  role: 'student', // or 'faculty', 'admin'
  system_id: 'STU001',
  name: 'John Doe'
})

// Role-based access control
const { user } = await auth.getCurrentUser()
const userRole = user?.user_metadata?.role
```

## Deployment

### Vercel (Recommended)

1. **Connect Repository**
   ```bash
   # Install Vercel CLI
   npm i -g vercel
   
   # Deploy
   vercel --prod
   ```

2. **Environment Variables**
   Add all `.env.local` variables to Vercel project settings

3. **Database**
   Ensure Supabase migrations are run in production

### Netlify

1. **Build Settings**
   ```toml
   [build]
     command = "pnpm build"
   
   [build.environment]
     NODE_VERSION = "20"
     PNPM_VERSION = "10.29.2"
   
   [[plugins]]
     package = "@netlify/plugin-nextjs"
   ```

2. **Environment Variables**
   Configure in Netlify dashboard

### AWS Amplify

1. **Build Configuration**
   ```yaml
   version: 1
   frontend:
     phases:
       preBuild:
         commands:
           - npm install -g pnpm
           - pnpm install
       build:
         commands:
           - pnpm build
     artifacts:
       baseDirectory: .next
       files:
         - '**/*'
     cache:
       paths:
         - node_modules/.cache
   ```

### Docker

```dockerfile
FROM node:20-alpine

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install --frozen-lockfile

COPY . .
RUN pnpm build

EXPOSE 3000
CMD ["pnpm", "start"]
```

## Environment Variables

### Required

| Variable | Description | Example |
|----------|-------------|---------|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase project URL | `https://project.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase anonymous key | `eyJ...` |
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://...` |
| `SUPABASE_SERVICE_ROLE_KEY` | Service role key (server-side) | `eyJ...` |

### Optional

| Variable | Description | Default |
|----------|-------------|---------|
| `NEXT_PUBLIC_APP_URL` | Application base URL | `http://localhost:3000` |
| `NEXT_PUBLIC_APP_NAME` | Application name | `CCS Organization Web` |

## Monitoring and Analytics

- **Vercel Analytics**: Built-in performance monitoring
- **Supabase Dashboard**: Database and auth metrics
- **Audit Logs**: Complete activity tracking in database

## Security Considerations

- **Row Level Security**: All tables have RLS policies
- **Environment Variables**: Keep service role keys secure
- **HTTPS**: Required for production
- **Input Validation**: Zod schemas for API validation
- **File Uploads**: Restrict file types and sizes

## Troubleshooting

### Common Issues

1. **Database Connection Errors**
   - Verify Supabase URL and keys
   - Check network connectivity
   - Ensure migrations are applied

2. **Authentication Issues**
   - Verify email confirmation settings in Supabase
   - Check redirect URLs in auth configuration
   - Ensure RLS policies allow user access

3. **Build Errors**
   - Update Node.js to version 18-20
   - Clear pnpm cache: `pnpm store prune`
   - Reinstall dependencies: `rm -rf node_modules && pnpm install`

4. **TypeScript Errors**
   - Run `pnpm build` to check for type issues
   - Ensure database types match current schema
   - Update Supabase types if schema changes

### Performance Optimization

- **Database Indexing**: Review indexes in migration files
- **Caching**: Implement Redis for frequent queries
- **CDN**: Use Supabase Storage for static assets
- **Code Splitting**: Leverage Next.js automatic splitting

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make changes and test thoroughly
4. Commit changes: `git commit -m "Add feature"`
5. Push to branch: `git push origin feature-name`
6. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:

- Create an issue in the repository
- Check the [Supabase Documentation](https://supabase.com/docs)
- Review the [Next.js Documentation](https://nextjs.org/docs)

## Changelog

### v1.0.0
- Initial release with core educational management features
- Supabase integration with PostgreSQL backend
- Role-based authentication system
- Real-time notifications
- Complete audit logging system
