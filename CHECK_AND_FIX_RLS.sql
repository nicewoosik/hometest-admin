-- RLS 정책 확인 및 수정 (단계별 실행)
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- ============================================
-- 1단계: 현재 정책 상태 확인
-- ============================================
SELECT 
  tablename,
  policyname,
  cmd,
  roles,
  with_check,
  qual
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
ORDER BY cmd, policyname;

-- ============================================
-- 2단계: RLS 활성화 확인
-- ============================================
SELECT 
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename = 'inquiries';

-- ============================================
-- 3단계: 모든 inquiries 정책 삭제 (깔끔하게 시작)
-- ============================================
DROP POLICY IF EXISTS "관리자는 모든 inquiries 조회 가능" ON inquiries;
DROP POLICY IF EXISTS "관리자는 inquiries 수정 가능" ON inquiries;
DROP POLICY IF EXISTS "관리자는 inquiries 삭제 가능" ON inquiries;
DROP POLICY IF EXISTS "모든 사용자는 inquiries 생성 가능" ON inquiries;
DROP POLICY IF EXISTS "anon_and_authenticated_can_insert_inquiries" ON inquiries;

-- ============================================
-- 4단계: is_admin() 함수 확인 및 생성
-- ============================================
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM admin_users
    WHERE auth_user_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 5단계: inquiries 테이블 RLS 정책 재생성
-- ============================================

-- INSERT 정책: anon과 authenticated 모두 허용 (가장 중요!)
CREATE POLICY "allow_insert_inquiries_for_all"
  ON inquiries FOR INSERT
  TO authenticated, anon
  WITH CHECK (true);

-- SELECT 정책: 관리자만 조회 가능
CREATE POLICY "allow_select_inquiries_for_admin"
  ON inquiries FOR SELECT
  TO authenticated
  USING (is_admin());

-- UPDATE 정책: 관리자만 수정 가능
CREATE POLICY "allow_update_inquiries_for_admin"
  ON inquiries FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- DELETE 정책: 관리자만 삭제 가능
CREATE POLICY "allow_delete_inquiries_for_admin"
  ON inquiries FOR DELETE
  TO authenticated
  USING (is_admin());

-- ============================================
-- 6단계: 정책 생성 확인
-- ============================================
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

-- ============================================
-- 7단계: 테스트 쿼리 (anon 역할로 INSERT 시도)
-- ============================================
-- 주의: 이 쿼리는 Supabase SQL Editor에서 직접 실행하면 
-- service_role로 실행되므로 성공할 수 있습니다.
-- 실제 테스트는 홈페이지에서 해야 합니다.

-- 테스트용 데이터 (실제로는 홈페이지에서 테스트)
-- INSERT INTO inquiries (name, email, content) 
-- VALUES ('테스트', 'test@test.com', '테스트 내용');

