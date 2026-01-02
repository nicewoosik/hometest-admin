import { useState } from 'react'
import { JobPostingList } from '../components/job-postings/JobPostingList'
import { JobPostingForm } from '../components/job-postings/JobPostingForm'
import { Briefcase, Plus } from 'lucide-react'
import type { JobPosting } from '../types'

export function JobPostingsPage() {
  const [selectedPosting, setSelectedPosting] = useState<JobPosting | null>(null)
  const [isCreating, setIsCreating] = useState(false)

  const handleSelectPosting = (posting: JobPosting) => {
    setSelectedPosting(posting)
    setIsCreating(false)
  }

  const handleCreateNew = () => {
    setSelectedPosting(null)
    setIsCreating(true)
  }

  const handleCloseForm = () => {
    setSelectedPosting(null)
    setIsCreating(false)
  }

  const handleSuccess = () => {
    setSelectedPosting(null)
    setIsCreating(false)
  }

  return (
    <div className="space-y-6">
      {/* 헤더 */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">채용공고 관리</h1>
          <p className="text-gray-600 mt-1">채용공고를 작성하고 관리합니다</p>
        </div>
        <button
          onClick={handleCreateNew}
          className="flex items-center gap-2 px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition shadow-lg hover:shadow-xl"
        >
          <Plus className="w-5 h-5" />
          <span>새 공고 작성</span>
        </button>
      </div>

      {/* 메인 컨텐츠 영역 */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* 목록 영역 */}
        <div className={`lg:col-span-1 ${(selectedPosting || isCreating) ? 'hidden lg:block' : 'block'}`}>
          <JobPostingList
            onSelectPosting={handleSelectPosting}
            selectedId={selectedPosting?.id}
          />
        </div>

        {/* 작성/수정 영역 */}
        <div className={`lg:col-span-2 ${(selectedPosting || isCreating) ? 'block' : 'hidden lg:block'}`}>
          {(selectedPosting || isCreating) ? (
            <JobPostingForm
              posting={selectedPosting || undefined}
              onClose={handleCloseForm}
              onSuccess={handleSuccess}
            />
          ) : (
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-12 text-center">
              <Briefcase className="w-16 h-16 mx-auto mb-4 text-gray-400" />
              <h3 className="text-xl font-semibold text-gray-900 mb-2">공고를 선택하세요</h3>
              <p className="text-gray-600">왼쪽 목록에서 공고를 선택하거나 새 공고를 작성하세요.</p>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

