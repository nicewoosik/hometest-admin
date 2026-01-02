# 간헐적 오류 해결 가이드

## 현재 상황
- ✅ 첫 번째 요청: 성공
- ❌ 두 번째 요청: 실패 (RLS 오류)

이것은 정책이 간헐적으로 작동하거나 캐시 문제일 수 있습니다.

## 해결 방법

### `VERIFY_AND_FIX_POLICY.sql` 파일을 Supabase Dashboard → SQL Editor에서 실행하세요.

이 SQL은:
1. 현재 정책 상태 확인
2. 모든 INSERT 정책 삭제
3. RLS 재설정 (캐시 클리어)
4. 가장 확실한 정책 생성 (`TO public`)

## 실행 후 확인

SQL 실행 후 다음 쿼리로 확인:

```sql
SELECT policyname, cmd, roles, with_check, permissive
FROM pg_policies
WHERE tablename = 'inquiries' AND cmd = 'INSERT';
```

**예상 결과:**
- 정책이 1개만 있어야 함
- `policyname`: `insert_inquiries_all`
- `roles`: `{public}`
- `with_check`: `true`
- `permissive`: `PERMISSIVE`

## 추가 확인 사항

### 1. Supabase 프로젝트 재시작
- Settings → General → Restart 클릭
- 몇 분 대기 후 다시 시도

### 2. 브라우저 캐시 완전 삭제
- 브라우저 캐시 완전 삭제
- 시크릿 모드에서 테스트

### 3. 여러 번 테스트
- 간편문의 폼을 여러 번 제출해보세요
- 모든 요청이 성공하는지 확인

## 문제가 계속되면

만약 여전히 간헐적으로 실패한다면:

1. **정책을 다시 확인**: 위의 확인 쿼리 실행
2. **Supabase 로그 확인**: Settings → Logs → API Logs 확인
3. **Edge Function 사용**: RLS를 완전히 우회하는 방법

**`VERIFY_AND_FIX_POLICY.sql`을 실행한 후 여러 번 테스트해보세요!**

