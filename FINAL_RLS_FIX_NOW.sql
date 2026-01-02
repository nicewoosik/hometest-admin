-- 최종 RLS 수정 (100% 확실한 방법)
-- Supabase Dashboard → SQL Editor에서 실행하세요
-- ⚠️ 이 쿼리는 모든 정책을 삭제하고 가장 단순한 정책만 생성합니다

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
-- public 역할로 설정하여 모든 요청 허용 (가장 확실함)
CREATE POLICY "insert_inquiries_public_all"
  ON inquiries
  FOR INSERT
  TO public
  WITH CHECK (true);

-- ============================================
-- 4단계: 다른 정책들도 생성
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

-- 예상 결과:
-- 정책이 1개만 있어야 함
-- policyname: insert_inquiries_public_all
-- cmd: INSERT
-- roles: {public}
-- with_check: true

