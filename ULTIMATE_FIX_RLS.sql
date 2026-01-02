-- 최종 RLS INSERT 정책 수정 (100% 확실한 방법)
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- ============================================
-- 1단계: 모든 정책 완전 삭제
-- ============================================
-- inquiries 테이블의 모든 정책 삭제
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
        RAISE NOTICE 'Deleted policy: %', r.policyname;
    END LOOP;
END $$;

-- ============================================
-- 2단계: RLS 일시 비활성화 후 재활성화 (캐시 클리어)
-- ============================================
ALTER TABLE inquiries DISABLE ROW LEVEL SECURITY;
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 3단계: INSERT 정책 생성 (가장 단순하게)
-- ============================================
CREATE POLICY "allow_all_insert_inquiries"
  ON inquiries
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- ============================================
-- 4단계: SELECT 정책 (관리자만)
-- ============================================
CREATE POLICY "allow_admin_select_inquiries"
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
CREATE POLICY "allow_admin_update_inquiries"
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
CREATE POLICY "allow_admin_delete_inquiries"
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
SELECT 
  '=== INSERT 정책 확인 ===' as section,
  policyname,
  cmd,
  roles,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
  AND cmd = 'INSERT';

SELECT 
  '=== 모든 정책 확인 ===' as section,
  policyname,
  cmd,
  roles
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
ORDER BY cmd, policyname;

-- ============================================
-- 8단계: 테이블 구조 확인 (문제 진단용)
-- ============================================
SELECT 
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'inquiries'
ORDER BY ordinal_position;

