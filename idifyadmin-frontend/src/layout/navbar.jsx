import React from 'react'
import { useNavigate } from 'react-router-dom'

export default function Navbar() {
  const navigate = useNavigate()
  return (
    <nav class="navbar navbar-expand-lg navbar-light bg-light justify-content-end">
      <div className="dropdown">
        <a href="#" className="d-flex align-items-center text-white text-decoration-none dropdown-toggle" id="dropdownUser1" data-bs-toggle="dropdown" aria-expanded="false">
          <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSLU5_eUUGBfxfxRd4IquPiEwLbt4E_6RYMw&s" alt="hugenerd" width="50" height="50" className="rounded-circle" />
        </a>
        <ul className="dropdown-menu dropdown-menu-lg-end text-small shadow">
          <li><a className="dropdown-item" href="#">Admin</a></li>
          {/* <li><a className="dropdown-item" href="#">Settings</a></li>
          <li><a className="dropdown-item" href="#">Profile</a></li> */}
          <li>
            <hr className="dropdown-divider" />
          </li>
          <li><a className="dropdown-item" onClick={()=>{localStorage.clear(); navigate('/login')}}>Sign out</a></li>
        </ul>
      </div>
    </nav>
  )
}
