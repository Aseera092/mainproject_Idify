import React, { useState, useEffect } from 'react';
import { toast } from 'react-toastify';

const NotificationPage = () => {
  const [isAdmin, setIsAdmin] = useState(true);
  const [notification, setNotification] = useState({ title: '', description: '', date: '', priority: 'normal' });
  const [notifications, setNotifications] = useState([]);
  const [editMode, setEditMode] = useState(false);
  const [editId, setEditId] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    const storedNotifications = JSON.parse(localStorage.getItem('notifications')) || [];
    setNotifications(storedNotifications);
  }, []);

  const inputHandler = (event) => {
    setNotification({ ...notification, [event.target.name]: event.target.value });
  };

  const saveToLocalStorage = (data) => {
    localStorage.setItem('notifications', JSON.stringify(data));
  };

  const addNotification = () => {
    if (!notification.title || !notification.description || !notification.date) {
      alert('Please fill all the fields');
      return;
    }

    let updatedNotifications;
    if (editMode) {
      updatedNotifications = notifications.map((item) =>
        item.id === editId ? { ...notification, id: editId } : item
      );
      setEditMode(false);
      setEditId(null);
    } else {
      const newId = notifications.length > 0 ? Math.max(...notifications.map((n) => n.id)) + 1 : 1;
      updatedNotifications = [...notifications, { ...notification, id: newId }];
    }

    setNotifications(updatedNotifications);
    saveToLocalStorage(updatedNotifications);
    setNotification({ title: '', description: '', date: '' });
    toast(editMode ? 'Notification Updated Successfully' : 'Notification Added Successfully');
  };

  const deleteNotification = (id) => {
    const updatedNotifications = notifications.filter((n) => n.id !== id);
    setNotifications(updatedNotifications);
    saveToLocalStorage(updatedNotifications);
    toast('Notification Deleted Successfully');
  };

  const filteredNotifications = notifications.filter((item) =>
    item.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
    item.description.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="container py-5">
      <h1 className="text-center mb-4">Panchayath Notifications</h1>

      {isAdmin && (
        <div className="mb-4">
          <input
            type="text"
            name="title"
            placeholder="Title"
            value={notification.title}
            onChange={inputHandler}
            className="form-control mb-2"
          />
          <textarea
            name="description"
            placeholder="Description"
            value={notification.description}
            onChange={inputHandler}
            className="form-control mb-2"
          ></textarea>
          <input
            type="date"
            name="date"
            value={notification.date}
            onChange={inputHandler}
            className="form-control mb-2"
          />
        
          <button className="btn btn-success" onClick={addNotification}>
            {editMode ? 'Update Notification' : 'Add Notification'}
          </button>
        </div>
      )}

      <input
        type="text"
        placeholder="Search notifications..."
        value={searchTerm}
        onChange={(e) => setSearchTerm(e.target.value)}
        className="form-control mb-4"
      />

      {filteredNotifications.length > 0 ? (
        filteredNotifications.map((notif) => (
          <div key={notif.id} className="alert alert-info">
            <h5>{notif.title}</h5>
            <p>{notif.description}</p>
            <small>Date: {notif.date}</small>
            {isAdmin && (
              <div>
                <button
                  className="btn btn-primary btn-sm me-2"
                  onClick={() => {
                    setNotification(notif);
                    setEditMode(true);
                    setEditId(notif.id);
                  }}
                >
                  Edit
                </button>
                <button
                  className="btn btn-danger btn-sm"
                  onClick={() => deleteNotification(notif.id)}
                >
                  Delete
                </button>
              </div>
            )}
          </div>
        ))
      ) : (
        <p className="text-muted">No notifications found.</p>
      )}
    </div>
  );
};

export default NotificationPage;
