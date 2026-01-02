# RLS 정책 확인 가이드

## 1. Supabase Dashboard에서 확인

### 방법 1: Table Editor에서 확인
1. Supabase Dashboard → **Table Editor** 이동
2. 각 테이블(`inquiries`, `job_postings`, `job_applications`, `admin_users`) 선택
3. 테이블 이름 옆에 **🔒 자물쇠 아이콘**이 있으면 RLS가 활성화된 것입니다

### 방법 2: Authentication → Policies에서 확인
1. Supabase Dashboard → **Authentication** → **Policies** 이동
2. 각 테이블별로 정책이 생성되어 있는지 확인
3. 정책 이름이 다음과 같이 보여야 합니다:
   - `관리자는 모든 inquiries 조회 가능`
   - `관리자는 inquiries 수정 가능`
   - `관리자는 inquiries 삭제 가능`
   - `모든 사용자는 inquiries 생성 가능`
   - 등등...

## 2. SQL 쿼리로 확인

`RLS_VERIFICATION.sql` 파일의 쿼리를 Supabase Dashboard → **SQL Editor**에서 실행하세요.

### 확인 항목:
1. **RLS 활성화 여부**: `rls_enabled` 컬럼이 `true`인지 확인
2. **정책 목록**: 각 테이블에 정책이 생성되어 있는지 확인
3. **is_admin() 함수**: 함수가 생성되었는지 확인
4. **현재 사용자 권한**: 로그인한 사용자가 관리자인지 확인

## 3. 프론트엔드에서 테스트

### 테스트 시나리오:

#### ✅ 정상 동작 (관리자로 로그인한 경우)
1. 관리자 계정으로 로그인
2. `/inquiries` 페이지 접속
3. 문의 목록이 정상적으로 표시되어야 함
4. 브라우저 콘솔에 에러가 없어야 함

#### ❌ 에러 발생 (비관리자로 로그인한 경우)
1. 일반 사용자 계정으로 로그인 (admin_users 테이블에 없는 계정)
2. `/inquiries` 페이지 접속
3. "접근 권한이 없습니다" 에러 메시지 표시
4. 브라우저 콘솔에 RLS 관련 에러 확인

#### ✅ 정상 동작 (비로그인 상태)
1. 로그아웃 상태
2. 홈페이지에서 간편문의 폼 제출
3. 문의가 정상적으로 생성되어야 함 (INSERT는 anon 허용)

## 4. admin_users 테이블에 사용자 추가

**중요**: 관리자 권한을 받으려면 `admin_users` 테이블에 사용자를 추가해야 합니다!

```sql
-- 현재 로그인한 사용자의 UUID를 확인
SELECT auth.uid() as current_user_id;

-- admin_users 테이블에 관리자 추가
INSERT INTO admin_users (auth_user_id, email, name, role)
VALUES (
  auth.uid(),  -- 위에서 확인한 UUID 사용
  'admin@ecstel.co.kr',
  '관리자',
  'admin'
);
```

또는 Supabase Dashboard → **Table Editor** → **admin_users**에서 직접 추가:
- `auth_user_id`: Supabase Auth에서 사용자 UUID 복사
- `email`: 사용자 이메일
- `name`: 사용자 이름
- `role`: `admin` 또는 `manager`

## 5. 문제 해결

### 문제: "접근 권한이 없습니다" 에러 발생
**원인**: `admin_users` 테이블에 현재 사용자가 없음
**해결**: 위의 4번 항목 참조하여 사용자 추가

### 문제: RLS 정책이 보이지 않음
**원인**: SQL 스키마가 제대로 실행되지 않음
**해결**: `DATABASE_SCHEMA.sql` 파일을 다시 실행

### 문제: is_admin() 함수가 없다는 에러
**원인**: 함수가 생성되지 않음
**해결**: `DATABASE_SCHEMA.sql`의 함수 생성 부분만 다시 실행

```sql
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM admin_users
    WHERE auth_user_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

## 6. 브라우저 개발자 도구 확인

1. **F12** 또는 **우클릭 → 검사** 열기
2. **Console** 탭에서 에러 메시지 확인
3. **Network** 탭에서 Supabase API 요청 확인
   - 요청 헤더에 `Authorization: Bearer ...` 토큰이 포함되어 있는지 확인
   - 응답 상태 코드 확인 (403 = 권한 없음, 200 = 성공)

## 체크리스트

- [ ] RLS가 모든 테이블에 활성화되어 있음
- [ ] 각 테이블에 정책이 생성되어 있음
- [ ] `is_admin()` 함수가 생성되어 있음
- [ ] `admin_users` 테이블에 관리자 계정이 추가되어 있음
- [ ] 관리자로 로그인 시 데이터 조회 가능
- [ ] 비관리자로 로그인 시 접근 거부됨
- [ ] 비로그인 상태에서도 문의 생성 가능 (INSERT)

