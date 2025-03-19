import React, { useState, useEffect } from 'react';
import { deleteUser, getUsers, updateUser, updateUserStatus } from '../services/user';
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

  const userStatusChange = (user, status,reason="")=>{
    updateUserStatus(user._id,{status,rejectReason:reason}).then((res)=>{
      if(res.status){
        toast.success(res.message)
        init()
      }
    }).catch(err=>{
      console.log(err);
      toast.error(err.message)
    })
  }

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
              <th>Ration No</th>
              <th>Ration Card</th>
              <th>Homespot ID</th>
              <th>Status</th>
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
                <td>{user.rationCardNo}</td>
                <td><img src={`data:image/png;base64,${user.upload_rationcard}`} width="100px" /></td>
                <td>{user.homedetails ? user.homedetails.homeId : "Not Approved"}</td>
                <td>
                  <span className={`badge ${
                    user.status === 'Approved' ? 'bg-success' :
                    user.status === 'Pending' ? 'bg-warning' :
                    user.status === 'Reject' ? 'bg-danger' : 'bg-secondary'
                  }`}>
                    {user.status}
                  </span>
                  {user.rejectReason && user.status === 'Reject' && <p className="small text-danger mb-0">Reason: {user.rejectReason}</p>}
                </td>
                <td>
                  <div className="d-flex justify-content-center">
                    <button
                      className="btn btn-sm btn-outline-primary me-2"
                      data-bs-toggle="modal"
                      data-bs-target="#editmodal"
                      onClick={() => setSelectedUser(user)}
                    >
                      <i className="bi bi-pencil-fill"></i>
                    </button>
                    {(user.status === "Pending" || user.status === "Reject") && (
                      <>
                        <button
                          className="btn btn-sm btn-outline-success me-2"
                          onClick={() => userStatusChange(user, "Approved")}
                        >
                          <i className="bi bi-check-lg"></i> Approve
                        </button>
                        <button
                          className="btn btn-sm btn-outline-warning"
                          data-bs-toggle="modal"
                          data-bs-target="#rejectModal"
                          onClick={() => setSelectedUser(user)}
                        >
                          <i className="bi bi-x-lg"></i> Reject
                        </button>
                      </>
                    )}
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>

        <div className='modal fade' id='rejectModal' tabIndex='-1'>
          <div className='modal-dialog'>
            <div className='modal-content'>
              <div className='modal-header'>
                <h5 className='modal-title'>Reject User</h5>
                <button type='button' className='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>
              </div>
              <div className='modal-body'>
                <form onSubmit={(e) => {
                  e.preventDefault();
                  const reason = e.target.rejectReason.value;
                  userStatusChange(selectedUser, "Reject", reason);
                  e.target.reset();
                  document.querySelector('#rejectModal .btn-close').click();
                }}>
                  <div className='mb-3'>
                    <label htmlFor='rejectReason' className='form-label'>Reason for Rejection</label>
                    <textarea 
                      className='form-control' 
                      id='rejectReason' 
                      name='rejectReason' 
                      required
                    ></textarea>
                  </div>
                  <button type='submit' className='btn btn-danger'>Submit</button>
                </form>
              </div>
            </div>
          </div>
        </div>

        <div className='modal fade' id='editmodal' tabIndex='-1'>
          <div className='modal-dialog'>
            <div className='modal-content'>
              <div className='modal-header'>
                <h5 className='modal-title'>Edit User</h5>
                <button type='button' className='btn-close' data-bs-dismiss='modal' aria-label='Close' id='modal-close'></button>
              </div>
              <div className='modal-body'>
                <form onSubmit={submitAction}>
                  <div className='mb-3'>
                    <label htmlFor='firstName' className='form-label'>First Name</label>
                    <input type='text' className='form-control' id='firstName' defaultValue={selectedUser?.firstName} />
                  </div>
                  <div className='mb-3'>
                    <label htmlFor='lastName' className='form-label'>Last Name</label>
                    <input type='text' className='form-control' id='lastName' defaultValue={selectedUser?.lastName} />
                  </div>
                  <div className='mb-3'>
                    <label htmlFor='email' className='form-label'>Email</label>
                    <input type='email' className='form-control' id='email' defaultValue={selectedUser?.email} />
                  </div>
                  <div className='mb-3'>
                    <label htmlFor='MobileNo' className='form-label'>Mobile Number</label>
                    <input type='text' className='form-control' id='MobileNo' defaultValue={selectedUser?.MobileNo} />
                  </div>
                  <div className='mb-3'>
                    <label htmlFor='Address' className='form-label'>Address</label>
                    <textarea className='form-control' id='Address' defaultValue={selectedUser?.Address}></textarea>
                  </div>
                  <div className='mb-3'>
                    <label htmlFor='dob' className='form-label'>Date of Birth</label>
                    <input type='date' className='form-control' id='dob' defaultValue={selectedUser?.dob?.split('T')[0]} />
                  </div>
                  <div className='mb-3'>
                    <label htmlFor='alternateMobileNo' className='form-label'>Alternate Mobile Number</label>
                    <input type='text' className='form-control' id='alternateMobileNo' defaultValue={selectedUser?.alternateMobileNo} />
                  </div>
                  <button type='submit' className='btn btn-primary'>Update</button>
                </form>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
};

export default ViewAllUsers;