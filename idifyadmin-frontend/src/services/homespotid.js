import { SERVICE_URL } from "./service";

export const addHomespotid = async (data) => {
    const response = await fetch(`${SERVICE_URL}homespotid`, {
        headers: { "Content-Type": "application/json" },
        method: "POST",
        body: JSON.stringify(data)
    });
    return response.json();
};

export const getHomespotid = async () => {
    const response = await fetch(`${SERVICE_URL}homespotid`);
    return response.json();
};

export const updateHomespotid = async (id, data) => {
    const response = await fetch(`${SERVICE_URL}homespotid/${id}`, {
        headers: { "Content-Type": "application/json" },
        method: "PUT",
        body: JSON.stringify(data)
    });
    return response.json();
};

export const deleteHomespotid = async (id) => {
    const response = await fetch(`${SERVICE_URL}homespotid/${id}`, {
        method: "DELETE"
    });
    return response.json();
};
    
    export const getHomespotidById = async (id) => {
        const response = await fetch(`${SERVICE_URL}homespotid/${id}`);
        return response.json();
    };