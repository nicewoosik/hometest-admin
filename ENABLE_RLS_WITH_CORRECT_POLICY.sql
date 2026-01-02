-- RLS 재활성화 및 올바른 정책 설정
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- ============================================
-- 1단계: RLS 재활성화
-- ============================================
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 2단계: 기존 정책 모두 삭제 (혹시 모를 정책)
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
-- 3단계: INSERT 정책 생성 (public으로 설정 - 가장 확실함)
-- ============================================
CREATE POLICY "insert_inquiries_public"
  ON inquiries
  FOR INSERT
  TO public
  WITH CHECK (true);

-- ============================================
-- 4단계: SELECT 정책 (관리자만)
-- ============================================
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

-- ============================================
-- 5단계: UPDATE 정책 (관리자만)
-- ============================================
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

-- ============================================
-- 6단계: DELETE 정책 (관리자만)
-- ============================================
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

-- ============================================
-- 7단계: 확인
-- ============================================
SELECT 
  '=== INSERT 정책 확인 ===' as check_type,
  policyname,
  cmd,
  roles,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
  AND cmd = 'INSERT';

SELECT 
  '=== RLS 활성화 확인 ===' as check_type,
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename = 'inquiries';

-- ============================================
-- 예상 결과:
-- INSERT 정책: insert_inquiries_public
-- roles: {public}
-- with_check: true
-- RLS 활성화: true
-- ============================================

