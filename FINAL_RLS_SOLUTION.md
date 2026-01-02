# RLS INSERT 오류 최종 해결 가이드

## 현재 상황
여러 번 SQL을 실행했지만 여전히 같은 오류가 발생합니다.

## 해결 방법 (우선순위 순)

### 방법 1: RLS 완전 재설정 (가장 확실함) ⭐

`EMERGENCY_FIX_RLS.sql` 파일을 실행하세요.

이 방법은:
- 모든 정책을 삭제
- RLS를 완전히 비활성화했다가 재활성화 (캐시 클리어)
- `TO public`으로 설정하여 모든 역할 허용
- 가장 단순한 정책 생성

### 방법 2: 임시로 RLS 비활성화 (테스트용)

**⚠️ 주의: 보안이 약해지므로 프로덕션에서는 사용하지 마세요!**

`TEMPORARY_DISABLE_RLS.sql` 파일을 실행하여 RLS를 임시로 비활성화하고 테스트해보세요.

이렇게 하면:
- INSERT가 즉시 작동하는지 확인 가능
- 문제가 RLS인지 다른 것인지 확인 가능

**테스트 후 반드시 RLS를 다시 활성화하고 정책을 생성하세요!**

### 방법 3: Supabase Dashboard에서 직접 수정

1. **Supabase Dashboard** → **Table Editor** → **inquiries** 테이블
2. 왼쪽 사이드바에서 **"Policies"** 클릭
3. **모든 정책 삭제** (각 정책 옆 삭제 버튼)
4. **RLS 토글 스위치를 OFF했다가 ON** (캐시 클리어)
5. **"New Policy"** 클릭
6. 설정:
   - **Policy Name**: `test_insert`
   - **Allowed Operation**: `INSERT`
   - **Target Roles**: `public` 선택 (또는 `anon`, `authenticated` 둘 다)
   - **USING expression**: (비워두기)
   - **WITH CHECK expression**: `true`
   - **Save**

### 방법 4: Supabase 프로젝트 설정 확인

1. **Settings** → **API** → **Row Level Security** 섹션 확인
2. RLS가 전역적으로 활성화되어 있는지 확인
3. 필요시 프로젝트 재시작: **Settings** → **General** → **Restart**

## 문제 진단

다음 쿼리로 현재 상태를 확인하세요:

```sql
-- 1. RLS 활성화 상태
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'inquiries';

-- 2. 모든 정책 확인
SELECT policyname, cmd, roles, with_check, qual
FROM pg_policies
WHERE tablename = 'inquiries';

-- 3. 테이블 권한 확인
SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_name = 'inquiries';
```

## 추가 확인 사항

### 1. Supabase 클라이언트 라이브러리 사용

홈페이지 코드에서 Fetch API 대신 Supabase 클라이언트를 사용하는 것이 더 안전합니다:

```javascript
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  'https://qzymoraaukwicqlhjbsy.supabase.co',
  'sb_publishable_9h5TGNNrnzpjvWCu_CYxVg_VuOC7XFr'
)

// 사용
const { data, error } = await supabase
  .from('inquiries')
  .insert([{
    name: '...',
    email: '...',
    content: '...'
  }])
```

### 2. API 키 확인

현재 사용 중인 키: `sb_publishable_9h5TGNNrnzpjvWCu_CYxVg_VuOC7XFr`

이 키가:
- ✅ **anon key**인지 확인 (Settings → API → anon public)
- ❌ service_role key가 아닌지 확인

### 3. 네트워크 요청 확인

브라우저 DevTools → Network 탭에서:
- 요청 헤더에 `Authorization: Bearer ...` 토큰이 있는지 확인
- 응답 상태 코드 확인
- 응답 본문 확인

## 최종 체크리스트

- [ ] `EMERGENCY_FIX_RLS.sql` 실행 완료
- [ ] INSERT 정책이 생성되었는지 확인
- [ ] 정책의 `roles`에 `public` 또는 `anon` 포함 확인
- [ ] 홈페이지에서 테스트
- [ ] 여전히 실패하면 `TEMPORARY_DISABLE_RLS.sql`로 테스트

## 여전히 문제가 있다면

1. **Supabase 지원팀에 문의**: 프로젝트 설정 문제일 수 있음
2. **새로운 Supabase 프로젝트 생성**: 테스트용으로 새 프로젝트에서 시도
3. **다른 인증 방법 고려**: 예를 들어 Edge Function 사용

## 성공 후

RLS가 작동하면:
1. 정책을 더 엄격하게 조정
2. `TO public` 대신 `TO anon, authenticated` 사용
3. 필요시 추가 보안 정책 적용

