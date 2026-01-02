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


