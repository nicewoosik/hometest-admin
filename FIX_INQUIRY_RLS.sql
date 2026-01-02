-- 간편문의 INSERT 권한 수정
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- 기존 정책 삭제 (있는 경우)
DROP POLICY IF EXISTS "모든 사용자는 inquiries 생성 가능" ON inquiries;

-- 익명 사용자(anon)도 INSERT 가능하도록 정책 재생성
CREATE POLICY "모든 사용자는 inquiries 생성 가능"
  ON inquiries FOR INSERT
  TO authenticated, anon
  WITH CHECK (true);

-- 확인: 정책이 제대로 생성되었는지 확인
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE tablename = 'inquiries';


