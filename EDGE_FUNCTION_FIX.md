# Edge Function 인증 문제 해결

## 문제
401 "Invalid JWT" 에러가 발생합니다. Supabase Edge Function이 인증을 요구하고 있습니다.

## 해결 방법

### 방법 1: Edge Function 인증 설정 확인 (권장)

Supabase Dashboard에서:
1. **Edge Functions** → **create_inquiry** 클릭
2. **Settings** 탭 클릭
3. **"Verify JWT"** 옵션이 켜져 있으면 **끄기**
4. **Deploy** 클릭

### 방법 2: Edge Function 코드 업데이트

`EDGE_FUNCTION_CODE.ts` 파일의 최신 버전을 복사하여 Edge Function에 붙여넣고 Deploy하세요.

### 방법 3: 환경 변수 확인

Edge Function이 다음 환경 변수를 가지고 있는지 확인:
- `SUPABASE_URL`: `https://qzymoraaukwicqlhjbsy.supabase.co`
- `SUPABASE_SERVICE_ROLE_KEY`: Supabase Dashboard → Settings → API → service_role key

환경 변수는 Edge Function 생성 시 자동으로 설정되지만, 확인이 필요합니다.

## 테스트

코드 업데이트 후:
1. 홈페이지 새로고침
2. 간편문의 폼 제출
3. 콘솔에서 성공 메시지 확인

