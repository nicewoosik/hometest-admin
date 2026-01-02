-- 즉시 실행할 SQL
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- 1. 모든 INSERT 정책 삭제
DROP POLICY IF EXISTS "insert_inquiries_only" ON inquiries;
DROP POLICY IF EXISTS "insert_inquiries_public_all" ON inquiries;
DROP POLICY IF EXISTS "insert_inquiries_allow_all" ON inquiries;
DROP POLICY IF EXISTS "insert_allow_all" ON inquiries;
DROP POLICY IF EXISTS "insert_public" ON inquiries;

-- 2. 모든 정책 삭제 (혹시 모를 다른 정책도)
DO $$ 
DECLARE r RECORD;
BEGIN
    FOR r IN (SELECT policyname FROM pg_policies WHERE schemaname = 'public' AND tablename = 'inquiries' AND cmd = 'INSERT') 
    LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON inquiries';
    END LOOP;
END $$;

-- 3. RLS 재설정
ALTER TABLE inquiries DISABLE ROW LEVEL SECURITY;
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- 4. public 역할로 INSERT 정책 생성 (가장 확실함)
CREATE POLICY "insert_public_all"
  ON inquiries
  FOR INSERT
  TO public
  WITH CHECK (true);

-- 5. 확인
SELECT 
  policyname,
  cmd,
  roles,
  with_check
FROM pg_policies
WHERE tablename = 'inquiries' AND cmd = 'INSERT';

-- 예상 결과:
-- policyname: insert_public_all
-- cmd: INSERT
-- roles: {public}
-- with_check: true

