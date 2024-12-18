import React, {useState, useEffect} from "react";
import API from "./api";
import {Table,Button,Modal,Form,Alert} from 'react-bootstrap'

function PerformanceReviews() {
    const [reviews, setReviews] = useState([]);
    const [employees, setEmployees] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [currentReview, setCurrentReview] = useState({});
    const [isEditing, setIsEditing] = useState(false);
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false)

    useEffect(() => {
        fetchReviews();
        fetchEmployees();
    }, []);

    const fetchReviews = async () => {
        try {
            const response = await API.get("/performance_reviews")
            setReviews(response.data)
        } catch (err) {
            setError("Failed to fetch performance reviews")
        }
    };
    const fetchEmployees = async () => {
        try {
            setLoading(true);
            const response = await API.get("/employees");
            setEmployees(response.data);
        } catch (err) {
            setError("Failed to fetch employees");
        } finally {
            setLoading(false);
        }
    };

    const handleDelete = async (id) => {
        if(window.confirm("Are you sure you want to delete this review?")){
            try{
                await  API.delete(`/performance_reviews/${id}`);
                setReviews(reviews.filter((review) => review.id !== id));
            }catch (err){
                setError("Failed to delete review")
            }
        }
    }

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            if (isEditing){
                await API.put(`/performance_reviews/${currentReview.id}`, currentReview)
            }else{
                await API.post(`/performance_reviews`, currentReview)
            }

            fetchReviews();
            setShowModal(false);
            clearForm();
        } catch (err) {
            setError("Failed to save employee")
        }
    };

    const clearForm = () =>{
        setCurrentReview({});
        setError("");
    }
//uses DOM manipulation to call the functions to execute the REACT methods,additionally bootstrap styling added
    return (
        <div className="container mt-5">
            <h2 className="mb-4">Performance Reviews</h2>
            {error && <Alert variant="danger">{error}</Alert>}
            <Button onClick={() => setShowModal(true)}>
                Add Review
            </Button>
            <Table striped bordered hover className="mt-5">
                <thead>
                <tr>
                    <th>Employee</th>
                    <th>Reviewer</th>
                    <th>Rating</th>
                    <th>Feedback</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                {reviews.map((review) => (
                    <tr key={review.id}>
                        <td>{review.employee?.name || "N/A"}</td>
                        <td>{review.reviewer}</td>
                        <td>{review.rating}</td>
                        <td>{review.feedback}</td>
                        <td>
                            <Button
                                variant="warning"
                                className="me-2"
                                onClick={() =>{
                                    setCurrentReview(review);
                                    setIsEditing(true)
                                    setShowModal(true)
                                }}
                                >
                                Edit
                            </Button>
                            <Button
                                variant="danger"
                                onClick={() => handleDelete(review.id)}
                                >
                                Delete
                            </Button>
                        </td>
                    </tr>
                ))}
                </tbody>
            </Table>

            <Modal show={showModal} onHide={() => setShowModal(false)}>
                <Modal.Header closeButton>
                    <Modal.Title>{isEditing ? "Edit Performance Review" : "Add Performance Review"}</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form onSubmit={handleSubmit}>
                        <Form.Group>
                            <Form.Label>Employee</Form.Label>
                            <Form.Select
                                value={currentReview.employee_id || ""}
                                onChange={(e) =>
                                    setCurrentReview({...currentReview, employee_id: e.target.value})
                                }
                                required
                            >
                                <option value="">Select Employee</option>
                                {employees.map((emp) => (
                                    <option key={emp.id} value={emp.id}>
                                        {emp.name}
                                    </option>
                                ))}
                            </Form.Select>
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Reviewer</Form.Label>
                            <Form.Control
                                type="text"
                                value={currentReview.reviewer || ""}
                                onChange={(e) =>
                                    setCurrentReview({...currentReview, reviewer: e.target.value})
                                }
                                required
                            />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Rating</Form.Label>
                            <Form.Select
                                value={currentReview.rating || ""}
                                onChange={(e) =>
                                    setCurrentReview({...currentReview, rating: e.target.value})
                                }
                                required
                            >
                                <option value="">Select Rating</option>
                                {[1,2,3,4,5].map((rating) => (
                                    <option key={rating} value={rating}>
                                        {rating}
                                    </option>
                                ))}
                            </Form.Select>
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Feedback</Form.Label>
                            <Form.Control
                                as="textarea"
                                rows={3}
                                value={currentReview.feedback || ""}
                                onChange={(e) =>
                                    setCurrentReview({...currentReview, feedback: e.target.value})

                                }
                                required
                            />
                        </Form.Group>
                        <div className="mt-3">
                            <Button variant="primary" type="submit">
                                Save
                            </Button>
                            <Button
                                variant="secondary"
                                className="ms-2"
                                onClick={() => {setShowModal(false); clearForm()}}
                                >
                                Cancel
                            </Button>
                        </div>
                    </Form>
                </Modal.Body>
            </Modal>
        </div>
    );
}


export default PerformanceReviews;