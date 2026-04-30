-- Drop All Schema Migration
-- This migration will completely drop all existing tables, functions, triggers, and policies

-- =============================================
-- DROP ALL TRIGGERS
-- =============================================

-- Drop all triggers first
DROP TRIGGER IF EXISTS handle_users_updated_at ON public.users;
DROP TRIGGER IF EXISTS handle_student_profiles_updated_at ON public.student_profiles;
DROP TRIGGER IF EXISTS handle_faculty_profiles_updated_at ON public.faculty_profiles;
DROP TRIGGER IF EXISTS handle_admin_profiles_updated_at ON public.admin_profiles;
DROP TRIGGER IF EXISTS handle_courses_updated_at ON public.courses;
DROP TRIGGER IF EXISTS handle_course_prerequisites_updated_at ON public.course_prerequisites;
DROP TRIGGER IF EXISTS handle_enrollments_updated_at ON public.enrollments;
DROP TRIGGER IF EXISTS handle_academic_history_updated_at ON public.academic_history;
DROP TRIGGER IF EXISTS handle_attendance_updated_at ON public.attendance;
DROP TRIGGER IF EXISTS handle_medical_records_updated_at ON public.medical_records;
DROP TRIGGER IF EXISTS handle_counseling_records_updated_at ON public.counseling_records;
DROP TRIGGER IF EXISTS handle_discipline_records_updated_at ON public.discipline_records;
DROP TRIGGER IF EXISTS handle_student_documents_updated_at ON public.student_documents;
DROP TRIGGER IF EXISTS handle_student_organizations_updated_at ON public.student_organizations;
DROP TRIGGER IF EXISTS handle_organization_memberships_updated_at ON public.organization_memberships;
DROP TRIGGER IF EXISTS handle_notifications_updated_at ON public.notifications;
DROP TRIGGER IF EXISTS handle_system_settings_updated_at ON public.system_settings;
DROP TRIGGER IF EXISTS handle_audit_logs_updated_at ON public.audit_logs;
DROP TRIGGER IF EXISTS handle_grade_scales_updated_at ON public.grade_scales;

-- =============================================
-- DROP ALL FUNCTIONS
-- =============================================

-- Drop the generic updated_at function
DROP FUNCTION IF EXISTS public.update_updated_at_column() CASCADE;

-- =============================================
-- DROP ALL RLS POLICIES
-- =============================================

-- Drop all RLS policies (if they exist)
DO $$
DECLARE
    policy_record RECORD;
BEGIN
    FOR policy_record IN
        SELECT schemaname, tablename, policyname
        FROM pg_policies
        WHERE schemaname = 'public'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', 
                      policy_record.policyname, 
                      policy_record.schemaname, 
                      policy_record.tablename);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- DISABLE RLS ON ALL TABLES
-- =============================================

-- Disable RLS on all tables (optional)
DO $$
DECLARE
    table_record RECORD;
BEGIN
    FOR table_record IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = 'public'
    LOOP
        EXECUTE format('ALTER TABLE public.%I DISABLE ROW LEVEL SECURITY', table_record.tablename);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- DROP ALL TABLES
-- =============================================

-- Drop all tables in correct order to avoid foreign key constraints
DROP TABLE IF EXISTS public.organization_memberships CASCADE;
DROP TABLE IF EXISTS public.student_organizations CASCADE;
DROP TABLE IF EXISTS public.student_documents CASCADE;
DROP TABLE IF EXISTS public.discipline_records CASCADE;
DROP TABLE IF EXISTS public.counseling_records CASCADE;
DROP TABLE IF EXISTS public.medical_records CASCADE;
DROP TABLE IF EXISTS public.attendance CASCADE;
DROP TABLE IF EXISTS public.grade_scales CASCADE;
DROP TABLE IF EXISTS public.audit_logs CASCADE;
DROP TABLE IF EXISTS public.notifications CASCADE;
DROP TABLE IF EXISTS public.system_settings CASCADE;
DROP TABLE IF EXISTS public.academic_history CASCADE;
DROP TABLE IF EXISTS public.enrollments CASCADE;
DROP TABLE IF EXISTS public.course_prerequisites CASCADE;
DROP TABLE IF EXISTS public.courses CASCADE;
DROP TABLE IF EXISTS public.admin_profiles CASCADE;
DROP TABLE IF EXISTS public.faculty_profiles CASCADE;
DROP TABLE IF EXISTS public.student_profiles CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;

-- =============================================
-- VERIFY CLEANUP
-- =============================================

-- Check if any tables remain (optional - for verification)
DO $$
DECLARE
    table_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO table_count
    FROM information_schema.tables
    WHERE table_schema = 'public'
    AND table_type = 'BASE TABLE';
    
    IF table_count > 0 THEN
        RAISE NOTICE 'Warning: % tables still exist in public schema', table_count;
    ELSE
        RAISE NOTICE 'All tables successfully dropped from public schema';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- OPTIONAL: RESET SEQUENCES IF THEY EXIST
-- =============================================

-- Reset sequences (only if they exist)
DO $$
DECLARE
    sequence_record RECORD;
BEGIN
    FOR sequence_record IN
        SELECT sequence_name
        FROM information_schema.sequences
        WHERE sequence_schema = 'public'
    LOOP
        EXECUTE format('ALTER SEQUENCE public.%I RESTART WITH 1', sequence_record.sequence_name);
    END LOOP;
END;
$$ LANGUAGE plpgsql;