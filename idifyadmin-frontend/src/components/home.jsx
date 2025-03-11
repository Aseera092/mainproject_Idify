import React from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import Navbar from "../layout/navbar";
import Sidebar from "../layout/sidebar";
import UsageChart from "../components/chart";

const Home = () => {
  return (
    <div className="d-flex">
      <Sidebar />
      <div className="flex-grow-1">
        <Navbar />
        <div className="container mt-4">
          <div className="row">
            <div className="col-md-4">
              <div className="card text-white bg-primary mb-3">
                <div className="card-header">Total Users</div>
                <div className="card-body">
                  <h5 className="card-title">200</h5>
                </div>
              </div>
            </div>
          
            <div className="container mt-4">
          {/* Existing Dashboard Cards */}
          
          {/* Add the Chart Below */}
          <UsageChart />
        </div>
          </div>
          <div className="card mt-4">
            <div className="card-header">Recent Activities of panchayath</div>
            <div className="card-body">
              <table className="table table-striped">
                <thead>
                  <tr>
                    
                    <th>Action</th>
                    <th>Date</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                   
                    <td>event</td>
                    <td>Feb 15, 2025</td>
                  </tr>
                  <tr>
                    
                    <td>event</td>
                    <td>Feb 22, 2025</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Home;
