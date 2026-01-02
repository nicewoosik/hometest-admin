-- 최종 RLS 수정 (100% 확실한 방법)
-- Supabase Dashboard → SQL Editor에서 실행하세요
-- ⚠️ 이 파일을 실행하면 모든 정책이 삭제되고 새로 생성됩니다

-- ============================================
-- 1단계: 모든 정책 완전 삭제
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
        RAISE NOTICE 'Deleted: %', r.policyname;
    END LOOP;
END $$;

-- ============================================
-- 2단계: RLS 완전 재설정
-- ============================================
-- RLS 비활성화
ALTER TABLE inquiries DISABLE ROW LEVEL SECURITY;

-- 잠시 대기 (PostgreSQL이 변경사항을 적용하도록)
DO $$ BEGIN
    PERFORM pg_sleep(1);
END $$;

-- RLS 재활성화
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 3단계: INSERT 정책 생성 (가장 중요!)
-- ============================================
-- anon과 authenticated 모두 허용
CREATE POLICY "insert_inquiries_allow_all"
  ON inquiries
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- ============================================
-- 4단계: SELECT 정책 (관리자만)
-- ============================================
CREATE POLICY "select_inquiries_admin_only"
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
CREATE POLICY "update_inquiries_admin_only"
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
CREATE POLICY "delete_inquiries_admin_only"
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
-- 7단계: 최종 확인
-- ============================================
-- INSERT 정책 확인 (가장 중요!)
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

-- RLS 활성화 확인
SELECT 
  '=== RLS 활성화 확인 ===' as check_type,
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename = 'inquiries';

-- 모든 정책 확인
SELECT 
  '=== 모든 정책 확인 ===' as check_type,
  policyname,
  cmd,
  roles
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
ORDER BY cmd, policyname;

