-- 채용공고 테이블 RLS 정책 확인 및 수정

-- ============================================
-- Step 1: 현재 RLS 정책 확인
-- ============================================
SELECT 
  policyname,
  cmd,
  roles,
  qual,
  with_check
FROM pg_policies
WHERE tablename = 'job_postings'
ORDER BY cmd, policyname;

-- ============================================
-- Step 2: 모든 정책 삭제
-- ============================================

DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN 
    SELECT policyname 
    FROM pg_policies 
    WHERE tablename = 'job_postings'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON job_postings', r.policyname);
  END LOOP;
END $$;

-- ============================================
-- Step 3: 새로운 정책 생성 (관리자만 조회 가능)
-- ============================================

-- SELECT 정책: 관리자는 모든 job_postings 조회 가능
CREATE POLICY "job_postings_select_admin"
  ON job_postings FOR SELECT
  TO authenticated
  USING (
    -- 관리자인 경우 모든 레코드 조회 가능
    COALESCE(is_admin(), FALSE) = TRUE
  );

-- UPDATE 정책: 관리자는 모든 job_postings 수정 가능
CREATE POLICY "job_postings_update_admin"
  ON job_postings FOR UPDATE
  TO authenticated
  USING (COALESCE(is_admin(), FALSE) = TRUE)
  WITH CHECK (COALESCE(is_admin(), FALSE) = TRUE);

-- DELETE 정책: 관리자는 모든 job_postings 삭제 가능
CREATE POLICY "job_postings_delete_admin"
  ON job_postings FOR DELETE
  TO authenticated
  USING (COALESCE(is_admin(), FALSE) = TRUE);

-- INSERT 정책: 관리자는 새 공고 생성 가능
CREATE POLICY "job_postings_insert_admin"
  ON job_postings FOR INSERT
  TO authenticated
  WITH CHECK (COALESCE(is_admin(), FALSE) = TRUE);

-- SELECT 정책: 익명 사용자는 공개된 공고만 조회 가능 (홈페이지용)
CREATE POLICY "job_postings_select_public"
  ON job_postings FOR SELECT
  TO anon
  USING (status = 'open');

-- ============================================
-- Step 4: 테스트
-- ============================================

-- 관리자로 데이터 조회 테스트
SELECT COUNT(*) as job_postings_count FROM job_postings;
SELECT 
  id,
  title,
  status,
  department,
  target_audience,
  location,
  created_at
FROM job_postings
ORDER BY created_at DESC
LIMIT 5;

-- 정책 확인
SELECT 
  policyname,
  cmd,
  roles
FROM pg_policies
WHERE tablename = 'job_postings';

