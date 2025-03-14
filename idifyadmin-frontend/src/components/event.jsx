import React, { useState } from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import { toast } from 'react-toastify';
import { addEvent } from '../services/event';

const Eventpage = () => {
    const [newEvent, setNewEvent] = useState({
        Date: '',
        Time: '',
        NameofEvent: '',
        upload_event: '',
        Description: '',
        Location: '',
        WardNoSelection: '',
    });

    const inputHandler = (e) => {
        setNewEvent({ ...newEvent, [e.target.name]: e.target.value });
    };

    const handleAddEvent = async () => {
        if (!newEvent.Date || !newEvent.Time || !newEvent.NameofEvent || !newEvent.upload_event || !newEvent.Description || !newEvent.WardNoSelection || !newEvent.Location) {
            toast.warning('Please fill all fields');
            return;
        }

        try {
            await addEvent(newEvent);
            toast.success('Event Added Successfully');
            setNewEvent({
                Date: '',
                Time: '',
                NameofEvent: '',
                upload_event: '',
                Description: '',
                Location: '',
                WardNoSelection: '',
            });
        } catch (error) {
            toast.error('Failed to add event.');
        }
    };

    return (
        <div className="container py-5">
            <h1 className="text-center text-primary mb-4">Add Event</h1>
            <div className="card p-4 mb-4 shadow-sm">
                <div className="row g-3">
                    <div className="col-md-6">
                        <input type="date" name="Date" value={newEvent.Date} onChange={inputHandler} className="form-control" />
                    </div>
                    <div className="col-md-6">
                        <input type="text" name="Time" placeholder="Time" value={newEvent.Time} onChange={inputHandler} className="form-control" />
                    </div>
                    <div className="col-md-6">
                        <input type="text" name="NameofEvent" placeholder="Event Name" value={newEvent.NameofEvent} onChange={inputHandler} className="form-control" />
                    </div>
                    <div className="col-md-6">
                        <input type="file" name="upload_event" placeholder="Upload Event" value={newEvent.upload_event} onChange={inputHandler} className="form-control" />
                    </div>
                    <div className="col-12">
                        <textarea name="Description" placeholder="Description" value={newEvent.Description} onChange={inputHandler} className="form-control"></textarea>
                    </div>
                    <div className="col-12">
                        <textarea name="Location" placeholder="Location" value={newEvent.Location} onChange={inputHandler} className="form-control"></textarea>
                    </div>
                    <div className="col-md-6">
                        <select name="WardNoSelection" value={newEvent.WardNoSelection} onChange={inputHandler} className="form-control">
                            <option value="">Select Ward No</option>
                            {[...Array(19)].map((_, i) => (
                                <option key={i + 1} value={i + 1}>Ward {i + 1}</option>
                            ))}
                        </select>
                    </div>
                    <div className="col-12 text-center">
                        <button className="btn btn-success w-50" onClick={handleAddEvent}>Add Event</button>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Eventpage;
