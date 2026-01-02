-- admin_users 테이블 RLS 정책 확인 및 수정

-- 1. 현재 RLS 정책 확인
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
WHERE tablename = 'admin_users';

-- 2. is_admin() 함수 확인
SELECT 
  proname as function_name,
  prosrc as function_body
FROM pg_proc
WHERE proname = 'is_admin';

-- 3. 현재 사용자가 admin_users 테이블에 있는지 확인
SELECT 
  auth.uid() as current_user_id,
  EXISTS (
    SELECT 1 FROM admin_users
    WHERE auth_user_id = auth.uid()
  ) as is_admin;

-- 4. admin_users 테이블의 모든 정책 삭제
DROP POLICY IF EXISTS "관리자는 admin_users 조회 가능" ON admin_users;
DROP POLICY IF EXISTS "관리자는 admin_users 수정 가능" ON admin_users;
DROP POLICY IF EXISTS "관리자는 admin_users 삭제 가능" ON admin_users;
DROP POLICY IF EXISTS "관리자는 admin_users 생성 가능" ON admin_users;

-- 5. 새로운 정책 생성 (영문 이름으로)
CREATE POLICY "admin_users_select_policy"
  ON admin_users FOR SELECT
  TO authenticated
  USING (is_admin());

CREATE POLICY "admin_users_update_policy"
  ON admin_users FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "admin_users_delete_policy"
  ON admin_users FOR DELETE
  TO authenticated
  USING (is_admin());

CREATE POLICY "admin_users_insert_policy"
  ON admin_users FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

-- 6. 정책이 제대로 생성되었는지 확인
SELECT 
  policyname,
  cmd,
  roles,
  qual
FROM pg_policies
WHERE tablename = 'admin_users';

