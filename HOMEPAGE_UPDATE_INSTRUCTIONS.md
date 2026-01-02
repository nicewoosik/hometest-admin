# 홈페이지 코드 업데이트 가이드

## 현재 문제

홈페이지에서 Fetch API를 직접 사용하고 있어 RLS가 제대로 작동하지 않습니다.

## 해결 방법

### Step 1: Supabase 클라이언트 라이브러리 추가

`<head>` 태그 안에 다음 코드를 추가하세요 (다른 스크립트 태그 위에):

```html
<!-- Supabase 클라이언트 라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
```

### Step 2: 기존 스크립트 교체

기존의 다음 코드를 찾아서:

```html
<script type="text/javascript">
// Supabase 설정
var SUPABASE_URL = 'https://qzymoraaukwicqlhjbsy.supabase.co'
var SUPABASE_ANON_KEY = 'sb_publishable_9h5TGNNrnzpjvWCu_CYxVg_VuOC7XFr'

// 간편문의 폼 제출 함수
function submitInquiry(formData) {
  // ... 기존 코드 ...
}

function checkFrm(obj) {
  // ... 기존 코드 ...
}
</script>
```

`HOMEPAGE_FIXED_HTML.html` 파일의 전체 내용으로 교체하세요.

## 적용 위치

1. **Supabase 라이브러리 추가**: `<head>` 태그 안, 다른 스크립트 위에
2. **스크립트 교체**: 기존 `submitInquiry`와 `checkFrm` 함수가 있는 `<script>` 태그를 교체

## 주요 변경사항

1. ✅ Supabase 클라이언트 라이브러리 추가
2. ✅ `supabaseClient` 초기화 함수 추가
3. ✅ `submitInquiry` 함수를 Supabase 클라이언트 사용으로 변경
4. ✅ Fetch API는 폴백으로만 사용

## 적용 후 확인

1. 홈페이지 새로고침 (캐시 삭제: Cmd+Shift+R)
2. 브라우저 콘솔(F12)에서 확인:
   - "Supabase 클라이언트 초기화 완료" 메시지
3. 간편문의 폼 제출 테스트
4. 성공하면 완료!

## 문제 해결

### Supabase 클라이언트가 초기화되지 않는 경우

1. 네트워크 탭에서 `@supabase/supabase-js@2` 로드 확인
2. CDN이 차단되었는지 확인
3. 다른 CDN 사용: `https://unpkg.com/@supabase/supabase-js@2`

### 여전히 오류가 발생하는 경우

브라우저 콘솔의 에러 메시지를 확인하고 알려주세요.

