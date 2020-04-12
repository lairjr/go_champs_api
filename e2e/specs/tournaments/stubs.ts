
import { deleteStubOrganization, stubOrganization } from "../organizations/stubs";
import { TOURNAMENTS_URL } from "../URLs";
import { authenticationHeader } from "../utils/auth";
import httpClientFactory from "../utils/httpClientFactory";
import { tournamentPayload } from "./helpers";

const httpClient = httpClientFactory(TOURNAMENTS_URL);

export const createTournamentWithOrganizaion = async () => {
  const authHeader = await authenticationHeader();
  const { data: organization } = await stubOrganization();

  const payload = tournamentPayload(organization.id);
  const { data: { data: tournament } } = await httpClient.post(payload, { headers: authHeader });

  return { tournament, organization };
};

export const deleteTournamentAndOrganization = async (tournamentId: string, organizationId: string) => {
  const authHeader = await authenticationHeader();
  await httpClient.delete(tournamentId, { headers: authHeader });
  await deleteStubOrganization(organizationId);
};
