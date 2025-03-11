import React, { useEffect, useState } from 'react'
import { Link, Outlet, useNavigate } from 'react-router-dom'

export default function MainLayout() {
    const [isuserLogin,setIsuserLogin] = useState(localStorage.getItem('userLogin'))
    const navigate = useNavigate()

    useEffect(() => {
      setIsuserLogin(localStorage.getItem('userLogin'))
    }, [window.location.pathname])
    
    return (
        <div>
            <nav class="navbar navbar-expand-lg navbar-light bg-light">
                <div class="container-fluid">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR63gffyEfrXxm_TsBiHGFRhm0P7ZOjsH--pQ&s" height="100px" width="100px"alt="" />
                    <a class="navbar-brand" href="#">Binovate IoTrack</a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                            <li class="nav-item">
                                <Link class="nav-link active" to="/">Home</Link>
                            </li>
                            <li class="nav-item">
                                <Link class="nav-link" to="/service">Services</Link>
                            </li>
                            <li class="nav-item">
                                <Link class="nav-link active" to="/map">Map</Link>
                            </li>
                            <li class="nav-item">
                                <Link class="nav-link" to="/about">About</Link>
                            </li>
                            <li class="nav-item">
                                <Link class="nav-link" to="/contact">Contact</Link>
                            </li>
                        </ul>
                        {
                            isuserLogin ? <div>
                                <button class="btn btn-primary me-2" type="button" onClick={() => { navigate('/request') }}>Requests</button>
                                <button class="btn btn-danger" type="button" onClick={() => { localStorage.clear(); navigate('/login') }}>Logout</button>
                            </div> : <div>
                                <button class="btn btn-outline-success me-2" type="button" onClick={() => { navigate('/login') }}>Sign in</button>
                                <button class="btn btn-primary" type="button" onClick={() => { navigate('/signup') }}>Sign up</button>
                            </div>
                        }


                    </div>
                </div>
            </nav>
            <Outlet />
            <footer class="bg-dark text-white text-center py-3">
                <p>&copy; 2024 WasteManage. All rights reserved.</p>
                <p>Follow us on
                    <a href="#" class="text-white">Facebook</a>,
                    <a href="#" class="text-white">Twitter</a>, and
                    <a href="#" class="text-white">LinkedIn</a>.
                </p>
            </footer>
        </div>
    )
}
