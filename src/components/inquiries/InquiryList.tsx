import { useQuery } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import { Mail, Clock, CheckCircle, AlertCircle } from 'lucide-react'
import type { Inquiry } from '../../types'

interface InquiryListProps {
  statusFilter: 'all' | 'new' | 'processing' | 'completed'
  onSelectInquiry: (inquiry: Inquiry) => void
  selectedId?: string
}

export function InquiryList({ statusFilter, onSelectInquiry, selectedId }: InquiryListProps) {
  // 문의 목록 조회
  const { data: inquiries, isLoading } = useQuery({
    queryKey: ['inquiries', statusFilter],
    queryFn: async () => {
      let query = supabase
        .from('inquiries')
        .select('*')
        .order('created_at', { ascending: false })

      if (statusFilter !== 'all') {
        query = query.eq('status', statusFilter)
      }

      const { data, error } = await query

      if (error) throw error
      return data as Inquiry[]
    },
  })

  const getStatusIcon = (status: Inquiry['status']) => {
    switch (status) {
      case 'new':
        return <AlertCircle className="w-4 h-4 text-blue-600" />
      case 'processing':
        return <Clock className="w-4 h-4 text-yellow-600" />
      case 'completed':
        return <CheckCircle className="w-4 h-4 text-green-600" />
      default:
        return <Mail className="w-4 h-4 text-gray-400" />
    }
  }

  const getStatusLabel = (status: Inquiry['status']) => {
    switch (status) {
      case 'new':
        return '신규'
      case 'processing':
        return '처리중'
      case 'completed':
        return '완료'
      default:
        return status
    }
  }

  const getStatusColor = (status: Inquiry['status']) => {
    switch (status) {
      case 'new':
        return 'bg-blue-100 text-blue-800 border-blue-200'
      case 'processing':
        return 'bg-yellow-100 text-yellow-800 border-yellow-200'
      case 'completed':
        return 'bg-green-100 text-green-800 border-green-200'
      default:
        return 'bg-gray-100 text-gray-800 border-gray-200'
    }
  }

  if (isLoading) {
    return (
      <div className="bg-white rounded-lg shadow-md p-8 text-center">
        <div className="text-gray-600">로딩 중...</div>
      </div>
    )
  }

  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden flex-1 flex flex-col">
      <div className="overflow-y-auto flex-1">
        {inquiries && inquiries.length > 0 ? (
          <div className="divide-y divide-gray-200">
            {inquiries.map((inquiry) => (
              <button
                key={inquiry.id}
                onClick={() => onSelectInquiry(inquiry)}
                className={`w-full text-left p-4 hover:bg-gray-50 transition ${
                  selectedId === inquiry.id ? 'bg-indigo-50 border-l-4 border-indigo-600' : ''
                }`}
              >
                <div className="flex items-start justify-between gap-4">
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 mb-2">
                      {getStatusIcon(inquiry.status)}
                      <span className="font-semibold text-gray-900 truncate">
                        {inquiry.name}
                      </span>
                      {inquiry.company && (
                        <span className="text-sm text-gray-500 truncate">
                          ({inquiry.company})
                        </span>
                      )}
                    </div>
                    <p className="text-sm text-gray-600 line-clamp-2 mb-2">
                      {inquiry.content}
                    </p>
                    <div className="flex items-center gap-4 text-xs text-gray-500">
                      <span>{inquiry.email}</span>
                      {inquiry.phone && <span>{inquiry.phone}</span>}
                      <span>
                        {new Date(inquiry.created_at).toLocaleDateString('ko-KR', {
                          year: 'numeric',
                          month: 'long',
                          day: 'numeric',
                          hour: '2-digit',
                          minute: '2-digit',
                        })}
                      </span>
                    </div>
                  </div>
                  <div className="flex-shrink-0">
                    <span
                      className={`inline-flex items-center gap-1 px-2 py-1 text-xs font-semibold rounded-full border ${getStatusColor(
                        inquiry.status
                      )}`}
                    >
                      {getStatusLabel(inquiry.status)}
                    </span>
                  </div>
                </div>
              </button>
            ))}
          </div>
        ) : (
          <div className="p-8 text-center text-gray-500">
            <Mail className="w-12 h-12 mx-auto mb-4 text-gray-400" />
            <p>접수된 문의가 없습니다.</p>
          </div>
        )}
      </div>
    </div>
  )
}

