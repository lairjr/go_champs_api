import { organizationPayload } from "../organizations/helpers";
import { ORGANIZATIONS_URL } from "../URLs";
import { authenticationHeader } from "../utils/auth";
import httpClientFactory from "../utils/httpClientFactory";

const httpClient = httpClientFactory(ORGANIZATIONS_URL);

export const stubOrganization = async () => {
  const authHeader = await authenticationHeader();
  const { data } = await httpClient.post(organizationPayload(), { headers: authHeader });
  return data;
};

export const deleteStubOrganization = async (organizationId: string) => {
  const authHeader = await authenticationHeader();
  return httpClient.delete(organizationId, { headers: authHeader });
};
