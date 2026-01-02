# 홈페이지 간편문의 연동 가이드

## 개요
홈페이지에서 간편문의를 제출하면 Supabase `inquiries` 테이블에 자동으로 저장되고, 관리자 페이지에서 확인할 수 있습니다.

## 홈페이지에 추가할 코드

### HTML 폼 예시

```html
<form id="inquiry-form" class="inquiry-form">
  <div>
    <label for="name">이름 *</label>
    <input type="text" id="name" name="name" required />
  </div>
  
  <div>
    <label for="company">회사명 *</label>
    <input type="text" id="company" name="company" required />
  </div>
  
  <div>
    <label for="email">메일주소 *</label>
    <input type="email" id="email" name="email" required />
  </div>
  
  <div>
    <label for="phone">연락처</label>
    <input type="tel" id="phone" name="phone" />
  </div>
  
  <div>
    <label for="content">문의내용 *</label>
    <textarea id="content" name="content" required></textarea>
  </div>
  
  <div>
    <input type="checkbox" id="privacy" name="privacy" required />
    <label for="privacy">개인정보 취급방침 동의</label>
  </div>
  
  <button type="submit">문의하기</button>
</form>
```

### JavaScript 코드 (Supabase 클라이언트 사용)

```javascript
// Supabase 클라이언트 초기화 (홈페이지에 추가)
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://qzymoraaukwicqlhjbsy.supabase.co'
const supabaseAnonKey = 'sb_publishable_9h5TGNNrnzpjvWCu_CYxVg_VuOC7XFr'

const supabase = createClient(supabaseUrl, supabaseAnonKey)

// 폼 제출 핸들러
document.getElementById('inquiry-form').addEventListener('submit', async (e) => {
  e.preventDefault()
  
  const formData = new FormData(e.target)
  
  const inquiryData = {
    name: formData.get('name'),
    company: formData.get('company'),
    email: formData.get('email'),
    phone: formData.get('phone') || null,
    content: formData.get('content'),
    status: 'new' // 기본값: 신규
  }
  
  try {
    const { data, error } = await supabase
      .from('inquiries')
      .insert([inquiryData])
      .select()
    
    if (error) {
      throw error
    }
    
    alert('문의가 접수되었습니다. 빠른 시일 내에 답변드리겠습니다.')
    e.target.reset()
  } catch (error) {
    console.error('문의 접수 오류:', error)
    alert('문의 접수 중 오류가 발생했습니다. 다시 시도해주세요.')
  }
})
```

### 또는 Fetch API 사용 (Supabase 없이)

```javascript
// Supabase REST API 직접 호출
document.getElementById('inquiry-form').addEventListener('submit', async (e) => {
  e.preventDefault()
  
  const formData = new FormData(e.target)
  
  const inquiryData = {
    name: formData.get('name'),
    company: formData.get('company'),
    email: formData.get('email'),
    phone: formData.get('phone') || null,
    content: formData.get('content'),
    status: 'new'
  }
  
  try {
    const response = await fetch(
      'https://qzymoraaukwicqlhjbsy.supabase.co/rest/v1/inquiries',
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'apikey': 'sb_publishable_9h5TGNNrnzpjvWCu_CYxVg_VuOC7XFr',
          'Authorization': 'Bearer sb_publishable_9h5TGNNrnzpjvWCu_CYxVg_VuOC7XFr',
          'Prefer': 'return=representation'
        },
        body: JSON.stringify(inquiryData)
      }
    )
    
    if (!response.ok) {
      throw new Error('문의 접수 실패')
    }
    
    alert('문의가 접수되었습니다. 빠른 시일 내에 답변드리겠습니다.')
    e.target.reset()
  } catch (error) {
    console.error('문의 접수 오류:', error)
    alert('문의 접수 중 오류가 발생했습니다. 다시 시도해주세요.')
  }
})
```

## RLS (Row Level Security) 정책 확인

Supabase Dashboard에서 `inquiries` 테이블의 RLS 정책이 다음과 같이 설정되어 있는지 확인:

1. **모든 사용자는 INSERT 가능** (anon, authenticated 모두)
2. **인증된 사용자(관리자)만 SELECT 가능**

이미 `DATABASE_SCHEMA.sql`에 포함되어 있습니다.

## 테스트 방법

1. 홈페이지에서 간편문의 폼 제출
2. 관리자 페이지 → 간편문의 메뉴에서 확인
3. 상태 변경 (신규 → 처리중 → 완료) 테스트


