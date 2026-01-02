# 정책 문제 디버깅 가이드

## 현재 상황
- ✅ RLS 비활성화 시: 정상 작동
- ❌ 정책 활성화 시: 실패

## 디버깅 단계

### Step 1: 현재 정책 상태 확인

**`CHECK_CURRENT_POLICY.sql` 파일을 실행하세요.**

이 쿼리는 현재 정책 상태를 확인합니다:
- INSERT 정책이 있는지
- 정책의 `roles`가 무엇인지
- `with_check`가 무엇인지
- RLS가 활성화되어 있는지

### Step 2: 정책 재설정

**`SURE_FIX_POLICY.sql` 파일을 실행하세요.**

이 SQL은:
1. 모든 정책 삭제
2. 삭제 확인 (0개여야 함)
3. RLS 재설정
4. 가장 단순한 정책 생성 (`WITH CHECK` 없음)

### Step 3: 결과 확인

SQL 실행 후 다음 쿼리로 확인:

```sql
SELECT policyname, cmd, roles, with_check, qual
FROM pg_policies
WHERE tablename = 'inquiries' AND cmd = 'INSERT';
```

**예상 결과:**
- `policyname`: `insert_all`
- `cmd`: `INSERT`
- `roles`: `{public}`
- `with_check`: `null`
- `qual`: `null`

## 문제가 계속되면

### 1. Supabase 프로젝트 재시작
- Settings → General → Restart 클릭
- 몇 분 대기 후 다시 시도

### 2. 정책을 Supabase Dashboard에서 직접 생성
1. Table Editor → inquiries → Policies
2. 모든 정책 삭제
3. "New Policy" 클릭
4. 설정:
   - Policy Name: `test_insert`
   - Allowed Operation: `INSERT`
   - Target Roles: `public` 선택
   - USING expression: (비워두기)
   - WITH CHECK expression: (비워두기) ← **비워두기!**
   - Save

### 3. Edge Function 사용 (최후의 수단)
`CREATE_EDGE_FUNCTION.md` 파일을 참고하여 Edge Function을 생성하세요.

## 확인 사항

1. 정책이 실제로 생성되었는지 확인
2. 정책의 `roles`가 `{public}`인지 확인
3. `with_check`가 `null`이거나 없는지 확인
4. RLS가 활성화되어 있는지 확인

**먼저 `CHECK_CURRENT_POLICY.sql`을 실행하여 현재 상태를 확인하세요!**

