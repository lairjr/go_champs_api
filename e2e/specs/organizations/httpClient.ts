import axios from "axios";
import { ORGANIZATIONS_URL } from "../URLs";
import { randomString } from "../utils/random";

const randomOrganization = () => ({
  name: randomString(),
  slug: randomString(),
});

export const organizationPayload = () => (
  {
    organization: randomOrganization(),
  });

const post = (payload: any) => {
  return axios.post(ORGANIZATIONS_URL, payload);
};

const getAll = () => (
  axios.get(ORGANIZATIONS_URL)
);

const get = (organizationId: string) => (
  axios.get(`${ORGANIZATIONS_URL}/${organizationId}`)
);

const patch = (organizationId: string, payload: any) => {
  return axios.patch(`${ORGANIZATIONS_URL}/${organizationId}`, payload);
};

const deleteRequest = (organizationId: string) => {
  return axios.delete(`${ORGANIZATIONS_URL}/${organizationId}`);
};

export default {
  delete: deleteRequest,
  get,
  getAll,
  patch,
  post,
};
