# Edge Function 생성 단계별 가이드

## Step 1: Edge Function 생성

1. **Supabase Dashboard** → **Edge Functions** 클릭
2. **"Create a new function"** 버튼 클릭
3. 함수 이름 입력: `create_inquiry`
4. **"Deploy"** 클릭 (기본 코드는 나중에 수정)

## Step 2: 코드 수정

1. 생성된 함수를 클릭하여 편집 모드로 진입
2. 기존 코드를 모두 삭제
3. `EDGE_FUNCTION_CODE.ts` 파일의 전체 내용을 복사하여 붙여넣기
4. **"Deploy"** 클릭

## Step 3: 확인

Edge Function이 생성되면:
- 함수 목록에 `create_inquiry`가 표시됨
- 상태가 "Active"로 표시됨

## Step 4: 테스트

홈페이지에서 간편문의 폼을 제출해보세요. 이제 정상적으로 작동해야 합니다!

## 완료!

- ✅ 홈페이지 코드 수정 완료
- ✅ Edge Function 생성 필요
- ✅ 배포 완료 (Git push 후)

**Edge Function을 생성한 후 테스트해보세요!**

