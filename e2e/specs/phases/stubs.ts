
import { createTournamentWithOrganizaion, deleteTournamentAndOrganization } from "../tournaments/stubs";
import { PHASES_URL } from "../URLs";
import httpClientFactory from "../utils/httpClientFactory";
import { phasePayload } from "./helpers";

export const createPhaseWithOrganizaion = async () => {
  const { organization, tournament } = await createTournamentWithOrganizaion();

  const payload = phasePayload(tournament.id);
  const httpClient = httpClientFactory(PHASES_URL);
  const { data: { data: phase } } = await httpClient.post(payload);

  return { tournament, organization, phase };
};

export const deletePhaseAndOrganization = async (
  tournamentId: string,
  organizationId: string,
  phaseId: string,
) => {
  const httpClient = httpClientFactory(PHASES_URL);
  await httpClient.delete(phaseId);
  await deleteTournamentAndOrganization(tournamentId, organizationId);
};
