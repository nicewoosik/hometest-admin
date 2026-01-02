# 긴급 수정: 중복 정책 문제

## 문제 발견!

스크린샷에서 확인된 문제:
- **INSERT 정책이 2개 존재함**
  1. `insert_inquiries_allow_all` (anon, authenticated)
  2. `insert_allow_all` (public)

**여러 정책이 있을 때 충돌이 발생할 수 있습니다!**

## 즉시 해결 방법

**`FIX_DUPLICATE_POLICIES.sql` 파일을 Supabase Dashboard → SQL Editor에서 실행하세요.**

이 쿼리는:
1. 모든 INSERT 정책 삭제
2. RLS 재설정 (캐시 클리어)
3. 하나의 정책만 생성 (`TO public`으로 설정)

## 실행 후 확인

SQL 실행 후 다시 다음 쿼리로 확인:

```sql
SELECT policyname, cmd, roles, with_check
FROM pg_policies
WHERE tablename = 'inquiries' AND cmd = 'INSERT';
```

**예상 결과:**
- 정책이 **1개만** 있어야 함
- `policyname`: `insert_inquiries_public`
- `cmd`: `INSERT`
- `roles`: `{public}`
- `with_check`: `true`

## 테스트

1. SQL 실행 완료 확인
2. 홈페이지 새로고침
3. 간편문의 폼 제출 테스트
4. 성공하면 완료!

## 왜 이 방법이 작동하는가?

- 중복 정책 제거로 충돌 방지
- `TO public`으로 설정하여 모든 요청 허용
- RLS 재설정으로 캐시 클리어

**`FIX_DUPLICATE_POLICIES.sql`을 실행한 후 결과를 알려주세요!**

