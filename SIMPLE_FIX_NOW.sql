-- 간단한 수정: admin_users의 auth_user_id 업데이트

-- Step 1: 현재 로그인한 사용자 확인
SELECT 
  auth.uid() as current_user_id,
  auth.email() as current_user_email;

-- Step 2: admin_users 테이블 확인
SELECT 
  id,
  auth_user_id,
  email,
  name,
  role
FROM admin_users;

-- Step 3: admin@ecstel.co.kr의 auth_user_id를 현재 사용자로 업데이트
-- ⚠️ 위 Step 1에서 확인한 current_user_id를 복사해서 사용하세요!
UPDATE admin_users 
SET auth_user_id = auth.uid()  -- 현재 로그인한 사용자의 UUID
WHERE email = 'admin@ecstel.co.kr' AND auth_user_id IS NULL;

-- Step 4: 다른 레코드도 업데이트 (필요한 경우)
-- nicewoosik@gmail.com의 auth_user_id도 업데이트하려면:
-- 먼저 해당 사용자로 로그인한 후:
-- UPDATE admin_users 
-- SET auth_user_id = auth.uid()
-- WHERE email = 'nicewoosik@gmail.com' AND auth_user_id IS NULL;

-- Step 5: 확인
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
  END as status
FROM admin_users;

-- Step 6: is_admin() 함수 테스트
SELECT 
  auth.uid() as current_user_id,
  is_admin() as is_admin_result;

