
import { deleteStubOrganization, stubOrganization } from "../organizations/stubs";
import { TOURNAMENTS_URL } from "../URLs";
import httpClientFactory from "../utils/httpClientFactory";
import { tournamentPayload } from "./helpers";

const httpClient = httpClientFactory(TOURNAMENTS_URL);

export const createTournamentWithOrganizaion = async () => {
  const { data: organization } = await stubOrganization();

  const payload = tournamentPayload(organization.id);
  const { data: { data: tournament } } = await httpClient.post(payload);

  return { tournament, organization };
};

export const deleteTournamentAndOrganization = async (tournamentId: string, organizationId: string) => {
  await httpClient.delete(tournamentId);
  await deleteStubOrganization(organizationId);
};
