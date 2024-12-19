import React from 'react';
import {BrowserRouter as Router, Routes, Route, Link} from "react-router-dom";
import Employees from "./Employees";
import Department from "./Department";
import Attendance from "./Attendance";
import PerformanceReviews from "./PerformanceReviews";
import LeaveRequests from "./LeaveRequests";
import NotificationManager from "./NotificationManager";
import About from "./About";
import './App.css'
import logo from './assets/human-resource-logo.jpg'
import image from './images/HRdesign.jpg'
function App(){
    //Reference: https://api.reactrouter.com/v7/functions/react_router.Link.html
    //Inspiration and Reference:https://www.npmjs.com/package/react-router-dom
    //Inspiration and Reference:https://create-react-app.dev/docs/adding-images-fonts-and-files/
  return(
      <Router>
          <div>
              <nav className="navbar navbar-expand-lg navbar-light bg-light mb-4">
                  <div className="container">
                      <Link className="navbar-brand d-flex align-items-center" to="/">
                          <img
                              src={logo}
                              alt="Snap HR Logo"
                              width="40"
                              height="40"
                              className="me-2"
                          />
                          <span>Snap HR Management System </span>
                      </Link >
                      <button
                          className="navbar-toggler"
                          type="button"
                          data-bs-toggle="collapse"
                          data-bs-target="#navbarNav"
                          aria-controls="navbarNav"
                          aria-expanded="false"
                          aria-label="Toggle navigation"
                          >
                          <span className="navbar-toggler-icon"></span>
                      </button>
                      <div className="collapse navbar-collapse" id="navbarNav">
                          <ul className="navbar-nav me-auto mb-2 mb-lg-0">
                              <li className="nav-item">
                                  <Link className="nav-link" to="/employees">
                                      Employees
                                  </Link>
                              </li>
                              <li className="nav-item">
                                  <Link className="nav-link" to="/departments">
                                      Departments
                                  </Link>
                              </li>
                              <li className="nav-item">
                                  <Link className="nav-link" to="/attendance">
                                      Attendance
                                  </Link>
                              </li>
                              <li className="nav-item">
                                  <Link className="nav-link" to="/performance_reviews">
                                      Performance Reviews
                                  </Link>
                              </li>
                              <li className="nav-item">
                                  <Link className="nav-link" to="/leave_requests">
                                      Leave Requests
                                  </Link>
                              </li>
                              <li className="nav-item">
                                  <Link className="nav-link" to="/notifications">
                                      Notifications
                                  </Link>
                              </li>
                              <li className="nav-item">
                                  <Link className="nav-link" to="/about">
                                      About
                                  </Link>
                              </li>
                          </ul>
                      </div>
                  </div>
              </nav>
              <div className="container">
                  <Routes>
                      <Route path="/" element={
                          <div style={{textAlign: "center", marginTop: "20px"}}>
                          <h1>Welcome to Snap HR Management System</h1>
                          <img
                            src={image}
                            alt="Image for topic"
                            style={{
                                maxWidth: "100%",
                                height: "auto",
                                marginTop: "20px",
                                borderRadius: "8px"
                            }}
                            />
                          </div>
                      }/>
                      <Route path="/employees" element={<Employees />} />
                      <Route path="/departments" element={<Department/>} />
                      <Route path="/attendance" element={<Attendance/>} />
                      <Route path="/performance_reviews" element={<PerformanceReviews />} />
                      <Route path="/leave_requests" element={<LeaveRequests />} />
                      <Route path="/notifications" element={<NotificationManager />} />
                      <Route path="/about" element={<About />} />
                  </Routes>
              </div>
          </div>
      </Router>
  )
}
export default App;
