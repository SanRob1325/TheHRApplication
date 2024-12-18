import React, {useState, useEffect, use} from "react";
import API from "./api";

const NotificationManager = () => {
    const [notifications, setNotifications] = useState([]);
    const [message, setMessage] = useState("");
    const [error, setError] = useState("");

    const fetchNotifications = async () => {
        try {
            const response = await API.get("/notifications");
            setNotifications(response.data);
        } catch (err) {
            console.error("Error fetching notifications:", err);
            setError("Error fetching notifications")
        }
    };

    const addNotification = async () => {
        if(message.trim() === "") return alert("Please fill in the message")
        const response = await API.post("/notifications", {message})
        setMessage("")
        fetchNotifications();
    };

    const deleteNotification = async (id) => {
        try {
            await API.delete(`/notifications/${id}`);
            fetchNotifications();
        } catch (err) {
            console.error("Error deleting notification", err)
            setError("Error deleting notification")
        }
    };

    const clearNotifications = async () => {
        try {
            await API.delete("/notifications")
            fetchNotifications()
        } catch (err) {
            console.error("Error clearing notifications", err)
            setError("Error clearing notifications")
        }
    };

    useEffect(() => {
        fetchNotifications();
    }, []);

    return (
        <div className="notification-manager">
            <h1 className="title">Notification Manager</h1>

            {error && <p className="error-message">{error}</p>}
            <div>
                <input
                    type="text"
                    placeholder="Enter a message"
                    value={message}
                    onChange={(e) => setMessage(e.target.value)}
                    className="input-box"
                />
                <button onClick={ addNotification} className="btn add-btn">Add Notification</button>
                <button onClick={ clearNotifications} className="btn clear-btn">Clear All</button>
            </div>
            <ul className="notification-list">
                {notifications.map((notification) => (
                    <li key={notification.id} className="notification-item">
                        {notification.message}
                        <button onClick={() => deleteNotification(notification.id)} className="btn delete-btn">
                            Delete
                        </button>
                    </li>
                ))}
            </ul>
        </div>

    );
};

export default NotificationManager;
