-- RLS 완전 비활성화 (테스트용)
-- ⚠️ 주의: 보안이 약해지므로 테스트 후 반드시 다시 활성화하세요!
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- ============================================
-- 1단계: 모든 정책 삭제
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
    END LOOP;
END $$;

-- ============================================
-- 2단계: RLS 완전 비활성화
-- ============================================
ALTER TABLE inquiries DISABLE ROW LEVEL SECURITY;

-- ============================================
-- 3단계: 확인
-- ============================================
SELECT 
  'RLS 상태' as check_type,
  tablename,
  rowsecurity as rls_enabled,
  CASE 
    WHEN rowsecurity THEN 'RLS 활성화됨'
    ELSE 'RLS 비활성화됨 ✅'
  END as status
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename = 'inquiries';

-- ============================================
-- 예상 결과:
-- rls_enabled: false
-- status: RLS 비활성화됨 ✅
-- ============================================

-- ============================================
-- 테스트 후 다시 활성화하려면:
-- ============================================
-- ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;
-- CREATE POLICY "insert_public_all"
--   ON inquiries FOR INSERT
--   TO public
--   WITH CHECK (true);

