import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import { Edit, Trash2, Briefcase, Calendar } from 'lucide-react'
import type { JobPosting } from '../../types'

interface JobPostingListProps {
  onSelectPosting: (posting: JobPosting) => void
  selectedId?: string
}

export function JobPostingList({ onSelectPosting, selectedId }: JobPostingListProps) {
  const queryClient = useQueryClient()

  // 채용공고 목록 조회
  const { data: postings, isLoading, error: queryError } = useQuery({
    queryKey: ['job-postings'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('job_postings')
        .select('*')
        .order('created_at', { ascending: false })

      if (error) {
        console.error('채용공고 목록 조회 오류:', error)
        console.error('에러 상세:', {
          message: error.message,
          code: error.code,
          details: error.details,
          hint: error.hint
        })
        throw error
      }
      
      console.log('조회된 채용공고 수:', data?.length || 0)
      console.log('조회된 채용공고 데이터:', data)
      
      return data as JobPosting[]
    },
  })

  // 채용공고 삭제
  const deleteMutation = useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase
        .from('job_postings')
        .delete()
        .eq('id', id)

      if (error) throw error
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['job-postings'] })
    },
  })

  const handleDelete = async (posting: JobPosting, e: React.MouseEvent) => {
    e.stopPropagation()
    if (!confirm(`정말로 "${posting.title}" 공고를 삭제하시겠습니까?`)) {
      return
    }

    try {
      await deleteMutation.mutateAsync(posting.id)
      alert('채용공고가 삭제되었습니다.')
    } catch (error) {
      alert('채용공고 삭제 중 오류가 발생했습니다.')
      console.error(error)
    }
  }

  const getStatusBadge = (status: JobPosting['status']) => {
    return status === 'open' ? (
      <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">
        모집중
      </span>
    ) : (
      <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800">
        마감
      </span>
    )
  }

  if (isLoading) {
    return (
      <div className="bg-white rounded-lg shadow-md p-8 text-center">
        <div className="text-gray-600">로딩 중...</div>
      </div>
    )
  }

  if (queryError) {
    return (
      <div className="bg-white rounded-lg shadow-md p-8">
        <div className="text-red-600 font-semibold mb-2">오류 발생</div>
        <div className="text-sm text-gray-600 mb-4">
          {queryError instanceof Error ? queryError.message : '채용공고 목록을 불러올 수 없습니다.'}
        </div>
        <div className="text-xs text-gray-500">
          <details>
            <summary className="cursor-pointer">상세 정보</summary>
            <pre className="mt-2 p-2 bg-gray-100 rounded overflow-auto">
              {JSON.stringify(queryError, null, 2)}
            </pre>
          </details>
        </div>
      </div>
    )
  }

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden flex flex-col h-[calc(100vh-250px)]">
      <div className="p-4 border-b border-gray-200 bg-gray-50">
        <h2 className="text-lg font-semibold text-gray-900">채용공고 목록</h2>
        <p className="text-sm text-gray-600 mt-1">{postings?.length || 0}개의 공고</p>
      </div>
      
      <div className="overflow-y-auto flex-1">
        {postings && postings.length > 0 ? (
          <div className="divide-y divide-gray-100">
            {postings.map((posting) => (
              <div
                key={posting.id}
                onClick={() => onSelectPosting(posting)}
                className={`p-4 hover:bg-indigo-50 cursor-pointer transition-all duration-200 ${
                  selectedId === posting.id 
                    ? 'bg-indigo-50 border-l-4 border-indigo-600 shadow-sm' 
                    : 'hover:border-l-4 hover:border-indigo-200'
                }`}
              >
                <div className="flex items-start justify-between gap-3">
                  <div className="flex-1 min-w-0">
                    <div className="flex items-start gap-2 mb-2">
                      <div className="mt-1">
                        {getStatusBadge(posting.status)}
                      </div>
                      <h3 className="text-base font-semibold text-gray-900 line-clamp-2 flex-1">
                        {posting.title}
                      </h3>
                    </div>
                    
                    <div className="space-y-1.5 mt-2">
                      {posting.department && (
                        <div className="flex items-center gap-2 text-xs text-gray-600">
                          <span className="font-medium min-w-[60px]">부문</span>
                          <span>{posting.department}</span>
                        </div>
                      )}
                      {posting.target_audience && (
                        <div className="flex items-center gap-2 text-xs text-gray-600">
                          <span className="font-medium min-w-[60px]">지원대상</span>
                          <span>{posting.target_audience}</span>
                        </div>
                      )}
                      {posting.location && posting.position_level && (
                        <div className="flex items-center gap-2 text-xs text-gray-600">
                          <span className="font-medium min-w-[60px]">지역/직급</span>
                          <span>{posting.location} · {posting.position_level}</span>
                        </div>
                      )}
                      {posting.deadline && (
                        <div className="flex items-center gap-2 text-xs text-gray-600">
                          <Calendar className="w-3 h-3" />
                          <span>{new Date(posting.deadline).toLocaleDateString('ko-KR')}</span>
                        </div>
                      )}
                    </div>
                  </div>

                  <div className="flex flex-col items-center gap-1 flex-shrink-0">
                    <button
                      onClick={(e) => {
                        e.stopPropagation()
                        onSelectPosting(posting)
                      }}
                      className="text-indigo-600 hover:text-indigo-900 p-1.5 hover:bg-indigo-100 rounded transition"
                      title="수정"
                    >
                      <Edit className="w-4 h-4" />
                    </button>
                    <button
                      onClick={(e) => handleDelete(posting, e)}
                      className="text-red-600 hover:text-red-900 p-1.5 hover:bg-red-100 rounded transition"
                      title="삭제"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="p-12 text-center text-gray-500">
            <Briefcase className="w-16 h-16 mx-auto mb-4 text-gray-300" />
            <p className="text-gray-600">등록된 채용공고가 없습니다.</p>
            <p className="text-sm text-gray-500 mt-1">새 공고를 작성해보세요.</p>
          </div>
        )}
      </div>
    </div>
  )
}

