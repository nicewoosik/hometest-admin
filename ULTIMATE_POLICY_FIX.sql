-- 최종 정책 수정 (100% 확실한 방법)
-- Supabase Dashboard → SQL Editor에서 실행하세요

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
-- public 역할, WITH CHECK 없이 (가장 단순함)
CREATE POLICY "allow_insert"
  ON inquiries
  FOR INSERT
  TO public;

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
  with_check,
  qual
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
  AND cmd = 'INSERT';

-- 예상 결과:
-- policyname: allow_insert
-- cmd: INSERT
-- roles: {public}
-- with_check: (null 또는 없음)
-- qual: (null 또는 없음)

