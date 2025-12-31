import { useQuery } from '@tanstack/react-query'
import { supabase } from '../lib/supabase'
import { Mail, Briefcase, FileText } from 'lucide-react'

export function DashboardPage() {
  // 통계 데이터 조회
  const { data: inquiriesCount } = useQuery({
    queryKey: ['inquiries-count'],
    queryFn: async () => {
      const { count } = await supabase
        .from('inquiries')
        .select('*', { count: 'exact', head: true })
      return count || 0
    },
  })

  const { data: jobPostingsCount } = useQuery({
    queryKey: ['job-postings-count'],
    queryFn: async () => {
      const { count } = await supabase
        .from('job_postings')
        .select('*', { count: 'exact', head: true })
      return count || 0
    },
  })

  const { data: applicationsCount } = useQuery({
    queryKey: ['applications-count'],
    queryFn: async () => {
      const { count } = await supabase
        .from('job_applications')
        .select('*', { count: 'exact', head: true })
      return count || 0
    },
  })

  const stats = [
    {
      title: '간편문의',
      value: inquiriesCount ?? 0,
      icon: Mail,
      color: 'bg-blue-500',
      link: '/inquiries',
    },
    {
      title: '채용공고',
      value: jobPostingsCount ?? 0,
      icon: Briefcase,
      color: 'bg-green-500',
      link: '/job-postings',
    },
    {
      title: '채용 접수',
      value: applicationsCount ?? 0,
      icon: FileText,
      color: 'bg-purple-500',
      link: '/applications',
    },
  ]

  return (
    <div>
      <h1 className="text-3xl font-bold text-gray-900 mb-8">대시보드</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {stats.map((stat) => {
          const Icon = stat.icon
          return (
            <div
              key={stat.title}
              className="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition"
            >
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-gray-600 text-sm font-medium">{stat.title}</p>
                  <p className="text-3xl font-bold text-gray-900 mt-2">{stat.value}</p>
                </div>
                <div className={`${stat.color} p-4 rounded-lg`}>
                  <Icon className="w-8 h-8 text-white" />
                </div>
              </div>
            </div>
          )
        })}
      </div>

      <div className="mt-8 bg-white rounded-lg shadow-md p-6">
        <h2 className="text-xl font-bold text-gray-900 mb-4">최근 활동</h2>
        <p className="text-gray-600">최근 활동 내역이 여기에 표시됩니다.</p>
      </div>
    </div>
  )
}

