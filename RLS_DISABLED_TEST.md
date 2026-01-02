# RLS 비활성화 테스트 가이드

## 현재 상황
Supabase 클라이언트는 올바르게 작동하지만 RLS 정책 위반이 계속 발생합니다.

## 해결 방법

### Step 1: RLS 완전 비활성화

**`COMPLETE_DISABLE_RLS.sql` 파일을 Supabase Dashboard → SQL Editor에서 실행하세요.**

이렇게 하면:
- 모든 정책 삭제
- RLS 완전 비활성화
- INSERT가 즉시 작동해야 함

### Step 2: 테스트

1. SQL 실행 완료 확인
2. 홈페이지 새로고침 (캐시 삭제: Cmd+Shift+R)
3. 간편문의 폼 제출 테스트
4. 성공하면 RLS 정책 문제임을 확인

### Step 3: RLS 재활성화 및 정책 설정

테스트가 성공하면, RLS를 다시 활성화하고 올바른 정책을 설정하세요:

```sql
-- RLS 재활성화
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- INSERT 정책 생성 (public으로 설정)
CREATE POLICY "insert_public_all"
  ON inquiries FOR INSERT
  TO public
  WITH CHECK (true);

-- SELECT 정책 (관리자만)
CREATE POLICY "select_admin_only"
  ON inquiries FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE auth_user_id = auth.uid()
    )
  );
```

## 확인

SQL 실행 후 다음 쿼리로 확인:

```sql
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'inquiries';
```

**예상 결과:**
- `rowsecurity`: `false` (RLS 비활성화됨)

## 중요

- ⚠️ RLS를 비활성화하면 보안이 약해집니다
- ✅ 테스트 후 반드시 RLS를 다시 활성화하세요
- ✅ 올바른 정책을 설정하세요

**`COMPLETE_DISABLE_RLS.sql`을 실행한 후 홈페이지에서 테스트해보세요!**

