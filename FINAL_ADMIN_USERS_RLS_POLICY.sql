-- 최종 admin_users 테이블 RLS 정책 (관리자만 조회 가능)

-- ============================================
-- Step 1: admin_users 테이블의 모든 정책 삭제
-- ============================================

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
-- Step 2: 최종 정책 생성 (관리자만 조회 가능)
-- ============================================

-- SELECT 정책: 관리자는 모든 admin_users 조회 가능
CREATE POLICY "admin_users_select"
  ON admin_users FOR SELECT
  TO authenticated
  USING (
    -- 관리자인 경우 모든 레코드 조회 가능
    COALESCE(is_admin(), FALSE) = TRUE
  );

-- UPDATE 정책: 관리자는 모든 admin_users 수정 가능
CREATE POLICY "admin_users_update"
  ON admin_users FOR UPDATE
  TO authenticated
  USING (COALESCE(is_admin(), FALSE) = TRUE)
  WITH CHECK (COALESCE(is_admin(), FALSE) = TRUE);

-- DELETE 정책: 관리자는 모든 admin_users 삭제 가능
CREATE POLICY "admin_users_delete"
  ON admin_users FOR DELETE
  TO authenticated
  USING (COALESCE(is_admin(), FALSE) = TRUE);

-- INSERT 정책: 관리자는 새 계정 생성 가능
CREATE POLICY "admin_users_insert"
  ON admin_users FOR INSERT
  TO authenticated
  WITH CHECK (COALESCE(is_admin(), FALSE) = TRUE);

-- ============================================
-- Step 3: 테스트 및 확인
-- ============================================

-- 정책 확인
SELECT 
  policyname,
  cmd,
  roles,
  qual
FROM pg_policies
WHERE tablename = 'admin_users';

-- 관리자로 데이터 조회 테스트
SELECT COUNT(*) as admin_users_count FROM admin_users;
SELECT * FROM admin_users LIMIT 5;

-- is_admin() 함수 테스트
SELECT 
  auth.uid() as current_user_id,
  is_admin() as is_admin_result;

