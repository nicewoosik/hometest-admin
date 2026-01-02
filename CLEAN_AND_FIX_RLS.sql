-- RLS INSERT 정책 완전 정리 및 재생성
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- ============================================
-- 1단계: 모든 기존 INSERT 정책 명시적으로 삭제
-- ============================================
DROP POLICY IF EXISTS "anon_insert_inquiries_policy" ON inquiries;
DROP POLICY IF EXISTS "anon_insert_inquiries" ON inquiries;
DROP POLICY IF EXISTS "모든 사용자는 inquiries 생성 가능" ON inquiries;
DROP POLICY IF EXISTS "insert_inquiries_anon_authenticated" ON inquiries;
DROP POLICY IF EXISTS "anon_and_authenticated_can_insert_inquiries" ON inquiries;
DROP POLICY IF EXISTS "allow_insert_inquiries_for_all" ON inquiries;
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
    END LOOP;
END $$;

-- ============================================
-- 2단계: 삭제 확인
-- ============================================
SELECT 
  '삭제 후 남은 INSERT 정책 수' as check_type,
  COUNT(*) as count
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
  AND cmd = 'INSERT';

-- ============================================
-- 3단계: RLS 활성화 확인
-- ============================================
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 4단계: 새로운 INSERT 정책 생성 (하나만!)
-- ============================================
CREATE POLICY "insert_inquiries_all"
  ON inquiries
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- ============================================
-- 5단계: 생성 확인
-- ============================================
SELECT 
  policyname,
  cmd,
  roles,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
  AND cmd = 'INSERT'
ORDER BY policyname;

-- ============================================
-- 예상 결과:
-- policyname: insert_inquiries_all
-- cmd: INSERT
-- roles: {anon,authenticated} 또는 {authenticated,anon}
-- with_check: true
-- ============================================

