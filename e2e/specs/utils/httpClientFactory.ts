import axios, { AxiosRequestConfig } from "axios";

const post = (baseUri: string) => (payload: any, config?: AxiosRequestConfig) => {
  return axios.post(baseUri, payload, config);
};

const getAll = (baseUri: string) => () => (
  axios.get(baseUri)
);

const get = (baseUri: string) => (resourceId: string) => (
  axios.get(`${baseUri}/${resourceId}`)
);

const patch = (baseUri: string) => (resourceId: string, payload: any, config?: AxiosRequestConfig) => {
  return axios.patch(`${baseUri}/${resourceId}`, payload, config);
};

const patchBatch = (baseUri: string) => (payload: any, config?: AxiosRequestConfig) => {
  return axios.patch(`${baseUri}`, payload, config);
};

const deleteRequest = (baseUri: string) => (resourceId: string, config?: AxiosRequestConfig) => {
  return axios.delete(`${baseUri}/${resourceId}`, config);
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
