# ECSTEL 관리자 페이지 프로젝트 계획

## 프로젝트 개요
ECSTEL 홈페이지를 관리하기 위한 관리자 대시보드

## 기술 스택
- **Frontend**: React + TypeScript + Vite
- **Backend/Database**: Supabase
- **Routing**: React Router
- **State Management**: TanStack Query (React Query)
- **Icons**: Lucide React

## 주요 기능

### 1. 인증 시스템
- 로그인 화면
- Supabase Auth를 통한 인증
- 세션 관리

### 2. 관리자 대시보드
- 사이드바 네비게이션
- 메인 콘텐츠 영역
- 반응형 디자인

### 3. 메뉴 구성

#### 3.1 계정 관리
- 관리자 계정 목록 조회
- 계정 생성/수정/삭제
- 권한 관리

#### 3.2 간편문의 관리
- 간편문의 목록 조회
- 문의 내용 상세 확인
- 문의 상태 관리 (신규/처리중/완료)

#### 3.3 채용공고 관리
- 채용공고 목록 조회
- 채용공고 등록/수정/삭제
- 공고 상태 관리 (접수중/마감)

#### 3.4 채용 접수 관리
- 지원자 목록 조회
- 지원서 상세 확인
- 지원 상태 관리 (서류전형/면접/최종합격 등)

## 데이터베이스 스키마 (Supabase)

### 1. users (관리자 계정)
- id (uuid, primary key)
- email (text, unique)
- password_hash (text)
- name (text)
- role (text) - 'admin', 'manager'
- created_at (timestamp)
- updated_at (timestamp)

### 2. inquiries (간편문의)
- id (uuid, primary key)
- name (text)
- company (text)
- email (text)
- phone (text)
- content (text)
- status (text) - 'new', 'processing', 'completed'
- created_at (timestamp)
- updated_at (timestamp)

### 3. job_postings (채용공고)
- id (uuid, primary key)
- title (text)
- description (text)
- requirements (text)
- deadline (date)
- status (text) - 'open', 'closed'
- attachment_url (text)
- created_at (timestamp)
- updated_at (timestamp)

### 4. job_applications (채용 접수)
- id (uuid, primary key)
- job_posting_id (uuid, foreign key)
- name (text)
- email (text)
- phone (text)
- resume_url (text)
- status (text) - 'applied', 'reviewing', 'interview', 'accepted', 'rejected'
- created_at (timestamp)
- updated_at (timestamp)

## 프로젝트 구조
```
ecstel-admin/
├── src/
│   ├── components/
│   │   ├── auth/
│   │   │   └── Login.tsx
│   │   ├── layout/
│   │   │   ├── Sidebar.tsx
│   │   │   └── Header.tsx
│   │   ├── accounts/
│   │   │   ├── AccountList.tsx
│   │   │   └── AccountForm.tsx
│   │   ├── inquiries/
│   │   │   ├── InquiryList.tsx
│   │   │   └── InquiryDetail.tsx
│   │   ├── job-postings/
│   │   │   ├── JobPostingList.tsx
│   │   │   └── JobPostingForm.tsx
│   │   └── applications/
│   │       ├── ApplicationList.tsx
│   │       └── ApplicationDetail.tsx
│   ├── pages/
│   │   ├── LoginPage.tsx
│   │   ├── DashboardPage.tsx
│   │   ├── AccountsPage.tsx
│   │   ├── InquiriesPage.tsx
│   │   ├── JobPostingsPage.tsx
│   │   └── ApplicationsPage.tsx
│   ├── lib/
│   │   └── supabase.ts
│   ├── hooks/
│   │   └── useAuth.ts
│   ├── types/
│   │   └── index.ts
│   ├── App.tsx
│   └── main.tsx
├── package.json
└── README.md
```


