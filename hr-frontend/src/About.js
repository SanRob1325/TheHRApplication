import React from "react";
import "./About.css"
//Added bootstrap styling
function About(){
    return(
        <div className="container mt-5 about-container">
            <h1>About Snap HR Management System</h1>
            <p>
                Welcome to the Snap HR Management System! This application is designed to streamline automated HR processes,providing
                a user friendly interface fo managing departments,employees and more
            </p>
            <h3>Features:</h3>
            <ul>
                <li>Employment Management</li>
                <li>Department Management</li>
                <li>Attendance Tracking</li>
                <li>Performance Reviews</li>
            </ul>
            <p>
                Built with <strong>Ruby on Rails</strong> for the backend and <strong>React</strong> for the frontend,Snap HR Management System is a scalable SaaS service for management solutions
            </p>
        </div>
    );
}

export default About;