import axios from "axios";
import { SERVICE_URL } from "./service";

export const addNotificationAPI = async (data) => {
    const response = await axios.post(`${SERVICE_URL}notification`, data);
    return response.data;
}


export const getNotificationAPI = async () => {
    const response = await axios.get(`${SERVICE_URL}notification`);
    return response.data;
}