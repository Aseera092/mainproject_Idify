import React, { useState, useEffect } from 'react';
import { getMembers, deleteMember, updateMember } from '../services/member';
import { toast } from 'react-toastify';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap-icons/font/bootstrap-icons.css';

const ViewMembers = () => {
    const [members, setMembers] = useState([]);
    const [selectedMember, setSelectedMember] = useState(null);
    const [updatedName, setUpdatedName] = useState('');
    const [updatedEmail, setUpdatedEmail] = useState('');
    const [updatedMobileNo, setUpdatedMobileNo] = useState('');
    const [updatedWard, setUpdatedWard] = useState('');

    const init = () => {
        getMembers()
            .then((res) => {
                setMembers(res.data);
            })
            .catch((err) => {
                toast.error('Failed to fetch members');
            });
    };

    useEffect(() => {
        init();
    }, []);

    const deleteMemberById = (id) => {
        deleteMember(id)
            .then((res) => {
                if (res.status) {
                    toast.success('Member Deleted Successfully');
                    init();
                }
            })
            .catch((err) => {
                toast.error('Failed to delete member');
            });
    };

    const openModal = (member) => {
        setSelectedMember(member);
        setUpdatedName(member.name);
        setUpdatedEmail(member.email);
        setUpdatedMobileNo(member.mobileNo);
        setUpdatedWard(member.ward);
    };

    const submitAction = (e) => {
        e.preventDefault();
        const data = {
            name: updatedName,
            email: updatedEmail,
            mobileNo: updatedMobileNo,
            ward: updatedWard,
        };
    
        updateMember(selectedMember._id, data)
        .then((res) => {
            console.log('Update response:', res); // Log the response
        
            // Adjust this condition based on the actual response structure
            if (res.status === true) { 
                toast.success('Member Updated Successfully');
                init();
                document.getElementById('modal-close').click();
            } else {
                    toast.error(`Failed to update member. Status: ${res?.status || 'Unknown'}. Check console.`); // Added optional chaining
                    console.error('Update member failed:', res);
                }
            })
            .catch((err) => {
                toast.error('Failed to update member. Check console.');
                console.error('Update member error:', err);
            });
    };

    return (
        <div className='container mt-4'>
            <h2>Members</h2>
            <div className='table-responsive p-3 shadow mt-2 bg-white rounded'>
                <table className='table table-striped table-bordered table-hover'>
                    <thead className='table-dark'>
                        <tr>
                            <th>Sl.No</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Ward</th>
                            <th>MobileNo</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        {members.map((member, index) => (
                            <tr key={member._id}>
                                <td>{index + 1}</td>
                                <td>{member.name}</td>
                                <td>{member.email}</td>
                                <td>{member.ward}</td>
                                <td>{member.mobileNo}</td>
                                <td>
                                    <div className='d-flex justify-content-center'>
                                        <button
                                            className='btn btn-sm btn-outline-primary me-2'
                                            data-bs-toggle='modal'
                                            data-bs-target='#editModal'
                                            onClick={() => openModal(member)}
                                        >
                                            <i className='bi bi-pencil-fill'></i>
                                        </button>
                                        <button
                                            className='btn btn-sm btn-outline-danger'
                                            onClick={() => deleteMemberById(member._id)}
                                        >
                                            <i className='bi bi-trash3-fill'></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>

                <div className='modal fade' id='editModal' tabIndex='-1' aria-hidden='true'>
                    <div className='modal-dialog'>
                        <div className='modal-content'>
                            <form onSubmit={submitAction}>
                                <div className='modal-header'>
                                    <h5 className='modal-title'>Edit Member</h5>
                                    <button
                                        type='button'
                                        id='modal-close'
                                        className='btn-close'
                                        data-bs-dismiss='modal'
                                        aria-label='Close'
                                    ></button>
                                </div>
                                <div className='modal-body'>
                                    <div className='mb-3'>
                                        <label htmlFor='name' className='form-label'>
                                            Name
                                        </label>
                                        <input
                                            type='text'
                                            className='form-control'
                                            id='name'
                                            value={updatedName}
                                            onChange={(e) => setUpdatedName(e.target.value)}
                                            required
                                        />
                                    </div>
                                    <div className='mb-3'>
                                        <label htmlFor='email' className='form-label'>
                                            Email
                                        </label>
                                        <input
                                            type='email'
                                            className='form-control'
                                            id='email'
                                            value={updatedEmail}
                                            onChange={(e) => setUpdatedEmail(e.target.value)}
                                            required
                                        />
                                    </div>
                                    <div className='mb-3'>
                                        <label htmlFor='mobileNo' className='form-label'>
                                            MobileNo
                                        </label>
                                        <input
                                            type='text'
                                            className='form-control'
                                            id='mobileNo'
                                            value={updatedMobileNo}
                                            onChange={(e) => setUpdatedMobileNo(e.target.value)}
                                            required
                                        />
                                    </div>
                                    <div className='mb-3'>
                                        <label htmlFor='ward' className='form-label'>
                                            Ward
                                        </label>
                                        <input
                                            type='text'
                                            className='form-control'
                                            id='ward'
                                            value={updatedWard}
                                            onChange={(e) => setUpdatedWard(e.target.value)}
                                            required
                                        />
                                    </div>
                                </div>
                                <div className='modal-footer'>
                                    <button
                                        type='button'
                                        className='btn btn-secondary'
                                        data-bs-dismiss='modal'
                                    >
                                        Close
                                    </button>
                                    <button type='submit' className='btn btn-primary'>
                                        Save Changes
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default ViewMembers;