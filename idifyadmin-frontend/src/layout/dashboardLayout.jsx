import React, { useEffect } from 'react'
import Navbar from './navbar'
import Sidebar from './sidebar'
import { Outlet, useNavigate } from 'react-router-dom'
import { toast } from 'react-toastify'

export default function DashboardLayout() {
  const navigate = useNavigate()
  useEffect(() => {
    if(!localStorage.getItem('token')){
      navigate('/login')
      toast.error("Please Login")
    }
  }, [])
  
  return (
    <div className="container-fluid">
      <div className="row flex-nowrap">
        <Sidebar />
        <div className="col">
          <Navbar />
          <div className="py-3">
            <Outlet />
          </div>
        </div>
      </div>
    </div>
  )
}
