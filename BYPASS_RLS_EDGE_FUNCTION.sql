-- RLS를 우회하는 Edge Function 생성 (최후의 수단)
-- Supabase Dashboard → Edge Functions에서 실행하세요

-- 이 방법은 RLS를 완전히 우회하므로 보안에 주의하세요!

-- Edge Function 코드 (create_inquiry 함수)
-- Supabase Dashboard → Edge Functions → Create Function → "create_inquiry" 생성

/*
Edge Function 코드:

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { name, company, email, phone, content } = await req.json()

    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false
        }
      }
    )

    const { data, error } = await supabaseClient
      .from('inquiries')
      .insert([{
        name,
        company: company || null,
        email,
        phone: phone || null,
        content,
        status: 'new'
      }])
      .select()

    if (error) throw error

    return new Response(
      JSON.stringify({ success: true, data }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      },
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      },
    )
  }
})
*/

-- 홈페이지에서 Edge Function 호출하는 코드:
/*
async function submitInquiry(formData) {
  const inquiryData = {
    name: formData.wr_name,
    company: formData.wr_subject || null,
    email: formData.wr_email,
    phone: formData.wr_2 || null,
    content: formData.wr_content,
  };

  try {
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

    return result;
  } catch (error) {
    console.error('문의 접수 오류:', error);
    throw error;
  }
}
*/

