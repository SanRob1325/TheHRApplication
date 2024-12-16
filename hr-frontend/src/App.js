import React from 'react';
import {BrowserRouter as Router, Routes, Route, Link} from "react-router-dom";
import Employees from "./Employees";
import Department from "./Department";
import Attendance from "./Attendance";
import PerformanceReviews from "./PerformanceReviews";
import LeaveRequests from "./LeaveRequests";
import './App.css'

function App(){
  return(
      <Router>
          <div>
              <nav className="navbar navbar-expand-lg navbar-light bg-light mb-4">
                  <div className="container">
                      <Link className="navbar-brand" to="/">
                          Snap HR Management System
                      </Link>
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
                          </ul>
                      </div>
                  </div>
              </nav>
              <div className="container">
                  <Routes>
                      <Route path="/" element={<h1>Welcome to Snap HR Management System</h1>}/>
                      <Route path="/employees" element={<Employees />} />
                      <Route path="/departments" element={<Department/>} />
                      <Route path="/attendance" element={<Attendance/>} />
                      <Route path="/performance_reviews" element={<PerformanceReviews />} />
                      <Route path="/leave_requests" element={<LeaveRequests />} />
                  </Routes>
              </div>
          </div>
      </Router>
  )
}
export default App;
