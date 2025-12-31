import { useState } from 'react'
import { InquiryList } from '../components/inquiries/InquiryList'
import { InquiryDetail } from '../components/inquiries/InquiryDetail'
import { Mail, Filter } from 'lucide-react'
import type { Inquiry } from '../types'

export function InquiriesPage() {
  const [selectedInquiry, setSelectedInquiry] = useState<Inquiry | null>(null)
  const [statusFilter, setStatusFilter] = useState<'all' | 'new' | 'processing' | 'completed'>('all')

  const handleSelectInquiry = (inquiry: Inquiry) => {
    setSelectedInquiry(inquiry)
  }

  const handleCloseDetail = () => {
    setSelectedInquiry(null)
  }

  return (
    <div className="flex gap-6 h-[calc(100vh-200px)]">
      {/* 목록 영역 */}
      <div className={`flex-1 flex flex-col ${selectedInquiry ? 'hidden lg:flex' : 'flex'}`}>
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-3">
            <div className="p-3 bg-blue-100 rounded-lg">
              <Mail className="w-6 h-6 text-blue-600" />
            </div>
            <div>
              <h1 className="text-3xl font-bold text-gray-900">간편문의</h1>
              <p className="text-gray-600 mt-1">접수된 문의를 확인하고 관리합니다</p>
            </div>
          </div>
        </div>

        {/* 필터 */}
        <div className="mb-4 flex items-center gap-2">
          <Filter className="w-4 h-4 text-gray-500" />
          <span className="text-sm font-medium text-gray-700">상태 필터:</span>
          <select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value as any)}
            className="px-3 py-1 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
          >
            <option value="all">전체</option>
            <option value="new">신규</option>
            <option value="processing">처리중</option>
            <option value="completed">완료</option>
          </select>
        </div>

        {/* 문의 목록 */}
        <InquiryList
          statusFilter={statusFilter}
          onSelectInquiry={handleSelectInquiry}
          selectedId={selectedInquiry?.id}
        />
      </div>

      {/* 상세 보기 영역 */}
      {selectedInquiry && (
        <div className="flex-1 lg:flex-1">
          <InquiryDetail
            inquiry={selectedInquiry}
            onClose={handleCloseDetail}
            onUpdate={() => {
              // 목록 새로고침을 위해 상태 초기화 후 다시 선택
              const id = selectedInquiry.id
              setSelectedInquiry(null)
              setTimeout(() => {
                // InquiryList에서 자동으로 새로고침됨
              }, 100)
            }}
          />
        </div>
      )}
    </div>
  )
}

