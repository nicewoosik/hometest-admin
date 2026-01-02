-- 가장 간단한 RLS INSERT 정책 수정
-- 이 파일을 Supabase Dashboard → SQL Editor에서 실행하세요

-- 1. inquiries 테이블의 모든 정책 삭제
DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT policyname FROM pg_policies WHERE schemaname = 'public' AND tablename = 'inquiries') 
    LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON inquiries';
    END LOOP;
END $$;

-- 2. RLS 활성화 확인 및 활성화
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- 3. INSERT 정책 생성 (anon과 authenticated 모두 허용)
CREATE POLICY "insert_inquiries_anon_authenticated"
  ON inquiries
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- 4. SELECT 정책 생성 (관리자만)
CREATE POLICY "select_inquiries_admin"
  ON inquiries
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE auth_user_id = auth.uid()
    )
  );

-- 5. UPDATE 정책 생성 (관리자만)
CREATE POLICY "update_inquiries_admin"
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

-- 6. DELETE 정책 생성 (관리자만)
CREATE POLICY "delete_inquiries_admin"
  ON inquiries
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE auth_user_id = auth.uid()
    )
  );

-- 7. 생성된 정책 확인
SELECT 
  policyname,
  cmd as command,
  roles,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
ORDER BY cmd, policyname;

