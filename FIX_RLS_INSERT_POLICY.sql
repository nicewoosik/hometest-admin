-- RLS INSERT 정책 수정 (즉시 실행)
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- 1. 기존 INSERT 정책 모두 삭제 (한글 이름 포함)
DROP POLICY IF EXISTS "모든 사용자는 inquiries 생성 가능" ON inquiries;
DROP POLICY IF EXISTS "anon_and_authenticated_can_insert_inquiries" ON inquiries;
DROP POLICY IF EXISTS "모든 사용자는 job_applications 생성 가능" ON job_applications;
DROP POLICY IF EXISTS "anon_and_authenticated_can_insert_job_applications" ON job_applications;

-- 2. inquiries 테이블 INSERT 정책 재생성 (명확하게)
-- anon과 authenticated 모두 INSERT 가능하도록 설정
CREATE POLICY "anon_and_authenticated_can_insert_inquiries"
  ON inquiries FOR INSERT
  TO authenticated, anon
  WITH CHECK (true);

-- 3. job_applications 테이블 INSERT 정책 재생성
CREATE POLICY "anon_and_authenticated_can_insert_job_applications"
  ON job_applications FOR INSERT
  TO authenticated, anon
  WITH CHECK (true);

-- 4. 정책이 제대로 생성되었는지 확인
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
WHERE schemaname = 'public'
  AND tablename IN ('inquiries', 'job_applications')
  AND cmd = 'INSERT'
ORDER BY tablename, policyname;

-- 5. RLS가 활성화되어 있는지 확인
SELECT 
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN ('inquiries', 'job_applications')
ORDER BY tablename;

-- 6. 모든 inquiries 정책 확인 (문제 진단용)
SELECT 
  tablename,
  policyname,
  cmd,
  roles,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
ORDER BY cmd, policyname;

