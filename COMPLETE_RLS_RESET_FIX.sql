-- 완전한 RLS 정책 재설정 및 수정

-- ============================================
-- Step 1: 현재 상태 확인
-- ============================================
SELECT 
  auth.uid() as current_user_id,
  auth.email() as current_user_email,
  is_admin() as is_admin_result;

-- admin_users 테이블 확인
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
-- Step 2: admin_users 테이블의 모든 RLS 정책 삭제
-- ============================================
DROP POLICY IF EXISTS "admin_users_select_policy" ON admin_users;
DROP POLICY IF EXISTS "admin_users_update_policy" ON admin_users;
DROP POLICY IF EXISTS "admin_users_delete_policy" ON admin_users;
DROP POLICY IF EXISTS "admin_users_insert_policy" ON admin_users;
DROP POLICY IF EXISTS "관리자는 admin_users 조회 가능" ON admin_users;
DROP POLICY IF EXISTS "관리자는 admin_users 수정 가능" ON admin_users;
DROP POLICY IF EXISTS "관리자는 admin_users 삭제 가능" ON admin_users;
DROP POLICY IF EXISTS "관리자는 admin_users 생성 가능" ON admin_users;

-- ============================================
-- Step 3: admin_users 테이블의 auth_user_id 업데이트
-- ============================================
-- 현재 로그인한 사용자로 admin@ecstel.co.kr 업데이트
UPDATE admin_users 
SET auth_user_id = auth.uid()
WHERE email = 'admin@ecstel.co.kr' AND (auth_user_id IS NULL OR auth_user_id != auth.uid());

-- ============================================
-- Step 4: 새로운 RLS 정책 생성 (간단하고 명확하게)
-- ============================================

-- SELECT 정책: 관리자는 모든 admin_users 조회 가능
CREATE POLICY "admin_users_select_all"
  ON admin_users FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE auth_user_id = auth.uid()
    )
  );

-- UPDATE 정책: 관리자는 자신의 레코드 수정 가능
CREATE POLICY "admin_users_update"
  ON admin_users FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE auth_user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE auth_user_id = auth.uid()
    )
  );

-- DELETE 정책: 관리자는 자신의 레코드 삭제 가능 (또는 모든 레코드)
CREATE POLICY "admin_users_delete"
  ON admin_users FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE auth_user_id = auth.uid()
    )
  );

-- INSERT 정책: 관리자는 새 계정 생성 가능
CREATE POLICY "admin_users_insert"
  ON admin_users FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE auth_user_id = auth.uid()
    )
  );

-- ============================================
-- Step 5: inquiries 테이블 정책 확인 및 수정
-- ============================================

-- inquiries 테이블의 모든 정책 확인
SELECT 
  policyname,
  cmd,
  roles,
  qual,
  with_check
FROM pg_policies
WHERE tablename = 'inquiries';

-- 관리자가 모든 inquiries 조회할 수 있는지 확인
-- (이미 정책이 있다면 그대로 사용)

-- ============================================
-- Step 6: 테스트
-- ============================================

-- admin_users 조회 테스트
SELECT COUNT(*) as admin_users_count FROM admin_users;
SELECT * FROM admin_users;

-- inquiries 조회 테스트
SELECT COUNT(*) as inquiries_count FROM inquiries;

-- is_admin() 함수 테스트
SELECT 
  auth.uid() as current_user_id,
  is_admin() as is_admin_result,
  EXISTS (
    SELECT 1 FROM admin_users
    WHERE auth_user_id = auth.uid()
  ) as manual_check;

