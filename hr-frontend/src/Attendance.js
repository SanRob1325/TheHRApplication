import React, {useState, useEffect} from "react";
import API from "./api";
import {Table,Button,Modal,Form,Alert,Spinner} from 'react-bootstrap'
import "./Attendance.css"
function Attendances(){
    const [attendances,setAttendances] = useState([]);
    const [employees,setEmployees] = useState([])
    const [showModal, setShowModal] = useState(false);
    const [currentAttendance,setCurrentAttendance] = useState({});
    const [isEditing,setIsEditing] = useState(false);
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        fetchAttendances();
        fetchEmployees();
    }, []);
    //API calls to the backend
    const fetchAttendances = async () => {
        try{
            setLoading(true);
            const response = await API.get("/attendances");
            setAttendances(response.data);
        }catch (error){
            setError("Failed to fetch attendance records");
        } finally {
            setLoading(false);
        }
    };

    const fetchEmployees = async () => {
        try{
            const response =await API.get("/employees");
            setEmployees(response.data)
        }catch (error){
            setError("Failed to fetch employees")
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try{
            if (isEditing) {
                await  API.put(`/attendances/${currentAttendance.id}`, currentAttendance)
            } else{
                await API.post("/attendances", {attendance: currentAttendance});
            }
            setShowModal(false);
            fetchAttendances();
            clearForm();
        } catch (error){
            setError("Failed to save Attendance")
        }
    };

    const handleAddAttendance = () => {
        setCurrentAttendance({
            employee_id: "",
            date:"",
            status:""
        });
        setIsEditing(false)
        setShowModal(true)
    };

    const handleEditAttendance = (attendance) => {
        setCurrentAttendance(attendance);
        setIsEditing(true);
        setShowModal(true)
    };

    const handleDeleteAttendance = async (id) => {
        if (window.confirm("Are you sure you want to delete this record?")){
            try{
                await API.delete(`/attendances/${id}`);
                fetchAttendances();
            }catch (error){
                setError("Failed to delete attendance")
            }
        }
    };

    const clearForm = () => {
        setCurrentAttendance({});
        setShowModal(false);
        setError("");
    };
    //uses DOM manipulation to call the functions to execute the REACT methods,additionally bootstrap styling added
    //Inspiration and Reference:https://www.npmjs.com/package/react-spinners
    return (
        <div className="container mt-5 attendances-container">
            <h2 className="mb-4">Attendance Management</h2>
            {error && <Alert variant="danger">{error}</Alert>}
            <Button variant="primary" onClick={handleAddAttendance} className="mb-3">
                Add Attendance
            </Button>
            {loading ? (
                <Spinner animation="border" />
            ) :(
                <Table striped bordered hover>
                    <thead className="table-header">
                    <tr>
                        <th>Name</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    {attendances.length > 0 ? (
                        attendances.map((att) =>(
                            <tr key={att.id}>
                                <td>{att.employee?.name || "N/A"}</td>
                                <td>{att.date}</td>
                                <td>{att.status}</td>
                                <td>
                                    <Button
                                        variant="warning"
                                        className="me-2"
                                        onClick={() => handleEditAttendance(att)}
                                        aria-label={`Edit ${att.employee?.name || "N/A"}`}
                                    >
                                        Edit
                                    </Button>
                                    <Button
                                        variant="danger"
                                        onClick={() => handleDeleteAttendance(att.id)}
                                        aria-label={`Delete ${att.employee?.name || "N/A"}`}
                                    >
                                        Delete
                                    </Button>
                                </td>
                            </tr>
                        ))
                    ) : (
                        <tr>
                            <td colSpan="4" className="text-center">
                                No attendance records found.
                            </td>
                        </tr>
                    )}
                    </tbody>
                </Table>
            )}
            <Modal show={showModal} onHide={clearForm}>
                <Modal.Header closeButton>
                    <Modal.Title>{isEditing ? "Edit Attendance" : "Add Attendance"}</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form onSubmit={handleSubmit}>
                        <Form.Group className="mb-3">
                            <Form.Label>Employee</Form.Label>
                            <Form.Select
                                value={currentAttendance.employee_id || ""}
                                onChange={(e) =>
                                    setCurrentAttendance({
                                        ...currentAttendance,
                                        employee_id: e.target.value || "",
                                    })
                                }
                                required
                            >
                                <option value="">Select Employee</option>
                                {employees.map((emp) =>(
                                    <option key={emp.id} value={emp.id} >
                                        {emp.name}
                                    </option>
                                    ))}
                            </Form.Select>
                            </Form.Group>
                            <Form.Group className="mb-3">
                            <Form.Label>Date</Form.Label>
                            <Form.Control
                                type="date"
                                value={currentAttendance.date || ""}
                                onChange={(e) =>
                                    setCurrentAttendance({
                                        ...currentAttendance,
                                        date: e.target.value || "",
                                    })
                                }
                                required
                            />
                        </Form.Group>
                        <Form.Group className="mb-3">
                            <Form.Label>Status</Form.Label>
                            <Form.Select
                                value={currentAttendance.status || ""}
                                onChange={(e) =>
                                    setCurrentAttendance({
                                        ...currentAttendance,
                                        status: e.target.value || "",
                                    })
                            }
                                required
                            >
                                <option value="">Select Status</option>
                                <option value="Present">Present</option>
                                <option value="Absent">Absent</option>
                            </Form.Select>
                        </Form.Group>
                        <Button variant="primary" type="submit">
                            Save
                        </Button>
                    </Form>
                </Modal.Body>
            </Modal>
        </div>
    );
}
export default Attendances;