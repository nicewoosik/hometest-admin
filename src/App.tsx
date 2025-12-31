import { Routes, Route, Navigate } from 'react-router-dom'
import { LoginPage } from './pages/LoginPage'
import { DashboardPage } from './pages/DashboardPage'
import { AccountsPage } from './pages/AccountsPage'
import { InquiriesPage } from './pages/InquiriesPage'
import { DashboardLayout } from './components/layout/DashboardLayout'
import { ProtectedRoute } from './components/ProtectedRoute'

function App() {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route
        path="/"
        element={
          <ProtectedRoute>
            <DashboardLayout />
          </ProtectedRoute>
        }
      >
        <Route index element={<Navigate to="/dashboard" replace />} />
        <Route path="dashboard" element={<DashboardPage />} />
        <Route path="accounts" element={<AccountsPage />} />
        <Route path="inquiries" element={<InquiriesPage />} />
        <Route path="job-postings" element={<div>채용공고 관리 페이지 (구현 예정)</div>} />
        <Route path="applications" element={<div>채용 접수 페이지 (구현 예정)</div>} />
      </Route>
    </Routes>
  )
}

export default App

