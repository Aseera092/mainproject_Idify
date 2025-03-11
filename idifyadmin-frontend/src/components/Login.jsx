import React, { useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import 'bootstrap/dist/css/bootstrap.min.css';

const Login = () => {
    const navigate = useNavigate();
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [message, setMessage] = useState("");

    const handleLogin = async (e) => {
        e.preventDefault();
        try {
            const response = await axios.post("http://localhost:8080/auth/login", {
                email,
                password,
            });

            setMessage(response.data.message);
            localStorage.setItem("token", response.data.token);
            localStorage.setItem("role", response.data.role);
            navigate("/dashboard");

        } catch (error) {
            setMessage(error.response?.data?.message || "Login failed");
        }
    };
    return (
        <div 
            className="d-flex align-items-center justify-content-center" 
            style={{ 
                minHeight: '100vh', 
                backgroundImage: 'url("https://tse3.mm.bing.net/th?id=OIP.mN8amtWIKkDIBcPHHP6TYgHaEK&pid=Api&P=0&h=180")', // Replace with your image path
                backgroundSize: 'cover',
                backgroundPosition: 'center',
            }}
        >
            <div className="container">
                <div className="row justify-content-center">
                    <div className="col-md-6">
                        <div className="card shadow-lg p-4 bg-white rounded">
                            <div className="card-body">
                                <h2 className="card-title text-center mb-4">Login</h2>
                                <form onSubmit={handleLogin}>
                                    <div className="mb-3">
                                        <input
                                            type="email"
                                            className="form-control form-control-lg"
                                            placeholder="Email"
                                            value={email}
                                            onChange={(e) => setEmail(e.target.value)}
                                            required
                                        />
                                    </div>
                                    <div className="mb-3">
                                        <input
                                            type="password"
                                            className="form-control form-control-lg"
                                            placeholder="Password"
                                            value={password}
                                            onChange={(e) => setPassword(e.target.value)}
                                            required
                                        />
                                    </div>
                                    <div className="d-grid gap-2">
                                        <button type="submit" className="btn btn-primary btn-lg">Login</button>
                                    </div>
                                </form>
                                {message && <p className="mt-3 text-center text-danger">{message}</p>}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Login;