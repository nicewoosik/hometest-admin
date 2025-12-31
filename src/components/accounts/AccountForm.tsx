import { useState, useEffect } from 'react'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import { X, Save, Mail, User as UserIcon, Shield, Lock } from 'lucide-react'
import type { User } from '../../types'

interface AccountFormProps {
  user: User | null
  onClose: () => void
  onSuccess: () => void
}

export function AccountForm({ user, onClose, onSuccess }: AccountFormProps) {
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [role, setRole] = useState<'admin' | 'manager'>('manager')
  const [error, setError] = useState('')
  const queryClient = useQueryClient()

  const isEditMode = !!user

  useEffect(() => {
    if (user) {
      setName(user.name)
      setEmail(user.email)
      setRole(user.role)
    }
  }, [user])

  // 계정 생성/수정
  const mutation = useMutation({
    mutationFn: async () => {
      if (isEditMode) {
        // 수정 모드
        if (!user) throw new Error('User not found')

        // admin_users 테이블 업데이트
        const { error: updateError } = await supabase
          .from('admin_users')
          .update({
            name,
            email,
            role,
            updated_at: new Date().toISOString(),
          })
          .eq('id', user.id)

        if (updateError) throw updateError

        // 비밀번호가 입력된 경우에만 Supabase Auth 업데이트
        if (password) {
          const { error: authError } = await supabase.auth.updateUser({
            password: password,
          })

          if (authError) throw authError
        }
      } else {
        // 생성 모드 - Supabase Auth로 계정 생성
        const { data: authData, error: authError } = await supabase.auth.signUp({
          email,
          password: password || 'temp123456', // 임시 비밀번호
        })

        if (authError) throw authError

        if (!authData.user) throw new Error('Failed to create user')

        // admin_users 테이블에 추가 정보 저장
        const { error: insertError } = await supabase
          .from('admin_users')
          .insert({
            auth_user_id: authData.user.id,
            email,
            name,
            role,
          })

        if (insertError) throw insertError
      }
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin-users'] })
      onSuccess()
    },
    onError: (err: Error) => {
      setError(err.message || '오류가 발생했습니다.')
    },
  })

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')

    if (!isEditMode && !password) {
      setError('비밀번호를 입력해주세요.')
      return
    }

    mutation.mutate()
  }

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg shadow-xl max-w-md w-full max-h-[90vh] overflow-y-auto">
        {/* 헤더 */}
        <div className="flex items-center justify-between p-6 border-b border-gray-200">
          <h2 className="text-xl font-bold text-gray-900">
            {isEditMode ? '계정 수정' : '계정 추가'}
          </h2>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-600 transition"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        {/* 폼 */}
        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          {error && (
            <div className="p-3 bg-red-50 border border-red-200 rounded-lg text-sm text-red-600">
              {error}
            </div>
          )}

          {/* 이름 */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <UserIcon className="w-4 h-4 inline mr-1" />
              이름
            </label>
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent outline-none"
              placeholder="홍길동"
            />
          </div>

          {/* 이메일 */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <Mail className="w-4 h-4 inline mr-1" />
              이메일
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              disabled={isEditMode}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent outline-none disabled:bg-gray-100 disabled:cursor-not-allowed"
              placeholder="admin@ecstel.co.kr"
            />
            {isEditMode && (
              <p className="mt-1 text-xs text-gray-500">
                이메일은 수정할 수 없습니다.
              </p>
            )}
          </div>

          {/* 비밀번호 */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <Lock className="w-4 h-4 inline mr-1" />
              비밀번호 {isEditMode && '(변경 시에만 입력)'}
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required={!isEditMode}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent outline-none"
              placeholder={isEditMode ? '변경하지 않으려면 비워두세요' : '••••••••'}
            />
          </div>

          {/* 권한 */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <Shield className="w-4 h-4 inline mr-1" />
              권한
            </label>
            <select
              value={role}
              onChange={(e) => setRole(e.target.value as 'admin' | 'manager')}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent outline-none"
            >
              <option value="manager">매니저</option>
              <option value="admin">관리자</option>
            </select>
          </div>

          {/* 버튼 */}
          <div className="flex gap-3 pt-4">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition"
            >
              취소
            </button>
            <button
              type="submit"
              disabled={mutation.isPending}
              className="flex-1 px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
            >
              <Save className="w-4 h-4" />
              {mutation.isPending ? '저장 중...' : '저장'}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}

