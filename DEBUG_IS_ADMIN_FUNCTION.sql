-- is_admin() 함수 디버깅

-- ============================================
-- Step 1: 현재 사용자 정보 확인
-- ============================================
SELECT 
  auth.uid() as current_user_id,
  auth.email() as current_user_email;

-- ============================================
-- Step 2: admin_users 테이블 확인
-- ============================================
SELECT 
  id,
  auth_user_id,
  email,
  name,
  role,
  CASE 
    WHEN auth_user_id = auth.uid() THEN '✅ 매칭됨'
    WHEN auth_user_id IS NULL THEN '❌ NULL'
    ELSE '⚠️ 다른 사용자'
  END as match_status
FROM admin_users;

-- ============================================
-- Step 3: is_admin() 함수 테스트
-- ============================================
SELECT 
  auth.uid() as current_user_id,
  is_admin() as is_admin_result,
  EXISTS (
    SELECT 1 FROM admin_users
    WHERE auth_user_id = auth.uid()
  ) as manual_check;

-- ============================================
-- Step 4: is_admin() 함수 코드 확인
-- ============================================
SELECT 
  proname as function_name,
  prosrc as function_body,
  proconfig as function_config
FROM pg_proc
WHERE proname = 'is_admin';

-- ============================================
-- Step 5: RLS 정책에서 is_admin() 사용 확인
-- ============================================
SELECT 
  tablename,
  policyname,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE qual LIKE '%is_admin%' OR with_check LIKE '%is_admin%';

