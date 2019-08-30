import { organizationPayload } from "../organizations/helpers";
import { ORGANIZATIONS_URL } from "../URLs";
import httpClientFactory from "../utils/httpClientFactory";

const httpClient = httpClientFactory(ORGANIZATIONS_URL);

export const stubOrganization = async () => {
  const { data } = await httpClient.post(organizationPayload());
  return data;
};

export const deleteStubOrganization = async (organizationId: string) => (
  await httpClient.delete(organizationId)
);
