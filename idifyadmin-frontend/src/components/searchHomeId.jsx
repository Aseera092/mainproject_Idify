import React, { useState, useEffect } from 'react';
import { getHomespotid } from '../services/homespotid';

const SearchHomeSpotId = () => {
    const [homespotids, setHomespotids] = useState([]);
    const [searchTerm, setSearchTerm] = useState('');
    const [filteredSpots, setFilteredSpots] = useState([]);
    const [searchPerformed, setSearchPerformed] = useState(false); // Track if a search was performed

    useEffect(() => {
        getHomespotid().then((res) => {
            setHomespotids(res.data);
            setFilteredSpots(res.data);
        });
    }, []);

    const handleSearch = () => {
        const filtered = homespotids.filter((spot) =>
            spot.address.toLowerCase().includes(searchTerm.toLowerCase()) ||
            spot.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
            spot.location.toLowerCase().includes(searchTerm.toLowerCase())
        );
        setFilteredSpots(filtered);
        setSearchPerformed(true); 
    };

    return (
        <div className='container'>
            <h2>Search Home Spot IDs</h2>
            <div className="input-group mb-3">
                <input
                    type='text'
                    placeholder='Search HomespotID'
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className='form-control'
                />
                <button className="btn btn-primary" type="button" onClick={handleSearch}>
                    Search
                </button>
            </div>
            {searchPerformed && ( // Conditionally render the table after a search
                <table className='table'>
                    <thead>
                        <tr>
                            <th>Address</th>
                            <th>Name</th>
                            <th>Location</th>
                        </tr>
                    </thead>
                    <tbody>
                        {filteredSpots.map((spot) => (
                            <tr key={spot._id}>
                                <td>{spot.address}</td>
                                <td>{spot.name}</td>
                                <td>{spot.location}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            )}
        </div>
    );
};

export default SearchHomeSpotId;