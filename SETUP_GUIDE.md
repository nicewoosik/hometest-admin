# ECSTEL 관리자 페이지 설정 가이드

## 1단계: 프로젝트 생성

터미널에서 실행:

```bash
cd /Users/tommyjang
npm create vite@latest ecstel-admin -- --template react-ts
cd ecstel-admin
npm install
npm install @supabase/supabase-js react-router-dom @tanstack/react-query lucide-react
```

## 2단계: Supabase 프로젝트 생성

1. https://supabase.com 접속
2. GitHub 계정으로 로그인
3. "New Project" 클릭
4. 프로젝트 정보 입력:
   - Name: `ecstel-admin`
   - Database Password: 강력한 비밀번호 설정 (기억해두세요!)
   - Region: Northeast Asia (Seoul)
5. "Create new project" 클릭
6. 프로젝트 생성 완료까지 대기 (약 2분)

## 3단계: Supabase 설정 정보 확인

프로젝트 생성 후:
1. Settings → **API Keys** 메뉴로 이동
2. 다음 정보 확인:
   - **Project URL**: 페이지 상단 "Reference ID" 또는 "Project URL" 섹션에 표시됨 (`https://xxxxx.supabase.co`)
   - **Publishable key** (또는 "anon key", "public key"): 
     - ✅ **"Publishable key"**가 바로 사용할 키입니다!
     - 이것이 클라이언트 사이드(프론트엔드)에서 사용하는 공개 키입니다
     - 키가 숨겨져 있다면 "Reveal" 또는 "Show" 버튼 클릭
     - 또는 키 옆의 눈 아이콘 클릭하여 표시
     - 형식: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` (긴 문자열)
   
   **주의사항:**
   - ✅ **Publishable key** 사용 (프론트엔드용)
   - ❌ **Secret key** 또는 **service_role key**는 사용하지 마세요 (서버 사이드 전용, 보안상 위험)

## 4단계: 환경 변수 설정

프로젝트 루트에 `.env.local` 파일 생성:

```bash
cd /Users/tommyjang/ecstel-admin
touch .env.local
```

`.env.local` 파일 내용:
```
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your-publishable-key-here
```

**참고**: `VITE_SUPABASE_ANON_KEY`에는 **Publishable key** 값을 입력하세요.

## 5단계: 데이터베이스 테이블 생성

Supabase Dashboard → SQL Editor에서 다음 SQL 실행:

```sql
-- 1. 관리자 계정 테이블
CREATE TABLE admin_users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
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
```

## 6단계: Storage 설정 (파일 업로드용)

1. Supabase Dashboard → Storage
2. "Create a new bucket" 클릭
3. Bucket name: `resumes`
4. Public bucket: **체크 해제** (비공개)
5. File size limit: 10MB
6. Allowed MIME types: `application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document`
7. "Create bucket" 클릭

## 7단계: 인증 설정 확인

Supabase는 기본적으로 이메일/비밀번호 인증을 지원합니다.

1. Authentication → **Sign In / Providers** 메뉴로 이동
2. 확인 사항:
   - ✅ **"Allow new users to sign up"**: 이미 활성화되어 있으면 완료
   - ✅ **Email provider**: Enabled 상태 확인
   - ⚠️ **"Confirm email"**: 개발 중에는 비활성화해도 됨 (현재 비활성화 상태면 OK)

## 다음 단계

위 단계를 완료한 후 알려주시면, 로그인 화면과 관리자 대시보드를 구현하겠습니다.

