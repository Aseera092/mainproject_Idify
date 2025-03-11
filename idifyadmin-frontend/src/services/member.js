import { SERVICE_URL } from "./service";

export const addMember = async (data) => {
    const response = await fetch(`${SERVICE_URL}member`, {
        headers: { "Content-Type": "application/json" },
        method: "POST",
        body: JSON.stringify(data)
    });
    return response.json();
};

export const getMembers = async () => {
    const response = await fetch(`${SERVICE_URL}member`);
    return response.json();
};

export const updateMember = async (id, data) => {
    const response = await fetch(`${SERVICE_URL}member/${id}`, {
        headers: { "Content-Type": "application/json" },
        method: "PUT",
        body: JSON.stringify(data)
    });
    return response.json();
};

export const deleteMember = async (id) => {
    const response = await fetch(`${SERVICE_URL}member/${id}`, {
        method: "DELETE"
    });
    return response.json();
};
