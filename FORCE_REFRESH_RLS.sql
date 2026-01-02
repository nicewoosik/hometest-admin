-- RLS 강제 새로고침 (캐시 클리어)
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- ============================================
-- 1. 모든 정책 삭제
-- ============================================
DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT policyname 
        FROM pg_policies 
        WHERE schemaname = 'public' 
          AND tablename = 'inquiries'
    ) 
    LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON inquiries';
    END LOOP;
END $$;

-- ============================================
-- 2. RLS 완전 재설정
-- ============================================
ALTER TABLE inquiries DISABLE ROW LEVEL SECURITY;
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 3. INSERT 정책 재생성 (가장 단순하게)
-- ============================================
CREATE POLICY "insert_policy_simple"
  ON inquiries
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- ============================================
-- 4. 다른 정책들도 재생성
-- ============================================
CREATE POLICY "select_policy_admin"
  ON inquiries
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "update_policy_admin"
  ON inquiries
  FOR UPDATE
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

CREATE POLICY "delete_policy_admin"
  ON inquiries
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE auth_user_id = auth.uid()
    )
  );

-- ============================================
-- 5. 확인
-- ============================================
SELECT 
  policyname,
  cmd,
  roles,
  with_check
FROM pg_policies
WHERE tablename = 'inquiries'
ORDER BY cmd;

