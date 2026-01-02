# 최종 해결 방법

## 현재 상황
- ✅ Supabase 클라이언트 초기화 완료
- ✅ 코드는 올바르게 수정됨
- ❌ 여전히 RLS 오류 발생

## 즉시 시도할 방법

### 방법 1: RLS 임시 비활성화 (테스트용)

**`DISABLE_RLS_TEMPORARILY.sql` 파일을 Supabase Dashboard → SQL Editor에서 실행하세요.**

이렇게 하면:
- RLS가 완전히 비활성화됨
- INSERT가 즉시 작동함
- 문제가 RLS인지 다른 것인지 확인 가능

**⚠️ 주의: 테스트 후 반드시 RLS를 다시 활성화하고 정책을 설정하세요!**

### 방법 2: 정책을 다시 확인하고 재설정

1. Supabase Dashboard → Table Editor → inquiries → Policies
2. 모든 정책 삭제
3. 새 정책 생성:
   - Policy Name: `test_insert`
   - Allowed Operation: `INSERT`
   - Target Roles: `public` 선택
   - WITH CHECK: `true`
   - Save

### 방법 3: Edge Function 사용 (RLS 완전 우회)

`CREATE_EDGE_FUNCTION.md` 파일을 참고하여 Edge Function을 생성하세요.

이 방법은 RLS를 완전히 우회하므로 100% 작동합니다.

## 확인 사항

### 1. 정책이 실제로 존재하는지 확인

```sql
SELECT policyname, cmd, roles, with_check
FROM pg_policies
WHERE tablename = 'inquiries' AND cmd = 'INSERT';
```

### 2. RLS가 활성화되어 있는지 확인

```sql
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'inquiries';
```

### 3. Supabase 프로젝트 설정 확인

- Settings → API → Row Level Security 확인
- 전역 RLS 설정이 올바른지 확인
- 필요시 프로젝트 재시작: Settings → General → Restart

## 우선순위

1. **`DISABLE_RLS_TEMPORARILY.sql` 실행** ← 가장 빠른 확인 방법
2. 정책을 `TO public`으로 재설정
3. Edge Function 사용

**`DISABLE_RLS_TEMPORARILY.sql`을 실행한 후 홈페이지에서 테스트해보세요. 작동하면 RLS 정책 문제입니다.**

