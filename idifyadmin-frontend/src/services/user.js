import { SERVICE_URL } from "./service";

export const addUser = async (data) => {
    const response = await fetch(`${SERVICE_URL}user`, {
        headers: { "Content-Type": "application/json" },
        method: "POST",
        body: JSON.stringify(data)
    });
    return response.json();
}

export const getUsers = async () => {
    const response = await fetch(`${SERVICE_URL}user`);
    return response.json();
}

export const updateUser = async (id, data) => {
    const response = await fetch(`${SERVICE_URL}user/${id}`, {
        headers: { "Content-Type": "application/json" },
        method: "PUT",
        body: JSON.stringify(data)
    });
    return response.json();
}

export const updateUserStatus = async (id, data) => {
    const response = await fetch(`${SERVICE_URL}user/status/${id}`, {
        headers: { "Content-Type": "application/json" },
        method: "PUT",
        body: JSON.stringify(data)
    });
    return response.json();
}

export const deleteUser = async (id) => {
    const response = await fetch(`${SERVICE_URL}user/${id}`, {
        method: "DELETE"
    });
    return response.json();
}
