import React, {useState, useEffect} from "react";
import API from "./api";
import {Table,Button,Modal,Form,Alert,Spinner} from 'react-bootstrap'
import "./Employee.css"
function Employees(){
    const [employees,setEmployees] = useState([]);
    const [departments,setDepartments] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [currentEmployee,setCurrentEmployee] = useState({});
    const [isEditing,setIsEditing] = useState(false);
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        fetchEmployees();
        fetchDepartments();
    }, []);

    const fetchEmployees = async  () =>{
        try {
            setLoading(true);
            const response = await API.get("/employees");
            setEmployees(response.data);
        }catch(err){
            setError("Failed to fetch employees");
        }finally {
            setLoading(false)
        }
    };

    const fetchDepartments = async () => {
        try{
            const response = await API.get("/departments");
            setDepartments(response.data);
        }catch (error){
            setError("Failed to fetch departments")
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();

        try{
            if (isEditing) {
                await  API.put(`/employees/${currentEmployee.id}`, currentEmployee)
            } else{
                await API.post("/employees", currentEmployee);
            }
            setShowModal(false);
            fetchEmployees();
            clearForm();
        } catch (error){
            setError("Failed to save employee")
        }
    };

    const handleAddEmployee = () => {
        setCurrentEmployee({
            name: "",
            email: "",
            department_id: ""});
        setIsEditing(false)
        setShowModal(true)
    };

    const handleEditEmployee = (employee) => {
        setCurrentEmployee(employee);
        setIsEditing(true);
        setShowModal(true)
    };

    const handleDeleteEmployee = async (id) => {
        if (window.confirm("Are you sure you want to delete this employee?")){
            try{
                await API.delete(`/employees/${id}`);
                fetchEmployees();
            }catch (error){
                setError("Failed to delete employee")
            }
        }
    };

    const clearForm = () => {
        setCurrentEmployee({});
        setShowModal(false);
        setError("");
    };

    return (
        <div className="container mt-5 employees-container">
            <h2 className="mb-4">Employee Management</h2>
            {error && <Alert variant="danger">{error}</Alert>}
            <Button id ="add-employee" variant="primary" onClick={handleAddEmployee} className="mb-3">
                Add Employee
            </Button>
            {loading ? (
                <Spinner animation="border" />
            ) :(
                <Table striped bordered hover>
                    <thead className="table-header">
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Department</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    {employees.length > 0 ? (
                        employees.map((emp) =>(
                            <tr key={emp.id}>
                                <td>{emp.name}</td>
                                <td>{emp.email}</td>
                                <td>{emp.department?.name || "N/A"}</td>
                                <td>
                                    <Button
                                        variant="warning"
                                        className="me-2"
                                        onClick={() => handleEditEmployee(emp)}
                                        aria-label={`Edit ${emp.name}`}
                                        >
                                        Edit
                                    </Button>
                                    <Button
                                        variant="danger"
                                        onClick={() => handleDeleteEmployee(emp.id)}
                                        aria-label={`Delete ${emp.name}`}
                                        >
                                        Delete
                                        </Button>
                                </td>
                            </tr>
                        ))
                        ) : (
                            <tr>
                                <td colSpan="4" className="text-center">
                                    No employees found.
                                </td>
                            </tr>
                            )}
                    </tbody>
                </Table>
            )}
                    <Modal show={showModal} onHide={clearForm}>
                        <Modal.Header closeButton>
                            <Modal.Title>{isEditing ? "Edit Employee" : "Add Employee"}</Modal.Title>
                        </Modal.Header>
                        <Modal.Body>
                            <Form onSubmit={handleSubmit}>
                                <Form.Group className="mb-3">
                                    <Form.Label>Name</Form.Label>
                                    <Form.Control
                                        type="text"
                                        value={currentEmployee.name || ""}
                                        onChange={(e) =>
                                            setCurrentEmployee({
                                                ...currentEmployee,
                                                name: e.target.value,
                                            })
                                        }
                                        required
                                        />
                                </Form.Group>
                                <Form.Group className="mb-3">
                                    <Form.Label>Email</Form.Label>
                                    <Form.Control
                                        type="email"
                                        value={currentEmployee.email || ""}
                                        onChange={(e) =>
                                            setCurrentEmployee({
                                                ...currentEmployee,
                                                email: e.target.value
                                            })
                                        }
                                        required
                                        />
                                </Form.Group>
                                <Form.Group className="mb-3">
                                    <Form.Label>Department</Form.Label>
                                    <Form.Select
                                        value={currentEmployee.department_id || ""}
                                        onChange={(e) =>
                                        setCurrentEmployee({
                                            ...currentEmployee,
                                            department_id: e.target.value,
                                        })
                                        }
                                        required
                                        >
                                        <option value="">Select Department</option>
                                        {departments.map((dept) => (
                                            <option key={dept.id} value={dept.id}>
                                                {dept.name}
                                            </option>
                                        ))}
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
export default Employees;




