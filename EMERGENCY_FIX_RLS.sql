-- 긴급 RLS 수정 (가장 확실한 방법)
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- ============================================
-- 방법 1: RLS를 완전히 비활성화했다가 재활성화
-- ============================================

-- 1. 모든 정책 삭제
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

-- 2. RLS 완전히 비활성화
ALTER TABLE inquiries DISABLE ROW LEVEL SECURITY;

-- 3. 잠시 대기 후 RLS 재활성화
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- 4. 가장 단순한 INSERT 정책 생성
CREATE POLICY "insert_policy"
  ON inquiries
  FOR INSERT
  TO public
  WITH CHECK (true);

-- 5. SELECT 정책 (관리자만)
CREATE POLICY "select_policy"
  ON inquiries
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE auth_user_id = auth.uid()
    )
  );

-- 6. UPDATE 정책 (관리자만)
CREATE POLICY "update_policy"
  ON inquiries
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE auth_user_id = auth.uid()
    )
  );

-- 7. DELETE 정책 (관리자만)
CREATE POLICY "delete_policy"
  ON inquiries
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE auth_user_id = auth.uid()
    )
  );

-- 8. 확인
SELECT 
  policyname,
  cmd,
  roles,
  with_check
FROM pg_policies
WHERE tablename = 'inquiries'
ORDER BY cmd;

