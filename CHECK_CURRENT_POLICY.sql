-- 현재 정책 상태 확인
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- ============================================
-- 1. INSERT 정책 확인
-- ============================================
SELECT 
  policyname,
  cmd,
  roles,
  with_check,
  qual,
  permissive
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
  AND cmd = 'INSERT';

-- ============================================
-- 2. RLS 활성화 상태 확인
-- ============================================
SELECT 
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename = 'inquiries';

-- ============================================
-- 3. 모든 inquiries 정책 확인
-- ============================================
SELECT 
  policyname,
  cmd,
  roles,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
ORDER BY cmd, policyname;

