# 정책이 작동하지 않는 이유 분석

## 현재 상황
- ✅ RLS 비활성화 시: 정상 작동
- ❌ 정책 활성화 시: 실패

## 가능한 원인

### 1. WITH CHECK 조건 문제
`WITH CHECK (true)`가 있어도 때때로 작동하지 않을 수 있습니다.

**해결**: `WITH CHECK` 없이 정책 생성

### 2. 정책의 roles 설정 문제
`{anon, authenticated}`로 설정했을 때 문제가 발생할 수 있습니다.

**해결**: `TO public`으로 설정

### 3. 정책이 실제로 적용되지 않음
정책이 생성되었지만 실제로 적용되지 않을 수 있습니다.

**해결**: RLS를 재설정하고 정책을 다시 생성

## 해결 방법

### `ULTIMATE_POLICY_FIX.sql` 파일을 실행하세요.

이 SQL은:
1. 모든 정책 삭제
2. RLS 재설정
3. **WITH CHECK 없이** 가장 단순한 정책 생성
4. `TO public`으로 설정

## 주요 차이점

**이전 정책:**
```sql
CREATE POLICY "insert_inquiries_public"
  ON inquiries FOR INSERT
  TO public
  WITH CHECK (true);  -- WITH CHECK 있음
```

**새 정책:**
```sql
CREATE POLICY "allow_insert"
  ON inquiries FOR INSERT
  TO public;
  -- WITH CHECK 없음 (가장 단순함)
```

## 실행 후 확인

```sql
SELECT policyname, cmd, roles, with_check, qual
FROM pg_policies
WHERE tablename = 'inquiries' AND cmd = 'INSERT';
```

**예상 결과:**
- `policyname`: `allow_insert`
- `cmd`: `INSERT`
- `roles`: `{public}`
- `with_check`: `null` (없음)
- `qual`: `null` (없음)

## 테스트

1. SQL 실행 완료 확인
2. 홈페이지 새로고침
3. 간편문의 폼 여러 번 제출 테스트
4. 모든 요청이 성공해야 함

**`ULTIMATE_POLICY_FIX.sql`을 실행한 후 테스트해보세요!**

