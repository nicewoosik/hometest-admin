// 홈페이지에 적용할 완전한 코드
// 기존 <script> 태그를 이 코드로 교체하세요

<!-- Supabase 클라이언트 라이브러리 추가 (head 태그 안에) -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>

<script type="text/javascript">
// Supabase 설정
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

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
  if (typeof window.supabase !== 'undefined') {
    initializeSupabase();
  } else {
    var checkSupabase = setInterval(function() {
      if (typeof window.supabase !== 'undefined') {
        initializeSupabase();
        clearInterval(checkSupabase);
      }
    }, 100);
    setTimeout(function() {
      clearInterval(checkSupabase);
    }, 5000);
  }
});

// 간편문의 폼 제출 함수 (Supabase 클라이언트 사용)
async function submitInquiry(formData) {
  console.log('문의 제출 시작:', formData);
  
  if (!supabaseClient && typeof window.supabase !== 'undefined') {
    initializeSupabase();
  }
  
  const inquiryData = {
    name: formData.wr_name || null,
    company: formData.wr_subject || null,
    email: formData.wr_email || null,
    phone: formData.wr_2 || null,
    content: formData.wr_content || null,
    status: 'new'
  };
  
  Object.keys(inquiryData).forEach(function(key) {
    if (inquiryData[key] === '') {
      inquiryData[key] = null;
    }
  });
  
  console.log('전송할 데이터:', inquiryData);
  
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
      
      console.log('성공:', data);
      return { success: true, data };
    } else {
      throw new Error('Supabase 클라이언트를 초기화할 수 없습니다.');
    }
  } catch (error) {
    console.error('문의 접수 오류:', error);
    throw error;
  }
}

function checkFrm(obj) {
  var email = document.getElementById("wr_email").value;
  var exptext = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;

  if(exptext.test(email)==false){
    alert("이 메일형식이 올바르지 않습니다.");
    document.frm.wr_email.focus();
    return false;
  }

  if(obj.agree.checked == false) {
    alert('개인정보 취급방침 동의에 체크해주세요.');
    obj.agree.focus();
    return false;
  }

  var formData = {
    wr_name: obj.wr_name.value.trim(),
    wr_subject: obj.wr_subject.value.trim(),
    wr_email: obj.wr_email.value.trim(),
    wr_2: obj.wr_2 ? obj.wr_2.value.trim() : '',
    wr_content: obj.wr_content.value.trim(),
    agree: obj.agree ? obj.agree.checked : false
  }

  var submitBtn = document.getElementById('btn_submit')
  var originalValue = submitBtn.value
  submitBtn.disabled = true
  submitBtn.value = '제출 중...'

  submitInquiry(formData)
    .then(function(result) {
      alert('문의가 접수되었습니다.\n빠른 시일 내에 답변드리겠습니다.')
      obj.reset()
      if (typeof $ !== 'undefined') {
        $('.quick_contact .cnt').slideUp()
      }
    })
    .catch(function(error) {
      console.error('문의 접수 오류 상세:', error)
      var errorMessage = '문의 접수 중 오류가 발생했습니다.\n다시 시도해주세요.'
      if (error.message) {
        errorMessage += '\n\n오류: ' + error.message
      }
      alert(errorMessage)
    })
    .finally(function() {
      submitBtn.disabled = false
      submitBtn.value = originalValue
    })

  return false
}
</script>

