-- 모든 INSERT 정책 삭제 후 하나만 생성
-- Supabase Dashboard → SQL Editor에서 실행하세요
-- ⚠️ 이 쿼리를 실행하면 INSERT 정책이 1개만 남습니다

-- ============================================
-- 1단계: 모든 INSERT 정책 명시적으로 삭제
-- ============================================
DROP POLICY IF EXISTS "insert_inquiries_allow_all" ON inquiries;
DROP POLICY IF EXISTS "insert_allow_all" ON inquiries;
DROP POLICY IF EXISTS "insert_policy_simple" ON inquiries;
DROP POLICY IF EXISTS "insert_inquiries_all" ON inquiries;
DROP POLICY IF EXISTS "insert_inquiries_public" ON inquiries;
DROP POLICY IF EXISTS "allow_insert_inquiries" ON inquiries;
DROP POLICY IF EXISTS "allow_insert_inquiries_for_all" ON inquiries;
DROP POLICY IF EXISTS "anon_and_authenticated_can_insert_inquiries" ON inquiries;
DROP POLICY IF EXISTS "insert_policy" ON inquiries;
DROP POLICY IF EXISTS "insert_inquiries_anon_authenticated" ON inquiries;

-- 혹시 모를 다른 정책도 모두 삭제
DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT policyname 
        FROM pg_policies 
        WHERE schemaname = 'public' 
          AND tablename = 'inquiries'
          AND cmd = 'INSERT'
    ) 
    LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON inquiries';
        RAISE NOTICE '삭제됨: %', r.policyname;
    END LOOP;
END $$;

-- ============================================
-- 2단계: 삭제 확인 (0개여야 함)
-- ============================================
SELECT 
  '삭제 후 남은 INSERT 정책 수' as check_type,
  COUNT(*) as count
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
  AND cmd = 'INSERT';

-- ============================================
-- 3단계: RLS 재설정
-- ============================================
ALTER TABLE inquiries DISABLE ROW LEVEL SECURITY;
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 4단계: 하나의 정책만 생성
-- ============================================
CREATE POLICY "insert_inquiries_only"
  ON inquiries
  FOR INSERT
  TO public
  WITH CHECK (true);

-- ============================================
-- 5단계: 최종 확인 (1개만 있어야 함)
-- ============================================
SELECT 
  '=== 최종 INSERT 정책 확인 ===' as check_type,
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
-- policyname: insert_inquiries_only
-- cmd: INSERT
-- roles: {public}
-- with_check: true

