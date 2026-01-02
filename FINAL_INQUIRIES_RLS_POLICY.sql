-- 최종 inquiries 테이블 RLS 정책 (관리자만 조회 가능)

-- ============================================
-- Step 1: inquiries 테이블의 모든 정책 삭제
-- ============================================

DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN 
    SELECT policyname 
    FROM pg_policies 
    WHERE tablename = 'inquiries'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON inquiries', r.policyname);
  END LOOP;
END $$;

-- ============================================
-- Step 2: 최종 정책 생성 (관리자만 조회 가능)
-- ============================================

-- SELECT 정책: 관리자는 모든 inquiries 조회 가능
CREATE POLICY "inquiries_select_admin"
  ON inquiries FOR SELECT
  TO authenticated
  USING (
    -- 관리자인 경우 모든 레코드 조회 가능
    COALESCE(is_admin(), FALSE) = TRUE
  );

-- UPDATE 정책: 관리자는 모든 inquiries 수정 가능
CREATE POLICY "inquiries_update_admin"
  ON inquiries FOR UPDATE
  TO authenticated
  USING (COALESCE(is_admin(), FALSE) = TRUE)
  WITH CHECK (COALESCE(is_admin(), FALSE) = TRUE);

-- DELETE 정책: 관리자는 모든 inquiries 삭제 가능
CREATE POLICY "inquiries_delete_admin"
  ON inquiries FOR DELETE
  TO authenticated
  USING (COALESCE(is_admin(), FALSE) = TRUE);

-- INSERT 정책: 모든 사용자(익명 포함)가 문의 생성 가능
CREATE POLICY "inquiries_insert_all"
  ON inquiries FOR INSERT
  TO authenticated, anon
  WITH CHECK (true);

-- ============================================
-- Step 3: 테스트 및 확인
-- ============================================

-- 정책 확인
SELECT 
  policyname,
  cmd,
  roles,
  qual
FROM pg_policies
WHERE tablename = 'inquiries';

-- 관리자로 데이터 조회 테스트
SELECT COUNT(*) as inquiries_count FROM inquiries;
SELECT * FROM inquiries ORDER BY created_at DESC LIMIT 5;

-- is_admin() 함수 테스트
SELECT 
  auth.uid() as current_user_id,
  is_admin() as is_admin_result;

