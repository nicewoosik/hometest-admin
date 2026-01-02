// 홈페이지에 추가할 완전한 코드
// 이 코드를 <head> 태그 안에 추가하거나, 기존 스크립트를 이 코드로 교체하세요

<script type="text/javascript">
// Supabase 클라이언트 라이브러리 로드
(function() {
  // Supabase 클라이언트가 이미 로드되어 있는지 확인
  if (typeof window.supabase === 'undefined') {
    var script = document.createElement('script');
    script.src = 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2';
    script.onload = function() {
      initializeSupabase();
    };
    document.head.appendChild(script);
  } else {
    initializeSupabase();
  }
})();

// Supabase 설정 및 초기화
var SUPABASE_URL = 'https://qzymoraaukwicqlhjbsy.supabase.co';
var SUPABASE_ANON_KEY = 'sb_publishable_9h5TGNNrnzpjvWCu_CYxVg_VuOC7XFr';
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

// 기존 submitInquiry 함수를 완전히 교체
async function submitInquiry(formData) {
  console.log('문의 제출 시작:', formData);
  
  // Supabase 클라이언트가 초기화되지 않았다면 초기화
  if (!supabaseClient && typeof window.supabase !== 'undefined') {
    initializeSupabase();
  }
  
  // 데이터 변환
  const inquiryData = {
    name: formData.wr_name || formData.get('name'),
    company: formData.wr_subject || formData.get('company') || null,
    email: formData.wr_email || formData.get('email'),
    phone: formData.wr_2 || formData.get('phone') || null,
    content: formData.wr_content || formData.get('content'),
    status: 'new'
  };

  console.log('전송할 데이터:', inquiryData);

  try {
    // Supabase 클라이언트를 사용하여 데이터 삽입
    if (supabaseClient) {
      const { data, error } = await supabaseClient
        .from('inquiries')
        .insert([inquiryData])
        .select();

      if (error) {
        console.error('Supabase 에러:', error);
        throw new Error(error.message || '문의 접수 실패');
      }

      console.log('성공:', data);
      return { success: true, data };
    } else {
      // Supabase 클라이언트가 없으면 Fetch API 사용 (폴백)
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
    }
  } catch (error) {
    console.error('문의 접수 오류:', error);
    throw error;
  }
}

// 페이지 로드 시 기존 함수 오버라이드
document.addEventListener('DOMContentLoaded', function() {
  console.log('페이지 로드 완료');
  
  // 기존 submitInquiry 함수가 있다면 백업
  if (typeof window.originalSubmitInquiry === 'undefined' && typeof window.submitInquiry !== 'undefined') {
    window.originalSubmitInquiry = window.submitInquiry;
  }
  
  // 새로운 함수로 교체
  window.submitInquiry = submitInquiry;
  
  console.log('submitInquiry 함수 교체 완료');
  
  // Supabase 클라이언트 초기화 확인
  if (typeof window.supabase !== 'undefined') {
    initializeSupabase();
  }
});
</script>

