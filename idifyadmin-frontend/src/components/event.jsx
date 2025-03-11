import React, { useState, useEffect } from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import { toast } from 'react-toastify';

const Eventpage = () => {
    const [highlightIndex, setHighlightIndex] = useState(0);
    const [isAdmin, setIsAdmin] = useState(true);
    const [events, setEvents] = useState([]);
    const [newEvent, setNewEvent] = useState({ title: '', date: '', time: '', location: '', agenda: '' });
    const [editId, setEditId] = useState(null);

    const highlights = [
        { icon: '📅', text: 'October 28, 2023' },
        { icon: '📍', text: 'Local Community Hall, Nedumbassery' },
        { icon: '⏰', text: '10:00 AM - 1:00 PM' },
        { icon: '🗣️', text: 'Local Government Representatives' },
        { icon: '🤝', text: 'Community Interaction & Feedback Session' },
    ];

    useEffect(() => {
        const savedEvents = JSON.parse(localStorage.getItem('events')) || [];
        setEvents(savedEvents);

        const interval = setInterval(() => {
            setHighlightIndex((prevIndex) => (prevIndex + 1) % highlights.length);
        }, 3000);
        return () => clearInterval(interval);
    }, []);

    const inputHandler = (e) => {
        setNewEvent({ ...newEvent, [e.target.name]: e.target.value });
    };

    const addEvent = () => {
        if (!newEvent.title || !newEvent.date || !newEvent.time || !newEvent.location || !newEvent.agenda) {
            toast.warning('Please fill all fields');
            return;
        }

        let updatedEvents;
        if (editId !== null) {
            updatedEvents = events.map(event => event.id === editId ? { ...newEvent, id: editId, agenda: newEvent.agenda.split(',') } : event);
            toast.success('Event Updated Successfully');
            setEditId(null);
        } else {
            const newId = events.length > 0 ? Math.max(...events.map(event => event.id)) + 1 : 1;
            updatedEvents = [...events, { ...newEvent, id: newId, agenda: newEvent.agenda.split(',') }];
            toast.success('Event Added Successfully');
        }

        setEvents(updatedEvents);
        localStorage.setItem('events', JSON.stringify(updatedEvents));
        setNewEvent({ title: '', date: '', time: '', location: '', agenda: '' });
    };

    const deleteEvent = (id) => {
        const updatedEvents = events.filter(event => event.id !== id);
        setEvents(updatedEvents);
        localStorage.setItem('events', JSON.stringify(updatedEvents));
        toast.error('Event Deleted');
    };

    return (
        <div className="container py-5">
            <h1 className="text-center text-primary mb-4">Community Events</h1>

            {isAdmin && (
                <div className="card p-4 mb-4 shadow-sm">
                    <h3 className="mb-3">Add / Edit Event</h3>
                    <div className="row g-3">
                        <div className="col-md-6">
                            <input type="text" name="title" placeholder="Event Title" value={newEvent.title} onChange={inputHandler} className="form-control" />
                        </div>
                        <div className="col-md-6">
                            <input type="date" name="date" value={newEvent.date} onChange={inputHandler} className="form-control" />
                        </div>
                        <div className="col-md-6">
                            <input type="text" name="time" placeholder="Time" value={newEvent.time} onChange={inputHandler} className="form-control" />
                        </div>
                        <div className="col-md-6">
                            <input type="text" name="location" placeholder="Location" value={newEvent.location} onChange={inputHandler} className="form-control" />
                        </div>
                        <div className="col-12">
                            <textarea name="agenda" placeholder="Agenda (Comma Separated)" value={newEvent.agenda} onChange={inputHandler} className="form-control"></textarea>
                        </div>
                        <div className="col-12 text-center">
                            <button className="btn btn-success w-50" onClick={addEvent}>
                                {editId !== null ? 'Update Event' : 'Add Event'}
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {events.map(event => (
                <div key={event.id} className="card shadow-lg mb-4">
                    <div className="card-body">
                        <h2 className="text-primary text-center">{event.title}</h2>
                        <p><strong>Date:</strong> {event.date}</p>
                        <p><strong>Time:</strong> {event.time}</p>
                        <p><strong>Location:</strong> {event.location}</p>
                        <ul>
                            {event.agenda.map((item, index) => <li key={index}>{item}</li>)}
                        </ul>
                        {isAdmin && (
                            <div className="text-center">
                                <button className="btn btn-primary me-2" onClick={() => { setNewEvent({ ...event, agenda: event.agenda.join(',') }); setEditId(event.id); }}>Edit</button>
                                <button className="btn btn-danger" onClick={() => deleteEvent(event.id)}>Delete</button>
                            </div>
                        )}
                    </div>
                </div>
            ))}
        </div>
    );
};

export default Eventpage;
