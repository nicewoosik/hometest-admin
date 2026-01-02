-- 임시 해결책: RLS 완전 우회 (테스트용)

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
-- Step 2: 임시 정책 생성 (모든 인증된 사용자가 조회 가능)
-- ============================================

CREATE POLICY "temp_admin_users_select"
  ON admin_users FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "temp_admin_users_update"
  ON admin_users FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "temp_admin_users_delete"
  ON admin_users FOR DELETE
  TO authenticated
  USING (true);

CREATE POLICY "temp_admin_users_insert"
  ON admin_users FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- ============================================
-- Step 3: 테스트
-- ============================================

SELECT COUNT(*) as admin_users_count FROM admin_users;
SELECT * FROM admin_users;

