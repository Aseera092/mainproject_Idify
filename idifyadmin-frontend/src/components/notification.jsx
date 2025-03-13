import React, { useState, useEffect } from 'react';
import { toast } from 'react-toastify';
import { addNotificationAPI, getNotificationAPI } from '../services/notification';

const NotificationPage = () => {
  const [isAdmin, setIsAdmin] = useState(true);
  const [notification, setNotification] = useState({ title: '', body: '', Date: '' });
  const [notifications, setNotifications] = useState([]);
  const [editMode, setEditMode] = useState(false);
  const [editId, setEditId] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    init()
  }, []);

  const init = () =>{
    getNotificationAPI().then((res)=>{
      if (res.status) {
        setNotifications(res.data);
      }
    })
  }

  const inputHandler = (event) => {
    setNotification({ ...notification, [event.target.name]: event.target.value });
  };

  const addNotification = () => {
    if (!notification.title || !notification.body || !notification.Date) {
      toast.error("Please fill all Fields")
      return;
    }
    addNotificationAPI(notification).then((res)=>{
      if(res.status){
        toast.success(res.message)
        init()
      }
    }).catch((error)=>{
      toast.error(error.response.data.message);
    })

    setNotification({ title: '', body: '', Date: '' });
  };


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
            name="body"
            placeholder="Description"
            value={notification.body}
            onChange={inputHandler}
            className="form-control mb-2"
          ></textarea>
          <input
            type="date"
            name="Date"
            value={notification.Date}
            onChange={inputHandler}
            className="form-control mb-2"
          />
        
          <button className="btn btn-success" onClick={addNotification}>
            Add Notification
          </button>
        </div>
      )}

      {/* <input
        type="text"
        placeholder="Search notifications..."
        value={searchTerm}
        onChange={(e) => setSearchTerm(e.target.value)}
        className="form-control mb-4"
      /> */}

      {notifications.length > 0 ? (
        notifications.map((notif) => (
          <div key={notif.id} className="alert alert-info">
            <h5>{notif.title}</h5>
            <p>{notif.body}</p>
            <small>Date: {notif.Date}</small>
            {/* {isAdmin && (
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
            )} */}
          </div>
        ))
      ) : (
        <p className="text-muted">No notifications found.</p>
      )}
    </div>
  );
};

export default NotificationPage;
