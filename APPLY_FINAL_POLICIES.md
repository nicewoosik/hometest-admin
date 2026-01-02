# 최종 RLS 정책 적용 가이드

## 완료된 작업
- ✅ 계정 관리 페이지 정상 작동
- ✅ 간편문의 페이지 정상 작동

## 다음 단계: 최종 정책 적용

임시 정책을 올바른 정책으로 교체해야 합니다.

### 1. admin_users 테이블 정책 적용

`FINAL_ADMIN_USERS_RLS_POLICY.sql` 파일을 Supabase Dashboard → SQL Editor에서 실행하세요.

이 정책은:
- 관리자만 `admin_users` 테이블 조회/수정/삭제 가능
- 관리자만 새 계정 생성 가능

### 2. inquiries 테이블 정책 적용

`FINAL_INQUIRIES_RLS_POLICY.sql` 파일을 Supabase Dashboard → SQL Editor에서 실행하세요.

이 정책은:
- 관리자만 `inquiries` 테이블 조회/수정/삭제 가능
- 모든 사용자(익명 포함)가 문의 생성 가능

## 실행 순서

1. `FINAL_ADMIN_USERS_RLS_POLICY.sql` 실행
2. `FINAL_INQUIRIES_RLS_POLICY.sql` 실행
3. 어드민 패널 새로고침
4. 두 페이지 모두 정상 작동 확인

## 확인 사항

정책 적용 후:
- 계정 관리 페이지에서 계정 목록이 표시되는지 확인
- 간편문의 페이지에서 문의 목록이 표시되는지 확인
- 브라우저 콘솔에 에러가 없는지 확인

## 완료!

모든 정책이 올바르게 적용되면:
- ✅ 보안: 관리자만 데이터 조회/수정/삭제 가능
- ✅ 기능: 모든 기능 정상 작동
- ✅ 익명 사용자: 홈페이지에서 문의 생성 가능

