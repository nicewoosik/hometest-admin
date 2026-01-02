-- RLS 정책 확인 쿼리
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- 1. RLS가 활성화되어 있는지 확인
SELECT 
  schemaname,
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN ('admin_users', 'inquiries', 'job_postings', 'job_applications')
ORDER BY tablename;

-- 2. 각 테이블의 RLS 정책 목록 확인
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename IN ('admin_users', 'inquiries', 'job_postings', 'job_applications')
ORDER BY tablename, policyname;

-- 3. is_admin() 함수가 생성되었는지 확인
SELECT 
  proname as function_name,
  prosrc as function_body
FROM pg_proc
WHERE proname = 'is_admin';

-- 4. 현재 인증된 사용자가 관리자인지 테스트
-- (인증된 상태에서 실행해야 함)
SELECT 
  auth.uid() as current_user_id,
  is_admin() as is_current_user_admin,
  EXISTS (
    SELECT 1 FROM admin_users 
    WHERE auth_user_id = auth.uid()
  ) as exists_in_admin_users;

-- 5. admin_users 테이블에 현재 사용자가 있는지 확인
SELECT 
  id,
  auth_user_id,
  email,
  name,
  role,
  created_at
FROM admin_users
WHERE auth_user_id = auth.uid();

