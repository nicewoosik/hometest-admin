-- RLS 심층 확인 및 문제 진단
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- ============================================
-- 1. 정책 상세 정보 확인
-- ============================================
SELECT 
  policyname,
  cmd,
  roles,
  qual as using_expression,
  with_check as with_check_expression,
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
  rowsecurity as rls_enabled,
  CASE 
    WHEN rowsecurity THEN 'RLS 활성화됨'
    ELSE 'RLS 비활성화됨 - 문제!'
  END as status
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename = 'inquiries';

-- ============================================
-- 3. 테이블 소유자 및 권한 확인
-- ============================================
SELECT 
  table_name,
  table_schema,
  table_type
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name = 'inquiries';

-- ============================================
-- 4. 역할(role) 확인
-- ============================================
SELECT 
  rolname,
  rolsuper,
  rolcreaterole,
  rolcreatedb
FROM pg_roles
WHERE rolname IN ('anon', 'authenticated', 'postgres', 'service_role');

-- ============================================
-- 5. 정책이 실제로 적용되는지 테스트
-- ============================================
-- 주의: 이 쿼리는 service_role로 실행되므로 성공할 수 있습니다
-- 실제 테스트는 홈페이지에서 해야 합니다
SELECT 
  '정책 테스트' as test_type,
  EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'inquiries'
      AND cmd = 'INSERT'
      AND ('anon' = ANY(roles) OR 'authenticated' = ANY(roles))
      AND with_check = 'true'
  ) as insert_policy_exists;

-- ============================================
-- 6. 모든 inquiries 정책 확인
-- ============================================
SELECT 
  '모든 정책' as check_type,
  policyname,
  cmd,
  roles,
  permissive,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
ORDER BY cmd, policyname;

