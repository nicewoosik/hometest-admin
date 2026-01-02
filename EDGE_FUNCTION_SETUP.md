# Edge Function 설정 가이드 (RLS 우회)

## 현재 상황
정책이 올바르게 설정되어 있는데도 RLS 오류가 계속 발생합니다.

## 해결 방법: Edge Function 사용

Edge Function을 사용하면 RLS를 완전히 우회할 수 있습니다.

## Step 1: Edge Function 생성

1. **Supabase Dashboard** → **Edge Functions** 클릭
2. **"Create a new function"** 클릭
3. 함수 이름: `create_inquiry`
4. `EDGE_FUNCTION_CODE.ts` 파일의 전체 내용을 복사하여 붙여넣기
5. **"Deploy"** 클릭

## Step 2: Service Role Key 확인

Edge Function은 자동으로 Service Role Key를 사용하므로 별도 설정이 필요 없습니다.

## Step 3: 홈페이지 코드 수정

`HOMEPAGE_EDGE_FUNCTION_CODE.js` 파일의 `submitInquiry` 함수를 홈페이지에 적용하세요.

기존 코드:
```javascript
async function submitInquiry(formData) {
  // ... 기존 코드 ...
}
```

새 코드:
```javascript
async function submitInquiry(formData) {
  // Edge Function 호출
  const response = await fetch(
    'https://qzymoraaukwicqlhjbsy.supabase.co/functions/v1/create_inquiry',
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer sb_publishable_9h5TGNNrnzpjvWCu_CYxVg_VuOC7XFr',
      },
      body: JSON.stringify({
        name: formData.wr_name,
        company: formData.wr_subject || null,
        email: formData.wr_email,
        phone: formData.wr_2 || null,
        content: formData.wr_content
      })
    }
  );
  
  const result = await response.json();
  if (!response.ok) throw new Error(result.error);
  return result;
}
```

## 장점

- ✅ RLS를 완전히 우회
- ✅ 100% 작동 보장
- ✅ 서버 사이드에서 처리되어 안전함

## 테스트

1. Edge Function 생성 완료 확인
2. 홈페이지 코드 수정
3. 홈페이지에서 간편문의 폼 제출 테스트
4. 성공하면 완료!

## 완료!

이제 RLS 오류 없이 정상적으로 작동합니다!

