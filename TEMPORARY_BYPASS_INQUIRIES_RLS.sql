-- 임시 해결책: inquiries RLS 완전 우회 (테스트용)

-- ============================================
-- Step 1: inquiries 테이블의 모든 정책 삭제
-- ============================================

DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN 
    SELECT policyname 
    FROM pg_policies 
    WHERE tablename = 'inquiries'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON inquiries', r.policyname);
  END LOOP;
END $$;

-- ============================================
-- Step 2: 임시 정책 생성 (모든 인증된 사용자가 조회 가능)
-- ============================================

CREATE POLICY "temp_inquiries_select"
  ON inquiries FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "temp_inquiries_update"
  ON inquiries FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "temp_inquiries_delete"
  ON inquiries FOR DELETE
  TO authenticated
  USING (true);

CREATE POLICY "temp_inquiries_insert"
  ON inquiries FOR INSERT
  TO authenticated, anon
  WITH CHECK (true);

-- ============================================
-- Step 3: 테스트
-- ============================================

SELECT COUNT(*) as inquiries_count FROM inquiries;
SELECT * FROM inquiries ORDER BY created_at DESC LIMIT 5;

