import { useState } from 'react'
import { AccountList } from '../components/accounts/AccountList'
import { AccountForm } from '../components/accounts/AccountForm'
import { Plus, Users } from 'lucide-react'
import type { User } from '../types'

export function AccountsPage() {
  const [isFormOpen, setIsFormOpen] = useState(false)
  const [editingUser, setEditingUser] = useState<User | null>(null)

  const handleEdit = (user: User) => {
    setEditingUser(user)
    setIsFormOpen(true)
  }

  const handleClose = () => {
    setIsFormOpen(false)
    setEditingUser(null)
  }

  const handleCreate = () => {
    setEditingUser(null)
    setIsFormOpen(true)
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-indigo-100 rounded-lg">
            <Users className="w-6 h-6 text-indigo-600" />
          </div>
          <div>
            <h1 className="text-3xl font-bold text-gray-900">계정 관리</h1>
            <p className="text-gray-600 mt-1">관리자 계정을 관리합니다</p>
          </div>
        </div>
        <button
          onClick={handleCreate}
          className="flex items-center gap-2 px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition"
        >
          <Plus className="w-5 h-5" />
          <span>계정 추가</span>
        </button>
      </div>

      <AccountList onEdit={handleEdit} />

      {isFormOpen && (
        <AccountForm
          user={editingUser}
          onClose={handleClose}
          onSuccess={handleClose}
        />
      )}
    </div>
  )
}

