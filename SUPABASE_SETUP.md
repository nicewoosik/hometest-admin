# Supabase 설정 가이드

## 1. Supabase 프로젝트 생성

1. https://supabase.com 접속
2. "Start your project" 클릭
3. GitHub 계정으로 로그인
4. "New Project" 클릭
5. 프로젝트 정보 입력:
   - Name: `ecstel-admin`
   - Database Password: 강력한 비밀번호 설정
   - Region: Northeast Asia (Seoul) 선택
6. "Create new project" 클릭

## 2. 프로젝트 설정에서 필요한 정보 확인

프로젝트 생성 후:
1. Settings → API 메뉴로 이동
2. 다음 정보를 확인:
   - Project URL
   - anon/public key

## 3. 환경 변수 설정

프로젝트 루트에 `.env.local` 파일 생성:
```
VITE_SUPABASE_URL=your-project-url
VITE_SUPABASE_ANON_KEY=your-anon-key
```

## 4. 데이터베이스 테이블 생성

Supabase Dashboard → SQL Editor에서 다음 SQL 실행:

```sql
-- 1. 관리자 계정 테이블
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  name TEXT NOT NULL,
  role TEXT DEFAULT 'manager' CHECK (role IN ('admin', 'manager')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. 간편문의 테이블
CREATE TABLE inquiries (
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
CREATE TABLE job_postings (
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
CREATE TABLE job_applications (
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
CREATE INDEX idx_inquiries_status ON inquiries(status);
CREATE INDEX idx_inquiries_created_at ON inquiries(created_at DESC);
CREATE INDEX idx_job_postings_status ON job_postings(status);
CREATE INDEX idx_job_applications_job_posting_id ON job_applications(job_posting_id);
CREATE INDEX idx_job_applications_status ON job_applications(status);

-- RLS (Row Level Security) 설정
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_postings ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_applications ENABLE ROW LEVEL SECURITY;

-- 관리자만 모든 데이터 접근 가능하도록 정책 설정
-- (실제 구현 시 Supabase Auth와 연동 필요)
```

## 5. Storage 설정 (파일 업로드용)

1. Storage → Create a new bucket
2. Bucket name: `resumes` (채용 지원서)
3. Public bucket: 체크 해제 (비공개)
4. File size limit: 10MB
5. Allowed MIME types: `application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document`

## 6. 초기 관리자 계정 생성

SQL Editor에서:
```sql
-- 비밀번호는 실제로는 해시화되어야 하지만, 
-- Supabase Auth를 사용할 경우 별도로 관리
INSERT INTO users (email, password_hash, name, role) 
VALUES ('admin@ecstel.co.kr', 'temp_hash', '관리자', 'admin');
```

