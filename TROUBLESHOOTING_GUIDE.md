# RLS INSERT 오류 문제 해결 가이드

## 현재 상황
정책이 올바르게 설정되어 있는데도 여전히 오류가 발생합니다.

## 확인된 사항
✅ `insert_inquiries_allow_all` 정책이 존재함
✅ 정책이 `anon`과 `authenticated` 모두 허용함
✅ `with_check`가 `true`로 설정됨

## 가능한 원인 및 해결 방법

### 1. Supabase 캐시 문제
**해결 방법:**
- `FORCE_REFRESH_RLS.sql` 파일 실행
- Supabase 프로젝트 재시작: **Settings** → **General** → **Restart**

### 2. 정책의 WITH CHECK 조건 문제
**확인 방법:**
`DEEP_CHECK_RLS.sql` 파일을 실행하여 정책의 실제 `with_check` 값을 확인하세요.

**예상 결과:**
- `with_check`가 `true`여야 함
- `qual` (USING)이 NULL이거나 문제없어야 함

### 3. RLS가 실제로 활성화되지 않음
**확인 방법:**
```sql
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'inquiries';
```

**예상 결과:**
- `rowsecurity`가 `true`여야 함

### 4. 다른 정책이 충돌함
**확인 방법:**
```sql
SELECT * FROM pg_policies 
WHERE tablename = 'inquiries';
```

INSERT 정책이 **1개만** 있어야 합니다.

### 5. API 키 문제
**확인 사항:**
- 홈페이지에서 사용하는 키가 **anon key**인지 확인
- Settings → API → anon public key 확인
- 키가 올바른지 확인

### 6. Supabase 프로젝트 설정 문제
**확인 사항:**
- Settings → API → Row Level Security 확인
- 전역 RLS 설정이 활성화되어 있는지 확인

## 단계별 해결 방법

### Step 1: 심층 확인
`DEEP_CHECK_RLS.sql` 파일을 실행하여 현재 상태를 확인하세요.

### Step 2: 강제 새로고침
`FORCE_REFRESH_RLS.sql` 파일을 실행하여 RLS를 완전히 재설정하세요.

### Step 3: Supabase 재시작
- Settings → General → Restart 클릭
- 몇 분 대기 후 다시 시도

### Step 4: 브라우저 캐시 삭제
- 브라우저 캐시 완전 삭제
- 시크릿 모드에서 테스트

### Step 5: 네트워크 요청 확인
브라우저 DevTools → Network 탭에서:
- 요청 헤더 확인
- `Authorization` 헤더 확인
- 응답 본문 확인

## 추가 확인 사항

### 1. 홈페이지 코드 확인
홈페이지에서 보내는 요청이 올바른지 확인:
- URL이 올바른지
- 헤더가 올바른지
- 데이터 형식이 올바른지

### 2. Supabase 프로젝트 로그 확인
- Settings → Logs → API Logs 확인
- 최근 요청에서 오류 확인

### 3. 다른 테이블 테스트
다른 테이블(예: `job_applications`)에서도 같은 문제가 발생하는지 확인

## 최종 해결 방법

만약 위의 모든 방법을 시도했는데도 문제가 계속되면:

1. **Supabase 지원팀에 문의**
   - 프로젝트 ID: `qzymoraaukwicqlhjbsy`
   - 오류 코드: `42501`
   - 정책 설정 스크린샷 첨부

2. **새로운 Supabase 프로젝트 생성** (테스트용)
   - 새 프로젝트에서 같은 설정 시도
   - 문제가 재현되는지 확인

3. **Edge Function 사용** (대안)
   - RLS를 우회하는 Edge Function 생성
   - 홈페이지에서 Edge Function 호출

## 성공 확인

다음 조건을 모두 만족해야 합니다:
- ✅ INSERT 정책이 1개만 존재
- ✅ 정책이 `anon`과 `authenticated` 허용
- ✅ `with_check`가 `true`
- ✅ RLS가 활성화되어 있음
- ✅ 홈페이지에서 테스트 성공

## 다음 단계

1. `DEEP_CHECK_RLS.sql` 실행 → 결과 확인
2. `FORCE_REFRESH_RLS.sql` 실행 → RLS 재설정
3. Supabase 프로젝트 재시작
4. 홈페이지에서 다시 테스트

문제가 계속되면 `DEEP_CHECK_RLS.sql` 실행 결과를 공유해주세요.

