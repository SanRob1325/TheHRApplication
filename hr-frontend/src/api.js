import axios from "axios";
//Main API gateway for the backend CRUD functionalities
const API = axios.create({baseURL: 'http://44.212.150.181:3000',headers:{'Content-Type': 'application/json'}});

export default API