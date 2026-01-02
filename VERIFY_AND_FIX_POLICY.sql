-- 정책 확인 및 재설정
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- ============================================
-- 1단계: 현재 정책 상태 확인
-- ============================================
SELECT 
  '현재 INSERT 정책' as check_type,
  policyname,
  cmd,
  roles,
  with_check,
  permissive
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
  AND cmd = 'INSERT';

-- ============================================
-- 2단계: RLS 활성화 상태 확인
-- ============================================
SELECT 
  'RLS 상태' as check_type,
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename = 'inquiries';

-- ============================================
-- 3단계: 모든 INSERT 정책 삭제
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
          AND cmd = 'INSERT'
    ) 
    LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON inquiries';
        RAISE NOTICE '삭제됨: %', r.policyname;
    END LOOP;
END $$;

-- ============================================
-- 4단계: RLS 재설정 (캐시 클리어)
-- ============================================
ALTER TABLE inquiries DISABLE ROW LEVEL SECURITY;
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 5단계: 가장 확실한 INSERT 정책 생성
-- ============================================
-- public 역할로 설정하고 permissive로 설정
CREATE POLICY "insert_inquiries_all"
  ON inquiries
  FOR INSERT
  TO public
  WITH CHECK (true);

-- ============================================
-- 6단계: 최종 확인
-- ============================================
SELECT 
  '=== 최종 INSERT 정책 확인 ===' as check_type,
  policyname,
  cmd,
  roles,
  with_check,
  permissive
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
  AND cmd = 'INSERT';

SELECT 
  '=== RLS 활성화 확인 ===' as check_type,
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename = 'inquiries';

-- ============================================
-- 예상 결과:
-- INSERT 정책: insert_inquiries_all
-- roles: {public}
-- with_check: true
-- permissive: PERMISSIVE
-- RLS 활성화: true
-- ============================================

