-- RLS 재활성화 및 보안 정책 설정
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- ============================================
-- 1단계: RLS 활성화 확인
-- ============================================
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 2단계: 기존 정책 삭제 (있는 경우)
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
-- 3단계: 보안 정책 생성
-- ============================================

-- INSERT 정책: anon과 authenticated 모두 허용 (홈페이지에서 문의 제출 가능)
CREATE POLICY "allow_insert_inquiries"
  ON inquiries
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- SELECT 정책: 관리자만 조회 가능
CREATE POLICY "allow_select_inquiries_admin"
  ON inquiries
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE auth_user_id = auth.uid()
    )
  );

-- UPDATE 정책: 관리자만 수정 가능
CREATE POLICY "allow_update_inquiries_admin"
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

-- DELETE 정책: 관리자만 삭제 가능
CREATE POLICY "allow_delete_inquiries_admin"
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
-- 4단계: 정책 확인
-- ============================================
SELECT 
  policyname,
  cmd,
  roles,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
ORDER BY cmd, policyname;

-- ============================================
-- 5단계: RLS 활성화 확인
-- ============================================
SELECT 
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename = 'inquiries';

