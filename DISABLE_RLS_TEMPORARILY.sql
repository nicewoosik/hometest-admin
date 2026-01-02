-- RLS 임시 비활성화 (테스트용)
-- ⚠️ 주의: 보안이 약해지므로 테스트 후 반드시 다시 활성화하세요!
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- RLS 비활성화
ALTER TABLE inquiries DISABLE ROW LEVEL SECURITY;

-- 확인
SELECT 
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename = 'inquiries';

-- 예상 결과: rls_enabled = false

-- 테스트 후 다시 활성화하려면:
-- ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;
-- 그리고 정책을 다시 생성하세요

