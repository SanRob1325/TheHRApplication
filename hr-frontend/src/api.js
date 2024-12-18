import axios from "axios";
//Main API gateway for the backend CRUD functionalities
const API = axios.create({baseURL: 'http://54.161.211.89:3000',headers:{'Content-Type': 'application/json'}});

export default API