// Edge Function 코드
// Supabase Dashboard → Edge Functions → Create Function → "create_inquiry" 생성
// 이 코드를 복사하여 붙여넣으세요

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // CORS 처리
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // 인증 헤더 확인 (선택적 - anon key 허용)
    const authHeader = req.headers.get('Authorization')
    const apikeyHeader = req.headers.get('apikey')
    
    // 인증이 없어도 허용 (공개 API)
    // 하지만 anon key가 있으면 검증
    if (authHeader && !authHeader.startsWith('Bearer ')) {
      return new Response(
        JSON.stringify({ success: false, error: 'Invalid authorization header format' }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 401,
        },
      )
    }

    const { name, company, email, phone, content } = await req.json()

    // 필수 필드 검증
    if (!name || !email) {
      return new Response(
        JSON.stringify({ success: false, error: '이름과 이메일은 필수입니다.' }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 400,
        },
      )
    }

    // Service Role Key 사용 (RLS 우회)
    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    
    if (!supabaseUrl || !supabaseServiceKey) {
      console.error('환경 변수 누락:', { supabaseUrl: !!supabaseUrl, supabaseServiceKey: !!supabaseServiceKey })
      throw new Error('Supabase 환경 변수가 설정되지 않았습니다.')
    }

    const supabaseClient = createClient(
      supabaseUrl,
      supabaseServiceKey,
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false
        }
      }
    )

    // 데이터 삽입
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

    if (error) {
      console.error('Supabase 에러:', error)
      throw error
    }

    return new Response(
      JSON.stringify({ success: true, data }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      },
    )
  } catch (error) {
    console.error('에러:', error)
    return new Response(
      JSON.stringify({ 
        success: false, 
        error: error.message || '알 수 없는 오류'
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      },
    )
  }
})

