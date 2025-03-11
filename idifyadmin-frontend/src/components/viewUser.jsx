import React, { useState, useEffect } from 'react';
import { deleteUser, getUsers, updateUser } from '../services/user';
import { toast } from 'react-toastify';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap-icons/font/bootstrap-icons.css';

const ViewAllUsers = () => {
  const [users, setUsers] = useState([]);
  const [selectedUser, setSelectedUser] = useState(null);

  const init = () => {
    getUsers()
      .then((res) => {
        setUsers(res.data);
      })
      .catch((err) => {
        toast.error('Failed to fetch users');
      });
  };

  useEffect(() => {
    init();
  }, []);

  const deleteUserById = (id) => {
    deleteUser(id)
      .then((res) => {
        if (res.status) {
          toast.success('User Deleted Successfully');
          init();
        }
      })
      .catch((err) => {
        toast.error('Failed to delete user');
      });
  };

  const submitAction = (e) => {
    e.preventDefault();

    const username = document.getElementById('firstName').value;
    const lastName = document.getElementById('lastName').value;
    const email = document.getElementById('email').value;
    const mobileNo = document.getElementById('MobileNo').value;
    const address = document.getElementById('Address').value;
    const dob = document.getElementById('dob').value;
    const alternateMobileNo = document.getElementById('alternateMobileNo').value;

    const data = {
      firstName: username,
      lastName: lastName,
      email: email,
      MobileNo: mobileNo,
      Address: address,
      dob: dob,
      alternateMobileNo: alternateMobileNo,
    };

    updateUser(selectedUser._id, data)
      .then((res) => {
        if (res.status) {
          init();
          toast.success('User Updated Successfully');
          document.getElementById('modal-close').click();
        }
      })
      .catch((err) => {
        toast.error('Failed to update user');
      });
  };

  return (
    <div className='container mt-4'>
      <h2>Users</h2>
      <div className='table-responsive p-3 shadow mt-2 bg-white rounded'>
        <table className='table table-striped table-bordered table-hover'>
          <thead className='table-dark'>
            <tr>
              <th>Sl No</th>
              <th>Username</th>
              <th>Email</th>
              <th>MobileNo</th>
              <th>Address</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {users.map((user, index) => (
              <tr key={user._id}>
                <td>{index + 1}</td>
                <td>{user.firstName}</td>
                <td>{user.email}</td>
                <td>{user.MobileNo}</td>
                <td>{user.Address}</td>
                <td>
                  <div className='d-flex justify-content-center'>
                    <button
                      className='btn btn-sm btn-outline-primary me-2'
                      data-bs-toggle='modal'
                      data-bs-target='#editmodal'
                      onClick={() => setSelectedUser(user)}
                    >
                      <i className='bi bi-pencil-fill'></i>
                    </button>
                    <button
                      className='btn btn-sm btn-outline-danger'
                      onClick={() => deleteUserById(user._id)}
                    >
                      <i className='bi bi-trash3-fill'></i>
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>

        <div className='modal fade' id='editmodal' tabIndex='-1' aria-hidden='true'>
          <div className='modal-dialog'>
            <div className='modal-content'>
              <form onSubmit={submitAction}>
                <div className='modal-header'>
                  <h5 className='modal-title'>Edit User</h5>
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
                    <label htmlFor='firstName' className='form-label'>
                      firstName
                    </label>
                    <input
                      type='text'
                      className='form-control'
                      id='firstName'
                      defaultValue={selectedUser?.firstName}
                    />
                  </div>
                  <div className='mb-3'>
                    <label htmlFor='lastName' className='form-label'>
                      lastName
                    </label>
                    <input
                      type='text'
                      className='form-control'
                      id='lastName'
                      defaultValue={selectedUser?.lastName}
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
                      defaultValue={selectedUser?.email}
                    />
                  </div>
                  <div className='mb-3'>
                    <label htmlFor='MobileNo' className='form-label'>
                      MobileNo
                    </label>
                    <input
                      type='text'
                      className='form-control'
                      id='MobileNo'
                      defaultValue={selectedUser?.MobileNo}
                    />
                  </div>
                  <div className='mb-3'>
                    <label htmlFor='Address' className='form-label'>
                      Address
                    </label>
                    <input
                      type='text'
                      className='form-control'
                      id='Address'
                      defaultValue={selectedUser?.Address}
                    />
                  </div>
                  <div className='mb-3'>
                    <label htmlFor='dob' className='form-label'>
                      dob
                    </label>
                    <input
                      type='date'
                      className='form-control'
                      id='dob'
                      defaultValue={selectedUser?.dob}
                    />
                  </div>
                  <div className='mb-3'>
                    <label htmlFor='alternateMobileNo' className='form-label'>
                      alternateMobileNo
                    </label>
                    <input
                      type='text'
                      className='form-control'
                      id='alternateMobileNo'
                      defaultValue={selectedUser?.alternateMobileNo}
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
                    Save changes
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

export default ViewAllUsers;