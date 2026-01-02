// 홈페이지 간편문의 제출 코드 (수정 버전)
// 이 코드를 홈페이지에 적용하세요

// ============================================
// 방법 1: Supabase 클라이언트 사용 (권장) ⭐
// ============================================
// CDN을 사용하는 경우 (HTML에 추가)
// <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>

async function submitInquiryWithSupabaseClient(formData) {
  // Supabase 클라이언트 초기화
  const { createClient } = supabase;
  const supabaseUrl = 'https://qzymoraaukwicqlhjbsy.supabase.co';
  const supabaseAnonKey = 'sb_publishable_9h5TGNNrnzpjvWCu_CYxVg_VuOC7XFr';
  
  const supabaseClient = createClient(supabaseUrl, supabaseAnonKey, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
    },
  });

  const inquiryData = {
    name: formData.get('name') || formData.wr_name,
    company: formData.get('company') || formData.wr_subject || null,
    email: formData.get('email') || formData.wr_email,
    phone: formData.get('phone') || formData.wr_2 || null,
    content: formData.get('content') || formData.wr_content,
    status: 'new'
  };

  try {
    const { data, error } = await supabaseClient
      .from('inquiries')
      .insert([inquiryData])
      .select();

    if (error) {
      console.error('Supabase 에러:', error);
      throw error;
    }

    return { success: true, data };
  } catch (error) {
    console.error('문의 접수 오류:', error);
    throw error;
  }
}

// ============================================
// 방법 2: Fetch API 사용 (수정 버전)
// ============================================
async function submitInquiryWithFetch(formData) {
  const inquiryData = {
    name: formData.get('name') || formData.wr_name,
    company: formData.get('company') || formData.wr_subject || null,
    email: formData.get('email') || formData.wr_email,
    phone: formData.get('phone') || formData.wr_2 || null,
    content: formData.get('content') || formData.wr_content,
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

    // 응답 본문을 먼저 읽어야 함
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

    return { success: true, data: responseData };
  } catch (error) {
    console.error('Fetch 에러:', error);
    throw error;
  }
}

// ============================================
// 통합 함수 (사용 예시)
// ============================================
async function submitInquiry(formElement) {
  const formData = new FormData(formElement);
  
  // 방법 1: Supabase 클라이언트 사용 (권장)
  // return await submitInquiryWithSupabaseClient(formData);
  
  // 방법 2: Fetch API 사용
  return await submitInquiryWithFetch(formData);
}

// 폼 제출 이벤트 리스너 예시
document.addEventListener('DOMContentLoaded', function() {
  const inquiryForm = document.getElementById('inquiry-form') || 
                     document.querySelector('form[onsubmit*="checkFrm"]');
  
  if (inquiryForm) {
    inquiryForm.addEventListener('submit', async function(e) {
      e.preventDefault();
      
      const submitButton = inquiryForm.querySelector('button[type="submit"]');
      const originalText = submitButton ? submitButton.textContent : '';
      
      if (submitButton) {
        submitButton.disabled = true;
        submitButton.textContent = '제출 중...';
      }

      try {
        const result = await submitInquiry(inquiryForm);
        
        if (result.success) {
          alert('문의가 접수되었습니다. 빠른 시일 내에 답변드리겠습니다.');
          inquiryForm.reset();
        }
      } catch (error) {
        console.error('문의 접수 오류:', error);
        alert('문의 접수 중 오류가 발생했습니다. 다시 시도해주세요.\n오류: ' + error.message);
      } finally {
        if (submitButton) {
          submitButton.disabled = false;
          submitButton.textContent = originalText;
        }
      }
    });
  }
});

