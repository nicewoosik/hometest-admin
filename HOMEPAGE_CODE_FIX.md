# 홈페이지 코드 수정 가이드

## 문제점

현재 홈페이지에서 Fetch API를 사용하여 Supabase REST API를 직접 호출하고 있는데, RLS 정책이 올바르게 작동하지 않을 수 있습니다.

## 해결 방법

### 방법 1: Supabase 클라이언트 사용 (권장) ⭐

Supabase 클라이언트 라이브러리를 사용하면 RLS가 자동으로 올바르게 처리됩니다.

#### HTML에 추가:

```html
<!-- Supabase 클라이언트 라이브러리 추가 -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>

<!-- 또는 ES6 모듈 사용 -->
<script type="module">
  import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm';
  
  const supabaseUrl = 'https://qzymoraaukwicqlhjbsy.supabase.co';
  const supabaseAnonKey = 'sb_publishable_9h5TGNNrnzpjvWCu_CYxVg_VuOC7XFr';
  
  const supabase = createClient(supabaseUrl, supabaseAnonKey, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
    },
  });

  // 폼 제출 함수
  async function submitInquiry(formData) {
    const inquiryData = {
      name: formData.get('name') || formData.wr_name,
      company: formData.get('company') || formData.wr_subject || null,
      email: formData.get('email') || formData.wr_email,
      phone: formData.get('phone') || formData.wr_2 || null,
      content: formData.get('content') || formData.wr_content,
      status: 'new'
    };

    const { data, error } = await supabase
      .from('inquiries')
      .insert([inquiryData])
      .select();

    if (error) throw error;
    return data;
  }

  // 폼 제출 이벤트
  document.querySelector('form').addEventListener('submit', async (e) => {
    e.preventDefault();
    try {
      await submitInquiry(new FormData(e.target));
      alert('문의가 접수되었습니다.');
      e.target.reset();
    } catch (error) {
      console.error('오류:', error);
      alert('문의 접수 중 오류가 발생했습니다.');
    }
  });
</script>
```

### 방법 2: Fetch API 수정 버전

현재 코드를 수정해야 합니다.

#### 문제가 있는 코드:
```javascript
// ❌ 문제: 응답을 제대로 처리하지 않음
const response = await fetch(url, options);
if (!response.ok) {
  throw new Error('문의 접수 실패');
}
```

#### 수정된 코드:
```javascript
// ✅ 수정: 응답 본문을 먼저 읽고 에러 처리
const response = await fetch(url, options);
const responseText = await response.text();
let responseData;

try {
  responseData = JSON.parse(responseText);
} catch (e) {
  responseData = { message: responseText };
}

if (!response.ok) {
  console.error('응답 상태:', response.status);
  console.error('응답 본문:', responseData);
  throw new Error(responseData.message || `HTTP ${response.status}`);
}
```

### 방법 3: 현재 코드 수정

현재 홈페이지의 `submitInquiry` 함수를 다음과 같이 수정하세요:

```javascript
async function submitInquiry(formData) {
  const inquiryData = {
    name: formData.wr_name,
    company: formData.wr_subject || null,
    email: formData.wr_email,
    phone: formData.wr_2 || null,
    content: formData.wr_content,
    status: 'new'
  };

  const supabaseUrl = 'https://qzymoraaukwicqlhjbsy.supabase.co';
  const supabaseAnonKey = 'sb_publishable_9h5TGNNrnzpjvWCu_CYxVg_VuOC7XFr';

  try {
    const response = await fetch(`${supabaseUrl}/rest/v1/inquiries`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'apikey': supabaseAnonKey,
        'Authorization': `Bearer ${supabaseAnonKey}`,
        'Prefer': 'return=representation'
      },
      body: JSON.stringify(inquiryData)
    });

    // 응답 본문 먼저 읽기
    const responseText = await response.text();
    let responseData;
    
    try {
      responseData = JSON.parse(responseText);
    } catch (e) {
      responseData = { message: responseText };
    }

    if (!response.ok) {
      console.error('=== Supabase 응답 정보 ===');
      console.error('응답 상태:', response.status);
      console.error('응답 본문 (텍스트):', responseText);
      console.error('응답 본문 (JSON):', responseData);
      console.error('에러 코드:', responseData.code);
      console.error('에러 메시지:', responseData.message);
      
      throw new Error(responseData.message || `HTTP ${response.status}`);
    }

    return { success: true, data: responseData };
  } catch (error) {
    console.error('문의 접수 오류:', error);
    throw error;
  }
}
```

## 주요 수정 사항

1. **응답 본문을 먼저 읽기**: `response.text()`를 먼저 호출하여 응답 본문을 읽습니다.
2. **에러 메시지 상세 출력**: RLS 오류를 더 명확하게 확인할 수 있습니다.
3. **데이터 형식 확인**: `null` 값 처리를 명확히 합니다.

## 테스트

수정 후:
1. 브라우저 콘솔에서 에러 메시지 확인
2. Network 탭에서 요청/응답 확인
3. Supabase Dashboard에서 데이터 확인

## 추가 확인 사항

만약 여전히 문제가 발생한다면:

1. **Supabase 프로젝트 설정 확인**
   - Settings → API → Row Level Security 확인
   - 전역 RLS 설정이 활성화되어 있는지 확인

2. **정책 확인**
   ```sql
   SELECT policyname, cmd, roles, with_check
   FROM pg_policies
   WHERE tablename = 'inquiries' AND cmd = 'INSERT';
   ```

3. **테이블 구조 확인**
   - 모든 필수 필드가 포함되어 있는지 확인
   - 데이터 타입이 일치하는지 확인

