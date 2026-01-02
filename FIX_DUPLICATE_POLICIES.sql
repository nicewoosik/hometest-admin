-- 중복된 INSERT 정책 정리
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- ============================================
-- 문제: INSERT 정책이 2개 존재함
-- 1. insert_inquiries_allow_all (anon, authenticated)
-- 2. insert_allow_all (public)
-- ============================================

-- ============================================
-- 해결: 하나만 남기고 나머지 삭제
-- ============================================

-- 1. 기존 정책 모두 삭제
DROP POLICY IF EXISTS "insert_inquiries_allow_all" ON inquiries;
DROP POLICY IF EXISTS "insert_allow_all" ON inquiries;
DROP POLICY IF EXISTS "insert_policy_simple" ON inquiries;
DROP POLICY IF EXISTS "insert_inquiries_all" ON inquiries;
DROP POLICY IF EXISTS "allow_insert_inquiries" ON inquiries;
DROP POLICY IF EXISTS "anon_and_authenticated_can_insert_inquiries" ON inquiries;

-- 2. RLS 재설정 (캐시 클리어)
ALTER TABLE inquiries DISABLE ROW LEVEL SECURITY;
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- 3. 하나의 정책만 생성 (public으로 설정하여 모든 요청 허용)
CREATE POLICY "insert_inquiries_public"
  ON inquiries
  FOR INSERT
  TO public
  WITH CHECK (true);

-- ============================================
-- 4. 확인 (정책이 1개만 있어야 함)
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

-- 예상 결과: 정책이 1개만 있어야 함
-- policyname: insert_inquiries_public
-- cmd: INSERT
-- roles: {public}
-- with_check: true

