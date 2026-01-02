// 홈페이지에 적용할 Edge Function 사용 코드
// 기존 submitInquiry 함수를 이 코드로 교체하세요

// 간편문의 폼 제출 함수 (Edge Function 사용 - RLS 우회)
async function submitInquiry(formData) {
  console.log('문의 제출 시작:', formData);
  
  // 전송할 데이터 준비
  const inquiryData = {
    name: formData.wr_name || null,
    company: formData.wr_subject || null,
    email: formData.wr_email || null,
    phone: formData.wr_2 || null,
    content: formData.wr_content || null
  };
  
  // 빈 문자열을 null로 변환
  Object.keys(inquiryData).forEach(function(key) {
    if (inquiryData[key] === '') {
      inquiryData[key] = null;
    }
  });
  
  console.log('전송할 데이터:', inquiryData);
  
  try {
    // Edge Function 호출 (RLS 우회)
    const response = await fetch(
      'https://qzymoraaukwicqlhjbsy.supabase.co/functions/v1/create_inquiry',
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer sb_publishable_9h5TGNNrnzpjvWCu_CYxVg_VuOC7XFr',
        },
        body: JSON.stringify(inquiryData)
      }
    );

    const result = await response.json();
    
    if (!response.ok) {
      throw new Error(result.error || '문의 접수 실패');
    }

    console.log('성공:', result);
    return result;
  } catch (error) {
    console.error('문의 접수 오류:', error);
    throw error;
  }
}

