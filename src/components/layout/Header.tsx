import { useAuth } from '../../hooks/useAuth'
import { User } from 'lucide-react'

export function Header() {
  const { user } = useAuth()

  return (
    <header className="bg-white border-b border-gray-200 px-6 py-4">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold text-gray-900">관리자 대시보드</h2>
        </div>
        <div className="flex items-center gap-4">
          <div className="flex items-center gap-2 text-gray-700">
            <User className="w-5 h-5" />
            <span className="font-medium">{user?.email || '관리자'}</span>
          </div>
        </div>
      </div>
    </header>
  )
}

