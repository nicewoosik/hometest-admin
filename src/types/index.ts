export interface User {
  id: string
  email: string
  name: string
  role: 'admin' | 'manager'
  created_at: string
  updated_at: string
}

export interface Inquiry {
  id: string
  name: string
  company?: string
  email: string
  phone?: string
  content: string
  status: 'new' | 'processing' | 'completed'
  created_at: string
  updated_at: string
}

export interface JobPosting {
  id: string
  title: string
  description?: string
  requirements?: string
  deadline?: string
  status: 'open' | 'closed'
  attachment_url?: string
  // 모집부문 정보
  department?: string
  target_audience?: string // 지원대상
  job_type?: string // 직무
  location?: string // 지역
  position_level?: string // 직급
  recruitment_count?: number // 모집인원
  // 수행직무 상세 정보
  work_experience?: string // 업무/경력
  main_duties?: string // 주요업무
  job_description_en?: string // Job Description (영문)
  required_qualifications?: string // 필수요건
  preferred_qualifications?: string // 우대사항
  // 전형일정 및 지원문의
  recruitment_process?: string // 전형일정
  contact_email?: string // 지원문의 이메일
  contact_phone?: string // 지원문의 전화번호
  // 조회수
  view_count?: number // 조회수
  created_at: string
  updated_at: string
}

export interface JobApplication {
  id: string
  job_posting_id: string
  name: string
  email: string
  phone?: string
  resume_url?: string
  status: 'applied' | 'reviewing' | 'interview' | 'accepted' | 'rejected'
  created_at: string
  updated_at: string
  job_posting?: JobPosting
}


