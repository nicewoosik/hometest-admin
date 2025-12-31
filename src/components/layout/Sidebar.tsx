import { NavLink } from 'react-router-dom'
import { 
  LayoutDashboard, 
  Users, 
  Mail, 
  Briefcase, 
  FileText,
  LogOut
} from 'lucide-react'
import { useAuth } from '../../hooks/useAuth'
import { useNavigate } from 'react-router-dom'

const menuItems = [
  { path: '/dashboard', icon: LayoutDashboard, label: '대시보드' },
  { path: '/accounts', icon: Users, label: '계정 관리' },
  { path: '/inquiries', icon: Mail, label: '간편문의' },
  { path: '/job-postings', icon: Briefcase, label: '채용공고 관리' },
  { path: '/applications', icon: FileText, label: '채용 접수' },
]

export function Sidebar() {
  const { signOut } = useAuth()
  const navigate = useNavigate()

  const handleLogout = async () => {
    await signOut()
    navigate('/login')
  }

  return (
    <div className="w-64 bg-gray-900 text-white min-h-screen flex flex-col">
      {/* 로고 */}
      <div className="p-6 border-b border-gray-800">
        <h1 className="text-xl font-bold">ECSTEL 관리자</h1>
        <p className="text-sm text-gray-400 mt-1">Admin Dashboard</p>
      </div>

      {/* 메뉴 */}
      <nav className="flex-1 p-4 space-y-2">
        {menuItems.map((item) => {
          const Icon = item.icon
          return (
            <NavLink
              key={item.path}
              to={item.path}
              className={({ isActive }) =>
                `flex items-center gap-3 px-4 py-3 rounded-lg transition ${
                  isActive
                    ? 'bg-indigo-600 text-white'
                    : 'text-gray-300 hover:bg-gray-800 hover:text-white'
                }`
              }
            >
              <Icon className="w-5 h-5" />
              <span className="font-medium">{item.label}</span>
            </NavLink>
          )
        })}
      </nav>

      {/* 로그아웃 */}
      <div className="p-4 border-t border-gray-800">
        <button
          onClick={handleLogout}
          className="w-full flex items-center gap-3 px-4 py-3 rounded-lg text-gray-300 hover:bg-gray-800 hover:text-white transition"
        >
          <LogOut className="w-5 h-5" />
          <span className="font-medium">로그아웃</span>
        </button>
      </div>
    </div>
  )
}

