-- RLS 문제 진단 쿼리
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- ============================================
-- 1. 현재 모든 정책 확인
-- ============================================
SELECT 
  '현재 정책 상태' as info,
  policyname,
  cmd,
  roles,
  with_check,
  qual
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
ORDER BY cmd, policyname;

-- ============================================
-- 2. RLS 활성화 상태 확인
-- ============================================
SELECT 
  'RLS 활성화 상태' as info,
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename = 'inquiries';

-- ============================================
-- 3. 테이블 구조 확인
-- ============================================
SELECT 
  '테이블 구조' as info,
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'inquiries'
ORDER BY ordinal_position;

-- ============================================
-- 4. admin_users 테이블 확인 (관리자 함수용)
-- ============================================
SELECT 
  'admin_users 테이블 존재 확인' as info,
  EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = 'admin_users'
  ) as table_exists;

-- ============================================
-- 5. is_admin() 함수 확인
-- ============================================
SELECT 
  'is_admin 함수 확인' as info,
  proname as function_name,
  prosrc as function_body
FROM pg_proc
WHERE proname = 'is_admin';

