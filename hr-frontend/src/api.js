import axios from "axios";
//Main API gateway for the backend CRUD functionalities
const API = axios.create({baseURL: 'http://54.196.228.85:3000',headers:{'Content-Type': 'application/json'}});

export default API