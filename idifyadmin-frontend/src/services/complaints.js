// services/complaints.js
import { SERVICE_URL } from './service';

export const getComplaint = async () => {
    try {
        const response = await fetch(`${SERVICE_URL}complaint/get-panchayath`, { // Assuming your endpoint is /complaint
            method: "GET",
            headers: { "Content-Type": "application/json" },
        });

        if (!response.ok) {
            throw new Error(`Failed to fetch complaints: ${response.statusText}`);
        }

        const data = await response.json();
        console.log("Data from backend:", data);

        // Since the backend populates userId, we can use the data directly.
        if (data && data.data && Array.isArray(data.data)) {
            return data;
        } else {
            console.error("Invalid data structure from backend:", data);
            throw new Error("Invalid data structure from backend");
        }
    } catch (err) {
        console.error("Error fetching complaints:", err);
        throw err;
    }
};


export const updateComplaint = async (complaintId, updateData) => {
    try {
        const response = await fetch(`${SERVICE_URL}complaint/${complaintId}`, {
            method: "PUT", // or PATCH, depending on your API
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(updateData),
        });

        if (!response.ok) {
            throw new Error(`Failed to update complaint: ${response.statusText}`);
        }

        const data = await response.json();
        return data;
    } catch (err) {
        console.error("Error updating complaint:", err);
        throw err;
    }
};