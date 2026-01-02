# 최종 해결 방법

## 문제 상황
정책이 올바르게 설정되어 있는데도 계속 RLS 오류가 발생합니다.

## 해결 방법 (우선순위 순)

### 방법 1: 홈페이지 코드를 Supabase 클라이언트로 변경 ⭐⭐⭐ (가장 확실함)

`HOMEPAGE_FINAL_FIX.html` 파일의 코드를 홈페이지 `<head>` 태그 안에 추가하세요.

**이 방법이 가장 확실합니다!** Supabase 클라이언트를 사용하면 RLS가 자동으로 올바르게 처리됩니다.

#### 적용 방법:
1. 홈페이지 HTML 파일 열기
2. `<head>` 태그 안에 `HOMEPAGE_FINAL_FIX.html` 내용 추가
3. 저장 후 배포

### 방법 2: RLS 정책을 완전히 재설정

Supabase Dashboard → SQL Editor에서 다음 쿼리 실행:

```sql
-- 1. 모든 정책 삭제
DO $$ 
DECLARE r RECORD;
BEGIN
    FOR r IN (SELECT policyname FROM pg_policies WHERE schemaname = 'public' AND tablename = 'inquiries') 
    LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON inquiries';
    END LOOP;
END $$;

-- 2. RLS 재설정
ALTER TABLE inquiries DISABLE ROW LEVEL SECURITY;
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- 3. INSERT 정책 생성 (가장 단순하게)
CREATE POLICY "insert_allow_all"
  ON inquiries FOR INSERT
  TO public
  WITH CHECK (true);

-- 4. 확인
SELECT policyname, cmd, roles FROM pg_policies WHERE tablename = 'inquiries' AND cmd = 'INSERT';
```

**주의**: `TO public`은 모든 역할을 허용합니다. 보안에 주의하세요.

### 방법 3: Edge Function 사용 (RLS 완전 우회)

`BYPASS_RLS_EDGE_FUNCTION.sql` 파일을 참고하여 Edge Function을 생성하세요.

이 방법은 RLS를 완전히 우회하므로 보안에 주의해야 합니다.

## 즉시 시도할 것

1. **`HOMEPAGE_FINAL_FIX.html` 코드를 홈페이지에 추가** ← 가장 확실함!
2. 홈페이지 새로고침
3. 테스트

## 왜 이 방법이 작동하는가?

현재 홈페이지에서 Fetch API를 직접 사용하고 있는데, 이 경우 Supabase가 요청을 올바르게 인식하지 못할 수 있습니다.

Supabase 클라이언트를 사용하면:
- RLS가 자동으로 올바르게 처리됨
- 인증 토큰이 자동으로 포함됨
- 에러 처리가 더 명확함

## 문제가 계속되면

1. Supabase Dashboard → Table Editor → inquiries → Policies 확인
2. INSERT 정책이 있는지 확인
3. 정책의 `roles`에 `anon`이 포함되어 있는지 확인
4. `with_check`가 `true`인지 확인

## 최종 확인

다음 조건을 모두 만족해야 합니다:
- ✅ Supabase 클라이언트 라이브러리가 로드됨
- ✅ `submitInquiry` 함수가 Supabase 클라이언트를 사용함
- ✅ INSERT 정책이 존재함
- ✅ 정책이 `anon` 역할을 허용함

**`HOMEPAGE_FINAL_FIX.html` 코드를 홈페이지에 추가하는 것이 가장 확실한 해결책입니다!**

