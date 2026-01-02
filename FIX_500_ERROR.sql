-- 500 에러 해결: is_admin() 함수 및 RLS 정책 수정

-- ============================================
-- Step 1: 현재 is_admin() 함수 확인
-- ============================================
SELECT 
  proname as function_name,
  prosrc as function_body
FROM pg_proc
WHERE proname = 'is_admin';

-- ============================================
-- Step 2: is_admin() 함수 재생성 (더 안전하게)
-- ============================================

-- 기존 함수를 CREATE OR REPLACE로 업데이트 (의존성 유지)
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN 
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- auth.uid()가 NULL이면 false 반환
  IF auth.uid() IS NULL THEN
    RETURN FALSE;
  END IF;
  
  -- admin_users 테이블에서 확인 (RLS 우회를 위해 SECURITY DEFINER 사용)
  RETURN EXISTS (
    SELECT 1 
    FROM admin_users
    WHERE auth_user_id = auth.uid()
  );
EXCEPTION
  WHEN OTHERS THEN
    -- 에러 발생 시 false 반환
    RETURN FALSE;
END;
$$;

-- ============================================
-- Step 3: admin_users 테이블의 모든 RLS 정책 삭제
-- ============================================
DROP POLICY IF EXISTS "admin_users_select_all" ON admin_users;
DROP POLICY IF EXISTS "admin_users_select_policy" ON admin_users;
DROP POLICY IF EXISTS "admin_users_update_policy" ON admin_users;
DROP POLICY IF EXISTS "admin_users_delete_policy" ON admin_users;
DROP POLICY IF EXISTS "admin_users_insert_policy" ON admin_users;
DROP POLICY IF EXISTS "관리자는 admin_users 조회 가능" ON admin_users;
DROP POLICY IF EXISTS "관리자는 admin_users 수정 가능" ON admin_users;
DROP POLICY IF EXISTS "관리자는 admin_users 삭제 가능" ON admin_users;
DROP POLICY IF EXISTS "관리자는 admin_users 생성 가능" ON admin_users;
DROP POLICY IF EXISTS "temp_admin_users_select" ON admin_users;

-- ============================================
-- Step 4: 간단하고 안전한 RLS 정책 생성
-- ============================================

-- SELECT 정책: 관리자는 모든 admin_users 조회 가능
CREATE POLICY "admin_users_select"
  ON admin_users FOR SELECT
  TO authenticated
  USING (
    -- is_admin() 함수 사용 (에러 처리 포함)
    COALESCE(is_admin(), FALSE) = TRUE
  );

-- UPDATE 정책
CREATE POLICY "admin_users_update"
  ON admin_users FOR UPDATE
  TO authenticated
  USING (COALESCE(is_admin(), FALSE) = TRUE)
  WITH CHECK (COALESCE(is_admin(), FALSE) = TRUE);

-- DELETE 정책
CREATE POLICY "admin_users_delete"
  ON admin_users FOR DELETE
  TO authenticated
  USING (COALESCE(is_admin(), FALSE) = TRUE);

-- INSERT 정책
CREATE POLICY "admin_users_insert"
  ON admin_users FOR INSERT
  TO authenticated
  WITH CHECK (COALESCE(is_admin(), FALSE) = TRUE);

-- ============================================
-- Step 5: 현재 사용자 확인 및 auth_user_id 업데이트
-- ============================================
SELECT 
  auth.uid() as current_user_id,
  auth.email() as current_user_email;

-- admin@ecstel.co.kr의 auth_user_id 업데이트
UPDATE admin_users 
SET auth_user_id = auth.uid()
WHERE email = 'admin@ecstel.co.kr' AND (auth_user_id IS NULL OR auth_user_id != auth.uid());

-- ============================================
-- Step 6: 테스트
-- ============================================

-- is_admin() 함수 테스트
SELECT 
  auth.uid() as current_user_id,
  is_admin() as is_admin_result;

-- admin_users 조회 테스트
SELECT COUNT(*) as admin_users_count FROM admin_users;
SELECT * FROM admin_users LIMIT 5;

