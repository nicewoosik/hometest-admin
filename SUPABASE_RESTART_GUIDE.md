# Supabase 프로젝트 재시작 가이드

## 현재 상황
정책이 올바르게 설정되어 있는데도 여전히 RLS 오류가 발생합니다.

## 해결 방법

### Step 1: Supabase 프로젝트 재시작

1. **Supabase Dashboard** → **Settings** → **General**
2. 페이지 하단에서 **"Restart"** 버튼 클릭
3. 몇 분 대기 (프로젝트가 재시작됨)

이렇게 하면:
- 정책 캐시가 클리어됨
- RLS 설정이 재적용됨
- 프로젝트가 새로 시작됨

### Step 2: 정책 재확인

재시작 후 다음 쿼리로 정책을 다시 확인:

```sql
SELECT policyname, cmd, roles, with_check
FROM pg_policies
WHERE tablename = 'inquiries' AND cmd = 'INSERT';
```

### Step 3: 테스트

1. 프로젝트 재시작 완료 확인
2. 홈페이지 새로고침 (캐시 삭제)
3. 간편문의 폼 제출 테스트

## 추가 확인

### `FINAL_DIAGNOSIS.sql` 파일을 실행하세요.

이 쿼리는:
- 정책 상세 정보 확인
- RLS 활성화 상태 확인
- 모든 정책 확인 (충돌 확인)
- 테이블 권한 확인

## 문제가 계속되면

### Edge Function 사용 (최후의 수단)

`CREATE_EDGE_FUNCTION.md` 파일을 참고하여 Edge Function을 생성하세요.

이 방법은 RLS를 완전히 우회하므로 100% 작동합니다.

## 우선순위

1. **Supabase 프로젝트 재시작** ← 가장 먼저 시도
2. `FINAL_DIAGNOSIS.sql` 실행하여 상태 확인
3. Edge Function 사용

**Supabase 프로젝트를 재시작한 후 테스트해보세요!**

