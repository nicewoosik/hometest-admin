-- 최종 진단 쿼리
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
    ELSE 'RLS 비활성화됨'
  END as status
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename = 'inquiries';

-- ============================================
-- 3. 모든 inquiries 정책 확인 (충돌 확인)
-- ============================================
SELECT 
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
-- 4. 테이블 권한 확인
-- ============================================
SELECT 
  grantee,
  privilege_type
FROM information_schema.role_table_grants
WHERE table_schema = 'public'
  AND table_name = 'inquiries';

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
      AND 'public' = ANY(roles)
  ) as public_policy_exists;

