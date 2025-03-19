import React, { useState, useEffect } from 'react';
import { getHomespotid, deleteHomespotid, updateHomespotid } from '../services/homespotid';
import { toast } from 'react-toastify';

const ViewHomeSpotId = () => {
  const [homespotids, setHomespotids] = useState([]);
  const [selectedSpot, setSelectedSpot] = useState(null);

  const init = () => {
    getHomespotid().then((res) => {
      setHomespotids(res.data);
    });
  };

  useEffect(() => {
    init();
  }, []);

  const deleteSpotById = (id) => {
    deleteHomespotid(id).then((res) => {
      if (res.status) {
        toast.success('Spot Deleted Successfully');
        init();
      }
    });
  };

  const submitAction = (e) => {
    e.preventDefault();
    const name = document.getElementById('name');
    const location = document.getElementById('location');

    const data = {
      name: name.value,
      location: location.value
    };

    updateHomespotid(selectedSpot._id, data).then((res) => {
      if (res.status) {
        toast.success('Spot Updated Successfully');
        init();
        document.getElementById('modal-close').click();
      }
    });
  };

  return (
    
    <div className='container'>
      <h2>Home Spot IDs</h2>
      <table className='table'>
        <thead>
          <tr>
          <th>Sl.No</th>
            <th>HomeId</th>
            <th>Location</th>
            <th>Pin Code</th>
            <th>Ward</th>
            <th>Email</th>
            <th>MobileNo</th>
           
          </tr>
        </thead>
        <tbody>
          {homespotids.map((spot, index) => (
            <tr key={spot._id}>
              <td>{index + 1}</td>
              <td>{spot.homeId}</td>
              <td>latitude: {spot.latitude}<br/>longitude: {spot.longitude}</td>
              <td> {spot.pincode}</td>
              <td> {spot.wardNo}</td>
              <td> {spot.email}</td>
              <td> {spot.MobileNo}</td>
              {/* <td>
                <button onClick={() => setSelectedSpot(spot)} data-bs-toggle='modal' data-bs-target='#editModal'>Edit</button>
                <button onClick={() => deleteSpotById(spot._id)}>Delete</button>
              </td> */}
            </tr>
          ))}
        </tbody>
      </table>

      <div className='modal' id='editModal'>
        <div className='modal-dialog'>
          <form onSubmit={submitAction}>
            <div className='modal-header'>
              <h5>Edit Spot</h5>
              <button type='button' id='modal-close' data-bs-dismiss='modal'>Close</button>
            </div>
            <div className='modal-body'>
              <input type='text' id='name' defaultValue={selectedSpot?.name} required />
              <input type='text' id='location' defaultValue={selectedSpot?.location} required />
            </div>
            <div className='modal-footer'>
              <button type='submit'>Save Changes</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default ViewHomeSpotId;
