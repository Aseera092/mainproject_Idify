import React from 'react'
import { Link } from 'react-router-dom'

const SIDEBARLIST = [
    // {
    //     title: 'Dashboard',
    //     link: '#',
    //     icon: 'fs-4 bi-house',
    //     isExtendable: false,
    // },
    {
        title: 'Panchayath',
        link: '',
        // icon: 'fs-4 bi-archive',
        isExtendable: true,
        isPanchayath: true,
        child: [
            {
                title: 'Events',
                link: '/dashboard/add-events'
            },
            {
                title: 'ViewEvents',
                link: '/dashboard/view-events'
            },
            {
                title: 'Notifications',
                link: '/dashboard/view-notifications'
            },
            
        ]
    },
    {
        title: 'User',
        link: '',
        // icon: 'fs-4 bi-archive',
        isExtendable: true,
        isPanchayath: false,
        child: [
            {
                title: 'Add User',
                link: '/dashboard/add-user'
            },
            {
                title: 'View UserDetails',
                link: '/dashboard/view-userdetails'
            }
        ]
    },
    {
        title: 'Member',
        link: '',
        // icon: 'fs-4 bi-car-front',
        isExtendable: true,
        isPanchayath: true,
        child: [
            {
                title: 'Add Member',
                link: '/dashboard/add-member'
            },
            {
                title: 'View Member',
                link: '/dashboard/view-member'
            }
        ]
    },
    ,
    {
        title: 'complaints',
        link: '',
        // icon: 'fs-4 bi-chat-left-quote-fill',
        isExtendable: true,
        isPanchayath: true,
        child: [
            {
                title: 'View complaints',
                link: '/dashboard/view-request'
            }
        ]
    },
    {
        title: 'HomespotId',
        link: '',
        // icon: 'fs-4 bi-chat-left-quote-fill',
        isExtendable: true,
        isPanchayath: true,
        child: [
            {
                title: 'View HomespotId',
                link: '/dashboard/view-homespotId'
            },
            {
                title: 'Search HomespotId',
                link: '/dashboard/search-homespotId'
            }
        ]
    },
]

export default function Sidebar() {
    return (
        <div className="col-auto col-md-3 col-xl-2 px-sm-2 px-0 bg-dark">
            <div className="d-flex flex-column align-items-center align-items-sm-start px-3 pt-2 text-white min-vh-100">
                <a href="/" className="d-flex align-items-center pb-3 mb-md-0 me-md-auto text-white text-decoration-none">
                    <span className="fs-5 d-none d-sm-inline">IDify</span>
                </a>
                <ul className="nav nav-pills flex-column mb-sm-auto mb-0 align-items-center align-items-sm-start" id="menu">

                    {
                        SIDEBARLIST.map((dt, index) => {
                            if (!dt.isPanchayath && localStorage.getItem('role') == 'panchayath') {
                                return null
                            }
                            if (dt.isExtendable) {
                                return (
                                    <li>
                                        <a href={`#submenu${index}`} data-bs-toggle="collapse" className="nav-link px-0 align-middle text-white">
                                            <i className={dt.icon}></i> <span className="ms-1 d-none d-sm-inline">{dt.title}</span> <i class="bi bi-caret-down-fill"></i> </a>
                                        <ul className="collapse nav flex-column ms-1" id={`submenu${index}`} data-bs-parent="#menu">
                                            {
                                                dt.child.map((ch) => {
                                                    return (
                                                        <li className="w-100 ps-2">
                                                            <Link to={ch.link} className="nav-link px-0 text-white"><i class="bi bi-caret-right-fill"></i> <span className="d-none d-sm-inline">{ch.title}</span> </Link>
                                                        </li>
                                                    )
                                                })
                                            }
                                        </ul>
                                    </li>
                                )
                            } else {
                                return (
                                    <li className="nav-item">
                                        <a href={dt.link} className="nav-link align-middle text-white px-0">
                                            <i className={dt.icon}></i> <span className="ms-1 d-none d-sm-inline">{dt.title}</span>
                                        </a>
                                    </li>
                                )
                            }
                        })
                    }
                </ul>
                <hr />
            </div>
        </div>
    )
}
