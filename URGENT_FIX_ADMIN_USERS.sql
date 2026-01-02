-- ⚠️ 긴급 수정: admin_users 및 inquiries 조회 문제 해결

-- ============================================
-- Step 1: 현재 로그인한 사용자 확인
-- ============================================
-- 이 쿼리를 먼저 실행하여 현재 사용자의 UUID를 확인하세요
SELECT 
  auth.uid() as current_user_id,
  auth.email() as current_user_email;

-- ============================================
-- Step 2: admin_users 테이블의 auth_user_id 업데이트
-- ============================================
-- ⚠️ 위 Step 1에서 확인한 current_user_id를 사용하세요!
-- 
-- 예시 1: admin@ecstel.co.kr의 auth_user_id 업데이트
-- UPDATE admin_users 
-- SET auth_user_id = auth.uid()  -- 현재 로그인한 사용자의 UUID
-- WHERE email = 'admin@ecstel.co.kr' AND auth_user_id IS NULL;

-- 예시 2: 모든 admin_users의 auth_user_id를 현재 사용자로 설정 (임시)
-- UPDATE admin_users 
-- SET auth_user_id = auth.uid()
-- WHERE auth_user_id IS NULL;

-- ============================================
-- Step 3: RLS 정책 수정 (관리자가 모든 레코드 조회 가능하도록)
-- ============================================

-- 기존 정책 삭제
DROP POLICY IF EXISTS "admin_users_select_policy" ON admin_users;
DROP POLICY IF EXISTS "관리자는 admin_users 조회 가능" ON admin_users;

-- 새로운 정책 생성: 관리자는 모든 admin_users 조회 가능
CREATE POLICY "admin_users_select_policy"
  ON admin_users FOR SELECT
  TO authenticated
  USING (
    -- 관리자인 경우 모든 레코드 조회 가능
    is_admin() = true
  );

-- ============================================
-- Step 4: inquiries 테이블 RLS 정책 확인 및 수정
-- ============================================

-- inquiries 테이블의 현재 정책 확인
SELECT 
  policyname,
  cmd,
  roles,
  qual,
  with_check
FROM pg_policies
WHERE tablename = 'inquiries';

-- 관리자가 모든 inquiries 조회할 수 있도록 정책 확인
-- (이미 DATABASE_SCHEMA.sql에 정책이 있을 수 있음)

-- ============================================
-- Step 5: 테스트
-- ============================================

-- admin_users 조회 테스트
SELECT COUNT(*) as admin_users_count FROM admin_users;

-- inquiries 조회 테스트  
SELECT COUNT(*) as inquiries_count FROM inquiries;

-- is_admin() 함수 테스트
SELECT 
  auth.uid() as current_user_id,
  is_admin() as is_admin_result;

