import React, {useState, useEffect, use} from "react"; // Import React and hooks for state adn lifecycle management
import API from "./api"; // Imports the API instance for interacting with the backend endpoints

// Functional component to manage notifications
const NotificationManager = () => {
    const [notifications, setNotifications] = useState([]);
    const [message, setMessage] = useState("");
    const [error, setError] = useState("");
    //API endpoint requests that will execute functionality once interaction
    const fetchNotifications = async () => {
        try {
            const response = await API.get("/notifications"); // GET request to fetch notifications
            setNotifications(response.data); // Update state with fetched notifications
        } catch (err) {
            console.error("Error fetching notifications:", err); //log error to the console
            setError("Error fetching notifications") // Set error  message for the UI
        }
    };
    // add notification to the backend, the message entered by the user is sent as the payload
    // Refreshes the notification list after a successful addition
    const addNotification = async () => {
        if(message.trim() === "") return alert("Please fill in the message")
        const response = await API.post("/notifications", {message})
        setMessage("")
        fetchNotifications();
    }
    /*
    * Deletes a specific notification by it's ID
    * Triggers a refresh of the notification list after successful deletion
    * **/
    const deleteNotification = async (id) => {
        try {
            await API.delete(`/notifications/${id}`);
            fetchNotifications();
        } catch (err) {
            console.error("Error deleting notification", err)
            setError("Error deleting notification")
        }
    };
    // clears all notifications from the backend
    //Refreshes the notification list after a deletion
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
    //uses DOM and JSX manipulation to call the functions to execute the REACT methods
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
