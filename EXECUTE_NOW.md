# 즉시 실행하세요!

## 문제 확인됨

스크린샷에서 확인:
- **INSERT 정책이 여전히 2개 존재함**
  1. `insert_inquiries_allow_all` (anon, authenticated)
  2. `insert_allow_all` (public)

**이것이 문제의 원인입니다!**

## 해결 방법

**`REMOVE_ALL_AND_CREATE_ONE.sql` 파일을 Supabase Dashboard → SQL Editor에서 실행하세요.**

이 쿼리는:
1. ✅ 모든 INSERT 정책을 명시적으로 삭제
2. ✅ RLS 재설정 (캐시 클리어)
3. ✅ 하나의 정책만 생성 (`TO public`)

## 실행 단계

1. Supabase Dashboard → SQL Editor 열기
2. `REMOVE_ALL_AND_CREATE_ONE.sql` 파일 내용 복사
3. SQL Editor에 붙여넣기
4. **Run** 버튼 클릭
5. 결과 확인 (INSERT 정책이 1개만 있어야 함)

## 실행 후 확인

다시 다음 쿼리로 확인:

```sql
SELECT policyname, cmd, roles, with_check
FROM pg_policies
WHERE tablename = 'inquiries' AND cmd = 'INSERT';
```

**예상 결과:**
- 정책이 **1개만** 있어야 함
- `policyname`: `insert_inquiries_only`
- `cmd`: `INSERT`
- `roles`: `{public}`
- `with_check`: `true`

## 테스트

1. SQL 실행 완료 확인
2. 홈페이지 새로고침 (캐시 삭제)
3. 간편문의 폼 제출 테스트
4. 성공하면 완료!

## 왜 이 방법이 작동하는가?

- 중복 정책 제거로 충돌 방지
- `TO public`으로 설정하여 모든 요청 허용
- RLS 재설정으로 캐시 클리어
- 하나의 정책만 존재하여 명확함

**지금 바로 `REMOVE_ALL_AND_CREATE_ONE.sql`을 실행하세요!**

