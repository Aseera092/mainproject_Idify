import React, { useState, useEffect } from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import { getComplaint, updateComplaint } from "../services/complaints";

const ViewComplaints = () => {
    const [complaints, setComplaints] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [searchTerm, setSearchTerm] = useState('');
    const [filterStatus, setFilterStatus] = useState('');

    useEffect(() => {
        const fetchComplaints = async () => {
            try {
                const data = await getComplaint();
                console.log("Fetched Complaints:", data.data); // Crucial for debugging
                setComplaints(data.data);
                setLoading(false);
            } catch (err) {
                setError(err);
                setLoading(false);
            }
        };
        fetchComplaints();
    }, []);

    const handleStatusChange = async (complaintId, newStatus) => {
        try {
            await updateComplaint(complaintId, { status: newStatus });
            setComplaints(complaints.map(complaint =>
                complaint._id === complaintId ? { ...complaint, status: newStatus } : complaint
            ));
        } catch (err) {
            console.error('Error updating status:', err);
            alert('Failed to update status.');
        }
    };

    const handleAcceptReject = async (complaintId, action) => {
        try {
            await updateComplaint(complaintId, { status: action });
            setComplaints(complaints.map(complaint =>
                complaint._id === complaintId ? { ...complaint, status: action } : complaint
            ));
        } catch (err) {
            console.error(`Error ${action}ing complaint:`, err);
            alert(`Failed to ${action} complaint.`);
        }
    };

    const filteredComplaints = complaints.filter(complaint => {
        const searchMatch =
            complaint.userId?.firstName?.toLowerCase().includes(searchTerm.toLowerCase()) ||
            complaint.userId?.email?.toLowerCase().includes(searchTerm.toLowerCase()) ||
            complaint.userId?.MobileNo?.toLowerCase().includes(searchTerm.toLowerCase()) ||
            complaint.userId?.wardNo?.toLowerCase().includes(searchTerm.toLowerCase()) ||
            complaint.category?.toLowerCase().includes(searchTerm.toLowerCase());

        const statusMatch = filterStatus ? complaint.status === filterStatus : true;

        return searchMatch && statusMatch;
    });

    if (loading) {
        return <div>Loading...</div>;
    }

    if (error) {
        return <div>Error: {error.message}</div>;
    }

    return (
        <div className="container mt-4">
            <h1 className="text-center text-primary mb-4">Manage Complaints</h1>
            <div className="row mb-4 g-3">
                <div className="col-md-12">
                    <div className="input-group">
                        <input type="text" placeholder="Search complaints related on category" value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} className="form-control shadow-sm" />
                        <button className="btn btn-outline-secondary" type="button" onClick={() => { }}>Search</button>
                    </div>
                </div>
                {/* <div className="col-md-4">
                    <select value={filterStatus} onChange={(e) => setFilterStatus(e.target.value)} className="form-select shadow-sm">
                        <option value="">All Statuses</option>
                        <option value="Pending">Pending</option>
                        <option value="In Progress">In Progress</option>
                        <option value="Resolved">Resolved</option>
                        <option value="Accepted">Accepted</option>
                        <option value="Rejected">Rejected</option>
                    </select>
                </div> */}
            </div>
            <div className="table-responsive">
                <table className="table table-hover table-bordered text-center">
                    <thead className="table-dark">
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Mobile No</th>
                            <th>Ward</th>
                            <th>Category</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {filteredComplaints.map((complaint) => (
                            <tr key={complaint._id}>
                                <td>{complaint.userId ? `${complaint.userId.firstName || ''} ${complaint.userId.email || ''}`.trim() : 'N/A'}</td>
                                <td>{complaint.userId?.email || 'N/A'}</td>
                                <td>{complaint.userId?.MobileNo || 'N/A'}</td>
                                <td>{complaint.userId?.wardNo || 'N/A'}</td>
                                <td>{complaint.category}</td>
                                <td>{complaint.status}</td>
                                <td>
                                    {complaint.status === 'Pending' ? (
                                        <div>
                                            <button className="btn btn-success btn-sm me-1" onClick={() => handleAcceptReject(complaint._id, 'Accepted')}>Accept</button>
                                            <button className="btn btn-danger btn-sm" onClick={() => handleAcceptReject(complaint._id, 'Rejected')}>Reject</button>
                                        </div>
                                    ) : (
                                        <select value={complaint.status} onChange={(e) => handleStatusChange(complaint._id, e.target.value)} className="form-select form-select-sm shadow-sm">
                                            <option value="Pending">Pending</option>
                                            <option value="In Progress">In Progress</option>
                                            <option value="Resolved">Resolved</option>
                                            <option value="Accepted">Accepted</option>
                                            <option value="Rejected">Rejected</option>
                                        </select>
                                    )}
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
};

export default ViewComplaints;