# Supabase API Keys 찾는 방법

## API Keys 페이지 구조

Supabase의 API Keys 페이지에는 보통 다음과 같은 섹션이 있습니다:

### 1. Project URL (Reference ID)
- 페이지 상단에 표시
- 형식: `https://xxxxx.supabase.co`
- 또는 "Reference ID"로 표시될 수 있음

### 2. Project API keys 섹션
이 섹션에 두 가지 키가 있습니다:

#### anon key (public key)
- **이름**: "anon" 또는 "public" 또는 "anon public"
- **용도**: 클라이언트 사이드에서 사용 (프론트엔드)
- **보안**: 공개되어도 괜찮지만, RLS 정책으로 보호됨
- **형식**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` (매우 긴 문자열)

#### service_role key (secret key)
- **이름**: "service_role" 또는 "secret"
- **용도**: 서버 사이드에서만 사용 (백엔드)
- **보안**: 절대 공개하면 안 됨!
- **사용하지 마세요**: 프론트엔드에서는 사용하지 않습니다

## 키가 보이지 않는 경우

1. **"Reveal" 버튼 클릭**
   - 키가 숨겨져 있을 수 있음
   - "Reveal" 또는 "Show" 버튼을 클릭하면 표시됨

2. **눈 아이콘 클릭**
   - 키 옆에 눈 아이콘이 있다면 클릭하여 표시

3. **"Copy" 버튼 사용**
   - 키를 직접 보지 않고 복사할 수도 있음

## 확인 방법

API Keys 페이지에서:
- ✅ **사용할 키**: "anon" 또는 "public" 라벨이 있는 키
- ❌ **사용하지 않을 키**: "service_role" 또는 "secret" 라벨이 있는 키

## .env.local 파일에 입력할 내용

```
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9... (anon 키)
```

**주의**: service_role 키는 절대 입력하지 마세요!


