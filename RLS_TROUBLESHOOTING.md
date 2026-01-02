# RLS INSERT 정책 오류 해결 가이드

## 에러 메시지
```
"new row violates row-level security policy for table \"inquiries\""
코드: 42501
상태: 401
```

## 원인
비로그인 사용자(anon)가 `inquiries` 테이블에 데이터를 INSERT하려고 할 때 RLS 정책 위반이 발생했습니다.

## 해결 방법

### 1단계: 즉시 수정 (가장 빠름)
`FIX_RLS_INSERT_POLICY.sql` 파일을 Supabase Dashboard → SQL Editor에서 실행하세요.

이 파일은:
- 기존 INSERT 정책을 삭제하고
- 새로운 INSERT 정책을 생성합니다
- 정책이 제대로 생성되었는지 확인합니다

### 2단계: 정책 확인
실행 후 다음 쿼리로 정책이 제대로 생성되었는지 확인:

```sql
SELECT 
  tablename,
  policyname,
  cmd,
  roles,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries'
  AND cmd = 'INSERT';
```

**예상 결과:**
- `policyname`: `anon_and_authenticated_can_insert_inquiries`
- `cmd`: `INSERT`
- `roles`: `{authenticated,anon}` 또는 `{anon,authenticated}`
- `with_check`: `true`

### 3단계: 테스트
홈페이지에서 간편문의 폼을 제출해보세요. 이제 정상적으로 작동해야 합니다.

## 문제가 계속되면

### 확인 사항 1: RLS가 활성화되어 있는지
```sql
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
  AND tablename = 'inquiries';
```
`rowsecurity`가 `true`여야 합니다.

### 확인 사항 2: 다른 정책이 충돌하는지
```sql
SELECT policyname, cmd, roles, qual, with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'inquiries';
```

모든 정책을 확인하여 INSERT를 차단하는 다른 정책이 없는지 확인하세요.

### 확인 사항 3: API 키 확인
홈페이지 코드에서 사용하는 Supabase API 키가 **anon key**인지 확인하세요.
- ✅ 올바름: `sb_publishable_...` (anon key)
- ❌ 잘못됨: service role key (관리자 키)

### 확인 사항 4: Supabase 프로젝트 설정
1. Supabase Dashboard → **Settings** → **API**
2. **Row Level Security** 섹션 확인
3. RLS가 활성화되어 있는지 확인

## 예방 조치

앞으로 이런 문제를 방지하려면:

1. **정책 이름을 영문으로 사용**: 한글 정책 이름은 때때로 문제를 일으킬 수 있습니다.
2. **정책을 단순하게 유지**: `WITH CHECK (true)`는 모든 행을 허용합니다.
3. **정기적으로 정책 확인**: `RLS_VERIFICATION.sql`을 실행하여 정책 상태를 확인하세요.

## 추가 도움말

- [Supabase RLS 문서](https://supabase.com/docs/guides/auth/row-level-security)
- [PostgreSQL RLS 문서](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)

