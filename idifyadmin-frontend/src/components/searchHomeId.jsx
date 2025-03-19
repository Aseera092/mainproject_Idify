import React, { useState, useEffect } from "react";
import { getHomespotid, getHomespotidById } from "../services/homespotid";
import { toast } from "react-toastify";

const SearchHomeSpotId = () => {
  const [homespotid, setHomespotid] = useState({});
  const [searchTerm, setSearchTerm] = useState("");

  const handleSearch = () => {
    getHomespotidById(searchTerm)
      .then((res) => {
        if (res.status) {
          setHomespotid(res.data);
        } else {
          toast.error("Home Not Found");
          setHomespotid();
        }
      })
      .catch((err) => {
        toast.error("Home Not Found");
      });
  };

  return (
    <div className="container">
      <h2>Search Home Spot IDs</h2>
      <div className="input-group mb-3">
        <input
          type="text"
          placeholder="Search HomespotID"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="form-control"
        />
        <button
          className="btn btn-primary"
          type="button"
          onClick={handleSearch}
        >
          Search
        </button>
      </div>
      {homespotid && ( // Conditionally render the table after a search
        <table className="table">
          <thead>
            <tr>
              <th>HomeId</th>
              <th>Location</th>
              <th>Pin Code</th>
              <th>Ward</th>
            </tr>
          </thead>
          <tbody>
            {homespotid && (
              <tr key={homespotid._id}>
                <td>{homespotid.homeId}</td>
                <td>
                  latitude:{homespotid.latitude}
                  <br />
                  longitude:{homespotid.longitude}
                </td>
                <td>{homespotid.pincode}</td>
                <td>{homespotid.wardNo}</td>
              </tr>
            )}
          </tbody>
        </table>
      )}
    </div>
  );
};

export default SearchHomeSpotId;
