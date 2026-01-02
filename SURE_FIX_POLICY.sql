-- 확실한 정책 수정 (단계별 실행)
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- ============================================
-- Step 1: 모든 정책 삭제
-- ============================================
DO $$ 
DECLARE r RECORD;
BEGIN
    FOR r IN (SELECT policyname FROM pg_policies WHERE schemaname = 'public' AND tablename = 'inquiries') 
    LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON inquiries';
    END LOOP;
END $$;

-- ============================================
-- Step 2: 삭제 확인 (0개여야 함)
-- ============================================
SELECT COUNT(*) as remaining_policies
FROM pg_policies
WHERE schemaname = 'public' AND tablename = 'inquiries';

-- ============================================
-- Step 3: RLS 재설정
-- ============================================
ALTER TABLE inquiries DISABLE ROW LEVEL SECURITY;
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- ============================================
-- Step 4: 가장 단순한 INSERT 정책 생성
-- ============================================
CREATE POLICY "insert_all"
  ON inquiries
  FOR INSERT
  TO public;

-- ============================================
-- Step 5: 생성 확인
-- ============================================
SELECT 
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
-- policyname: insert_all
-- cmd: INSERT
-- roles: {public}
-- with_check: null
-- qual: null

