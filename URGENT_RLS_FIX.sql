-- 긴급 RLS 수정 (즉시 실행)
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- 모든 INSERT 정책 삭제
DO $$ 
DECLARE r RECORD;
BEGIN
    FOR r IN (SELECT policyname FROM pg_policies WHERE schemaname = 'public' AND tablename = 'inquiries' AND cmd = 'INSERT') 
    LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON inquiries';
    END LOOP;
END $$;

-- RLS 재설정
ALTER TABLE inquiries DISABLE ROW LEVEL SECURITY;
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- public 역할로 INSERT 정책 생성 (가장 확실함)
CREATE POLICY "insert_public"
  ON inquiries FOR INSERT
  TO public
  WITH CHECK (true);

-- 확인
SELECT policyname, cmd, roles, with_check
FROM pg_policies
WHERE tablename = 'inquiries' AND cmd = 'INSERT';

