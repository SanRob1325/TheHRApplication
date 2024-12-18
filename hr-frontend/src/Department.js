import React, {useState, useEffect} from "react";
import API from "./api";
import {Table,Button,Modal,Form,Alert,Spinner} from 'react-bootstrap'
import "./Department.css"
function Department(){
    const [departments,setDepartments] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [currentDepartment,setCurrentDepartment] = useState({});
    const [isEditing,setIsEditing] = useState(false);
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        fetchDepartments();
    }, []);
    //API Calls to the backend
    const fetchDepartments = async () => {
        try{
            setLoading(true);
            const response = await API.get("/departments");
            setDepartments(response.data);
        }catch (error){
            setError("Failed to fetch departments");
        } finally {
            setLoading(false);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try{
            if (isEditing) {
                await  API.put(`/departments/${currentDepartment.id}`, currentDepartment)
            } else{
                await API.post("/departments", currentDepartment);
            }
            setShowModal(false);
            fetchDepartments();
            clearForm();
        } catch (error){
            setError("Failed to save Department")
        }
    };

    const handleAddDepartment = () => {
        setCurrentDepartment({
            name: "",
            description:""
        });
        setIsEditing(false)
        setShowModal(true)
    };

    const handleEditDepartment = (department) => {
        setCurrentDepartment(department);
        setIsEditing(true);
        setShowModal(true)
    };

    const handleDeleteDepartment = async (id) => {
        if (window.confirm("Are you sure you want to delete this department?")){
            try{
                await API.delete(`/departments/${id}`);
                fetchDepartments();
            }catch (error){
                setError("Failed to delete employee")
            }
        }
    };

    const clearForm = () => {
        setCurrentDepartment({});
        setShowModal(false);
        setError("");
    };
    //uses DOM manipulation to call the functions to execute the REACT methods,additionally bootstrap styling added
    return (
        <div className="container mt-5 departments-container">
            <h2 className="mb-4">Department Management</h2>
            {error && <Alert variant="danger">{error}</Alert>}
            <Button variant="primary" onClick={handleAddDepartment} className="mb-3">
                Add Department
            </Button>
            {loading ? (
                <Spinner animation="border" />
            ) :(
                <Table striped bordered hover>
                    <thead className="table-header">
                    <tr>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    {departments.length > 0 ? (
                        departments.map((dept) =>(
                            <tr key={dept.id}>
                                <td>{dept.name}</td>
                                <td>{dept.description}</td>
                                <td>
                                    <Button
                                        variant="warning"
                                        className="me-2"
                                        onClick={() => handleEditDepartment(dept)}
                                        aria-label={`Edit ${dept.name}`}
                                    >
                                        Edit
                                    </Button>
                                    <Button
                                        variant="danger"
                                        onClick={() => handleDeleteDepartment(dept.id)}
                                        aria-label={`Delete ${dept.name}`}
                                    >
                                        Delete
                                    </Button>
                                </td>
                            </tr>
                        ))
                    ) : (
                        <tr>
                            <td colSpan="3" className="text-center">
                                No departments found.
                            </td>
                        </tr>
                    )}
                    </tbody>
                </Table>
            )}
            <Modal show={showModal} onHide={clearForm}>
                <Modal.Header closeButton>
                    <Modal.Title>{isEditing ? "Edit Department" : "Add Department"}</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form onSubmit={handleSubmit}>
                        <Form.Group className="mb-3">
                            <Form.Label>Name</Form.Label>
                            <Form.Control
                                type="text"
                                value={currentDepartment.name || ""}
                                onChange={(e) =>
                                    setCurrentDepartment({
                                        ...currentDepartment,
                                        name: e.target.value,
                                    })
                                }
                                required
                            />
                        </Form.Group>
                        <Form.Group className="mb-3">
                            <Form.Label>Description</Form.Label>
                            <Form.Control
                                as="textarea"
                                value={currentDepartment.description || ""}
                                onChange={(e) =>
                                    setCurrentDepartment({
                                        ...currentDepartment,
                                        description: e.target.value
                                    })
                                }
                            />
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
export default Department;


