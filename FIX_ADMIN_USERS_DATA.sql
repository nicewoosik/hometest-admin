-- admin_users 테이블 데이터 수정 및 RLS 정책 확인

-- 1. 현재 로그인한 사용자의 auth.uid() 확인
SELECT 
  auth.uid() as current_user_id,
  auth.email() as current_user_email;

-- 2. admin_users 테이블의 현재 데이터 확인
SELECT 
  id,
  auth_user_id,
  email,
  name,
  role,
  created_at
FROM admin_users;

-- 3. 현재 로그인한 사용자의 이메일로 admin_users 레코드 찾기
-- (이 쿼리는 Supabase Dashboard에서 실행하면 현재 로그인한 사용자 정보를 볼 수 있습니다)
SELECT 
  au.id,
  au.auth_user_id,
  au.email,
  au.name,
  au.role,
  auth.uid() as current_auth_uid,
  CASE 
    WHEN au.auth_user_id = auth.uid() THEN '매칭됨'
    WHEN au.auth_user_id IS NULL THEN 'auth_user_id가 NULL'
    ELSE '매칭 안됨'
  END as match_status
FROM admin_users au;

-- 4. admin_users 테이블의 auth_user_id 업데이트
-- ⚠️ 주의: 이 쿼리를 실행하기 전에 현재 로그인한 사용자의 auth.uid()를 확인하세요!
-- 
-- 예시: admin@ecstel.co.kr의 auth_user_id를 업데이트하려면
-- UPDATE admin_users 
-- SET auth_user_id = auth.uid()  -- 또는 특정 UUID
-- WHERE email = 'admin@ecstel.co.kr' AND auth_user_id IS NULL;

-- 5. RLS 정책 확인
SELECT 
  policyname,
  cmd,
  roles,
  qual,
  with_check
FROM pg_policies
WHERE tablename = 'admin_users';

-- 6. is_admin() 함수 테스트
SELECT 
  auth.uid() as current_user_id,
  is_admin() as is_admin_result,
  EXISTS (
    SELECT 1 FROM admin_users
    WHERE auth_user_id = auth.uid()
  ) as manual_check;

