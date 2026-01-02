# 최종 해결 단계

## 현재 상황
RLS 정책이 올바르게 설정되어 있는데도 계속 오류가 발생합니다.

## 즉시 시도할 것 (순서대로)

### Step 1: RLS 완전 재설정

**`COMPLETE_RLS_RESET.sql` 파일을 Supabase Dashboard → SQL Editor에서 실행하세요.**

이 쿼리는:
- 모든 정책 삭제
- RLS 재설정
- `TO public`으로 설정하여 모든 요청 허용

### Step 2: 테스트

SQL 실행 후 홈페이지에서 문의 제출 테스트

### Step 3: 여전히 실패하면 Edge Function 사용

**`CREATE_EDGE_FUNCTION.md` 파일을 참고하여 Edge Function을 생성하세요.**

이 방법은 RLS를 완전히 우회하므로 100% 작동합니다.

## 추가 확인 사항

### 1. Supabase 프로젝트 설정 확인

1. **Settings** → **API** → **Row Level Security** 확인
2. 전역 RLS 설정이 올바른지 확인
3. 필요시 프로젝트 재시작: **Settings** → **General** → **Restart**

### 2. 정책 확인

```sql
SELECT policyname, cmd, roles, with_check
FROM pg_policies
WHERE tablename = 'inquiries' AND cmd = 'INSERT';
```

**예상 결과:**
- `policyname`: `allow_insert_public`
- `cmd`: `INSERT`
- `roles`: `{public}`
- `with_check`: `true`

### 3. 홈페이지 코드 확인

현재 홈페이지에서 사용하는 코드가:
- Supabase 클라이언트를 사용하는지 확인
- 또는 Fetch API를 올바르게 사용하는지 확인

## 최종 해결책 우선순위

1. **`COMPLETE_RLS_RESET.sql` 실행** ← 가장 먼저 시도
2. **Edge Function 생성** ← 위 방법이 실패하면
3. **Supabase 지원팀 문의** ← 모든 방법 실패 시

## 성공 확인

다음 조건을 모두 만족해야 합니다:
- ✅ INSERT 정책이 `TO public`으로 설정됨
- ✅ `with_check`가 `true`
- ✅ 홈페이지에서 테스트 성공

**`COMPLETE_RLS_RESET.sql`을 실행한 후 결과를 알려주세요!**

