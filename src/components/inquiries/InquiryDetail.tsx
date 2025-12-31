import { useState } from 'react'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import { X, Mail, Building, Phone, FileText, Clock, CheckCircle, AlertCircle, Save } from 'lucide-react'
import type { Inquiry } from '../../types'

interface InquiryDetailProps {
  inquiry: Inquiry
  onClose: () => void
  onUpdate: () => void
}

export function InquiryDetail({ inquiry, onClose, onUpdate }: InquiryDetailProps) {
  const [status, setStatus] = useState<Inquiry['status']>(inquiry.status)
  const [isUpdating, setIsUpdating] = useState(false)
  const queryClient = useQueryClient()

  // 상태 업데이트
  const updateMutation = useMutation({
    mutationFn: async (newStatus: Inquiry['status']) => {
      const { error } = await supabase
        .from('inquiries')
        .update({
          status: newStatus,
          updated_at: new Date().toISOString(),
        })
        .eq('id', inquiry.id)

      if (error) throw error
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['inquiries'] })
      onUpdate()
    },
  })

  const handleStatusChange = async (newStatus: Inquiry['status']) => {
    setIsUpdating(true)
    try {
      await updateMutation.mutateAsync(newStatus)
      setStatus(newStatus)
    } catch (error) {
      alert('상태 변경 중 오류가 발생했습니다.')
      console.error(error)
    } finally {
      setIsUpdating(false)
    }
  }

  const getStatusIcon = (status: Inquiry['status']) => {
    switch (status) {
      case 'new':
        return <AlertCircle className="w-5 h-5 text-blue-600" />
      case 'processing':
        return <Clock className="w-5 h-5 text-yellow-600" />
      case 'completed':
        return <CheckCircle className="w-5 h-5 text-green-600" />
      default:
        return <Mail className="w-5 h-5 text-gray-400" />
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

  return (
    <div className="bg-white rounded-lg shadow-md h-full flex flex-col">
      {/* 헤더 */}
      <div className="flex items-center justify-between p-6 border-b border-gray-200">
        <div className="flex items-center gap-3">
          {getStatusIcon(status)}
          <h2 className="text-xl font-bold text-gray-900">문의 상세</h2>
        </div>
        <button
          onClick={onClose}
          className="text-gray-400 hover:text-gray-600 transition lg:hidden"
        >
          <X className="w-6 h-6" />
        </button>
      </div>

      {/* 내용 */}
      <div className="flex-1 overflow-y-auto p-6 space-y-6">
        {/* 상태 변경 */}
        <div className="bg-gray-50 rounded-lg p-4">
          <label className="block text-sm font-medium text-gray-700 mb-2">
            처리 상태
          </label>
          <div className="flex gap-2">
            {(['new', 'processing', 'completed'] as const).map((s) => (
              <button
                key={s}
                onClick={() => handleStatusChange(s)}
                disabled={isUpdating || status === s}
                className={`flex-1 px-4 py-2 rounded-lg font-medium transition ${
                  status === s
                    ? 'bg-indigo-600 text-white'
                    : 'bg-white text-gray-700 hover:bg-gray-100 border border-gray-300'
                } disabled:opacity-50 disabled:cursor-not-allowed`}
              >
                {getStatusLabel(s)}
              </button>
            ))}
          </div>
        </div>

        {/* 문의자 정보 */}
        <div>
          <h3 className="text-lg font-semibold text-gray-900 mb-4">문의자 정보</h3>
          <div className="space-y-3">
            <div className="flex items-start gap-3">
              <Mail className="w-5 h-5 text-gray-400 mt-0.5" />
              <div>
                <p className="text-sm text-gray-500">이름</p>
                <p className="text-base font-medium text-gray-900">{inquiry.name}</p>
              </div>
            </div>
            {inquiry.company && (
              <div className="flex items-start gap-3">
                <Building className="w-5 h-5 text-gray-400 mt-0.5" />
                <div>
                  <p className="text-sm text-gray-500">회사명</p>
                  <p className="text-base font-medium text-gray-900">{inquiry.company}</p>
                </div>
              </div>
            )}
            <div className="flex items-start gap-3">
              <Mail className="w-5 h-5 text-gray-400 mt-0.5" />
              <div>
                <p className="text-sm text-gray-500">이메일</p>
                <a
                  href={`mailto:${inquiry.email}`}
                  className="text-base font-medium text-indigo-600 hover:text-indigo-800"
                >
                  {inquiry.email}
                </a>
              </div>
            </div>
            {inquiry.phone && (
              <div className="flex items-start gap-3">
                <Phone className="w-5 h-5 text-gray-400 mt-0.5" />
                <div>
                  <p className="text-sm text-gray-500">연락처</p>
                  <a
                    href={`tel:${inquiry.phone}`}
                    className="text-base font-medium text-indigo-600 hover:text-indigo-800"
                  >
                    {inquiry.phone}
                  </a>
                </div>
              </div>
            )}
          </div>
        </div>

        {/* 문의 내용 */}
        <div>
          <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
            <FileText className="w-5 h-5" />
            문의 내용
          </h3>
          <div className="bg-gray-50 rounded-lg p-4">
            <p className="text-gray-700 whitespace-pre-wrap">{inquiry.content}</p>
          </div>
        </div>

        {/* 접수 정보 */}
        <div className="border-t border-gray-200 pt-4">
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <p className="text-gray-500">접수일시</p>
              <p className="text-gray-900 font-medium mt-1">
                {new Date(inquiry.created_at).toLocaleString('ko-KR', {
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric',
                  hour: '2-digit',
                  minute: '2-digit',
                })}
              </p>
            </div>
            {inquiry.updated_at !== inquiry.created_at && (
              <div>
                <p className="text-gray-500">수정일시</p>
                <p className="text-gray-900 font-medium mt-1">
                  {new Date(inquiry.updated_at).toLocaleString('ko-KR', {
                    year: 'numeric',
                    month: 'long',
                    day: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit',
                  })}
                </p>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}

