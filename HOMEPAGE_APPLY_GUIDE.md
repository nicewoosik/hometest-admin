# 홈페이지 코드 적용 가이드

## 현재 문제

홈페이지에 Supabase 설정 변수만 있고, 실제로 Supabase 클라이언트를 사용하는 코드가 없습니다.

## 해결 방법

### 방법 1: 기존 코드 교체 (권장)

`HOMEPAGE_COMPLETE_CODE.js` 파일의 전체 내용을 복사하여 홈페이지의 기존 스크립트를 교체하세요.

**기존 코드:**
```javascript
<script type="text/javascript">
var SUPABASE_URL = 'https://qzymoraaukwicqlhjbsy.supabase.co'
var SUPABASE_ANON_KEY = 'sb_publishable_9h5TGNNrnzpjvWCu_CYxVg_VuOC7XFr'
</script>
```

**새 코드:**
`HOMEPAGE_COMPLETE_CODE.js` 파일의 전체 내용으로 교체

### 방법 2: 기존 코드에 추가

기존 코드를 유지하고, 그 아래에 다음 코드를 추가:

```html
<!-- Supabase 클라이언트 라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>

<script type="text/javascript">
// 기존 코드 유지
var SUPABASE_URL = 'https://qzymoraaukwicqlhjbsy.supabase.co'
var SUPABASE_ANON_KEY = 'sb_publishable_9h5TGNNrnzpjvWCu_CYxVg_VuOC7XFr'

// Supabase 클라이언트 초기화
var supabaseClient = null;

function initializeSupabase() {
  if (typeof window.supabase !== 'undefined') {
    supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
      auth: {
        persistSession: false,
        autoRefreshToken: false,
      },
    });
    console.log('Supabase 클라이언트 초기화 완료');
  }
}

// submitInquiry 함수 교체
async function submitInquiry(formData) {
  console.log('문의 제출 시작:', formData);
  
  if (!supabaseClient && typeof window.supabase !== 'undefined') {
    initializeSupabase();
  }
  
  const inquiryData = {
    name: formData.wr_name || formData.get('name'),
    company: formData.wr_subject || formData.get('company') || null,
    email: formData.wr_email || formData.get('email'),
    phone: formData.wr_2 || formData.get('phone') || null,
    content: formData.wr_content || formData.get('content'),
    status: 'new'
  };

  try {
    if (supabaseClient) {
      const { data, error } = await supabaseClient
        .from('inquiries')
        .insert([inquiryData])
        .select();

      if (error) {
        console.error('Supabase 에러:', error);
        throw new Error(error.message || '문의 접수 실패');
      }

      return { success: true, data };
    } else {
      // 폴백: Fetch API 사용
      const response = await fetch(`${SUPABASE_URL}/rest/v1/inquiries`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'apikey': SUPABASE_ANON_KEY,
          'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
          'Prefer': 'return=representation'
        },
        body: JSON.stringify(inquiryData)
      });

      const responseText = await response.text();
      let responseData = JSON.parse(responseText);

      if (!response.ok) {
        throw new Error(responseData.message || `HTTP ${response.status}`);
      }

      return { success: true, data: responseData };
    }
  } catch (error) {
    console.error('문의 접수 오류:', error);
    throw error;
  }
}

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
  if (typeof window.supabase !== 'undefined') {
    initializeSupabase();
  }
  window.submitInquiry = submitInquiry;
});
</script>
```

## 적용 후 확인

1. 홈페이지 새로고침 (캐시 삭제: Cmd+Shift+R)
2. 브라우저 콘솔(F12)에서 다음 메시지 확인:
   - "Supabase 클라이언트 초기화 완료"
   - "submitInquiry 함수 교체 완료"
3. 간편문의 폼 제출 테스트
4. 콘솔에서 "성공:" 메시지 확인

## 문제 해결

### Supabase 클라이언트가 로드되지 않는 경우

1. 네트워크 탭에서 `@supabase/supabase-js@2` 로드 확인
2. CDN이 차단되었는지 확인
3. 다른 CDN 사용: `https://unpkg.com/@supabase/supabase-js@2`

### 여전히 오류가 발생하는 경우

브라우저 콘솔의 에러 메시지를 확인하고 알려주세요.

