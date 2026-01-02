# RLS INSERT 오류 수동 해결 가이드

## 문제 상황
SQL을 실행했지만 여전히 같은 오류가 발생합니다.

## 해결 방법 (Supabase Dashboard에서 직접 수정)

### 방법 1: Table Editor에서 정책 삭제 및 재생성

1. **Supabase Dashboard** → **Table Editor** → **inquiries** 테이블 선택
2. 왼쪽 사이드바에서 **"Policies"** 또는 **"RLS"** 클릭
3. **모든 정책을 수동으로 삭제**:
   - 각 정책 옆의 **삭제 버튼(휴지통 아이콘)** 클릭
   - 특히 INSERT 관련 정책 모두 삭제
4. **새 정책 생성**:
   - **"New Policy"** 또는 **"Add Policy"** 클릭
   - **Policy Name**: `allow_all_insert_inquiries`
   - **Allowed Operation**: `INSERT` 선택
   - **Target Roles**: `anon`과 `authenticated` 둘 다 체크
   - **USING expression**: (비워두기)
   - **WITH CHECK expression**: `true` 입력
   - **Save** 클릭

### 방법 2: SQL Editor에서 단계별 실행

#### Step 1: 정책 확인
```sql
SELECT policyname, cmd, roles 
FROM pg_policies 
WHERE tablename = 'inquiries' AND cmd = 'INSERT';
```

#### Step 2: 각 정책을 하나씩 삭제
```sql
DROP POLICY IF EXISTS "anon_insert_inquiries_policy" ON inquiries;
DROP POLICY IF EXISTS "anon_insert_inquiries" ON inquiries;
DROP POLICY IF EXISTS "모든 사용자는 inquiries 생성 가능" ON inquiries;
```

각각 실행하고 결과 확인

#### Step 3: 삭제 확인
```sql
SELECT COUNT(*) as remaining_policies
FROM pg_policies 
WHERE tablename = 'inquiries' AND cmd = 'INSERT';
```
결과가 `0`이어야 합니다.

#### Step 4: 새 정책 생성
```sql
CREATE POLICY "allow_all_insert_inquiries"
  ON inquiries
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);
```

#### Step 5: 생성 확인
```sql
SELECT policyname, cmd, roles 
FROM pg_policies 
WHERE tablename = 'inquiries' AND cmd = 'INSERT';
```

예상 결과:
- 정책이 **1개만** 있어야 함
- `policyname`: `allow_all_insert_inquiries`
- `roles`: `{anon,authenticated}`

### 방법 3: RLS 일시 비활성화 후 재활성화

혹시 정책 캐시 문제일 수 있습니다:

```sql
-- RLS 비활성화
ALTER TABLE inquiries DISABLE ROW LEVEL SECURITY;

-- 잠시 대기 (1-2초)

-- RLS 재활성화
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- INSERT 정책 생성
CREATE POLICY "allow_all_insert_inquiries"
  ON inquiries
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);
```

## 문제 진단

`DIAGNOSE_RLS_ISSUE.sql` 파일을 실행하여 현재 상태를 확인하세요.

## 추가 확인 사항

### 1. Supabase 프로젝트 설정
- **Settings** → **API** → **Row Level Security** 확인
- RLS가 전역적으로 활성화되어 있는지 확인

### 2. 테이블 권한 확인
```sql
SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_schema = 'public'
  AND table_name = 'inquiries';
```

### 3. 홈페이지 코드 확인
홈페이지에서 보내는 데이터 형식이 테이블 스키마와 일치하는지 확인:
- `name`: TEXT NOT NULL ✅
- `company`: TEXT (nullable) ✅
- `email`: TEXT NOT NULL ✅
- `phone`: TEXT (nullable) ✅
- `content`: TEXT NOT NULL ✅
- `status`: TEXT DEFAULT 'new' ✅

## 최종 체크리스트

- [ ] 모든 기존 INSERT 정책 삭제 완료
- [ ] INSERT 정책이 1개만 존재
- [ ] 정책의 `roles`에 `anon`과 `authenticated` 모두 포함
- [ ] 정책의 `with_check`가 `true`
- [ ] 홈페이지에서 테스트 후 오류 없음

## 여전히 문제가 있다면

1. **브라우저 캐시 삭제** 후 다시 시도
2. **Supabase 프로젝트 재시작** (Settings → General → Restart)
3. **Supabase 지원팀에 문의** (프로젝트 설정 문제일 수 있음)

