# RLS 설정 성공 체크리스트

## ✅ 완료된 작업

- [x] RLS INSERT 정책 문제 해결
- [x] 홈페이지에서 간편문의 제출 성공

## 🔒 보안 설정 (다음 단계)

### 1. RLS 재활성화 (임시 비활성화한 경우)

만약 `TEMPORARY_DISABLE_RLS.sql`을 실행했다면, 반드시 RLS를 다시 활성화하세요:

**`ENABLE_RLS_WITH_POLICY.sql` 파일을 실행하세요.**

이 파일은:
- RLS를 활성화
- 적절한 보안 정책 생성
- INSERT는 anon/authenticated 허용
- SELECT/UPDATE/DELETE는 관리자만 허용

### 2. 정책 확인

다음 쿼리로 정책이 제대로 설정되었는지 확인:

```sql
SELECT policyname, cmd, roles 
FROM pg_policies 
WHERE tablename = 'inquiries'
ORDER BY cmd;
```

**예상 결과:**
- INSERT 정책: `allow_insert_inquiries` (anon, authenticated)
- SELECT 정책: `allow_select_inquiries_admin` (authenticated만, 관리자 체크)
- UPDATE 정책: `allow_update_inquiries_admin` (authenticated만, 관리자 체크)
- DELETE 정책: `allow_delete_inquiries_admin` (authenticated만, 관리자 체크)

### 3. admin_users 테이블에 관리자 추가

관리자 페이지에 접근하려면 `admin_users` 테이블에 사용자를 추가해야 합니다:

```sql
-- 현재 로그인한 사용자의 UUID 확인
SELECT auth.uid() as current_user_id;

-- admin_users 테이블에 추가
INSERT INTO admin_users (auth_user_id, email, name, role)
VALUES (
  auth.uid(),  -- 위에서 확인한 UUID
  'admin@ecstel.co.kr',
  '관리자',
  'admin'
);
```

또는 Supabase Dashboard → **Table Editor** → **admin_users**에서 직접 추가할 수 있습니다.

## 📋 최종 확인 사항

- [ ] RLS가 활성화되어 있음
- [ ] INSERT 정책이 생성되어 있음 (anon, authenticated 허용)
- [ ] SELECT/UPDATE/DELETE 정책이 생성되어 있음 (관리자만)
- [ ] 홈페이지에서 문의 제출 테스트 성공
- [ ] 관리자 페이지에서 문의 목록 조회 테스트 성공
- [ ] `admin_users` 테이블에 관리자 계정 추가됨

## 🎉 완료!

이제 시스템이 정상적으로 작동합니다:
- ✅ 홈페이지에서 비로그인 사용자도 문의 제출 가능
- ✅ 관리자만 문의 목록 조회 및 관리 가능
- ✅ 보안 정책이 적절히 설정됨

## 추가 개선 사항 (선택사항)

1. **이메일 알림**: 새 문의가 접수되면 관리자에게 이메일 발송
2. **상태 변경 알림**: 문의 상태가 변경되면 고객에게 알림
3. **문의 통계**: 대시보드에 문의 통계 추가
4. **검색 기능**: 문의 목록에서 검색 기능 추가

