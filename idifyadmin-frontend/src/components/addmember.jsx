import React, { useState } from 'react';
import axios from 'axios';
import { toast } from 'react-toastify';

const Member = () => {
    const [data, setData] = useState({
        name: '',
        email: '',
        mobileNo: '',
        ward: '',
        password: '',
    });

    const [errors, setErrors] = useState({});

    const inputHandler = (event) => {
        setData({ ...data, [event.target.name]: event.target.value });
        setErrors({ ...errors, [event.target.name]: '' }); 
    };

    const validateForm = () => {
        let isValid = true;
        const newErrors = {};

        if (data.name.trim() === '') {
            newErrors.name = 'Name is required';
            isValid = false;
        }

        if (data.email.trim() === '') {
            newErrors.email = 'Email is required';
            isValid = false;
        } else if (!/\S+@\S+\.\S+/.test(data.email)) {
            newErrors.email = 'Invalid email format';
            isValid = false;
        }

        if (data.mobileNo.trim() === '') {
            newErrors.mobileNo = 'Mobile number is required';
            isValid = false;
        } else if (!/^\d{10}$/.test(data.mobileNo)) {
            newErrors.mobileNo = 'Invalid mobile number format (10 digits required)';
            isValid = false;
        }

        if (data.ward.trim() === '') {
            newErrors.ward = 'Ward is required';
            isValid = false;
        }

        if (data.password.trim() === '') {
            newErrors.password = 'Password is required';
            isValid = false;
        }

        setErrors(newErrors);
        return isValid;
    };

    const readValue = () => {
        if (validateForm()) {
            axios
                .post('http://localhost:8080/member', data)
                .then((response) => {
                    if (response.data.status === 'success') {
                        toast.success('Successfully added');
                        setData({
                            name: '',
                            email: '',
                            mobileNo: '',
                            ward: '',
                            password: '',
                        }); 
                        setErrors({}); 
                    } else {
                        toast.error(response.data.message || 'Failed to add member.');
                    }
                })
                .catch((err) => {
                    toast.error(err.response?.data?.message || 'An error occurred.');
                    console.error('Error adding member:', err);
                });
        }
    };

    return (
        <div>
            <div className='container'>
                <div className='row g-3'>
                    <div className='col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12 col-xxl-12'>
                        <label htmlFor='name' className='form-label'>FullName</label>
                        <input
                            type='text'
                            className='form-control'
                            name='name'
                            value={data.name}
                            placeholder='Enter Full Name'
                            onChange={inputHandler}
                        />
                        {errors.name && <div className='text-danger'>{errors.name}</div>}
                    </div>
                    <div className='col-12 col-sm-6 col-md-6 col-lg-6 col-xl-6 col-xxl-6'>
                        <label htmlFor='email' className='form-label'>email</label>
                        <input
                            type='text'
                            className='form-control'
                            name='email'
                            value={data.email}
                            placeholder='Enter Email-ID'
                            onChange={inputHandler}
                        />
                        {errors.email && <div className='text-danger'>{errors.email}</div>}
                    </div>
                    <div className='col-12 col-sm-6 col-md-6 col-lg-6 col-xl-6 col-xxl-6'>
                        <label htmlFor='mobileNo' className='form-label'>MobileNo</label>
                        <input
                            type='text'
                            className='form-control'
                            name='mobileNo'
                            value={data.mobileNo}
                            placeholder='Enter MobileNo'
                            onChange={inputHandler}
                        />
                        {errors.mobileNo && <div className='text-danger'>{errors.mobileNo}</div>}
                    </div>
                    <div className='col-12 col-sm-6 col-md-6 col-lg-6 col-xl-6 col-xxl-6'>
                        <label htmlFor='ward' className='form-label'>ward</label>
                        <input
                            type='text'
                            className='form-control'
                            name='ward'
                            value={data.ward}
                            placeholder='Enter Ward'
                            onChange={inputHandler}
                        />
                        {errors.ward && <div className='text-danger'>{errors.ward}</div>}
                    </div>
                    <div className='col-12 col-sm-6 col-md-6 col-lg-6 col-xl-6 col-xxl-6'>
                        <label htmlFor='password' className='form-label'>password</label>
                        <input
                            type='password'
                            className='form-control'
                            name='password'
                            placeholder='Enter Password'
                            value={data.password}
                            onChange={inputHandler}
                        />
                        {errors.password && <div className='text-danger'>{errors.password}</div>}
                    </div>
                    <div className='col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12 col-xxl-12'>
                        <button className='btn btn-success' onClick={readValue}>Submit</button>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Member;