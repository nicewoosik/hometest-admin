-- 정책 확인 쿼리
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- ============================================
-- 1. INSERT 정책 확인 (가장 중요!)
-- ============================================
SELECT 
  'INSERT 정책' as policy_type,
  policyname,
  cmd,
  roles,
  with_check,
  qual
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
  AND cmd = 'INSERT';

-- ============================================
-- 2. RLS 활성화 상태 확인
-- ============================================
SELECT 
  'RLS 상태' as check_type,
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename = 'inquiries';

-- ============================================
-- 3. 모든 정책 확인
-- ============================================
SELECT 
  '모든 정책' as check_type,
  policyname,
  cmd,
  roles,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
ORDER BY cmd, policyname;

-- ============================================
-- 4. 테이블 구조 확인
-- ============================================
SELECT 
  '테이블 구조' as check_type,
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'inquiries'
ORDER BY ordinal_position;

