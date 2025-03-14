import React, { useState, useEffect } from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import { toast } from "react-toastify";
import { getEvents, updateEvent, deleteEvent } from "../services/event";

const ViewEventPage = () => {
    const [events, setEvents] = useState([]);
    const [loading, setLoading] = useState(true);
    const [selectedEvent, setSelectedEvent] = useState(null);
    const [formData, setFormData] = useState({});

    useEffect(() => {
        fetchEvents();
    }, []);

    const fetchEvents = async () => {
        try {
            const response = await getEvents();
            if (response?.status && Array.isArray(response.data)) {
                setEvents(response.data);
            } else {
                throw new Error("Invalid event data format");
            }
        } catch (error) {
            console.error("Error fetching events:", error);
            toast.error(`Failed to fetch events: ${error.message}`);
        } finally {
            setLoading(false);
        }
    };

    const handleEdit = (event) => {
        setSelectedEvent(event);
        setFormData({
            NameofEvent: event.NameofEvent || "",
            Date: event.Date ? new Date(event.Date).toISOString().split("T")[0] : "",
            Time: event.Time || "",
            Description: event.Description || "",
            Location: event.Location || "",
            WardNoSelection: event.WardNoSelection || "",
        });
    };

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleUpdate = async (e) => {
        e.preventDefault();
        try {
            if (!selectedEvent) return;
            const response = await updateEvent(selectedEvent._id, formData);
            toast.success(response.message || "Event updated successfully!");
            fetchEvents(); // Refresh events after update
            setSelectedEvent(null); // Close modal
        } catch (error) {
            toast.error(`Failed to update event: ${error.message}`);
        }
    };

    const handleDelete = async (eventId) => {
        if (window.confirm("Are you sure you want to delete this event?")) {
            try {
                const response = await deleteEvent(eventId);
                toast.success(response.message || "Event deleted successfully!");
                fetchEvents(); // Refresh the event list
            } catch (error) {
                toast.error(`Failed to delete event: ${error.message}`);
            }
        }
    };

    return (
        <div className="container py-5">
            <h1 className="text-center text-primary mb-4">View Events</h1>
            {loading ? (
                <p className="text-center">Loading events...</p>
            ) : events.length === 0 ? (
                <p className="text-center">No events available.</p>
            ) : (
                <div className="row">
                    {events.map((event) => (
                        <div key={event._id || event.id} className="col-md-6 col-lg-4">
                            <div className="card shadow-lg mb-4">
                                <div className="card-body">
                                    <h3 className="text-primary text-center">
                                        {event.NameofEvent || "Unnamed Event"}
                                    </h3>
                                    <p><strong>Date:</strong> {event.Date ? new Date(event.Date).toLocaleDateString() : "N/A"}</p>
                                    <p><strong>Time:</strong> {event.Time || "N/A"}</p>
                                    <p><strong>Description:</strong> {event.Description || "No description provided"}</p>
                                    <p><strong>Location:</strong> {event.Location || "No location specified"}</p>
                                    <p><strong>Ward No:</strong> {event.WardNoSelection || "N/A"}</p>
                                    <button className="btn btn-warning w-100 mt-2" onClick={() => handleEdit(event)}>
                                        Edit Event
                                    </button>
                                    <button className="btn btn-danger w-100 mt-2" onClick={() => handleDelete(event._id)}>
                                        Delete Event
                                    </button>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            )}

            {/* Edit Event Modal */}
            {selectedEvent && (
                <div className="modal show d-block bg-dark bg-opacity-50">
                    <div className="modal-dialog">
                        <div className="modal-content">
                            <div className="modal-header">
                                <h5 className="modal-title">Edit Event</h5>
                                <button className="btn-close" onClick={() => setSelectedEvent(null)}></button>
                            </div>
                            <div className="modal-body">
                                <form onSubmit={handleUpdate}>
                                    <div className="mb-3">
                                        <label className="form-label">Event Name</label>
                                        <input type="text" name="NameofEvent" className="form-control" value={formData.NameofEvent} onChange={handleChange} required />
                                    </div>
                                    <div className="mb-3">
                                        <label className="form-label">Date</label>
                                        <input type="date" name="Date" className="form-control" value={formData.Date} onChange={handleChange} required />
                                    </div>
                                    <div className="mb-3">
                                        <label className="form-label">Time</label>
                                        <input type="text" name="Time" className="form-control" value={formData.Time} onChange={handleChange} required />
                                    </div>
                                    <div className="mb-3">
                                        <label className="form-label">Description</label>
                                        <textarea name="Description" className="form-control" value={formData.Description} onChange={handleChange} required />
                                    </div>
                                    <div className="mb-3">
                                        <label className="form-label">Location</label>
                                        <input type="text" name="Location" className="form-control" value={formData.Location} onChange={handleChange} required />
                                    </div>
                                    <div className="mb-3">
                                        <label className="form-label">Ward No</label>
                                        <input type="number" name="WardNoSelection" className="form-control" value={formData.WardNoSelection} onChange={handleChange} required />
                                    </div>
                                    <button type="submit" className="btn btn-success w-100">Update Event</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default ViewEventPage;
