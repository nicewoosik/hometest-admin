-- 모든 정책 삭제 후 재생성 (완전 초기화)

-- ============================================
-- Step 1: admin_users 테이블의 모든 정책 확인
-- ============================================
SELECT 
  policyname,
  cmd,
  roles
FROM pg_policies
WHERE tablename = 'admin_users';

-- ============================================
-- Step 2: admin_users 테이블의 모든 정책 삭제
-- ============================================

-- 모든 가능한 정책 이름으로 삭제 시도
DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN 
    SELECT policyname 
    FROM pg_policies 
    WHERE tablename = 'admin_users'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON admin_users', r.policyname);
  END LOOP;
END $$;

-- ============================================
-- Step 3: is_admin() 함수 업데이트
-- ============================================

CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN 
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RETURN FALSE;
  END IF;
  
  RETURN EXISTS (
    SELECT 1 
    FROM admin_users
    WHERE auth_user_id = auth.uid()
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END;
$$;

-- ============================================
-- Step 4: 새로운 정책 생성
-- ============================================

CREATE POLICY "admin_users_select"
  ON admin_users FOR SELECT
  TO authenticated
  USING (COALESCE(is_admin(), FALSE) = TRUE);

CREATE POLICY "admin_users_update"
  ON admin_users FOR UPDATE
  TO authenticated
  USING (COALESCE(is_admin(), FALSE) = TRUE)
  WITH CHECK (COALESCE(is_admin(), FALSE) = TRUE);

CREATE POLICY "admin_users_delete"
  ON admin_users FOR DELETE
  TO authenticated
  USING (COALESCE(is_admin(), FALSE) = TRUE);

CREATE POLICY "admin_users_insert"
  ON admin_users FOR INSERT
  TO authenticated
  WITH CHECK (COALESCE(is_admin(), FALSE) = TRUE);

-- ============================================
-- Step 5: 현재 사용자 확인 및 auth_user_id 업데이트
-- ============================================
SELECT 
  auth.uid() as current_user_id,
  auth.email() as current_user_email;

UPDATE admin_users 
SET auth_user_id = auth.uid()
WHERE email = 'admin@ecstel.co.kr' AND (auth_user_id IS NULL OR auth_user_id != auth.uid());

-- ============================================
-- Step 6: 테스트
-- ============================================

SELECT 
  auth.uid() as current_user_id,
  is_admin() as is_admin_result;

SELECT COUNT(*) as admin_users_count FROM admin_users;
SELECT * FROM admin_users LIMIT 5;

