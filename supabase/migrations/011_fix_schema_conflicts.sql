-- Fix Schema Conflicts and Missing Columns
-- Migration: 011_fix_schema_conflicts.sql

-- =============================================
-- FIX STUDENT PROFILES TABLE
-- =============================================

-- Add missing columns to student_profiles if they don't exist
DO $$
BEGIN
    -- Add program column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'student_profiles' 
        AND column_name = 'program'
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE public.student_profiles ADD COLUMN program TEXT;
    END IF;

    -- Add enrollment_status column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'student_profiles' 
        AND column_name = 'enrollment_status'
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE public.student_profiles ADD COLUMN enrollment_status TEXT DEFAULT 'enrolled' CHECK (enrollment_status IN ('enrolled', 'suspended', 'graduated', 'withdrawn'));
    END IF;

    -- Convert year_level from TEXT to INTEGER if needed
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'student_profiles' 
        AND column_name = 'year_level'
        AND data_type = 'text'
        AND table_schema = 'public'
    ) THEN
        -- Create a temporary column
        ALTER TABLE public.student_profiles ADD COLUMN year_level_temp INTEGER;
        
        -- Convert text year levels to integers
        UPDATE public.student_profiles SET year_level_temp = 
            CASE 
                WHEN year_level = 'First Year' THEN 1
                WHEN year_level = 'Second Year' THEN 2
                WHEN year_level = 'Third Year' THEN 3
                WHEN year_level = 'Fourth Year' THEN 4
                WHEN year_level = 'Fifth Year' THEN 5
                WHEN year_level = '1' THEN 1
                WHEN year_level = '2' THEN 2
                WHEN year_level = '3' THEN 3
                WHEN year_level = '4' THEN 4
                WHEN year_level = '5' THEN 5
                ELSE 1
            END;
        
        -- Drop old column and rename temp column
        ALTER TABLE public.student_profiles DROP COLUMN year_level;
        ALTER TABLE public.student_profiles RENAME COLUMN year_level_temp TO year_level;
        
        -- Add check constraint
        ALTER TABLE public.student_profiles ADD CONSTRAINT check_year_level CHECK (year_level BETWEEN 1 AND 6);
    END IF;
END $$;

-- =============================================
-- FIX COURSES TABLE
-- =============================================

-- Add missing columns to courses table
DO $$
BEGIN
    -- Add title column if course_name exists but title doesn't
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'courses' 
        AND column_name = 'course_name'
        AND table_schema = 'public'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'courses' 
        AND column_name = 'title'
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE public.courses RENAME COLUMN course_name TO title;
    END IF;

    -- Add credits column if units exists but credits doesn't
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'courses' 
        AND column_name = 'units'
        AND table_schema = 'public'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'courses' 
        AND column_name = 'credits'
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE public.courses RENAME COLUMN units TO credits;
    END IF;

    -- Add missing columns
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'courses' 
        AND column_name = 'semester'
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE public.courses ADD COLUMN semester TEXT;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'courses' 
        AND column_name = 'academic_year'
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE public.courses ADD COLUMN academic_year TEXT;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'courses' 
        AND column_name = 'faculty_id'
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE public.courses ADD COLUMN faculty_id UUID REFERENCES public.faculty_profiles(id);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'courses' 
        AND column_name = 'max_students'
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE public.courses ADD COLUMN max_students INTEGER DEFAULT 50;
    END IF;
END $$;

-- =============================================
-- FIX FACULTY PROFILES TABLE
-- =============================================

-- Add missing columns to faculty_profiles table
DO $$
BEGIN
    -- Rename employee_number to employee_id if needed
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'faculty_profiles' 
        AND column_name = 'employee_number'
        AND table_schema = 'public'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'faculty_profiles' 
        AND column_name = 'employee_id'
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE public.faculty_profiles RENAME COLUMN employee_number TO employee_id;
    END IF;
END $$;

-- =============================================
-- FIX ADMIN PROFILES TABLE
-- =============================================

-- Add missing columns to admin_profiles table
DO $$
BEGIN
    -- Add department column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'admin_profiles' 
        AND column_name = 'department'
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE public.admin_profiles ADD COLUMN department TEXT;
    END IF;

    -- Update admin_level constraints if needed
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'admin_profiles' 
        AND column_name = 'admin_level'
        AND table_schema = 'public'
    ) THEN
        -- Update existing values to match new enum
        UPDATE public.admin_profiles SET admin_level = 
            CASE 
                WHEN admin_level = 'basic' THEN 'department'
                WHEN admin_level = 'super' THEN 'system'
                ELSE admin_level
            END
        WHERE admin_level IN ('basic', 'super');
    END IF;
END $$;

-- =============================================
-- UPDATE EXISTING DATA TO MATCH NEW SCHEMA
-- =============================================

-- Update student_profiles data
DO $$
BEGIN
    -- Update program from course if program is null
    UPDATE public.student_profiles SET program = course WHERE program IS NULL AND course IS NOT NULL;
    
    -- Set default enrollment status if null
    UPDATE public.student_profiles SET enrollment_status = 'enrolled' WHERE enrollment_status IS NULL;
    
    -- Set default year_level if null
    UPDATE public.student_profiles SET year_level = 1 WHERE year_level IS NULL;
END $$;

-- Update courses data
DO $$
BEGIN
    -- Set default semester if null
    UPDATE public.courses SET semester = 'First Semester' WHERE semester IS NULL;
    
    -- Set default academic_year if null
    UPDATE public.courses SET academic_year = '2023-2024' WHERE academic_year IS NULL;
    
    -- Set default max_students if null
    UPDATE public.courses SET max_students = 50 WHERE max_students IS NULL;
END $$;

-- =============================================
-- CREATE MISSING INDEXES
-- =============================================

-- Create indexes that might be missing
CREATE INDEX IF NOT EXISTS idx_student_profiles_program ON public.student_profiles(program);
CREATE INDEX IF NOT EXISTS idx_student_profiles_enrollment_status ON public.student_profiles(enrollment_status);
CREATE INDEX IF NOT EXISTS idx_courses_semester ON public.courses(semester);
CREATE INDEX IF NOT EXISTS idx_courses_academic_year ON public.courses(academic_year);
CREATE INDEX IF NOT EXISTS idx_courses_faculty_id ON public.courses(faculty_id);

-- =============================================
-- COMPLETION
-- =============================================

-- Log the completion of schema fixes
INSERT INTO public.audit_logs (id, user_id, action, table_name, record_id, new_values, created_at, updated_at)
VALUES 
('710e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'SCHEMA_FIXES_COMPLETE', 'system', NULL, '{"message": "Schema conflicts resolved and missing columns added"}', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;
