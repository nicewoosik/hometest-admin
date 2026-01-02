-- 작동하던 정책으로 되돌리기

-- ============================================
-- Step 1: inquiries 테이블의 모든 정책 삭제
-- ============================================

DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN 
    SELECT policyname 
    FROM pg_policies 
    WHERE tablename = 'inquiries'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON inquiries', r.policyname);
  END LOOP;
END $$;

-- ============================================
-- Step 2: 작동하던 임시 정책 재생성
-- ============================================

CREATE POLICY "temp_inquiries_select"
  ON inquiries FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "temp_inquiries_update"
  ON inquiries FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "temp_inquiries_delete"
  ON inquiries FOR DELETE
  TO authenticated
  USING (true);

CREATE POLICY "temp_inquiries_insert"
  ON inquiries FOR INSERT
  TO authenticated, anon
  WITH CHECK (true);

-- ============================================
-- Step 3: admin_users 테이블도 확인
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
-- Step 4: 테스트
-- ============================================

SELECT COUNT(*) as inquiries_count FROM inquiries;
SELECT COUNT(*) as admin_users_count FROM admin_users;

