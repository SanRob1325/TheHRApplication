import React from "react";
import {useNavigate} from "react-router-dom";

function Logout(){
    const navigate = useNavigate()

    const handleLogout = () => {
        localStorage.removeItem("authToken");
        navigate("/login")
    };

    return(
        <button onClick={handleLogout} className="btn btn-danger">
            Logout
        </button>
    );
}

export default Logout