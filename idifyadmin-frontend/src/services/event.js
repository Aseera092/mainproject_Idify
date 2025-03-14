import { SERVICE_URL } from './service'; // Ensure SERVICE_URL is correctly defined

export const addEvent = async (eventData) => {
  try {
    const response = await fetch(`${SERVICE_URL}event`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(eventData),
    });

    if (!response.ok) throw new Error(`Failed to add event: ${response.statusText}`);
    
    return await response.json();
  } catch (error) {
    console.error("Error adding event:", error);
    throw error;
  }
};

export const getEvents = async () => {
    try {
      const response = await fetch(`${SERVICE_URL}event`, {
        method: "GET",
        headers: { "Content-Type": "application/json" },
      });
      
      if (!response.ok) {
        throw new Error(`Failed to fetch events: ${response.statusText}`);
      }
      
      return await response.json();
    } catch (error) {
      console.error("Error fetching events:", error);
      throw error;
    }
  };

export const updateEvent = async (eventId, updatedData) => {
    try {
        const response = await fetch(`${SERVICE_URL}event/${eventId}`, {
            method: "PUT",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify(updatedData),
        });

        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`Failed to update event: ${response.statusText} - ${errorText}`);
        }

        return await response.json();
    } catch (error) {
        console.error("Error updating event:", error);
        throw error;
    }
};

export const deleteEvent = async (eventId) => {
    try {
        const response = await fetch(`${SERVICE_URL}event/${eventId}`, {
            method: "DELETE",
            headers: { "Content-Type": "application/json" },
        });

        if (!response.ok) {
            throw new Error(`Failed to delete event: ${response.statusText}`);
        }

        return await response.json();
    } catch (error) {
        console.error("Error deleting event:", error);
        throw error;
    }
};

