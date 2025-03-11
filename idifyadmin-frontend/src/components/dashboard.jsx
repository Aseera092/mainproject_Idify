import React from 'react'
import UsageChart from './chart'

export default function Dashboard() {
  return (
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
          </div>
          <div className="container mt-4">
            <UsageChart />
          </div>
          <div className="card mt-4">
            <div className="card-header">Recent Activities of Panchayath</div>
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
                    <td>Event</td>
                    <td>Feb 15, 2025</td>
                  </tr>
                  <tr>
                    <td>Event</td>
                    <td>Feb 22, 2025</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
  )
}
