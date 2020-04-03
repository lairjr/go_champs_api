import axios from "axios";

const post = (baseUri: string) => (payload: any) => {
  return axios.post(baseUri, payload);
};

const getAll = (baseUri: string) => () => (
  axios.get(baseUri)
);

const get = (baseUri: string) => (resourceId: string) => (
  axios.get(`${baseUri}/${resourceId}`)
);

const patch = (baseUri: string) => (resourceId: string, payload: any) => {
  return axios.patch(`${baseUri}/${resourceId}`, payload);
};

const patchBatch = (baseUri: string) => (payload: any) => {
  return axios.patch(`${baseUri}`, payload);
};

const deleteRequest = (baseUri: string) => (resourceId: string) => {
  return axios.delete(`${baseUri}/${resourceId}`);
};

const httpClientFactory = (baseUri: string) => {
  return {
    delete: deleteRequest(baseUri),
    get: get(baseUri),
    getAll: getAll(baseUri),
    patch: patch(baseUri),
    patchBatch: patchBatch(baseUri),
    post: post(baseUri),
  };
};

export default httpClientFactory;
