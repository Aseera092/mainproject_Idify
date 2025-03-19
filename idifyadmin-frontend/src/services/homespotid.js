import { SERVICE_URL } from "./service";

export const addHomespotid = async (data) => {
  const response = await fetch(`${SERVICE_URL}home`, {
    headers: { "Content-Type": "application/json" },
    method: "POST",
    body: JSON.stringify(data),
  });
  return response.json();
};

export const getHomespotid = async () => {
  const response = await fetch(`${SERVICE_URL}home`);
  return response.json();
};

export const updateHomespotid = async (id, data) => {
  const response = await fetch(`${SERVICE_URL}home/${id}`, {
    headers: { "Content-Type": "application/json" },
    method: "PUT",
    body: JSON.stringify(data),
  });
  return response.json();
};

export const deleteHomespotid = async (id) => {
  const response = await fetch(`${SERVICE_URL}home/${id}`, {
    method: "DELETE",
  });
  return response.json();
};

export const getHomespotidById = async (id) => {
  const response = await fetch(`${SERVICE_URL}home/search/${id}`,{
    headers: { "Content-Type": "application/json" },
    method: "GET",
});
  return response.json();
};
