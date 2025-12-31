# ECSTEL 관리자 페이지

ECSTEL 홈페이지를 관리하기 위한 관리자 대시보드입니다.

## 기능

- 🔐 로그인 및 인증 (Supabase Auth)
- 👥 계정 관리
- 📧 간편문의 확인 및 관리
- 💼 채용공고 등록 및 관리
- 📝 채용 접수 확인 및 관리

## 시작하기

### 1. 의존성 설치

```bash
npm install
npm install @supabase/supabase-js react-router-dom @tanstack/react-query lucide-react
```

### 2. Supabase 설정

1. https://supabase.com 에서 프로젝트 생성
2. `.env.local` 파일 생성:
   ```
   VITE_SUPABASE_URL=your-project-url
   VITE_SUPABASE_ANON_KEY=your-anon-key
   ```
3. `SETUP_GUIDE.md` 파일의 SQL을 실행하여 테이블 생성

### 3. 개발 서버 실행

```bash
npm run dev
```

## 프로젝트 구조

- `src/components/` - 재사용 가능한 컴포넌트
- `src/pages/` - 페이지 컴포넌트
- `src/lib/` - 라이브러리 설정 (Supabase 등)
- `src/hooks/` - 커스텀 훅
- `src/types/` - TypeScript 타입 정의

## 상세 가이드

- `SETUP_GUIDE.md` - Supabase 설정 가이드
- `PROJECT_PLAN.md` - 프로젝트 전체 계획

