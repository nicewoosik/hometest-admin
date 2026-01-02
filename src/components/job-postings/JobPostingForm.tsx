import { useState, useEffect } from 'react'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import { X, Save, Calendar, FileText, Info, Briefcase, ClipboardList } from 'lucide-react'
import { RichTextEditor } from '../editor/RichTextEditor'
import type { JobPosting } from '../../types'

interface JobPostingFormProps {
  posting?: JobPosting
  onClose: () => void
  onSuccess: () => void
}

export function JobPostingForm({ posting, onClose, onSuccess }: JobPostingFormProps) {
  const queryClient = useQueryClient()
  const isEditMode = !!posting
  const [activeTab, setActiveTab] = useState<'basic' | 'details' | 'process'>('basic')

  const [title, setTitle] = useState('')
  const [description, setDescription] = useState('')
  const [requirements, setRequirements] = useState('')
  const [deadline, setDeadline] = useState('')
  const [status, setStatus] = useState<'open' | 'closed'>('open')
  const [attachmentUrl, setAttachmentUrl] = useState('')
  
  // 모집부문 정보
  const [department, setDepartment] = useState('')
  const [targetAudience, setTargetAudience] = useState('')
  const [jobType, setJobType] = useState('')
  const [location, setLocation] = useState('')
  const [positionLevel, setPositionLevel] = useState('')
  const [recruitmentCount, setRecruitmentCount] = useState(1)
  
  // 수행직무 상세 정보
  const [workExperience, setWorkExperience] = useState('')
  const [mainDuties, setMainDuties] = useState('')
  const [jobDescriptionEn, setJobDescriptionEn] = useState('')
  const [requiredQualifications, setRequiredQualifications] = useState('')
  const [preferredQualifications, setPreferredQualifications] = useState('')
  
  // 전형일정 및 지원문의
  const [recruitmentProcess, setRecruitmentProcess] = useState('')
  const [contactEmail, setContactEmail] = useState('recruit@ecstel.co.kr')
  const [contactPhone, setContactPhone] = useState('02-3415-8326')

  useEffect(() => {
    if (posting) {
      setTitle(posting.title || '')
      setDescription(posting.description || '')
      setRequirements(posting.requirements || '')
      setDeadline(posting.deadline ? posting.deadline.split('T')[0] : '')
      setStatus(posting.status || 'open')
      setAttachmentUrl(posting.attachment_url || '')
      
      // 모집부문 정보
      setDepartment(posting.department || '')
      setTargetAudience(posting.target_audience || '')
      setJobType(posting.job_type || '')
      setLocation(posting.location || '')
      setPositionLevel(posting.position_level || '')
      setRecruitmentCount(posting.recruitment_count || 1)
      
      // 수행직무 상세 정보
      setWorkExperience(posting.work_experience || '')
      setMainDuties(posting.main_duties || '')
      setJobDescriptionEn(posting.job_description_en || '')
      setRequiredQualifications(posting.required_qualifications || '')
      setPreferredQualifications(posting.preferred_qualifications || '')
      
      // 전형일정 및 지원문의
      setRecruitmentProcess(posting.recruitment_process || '')
      setContactEmail(posting.contact_email || 'recruit@ecstel.co.kr')
      setContactPhone(posting.contact_phone || '02-3415-8326')
    }
  }, [posting])

  const saveMutation = useMutation({
    mutationFn: async (data: Partial<JobPosting>) => {
      if (isEditMode && posting) {
        const { error } = await supabase
          .from('job_postings')
          .update(data)
          .eq('id', posting.id)
        if (error) throw error
      } else {
        const { error } = await supabase
          .from('job_postings')
          .insert([data])
        if (error) throw error
      }
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['job-postings'] })
      alert(isEditMode ? '채용공고가 수정되었습니다.' : '채용공고가 등록되었습니다.')
      onSuccess()
    },
    onError: (error) => {
      alert('저장 중 오류가 발생했습니다.')
      console.error(error)
    },
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()

    if (!title.trim()) {
      alert('제목을 입력해주세요.')
      return
    }

    const data: Partial<JobPosting> = {
      title: title.trim(),
      description: description || undefined,
      requirements: requirements || undefined,
      deadline: deadline || undefined,
      status,
      attachment_url: attachmentUrl || undefined,
      // 모집부문 정보
      department: department || undefined,
      target_audience: targetAudience || undefined,
      job_type: jobType || undefined,
      location: location || undefined,
      position_level: positionLevel || undefined,
      recruitment_count: recruitmentCount || 1,
      // 수행직무 상세 정보
      work_experience: workExperience || undefined,
      main_duties: mainDuties || undefined,
      job_description_en: jobDescriptionEn || undefined,
      required_qualifications: requiredQualifications || undefined,
      preferred_qualifications: preferredQualifications || undefined,
      // 전형일정 및 지원문의
      recruitment_process: recruitmentProcess || undefined,
      contact_email: contactEmail || 'recruit@ecstel.co.kr',
      contact_phone: contactPhone || '02-3415-8326',
    }

    saveMutation.mutate(data)
  }


  const tabs = [
    { id: 'basic', label: '기본 정보', icon: Info },
    { id: 'details', label: '상세 정보', icon: Briefcase },
    { id: 'process', label: '전형일정', icon: ClipboardList },
  ]

  return (
    <div className="bg-white rounded-xl shadow-lg border border-gray-200 flex flex-col h-[calc(100vh-200px)]">
      {/* 헤더 */}
      <div className="flex items-center justify-between p-6 border-b border-gray-200">
        <h2 className="text-2xl font-bold text-gray-900">
          {isEditMode ? '채용공고 수정' : '새 채용공고 작성'}
        </h2>
        <button
          onClick={onClose}
          className="text-gray-400 hover:text-gray-600 p-2 hover:bg-gray-100 rounded-lg transition"
        >
          <X className="w-5 h-5" />
        </button>
      </div>

      {/* 탭 네비게이션 */}
      <div className="border-b border-gray-200 px-6">
        <div className="flex gap-1">
          {tabs.map((tab) => {
            const Icon = tab.icon
            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id as any)}
                className={`flex items-center gap-2 px-4 py-3 border-b-2 transition ${
                  activeTab === tab.id
                    ? 'border-indigo-600 text-indigo-600 font-semibold'
                    : 'border-transparent text-gray-600 hover:text-gray-900'
                }`}
              >
                <Icon className="w-4 h-4" />
                <span>{tab.label}</span>
              </button>
            )
          })}
        </div>
      </div>

      <form onSubmit={handleSubmit} className="flex-1 flex flex-col overflow-hidden">
        <div className="flex-1 overflow-y-auto p-6">
          {/* 기본 정보 탭 */}
          {activeTab === 'basic' && (
            <div className="space-y-6 max-w-4xl">
              <div>
                <h3 className="text-lg font-semibold text-gray-900 mb-4">공고 기본 정보</h3>
                <div className="space-y-4">
                  {/* 제목 */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      제목 <span className="text-red-500">*</span>
                    </label>
                    <input
                      type="text"
                      value={title}
                      onChange={(e) => setTitle(e.target.value)}
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition"
                      placeholder="채용공고 제목을 입력하세요"
                      required
                    />
                  </div>

                  {/* 지원여부 및 접수기한 */}
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        지원여부
                      </label>
                      <select
                        value={status}
                        onChange={(e) => setStatus(e.target.value as 'open' | 'closed')}
                        className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition"
                      >
                        <option value="open">접수중</option>
                        <option value="closed">마감</option>
                      </select>
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        <Calendar className="w-4 h-4 inline mr-1" />
                        접수기한
                      </label>
                      <input
                        type="date"
                        value={deadline}
                        onChange={(e) => setDeadline(e.target.value)}
                        className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition"
                      />
                    </div>
                  </div>

                  {/* 모집부문 정보 */}
                  <div className="bg-gray-50 rounded-lg p-4">
                    <h4 className="text-sm font-semibold text-gray-900 mb-4">모집부문 정보</h4>
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1.5">
                          모집부문
                        </label>
                        <input
                          type="text"
                          value={department}
                          onChange={(e) => setDepartment(e.target.value)}
                          className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition"
                          placeholder="예: Pre-Sales"
                        />
                      </div>

                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1.5">
                          지원대상
                        </label>
                        <input
                          type="text"
                          value={targetAudience}
                          onChange={(e) => setTargetAudience(e.target.value)}
                          className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition"
                          placeholder="예: 경력 3년 이상"
                        />
                      </div>

                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1.5">
                          직무
                        </label>
                        <input
                          type="text"
                          value={jobType}
                          onChange={(e) => setJobType(e.target.value)}
                          className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition"
                          placeholder="예: Pre-Sales"
                        />
                      </div>

                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1.5">
                          지역
                        </label>
                        <input
                          type="text"
                          value={location}
                          onChange={(e) => setLocation(e.target.value)}
                          className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition"
                          placeholder="예: 서울"
                        />
                      </div>

                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1.5">
                          직급
                        </label>
                        <input
                          type="text"
                          value={positionLevel}
                          onChange={(e) => setPositionLevel(e.target.value)}
                          className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition"
                          placeholder="예: 과장"
                        />
                      </div>

                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1.5">
                          모집인원
                        </label>
                        <input
                          type="number"
                          value={recruitmentCount}
                          onChange={(e) => setRecruitmentCount(parseInt(e.target.value) || 1)}
                          className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition"
                          min="1"
                        />
                      </div>
                    </div>
                  </div>

                  {/* 첨부파일 URL */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      <FileText className="w-4 h-4 inline mr-1" />
                      첨부파일 URL
                    </label>
                    <input
                      type="url"
                      value={attachmentUrl}
                      onChange={(e) => setAttachmentUrl(e.target.value)}
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition"
                      placeholder="https://example.com/application-form.pdf"
                    />
                  </div>
                </div>
              </div>
            </div>
            )}

            {/* 상세 정보 탭 */}
            {activeTab === 'details' && (
                <div className="space-y-6 max-w-4xl">
                  <div>
                    <h3 className="text-lg font-semibold text-gray-900 mb-4">상세 설명</h3>
                    <RichTextEditor
                      content={description}
                      onChange={setDescription}
                      placeholder="채용공고 상세 내용을 입력하세요"
                    />
                  </div>

                  <div className="bg-gray-50 rounded-lg p-4">
                    <h4 className="text-sm font-semibold text-gray-900 mb-4">수행직무 정보</h4>
                    <div className="grid grid-cols-2 gap-4 mb-4">
                      <div>
                        <label className="block text-xs font-medium text-gray-600 mb-1.5">
                          업무/경력
                        </label>
                        <input
                          type="text"
                          value={workExperience}
                          onChange={(e) => setWorkExperience(e.target.value)}
                          className="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition"
                          placeholder="예: SaaS/CCaaS Pre-Sales, 과장급"
                        />
                      </div>
                    </div>

                    <div className="space-y-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-2">
                          주요업무
                        </label>
                        <RichTextEditor
                          content={mainDuties}
                          onChange={setMainDuties}
                          placeholder="주요업무를 입력하세요"
                        />
                      </div>

                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-2">
                          Job Description (영문)
                        </label>
                        <RichTextEditor
                          content={jobDescriptionEn}
                          onChange={setJobDescriptionEn}
                          placeholder="Job Description을 입력하세요"
                        />
                      </div>

                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-2">
                          필수요건
                        </label>
                        <RichTextEditor
                          content={requiredQualifications}
                          onChange={setRequiredQualifications}
                          placeholder="필수요건을 입력하세요"
                        />
                      </div>

                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-2">
                          우대사항
                        </label>
                        <RichTextEditor
                          content={preferredQualifications}
                          onChange={setPreferredQualifications}
                          placeholder="우대사항을 입력하세요"
                        />
                      </div>
                    </div>
                  </div>
                </div>
              )}

            {/* 전형일정 탭 */}
            {activeTab === 'process' && (
                <div className="space-y-6 max-w-4xl">
                  <div>
                    <h3 className="text-lg font-semibold text-gray-900 mb-4">전형일정 및 지원문의</h3>
                    <div className="space-y-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-2">
                          전형일정
                        </label>
                        <input
                          type="text"
                          value={recruitmentProcess}
                          onChange={(e) => setRecruitmentProcess(e.target.value)}
                          className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition"
                          placeholder="예: 서류전형-1차 실무진 면접- 2차 대표이사 면접- 최종합격"
                        />
                      </div>

                      <div className="grid grid-cols-2 gap-4">
                        <div>
                          <label className="block text-sm font-medium text-gray-700 mb-2">
                            지원문의 이메일
                          </label>
                          <input
                            type="email"
                            value={contactEmail}
                            onChange={(e) => setContactEmail(e.target.value)}
                            className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition"
                            placeholder="recruit@ecstel.co.kr"
                          />
                        </div>

                        <div>
                          <label className="block text-sm font-medium text-gray-700 mb-2">
                            지원문의 전화번호
                          </label>
                          <input
                            type="tel"
                            value={contactPhone}
                            onChange={(e) => setContactPhone(e.target.value)}
                            className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition"
                            placeholder="02-3415-8326"
                          />
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              )}
        </div>

        {/* 하단 버튼 */}
        <div className="flex items-center justify-between pt-6 border-t border-gray-200 mt-6 bg-gray-50 -mx-6 -mb-6 px-6 py-4">
            <div className="text-sm text-gray-600">
              {activeTab === 'basic' && '기본 정보를 입력하세요'}
              {activeTab === 'details' && '상세 정보를 입력하세요'}
              {activeTab === 'process' && '전형일정 및 지원문의를 입력하세요'}
            </div>
            <div className="flex items-center gap-3">
              <button
                type="button"
                onClick={onClose}
                className="px-6 py-2.5 border border-gray-300 text-gray-700 rounded-lg hover:bg-white transition font-medium"
              >
                취소
              </button>
              <button
                type="submit"
                disabled={saveMutation.isPending}
                className="flex items-center gap-2 px-6 py-2.5 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition disabled:opacity-50 disabled:cursor-not-allowed shadow-md hover:shadow-lg font-medium"
              >
                <Save className="w-4 h-4" />
                {saveMutation.isPending ? '저장 중...' : isEditMode ? '수정 완료' : '등록 완료'}
              </button>
            </div>
          </div>
      </form>
    </div>
  )
}

