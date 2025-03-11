import React, { useState } from 'react';
import axios from 'axios';
import { toast } from 'react-toastify';
// import 'react-toastify/dist/ReactToastify.css';



const AddUser = () => {
    const [data, setData] = useState({
        firstName: "",
        lastName: "",
        Address: "",
        email: "",
        password: "",
        dob: "",
        MobileNo: "",
        alternateMobileNo: "",
        pincode: "",
        longitude: "",
        latitude: "",
        district: "",
        country: "",
        rationCardNo: "",
        upload_rationcard: "",
        location: ""
    });

    const [errors, setErrors] = useState({});

    const inputHandler = (event) => {
        setData({ ...data, [event.target.name]: event.target.value });
        setErrors({ ...errors, [event.target.name]: '' }); 
    };

    const validateForm = () => {
        let isValid = true;
        const newErrors = {};

        if (!data.firstName.trim()) {
            newErrors.firstName = "First Name is required";
            isValid = false;
        }

        if (!data.lastName.trim()) {
            newErrors.lastName = "Last Name is required";
            isValid = false;
        }

        if (!data.Address.trim()) {
            newErrors.Address = "Address is required";
            isValid = false;
        }

        if (!data.email.trim()) {
            newErrors.email = "Email is required";
            isValid = false;
        } else if (!/\S+@\S+\.\S+/.test(data.email)) {
            newErrors.email = "Invalid email format";
            isValid = false;
        }

        if (!data.password.trim()) {
            newErrors.password = "Password is required";
            isValid = false;
        }

        if (!data.dob.trim()) {
            newErrors.dob = "Date of Birth is required";
            isValid = false;
        }

        if (!data.MobileNo.trim()) {
            newErrors.MobileNo = "Mobile Number is required";
            isValid = false;
        } else if (!/^\d{10}$/.test(data.MobileNo)) {
            newErrors.MobileNo = "Mobile Number must be 10 digits";
            isValid = false;
        }

        if (data.alternateMobileNo.trim() && !/^\d{10}$/.test(data.alternateMobileNo)) {
            newErrors.alternateMobileNo = "Alternate Mobile Number must be 10 digits";
            isValid = false;
        }

        if (!data.pincode.trim()) {
            newErrors.pincode = "Pincode is required";
            isValid = false;
        }

        if (!data.district.trim()) {
            newErrors.district = "District is required";
            isValid = false;
        }

        if (!data.country.trim()) {
            newErrors.country = "Country is required";
            isValid = false;
        }

        if (!data.rationCardNo.trim()) {
            newErrors.rationCardNo = "Ration Card Number is required";
            isValid = false;
        }

        if (!data.location.trim()) {
            newErrors.location = "Location is required";
            isValid = false;
        }

        setErrors(newErrors);
        return isValid;
    };

    const readValue = () => {
        if (validateForm()) {
            axios.post("http://localhost:8080/user", data)
                .then((response) => {
                    if (response.data.status === "success") {
                        toast.success("Successfully added");
                        setData({
                            firstName: "",
                            lastName: "",
                            Address: "",
                            email: "",
                            password: "",
                            dob: "",
                            MobileNo: "",
                            alternateMobileNo: "",
                            pincode: "",
                            longitude: "",
                            latitude: "",
                            district: "",
                            country: "",
                            rationCardNo: "",
                            upload_rationcard: "",
                            location: ""
                        });
                        setErrors({});//clear all errors
                    } else {
                        toast.error(response.data.message || "Failed to add user");
                    }
                })
                .catch((err) => {
                    toast.error(err.response?.data?.message || "An error occurred");
                    console.error("Error adding user:", err);
                });
        }
    };

    return (
        <div>
            <div className="container">
                <div className="row g-3">
                    {Object.keys(data).map((key) => (
                        <div key={key} className="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-6 col-xxl-6">
                            <label htmlFor={key} className="form-label">{key}</label>
                            {key === "upload_rationcard" ? (
                                <input type="file" className="form-control" name={key} onChange={inputHandler} />
                            ) : key === "dob" ? (
                                <input type="date" className="form-control" name={key} value={data[key]} onChange={inputHandler} />
                            ) : (
                                <input type="text" className="form-control" name={key} placeholder={`Enter ${key}`} value={data[key]} onChange={inputHandler} />
                            )}
                            {errors[key] && <p className="text-danger">{errors[key]}</p>}
                        </div>
                    ))}
                    <div className="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-6 col-xxl-6">
                        <button className="btn btn-success" onClick={readValue}>Submit</button>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default AddUser;