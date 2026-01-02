# RLS INSERT 오류 해결 가이드

## 현재 문제
```
"new row violates row-level security policy for table \"inquiries\""
코드: 42501
```

## 해결 방법 (3가지 옵션)

### 방법 1: 가장 간단한 수정 (추천) ⭐
`SIMPLE_FIX_RLS.sql` 파일을 Supabase Dashboard → SQL Editor에서 실행하세요.

이 방법은:
- 모든 기존 정책을 자동으로 삭제
- 새로운 정책을 깔끔하게 생성
- 가장 확실하게 작동합니다

### 방법 2: 단계별 확인 및 수정
`CHECK_AND_FIX_RLS.sql` 파일을 실행하세요.

이 방법은:
- 각 단계별로 확인 가능
- 문제 진단에 유용

### 방법 3: 수동으로 Supabase Dashboard에서 수정

1. **Supabase Dashboard** → **Table Editor** → **inquiries** 테이블 선택
2. 왼쪽 메뉴에서 **Policies** 클릭
3. 기존 정책 모두 삭제
4. 새 정책 생성:
   - **Policy Name**: `insert_inquiries_anon_authenticated`
   - **Allowed Operation**: `INSERT`
   - **Target Roles**: `anon`, `authenticated` (둘 다 선택)
   - **USING expression**: (비워두기)
   - **WITH CHECK expression**: `true`

## 실행 후 확인

### 1. 정책 확인 쿼리 실행
```sql
SELECT policyname, cmd, roles, with_check
FROM pg_policies
WHERE tablename = 'inquiries' AND cmd = 'INSERT';
```

**예상 결과:**
```
policyname: insert_inquiries_anon_authenticated
cmd: INSERT
roles: {anon,authenticated}
with_check: true
```

### 2. 홈페이지에서 테스트
1. 홈페이지 새로고침
2. 간편문의 폼 작성 및 제출
3. 브라우저 콘솔(F12)에서 에러 확인
4. 성공하면 "문의가 접수되었습니다" 메시지 표시

## 문제가 계속되면

### 확인 사항 1: Supabase 프로젝트 설정
1. Supabase Dashboard → **Settings** → **API**
2. **Row Level Security** 섹션 확인
3. RLS가 활성화되어 있는지 확인

### 확인 사항 2: 테이블 RLS 활성화
```sql
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' AND tablename = 'inquiries';
```
`rowsecurity`가 `true`여야 합니다.

### 확인 사항 3: 모든 정책 확인
```sql
SELECT * FROM pg_policies 
WHERE tablename = 'inquiries';
```
INSERT 정책이 있고, `roles`에 `anon`이 포함되어 있어야 합니다.

### 확인 사항 4: API 키 확인
홈페이지 코드에서 사용하는 키가 **anon key**인지 확인:
- ✅ 올바름: `sb_publishable_...`
- ❌ 잘못됨: service role key (관리자 키)

## 빠른 테스트

Supabase SQL Editor에서 다음 쿼리로 테스트:

```sql
-- 이 쿼리는 service_role로 실행되므로 성공할 수 있습니다
-- 실제 테스트는 홈페이지에서 해야 합니다
INSERT INTO inquiries (name, email, content, status)
VALUES ('테스트', 'test@test.com', '테스트 내용', 'new');
```

이 쿼리가 성공해도 홈페이지에서 실패할 수 있습니다. 왜냐하면:
- SQL Editor는 `service_role`로 실행됨 (모든 정책 우회)
- 홈페이지는 `anon` 역할로 실행됨 (RLS 정책 적용)

## 최종 확인

모든 단계를 완료한 후:

1. ✅ `SIMPLE_FIX_RLS.sql` 실행 완료
2. ✅ INSERT 정책이 생성되었는지 확인
3. ✅ 홈페이지에서 테스트
4. ✅ 브라우저 콘솔에 에러가 없는지 확인

문제가 계속되면 Supabase Dashboard의 정책 화면을 스크린샷으로 공유해주시면 더 정확한 도움을 드릴 수 있습니다.

