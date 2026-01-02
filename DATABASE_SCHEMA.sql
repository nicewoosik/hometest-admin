-- ECSTEL 관리자 페이지 데이터베이스 스키마
-- Supabase Dashboard → SQL Editor에서 실행하세요

-- 1. 관리자 계정 테이블 (Supabase Auth와 연동)
-- 참고: 실제 인증은 Supabase Auth를 사용하므로, 이 테이블은 추가 정보 저장용
CREATE TABLE IF NOT EXISTS admin_users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  role TEXT DEFAULT 'manager' CHECK (role IN ('admin', 'manager')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. 간편문의 테이블
CREATE TABLE IF NOT EXISTS inquiries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  company TEXT,
  email TEXT NOT NULL,
  phone TEXT,
  content TEXT NOT NULL,
  status TEXT DEFAULT 'new' CHECK (status IN ('new', 'processing', 'completed')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 채용공고 테이블
CREATE TABLE IF NOT EXISTS job_postings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  requirements TEXT,
  deadline DATE,
  status TEXT DEFAULT 'open' CHECK (status IN ('open', 'closed')),
  attachment_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. 채용 접수 테이블
CREATE TABLE IF NOT EXISTS job_applications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_posting_id UUID REFERENCES job_postings(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  resume_url TEXT,
  status TEXT DEFAULT 'applied' CHECK (status IN ('applied', 'reviewing', 'interview', 'accepted', 'rejected')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_inquiries_status ON inquiries(status);
CREATE INDEX IF NOT EXISTS idx_inquiries_created_at ON inquiries(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_job_postings_status ON job_postings(status);
CREATE INDEX IF NOT EXISTS idx_job_applications_job_posting_id ON job_applications(job_posting_id);
CREATE INDEX IF NOT EXISTS idx_job_applications_status ON job_applications(status);

-- RLS (Row Level Security) 설정
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_postings ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_applications ENABLE ROW LEVEL SECURITY;

-- 기존 정책 삭제 (있는 경우)
DROP POLICY IF EXISTS "관리자는 모든 inquiries 조회 가능" ON inquiries;
DROP POLICY IF EXISTS "관리자는 inquiries 수정 가능" ON inquiries;
DROP POLICY IF EXISTS "관리자는 inquiries 삭제 가능" ON inquiries;
DROP POLICY IF EXISTS "모든 사용자는 inquiries 생성 가능" ON inquiries;
DROP POLICY IF EXISTS "anon_and_authenticated_can_insert_inquiries" ON inquiries;
DROP POLICY IF EXISTS "관리자는 모든 job_postings 조회 가능" ON job_postings;
DROP POLICY IF EXISTS "관리자는 job_postings 수정 가능" ON job_postings;
DROP POLICY IF EXISTS "관리자는 job_postings 삭제 가능" ON job_postings;
DROP POLICY IF EXISTS "모든 사용자는 job_postings 조회 가능" ON job_postings;
DROP POLICY IF EXISTS "관리자는 모든 job_applications 조회 가능" ON job_applications;
DROP POLICY IF EXISTS "관리자는 job_applications 수정 가능" ON job_applications;
DROP POLICY IF EXISTS "관리자는 job_applications 삭제 가능" ON job_applications;
DROP POLICY IF EXISTS "모든 사용자는 job_applications 생성 가능" ON job_applications;
DROP POLICY IF EXISTS "anon_and_authenticated_can_insert_job_applications" ON job_applications;
DROP POLICY IF EXISTS "관리자는 admin_users 조회 가능" ON admin_users;
DROP POLICY IF EXISTS "관리자는 admin_users 수정 가능" ON admin_users;
DROP POLICY IF EXISTS "관리자는 admin_users 삭제 가능" ON admin_users;

-- 관리자 확인 함수 (admin_users 테이블에 존재하는지 확인)
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM admin_users
    WHERE auth_user_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS 정책: 관리자만 모든 데이터 접근 가능
-- inquiries 테이블 정책
CREATE POLICY "관리자는 모든 inquiries 조회 가능"
  ON inquiries FOR SELECT
  TO authenticated
  USING (is_admin());

CREATE POLICY "관리자는 inquiries 수정 가능"
  ON inquiries FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "관리자는 inquiries 삭제 가능"
  ON inquiries FOR DELETE
  TO authenticated
  USING (is_admin());

CREATE POLICY "anon_and_authenticated_can_insert_inquiries"
  ON inquiries FOR INSERT
  TO authenticated, anon
  WITH CHECK (true);

-- job_postings 테이블 정책
CREATE POLICY "관리자는 모든 job_postings 조회 가능"
  ON job_postings FOR SELECT
  TO authenticated
  USING (is_admin());

CREATE POLICY "관리자는 job_postings 수정 가능"
  ON job_postings FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "관리자는 job_postings 삭제 가능"
  ON job_postings FOR DELETE
  TO authenticated
  USING (is_admin());

CREATE POLICY "관리자는 job_postings 생성 가능"
  ON job_postings FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "모든 사용자는 job_postings 조회 가능 (공개)"
  ON job_postings FOR SELECT
  TO anon
  USING (true);

-- job_applications 테이블 정책
CREATE POLICY "관리자는 모든 job_applications 조회 가능"
  ON job_applications FOR SELECT
  TO authenticated
  USING (is_admin());

CREATE POLICY "관리자는 job_applications 수정 가능"
  ON job_applications FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "관리자는 job_applications 삭제 가능"
  ON job_applications FOR DELETE
  TO authenticated
  USING (is_admin());

CREATE POLICY "anon_and_authenticated_can_insert_job_applications"
  ON job_applications FOR INSERT
  TO authenticated, anon
  WITH CHECK (true);

-- admin_users 테이블 정책
CREATE POLICY "관리자는 admin_users 조회 가능"
  ON admin_users FOR SELECT
  TO authenticated
  USING (is_admin());

CREATE POLICY "관리자는 admin_users 수정 가능"
  ON admin_users FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "관리자는 admin_users 삭제 가능"
  ON admin_users FOR DELETE
  TO authenticated
  USING (is_admin());

CREATE POLICY "관리자는 admin_users 생성 가능"
  ON admin_users FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

