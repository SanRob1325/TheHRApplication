import React, {useState, useEffect} from "react";
import API from "./api";
import {Table,Button,Modal,Form,Alert,Spinner} from 'react-bootstrap'

function LeaveRequests(){
    const [leaveRequests,setLeaveRequests] = useState([]);
    const [employees,setEmployees] = useState([])
    const [showModal, setShowModal] = useState(false);
    const [currentLeave,setCurrentLeave] = useState({});
    const [isEditing,setIsEditing] = useState(false);
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);
    const [saving, setSaving] = useState(false)

    useEffect(() => {
        fetchLeaveRequests();
        fetchEmployees();
    }, []);

    const fetchLeaveRequests = async () => {
        try{
            setLoading(true);
            const response = await API.get("/leave_requests");
            setLeaveRequests(response.data);
        }catch (error){
            setError("Failed to fetch leave requests");
        }finally {
            setLoading(false);
        }
    };
    //API Calls to the backend
    const fetchEmployees = async () => {
        try{
            const response = await API.get("/employees");
            setEmployees(response.data)
        }catch (err){
            setError("Failed to fetch employees")
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try{
            if (isEditing) {
                await  API.put(`/leave_requests/${currentLeave.id}`, {leave_request: currentLeave})
            } else{
                await API.post("/leave_requests",  currentLeave);
            }
            setShowModal(false);
            fetchLeaveRequests();
            clearForm();
        } catch (error){
            setError("Failed to save Leave Requests")
        } finally {
            setSaving(false);
        }
    };

    const handleAddLeaveRequest = () => {
        setCurrentLeave({
            employee_id: "",
            leave_type: "",
            start_date:"",
            end_date:"",
            reason:"",
            status:"Pending"
        });
        setIsEditing(false)
        setShowModal(true)
    };

    const handleEditLeaveRequest = (leaveRequest) => {
        setCurrentLeave(leaveRequest);
        setIsEditing(true);
        setShowModal(true)
    };

    const handleDeleteLeaveRequest = async (id) => {
        if (window.confirm("Are you sure you want to delete this leave request?")){
            try{
                await API.delete(`/leave_requests/${id}`);
                fetchLeaveRequests();
            }catch (error){
                setError("Failed to delete leave request")
            }
        }
    };

    const clearForm = () => {
        setCurrentLeave({});
        setShowModal(false);
        setError("");
    };
    // Inspiration and Reference:https://www.npmjs.com/package/react-modal
    // Inspiration and Reference: https://www.npmjs.com/package/react-alert
    // Inspiration and Reference:https://react.dev/reference/react-dom/components/form
    return (
        <div className="container mt-5 leave-requests-container">
            <h2 className="mb-4">Leave Requests Management</h2>
            {error && <Alert variant="danger">{error}</Alert>}
            <Button variant="primary" onClick={handleAddLeaveRequest} className="mb-3">
                Add A Leave Request
            </Button>
            {loading ? (
                <Spinner animation="border" />
            ) :(
                <Table striped bordered hover>
                    <thead className="table-header">
                    <tr>
                        <th>Employee</th>
                        <th>Leave Type</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Reason</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    {leaveRequests.length > 0 ? (
                        leaveRequests.map((leave) =>(
                            <tr key={leave.id}>
                                <td>{leave.employee?.name || "N/A"}</td>
                                <td>{leave.leave_type}</td>
                                <td>{leave.start_date}</td>
                                <td>{leave.end_date}</td>
                                <td>{leave.reason || "N/A"}</td>
                                <td>{leave.status}</td>
                                <td>
                                    <Button
                                        variant="warning"
                                        className="me-2"
                                        onClick={() => handleEditLeaveRequest(leave)}
                                    >
                                        Edit
                                    </Button>
                                    <Button
                                        variant="danger"
                                        onClick={() => handleDeleteLeaveRequest(leave.id)}
                                    >
                                        Reject Leave
                                    </Button>
                                </td>
                            </tr>
                        ))
                    ) : (
                        <tr>
                            <td colSpan="7" className="text-center">
                                No attendance leave requests found.
                            </td>
                        </tr>
                    )}
                    </tbody>
                </Table>
            )}
            <Modal show={showModal} onHide={clearForm}>
                <Modal.Header closeButton>
                    <Modal.Title>{isEditing ? "Edit Leave Request" : "Add Leave Request"}</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form onSubmit={handleSubmit}>
                        <Form.Group className="mb-3">
                            <Form.Label>Employee</Form.Label>
                            <Form.Select
                                value={currentLeave.employee_id || ""}
                                onChange={(e) =>
                                    setCurrentLeave({
                                        ...currentLeave,
                                        employee_id: e.target.value
                                    })
                                }
                                required
                            >
                                <option value="">Select Employee</option>
                                {employees.map((emp) => (
                                    <option key={emp.id} value={emp.id} >
                                        {emp.name}
                                    </option>
                                ))}
                            </Form.Select>
                        </Form.Group>
                        <Form.Group className="mb-3">
                            <Form.Label>Leave Type</Form.Label>
                            <Form.Select
                                value={currentLeave.leave_type || ""}
                                onChange={(e) =>
                                    setCurrentLeave({...currentLeave,leave_type: e.target.value})
                                }
                                required
                                >
                                <option value="">Select Type</option>
                                <option value="Casual">Casual</option>
                                <option value="Sick">Sick</option>
                                <option value="Unpaid">Unpaid</option>
                            </Form.Select>
                        </Form.Group>
                        <Form.Group className="mb-3">
                            <Form.Label>Start Date</Form.Label>
                            <Form.Control
                                type="date"
                                value={currentLeave.start_date || ""}
                                onChange={(e) =>
                                    setCurrentLeave(({...currentLeave,start_date: e.target.value}))
                            }
                                required
                                />
                            </Form.Group>
                                <Form.Group className="mb-3">
                                    <Form.Label>End Date</Form.Label>
                                    <Form.Control
                                        type="date"
                                        value={currentLeave.end_date || ""}
                                        onChange={(e) =>
                                            setCurrentLeave({...currentLeave,end_date: e.target.value})
                                        }
                                        required
                                        />
                                </Form.Group>
                                <Form.Group className="mb-3">
                                    <Form.Label>Reason</Form.Label>
                                    <Form.Control
                                        as="textarea"
                                        rows={3}
                                        value={currentLeave.reason || ""}
                                        onChange={(e) =>
                                            setCurrentLeave({...currentLeave,reason: e.target.value})

                                    }
                                        />
                            </Form.Group>
                        <Button variant="primary" type="submit" disable={saving}>
                            { saving ? "Saving..."  : "Save Leave Request"}
                        </Button>
                    </Form>
                </Modal.Body>
            </Modal>
        </div>
    );
}
export default LeaveRequests;