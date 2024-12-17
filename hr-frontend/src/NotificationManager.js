import React, {useState, useEffect, use} from "react";
import axios from "axios";
import API from "./api";

const NotificationManager = () => {
    const [notifications, setNotifications] = useState([]);
    const [newMessage, setNewMessage] = useState("");
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

    const addNotification = async (message) => {
        console.log("Sending notification:", message);
        try {
            const response = await API.post('/notifications',{message})
            console.log('Notification added:',response.data)
        } catch (error) {
            console.error("Error adding notifications", error.response?.data || error.message);
        }
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
        <div>
            <h1>Notification Manager</h1>

            {error && <p style={{color: "red"}}>{error}</p>}
            <div>
                <input
                    type="text"
                    placeholder="Enter notification message"
                    value={newMessage}
                    onChange={(e) => setNewMessage(e.target.value)}
                />
                <button onClick={() =>addNotification("New notification")}>Add Notification</button>
            </div>
            <h2>Notifications</h2>
            {notifications.length === 0 ? (
                <p>No notifications available.</p>
            ) : (
                <ul>
                    {notifications.map((notification) => (
                        <li key={notification.id}>
                            {notification.message}{""}
                            <button onClick={() => deleteNotification(notification.id)}>
                                Delete
                            </button>
                        </li>

                    ))}
                </ul>
            )}
            <button onClick={clearNotifications} style={{marginTop: "10px"}}>
                Clear All Notifications
            </button>
        </div>
    );
};

export default NotificationManager;
