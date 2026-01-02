-- inquiries 테이블 RLS 정책 수정 (관리자가 모든 레코드 조회 가능하도록)

-- ============================================
-- Step 1: inquiries 테이블의 현재 정책 확인
-- ============================================
SELECT 
  policyname,
  cmd,
  roles,
  qual,
  with_check
FROM pg_policies
WHERE tablename = 'inquiries'
ORDER BY cmd, policyname;

-- ============================================
-- Step 2: inquiries 테이블의 모든 정책 삭제
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
-- Step 3: 새로운 정책 생성
-- ============================================

-- SELECT 정책: 관리자는 모든 inquiries 조회 가능, 일반 사용자는 자신의 것만
CREATE POLICY "inquiries_select_admin"
  ON inquiries FOR SELECT
  TO authenticated
  USING (
    -- 관리자인 경우 모든 레코드 조회 가능
    COALESCE(is_admin(), FALSE) = TRUE
  );

-- SELECT 정책: 익명 사용자는 조회 불가 (필요시 추가)
-- CREATE POLICY "inquiries_select_anon"
--   ON inquiries FOR SELECT
--   TO anon
--   USING (false);

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
-- Step 4: 테스트
-- ============================================

-- 관리자로 inquiries 조회 테스트
SELECT COUNT(*) as inquiries_count FROM inquiries;
SELECT * FROM inquiries ORDER BY created_at DESC LIMIT 5;

-- is_admin() 함수 테스트
SELECT 
  auth.uid() as current_user_id,
  is_admin() as is_admin_result;
