-- RLS 완전 재설정 (100% 확실한 방법)
-- Supabase Dashboard → SQL Editor에서 실행하세요
-- ⚠️ 이 쿼리는 모든 정책을 삭제하고 새로 생성합니다

-- ============================================
-- 1단계: 모든 정책 완전 삭제
-- ============================================
DO $$ 
DECLARE
    r RECORD;
BEGIN
    -- inquiries 테이블의 모든 정책 삭제
    FOR r IN (
        SELECT policyname 
        FROM pg_policies 
        WHERE schemaname = 'public' 
          AND tablename = 'inquiries'
    ) 
    LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON inquiries';
        RAISE NOTICE '삭제됨: %', r.policyname;
    END LOOP;
END $$;

-- ============================================
-- 2단계: RLS 완전 재설정
-- ============================================
ALTER TABLE inquiries DISABLE ROW LEVEL SECURITY;
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 3단계: 가장 단순한 INSERT 정책 생성
-- ============================================
-- public 역할로 설정하여 모든 요청 허용
CREATE POLICY "allow_insert_public"
  ON inquiries
  FOR INSERT
  TO public
  WITH CHECK (true);

-- ============================================
-- 4단계: 다른 정책들도 생성
-- ============================================
CREATE POLICY "allow_select_admin"
  ON inquiries
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "allow_update_admin"
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

CREATE POLICY "allow_delete_admin"
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
-- 5단계: 확인
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

