# 최종 성공 가이드

## ✅ 확인됨!

RLS를 비활성화했을 때 정상적으로 작동하므로, 문제는 RLS 정책이었습니다.

## 다음 단계: RLS 재활성화 및 올바른 정책 설정

### `ENABLE_RLS_WITH_CORRECT_POLICY.sql` 파일을 Supabase Dashboard → SQL Editor에서 실행하세요.

이 SQL은:
1. ✅ RLS를 다시 활성화
2. ✅ 모든 기존 정책 삭제
3. ✅ `TO public`으로 INSERT 정책 생성 (모든 요청 허용)
4. ✅ SELECT/UPDATE/DELETE 정책 생성 (관리자만)

## 실행 후 확인

SQL 실행 후 다음 쿼리로 확인:

```sql
SELECT policyname, cmd, roles, with_check
FROM pg_policies
WHERE tablename = 'inquiries' AND cmd = 'INSERT';
```

**예상 결과:**
- `policyname`: `insert_inquiries_public`
- `cmd`: `INSERT`
- `roles`: `{public}`
- `with_check`: `true`

## 테스트

1. SQL 실행 완료 확인
2. 홈페이지 새로고침 (캐시 삭제)
3. 간편문의 폼 제출 테스트
4. 성공하면 완료!

## 완료 체크리스트

- [x] RLS 비활성화 시 정상 작동 확인
- [ ] RLS 재활성화 및 정책 설정
- [ ] INSERT 정책이 `TO public`으로 설정됨
- [ ] 홈페이지에서 테스트 성공

## 보안 참고사항

`TO public`으로 설정하면 모든 사용자가 INSERT할 수 있습니다. 이것은 간편문의 기능에는 적합하지만, 필요시 더 엄격한 정책으로 변경할 수 있습니다.

**`ENABLE_RLS_WITH_CORRECT_POLICY.sql`을 실행한 후 결과를 알려주세요!**

