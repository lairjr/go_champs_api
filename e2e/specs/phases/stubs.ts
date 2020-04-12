
import { createTournamentWithOrganizaion, deleteTournamentAndOrganization } from "../tournaments/stubs";
import { PHASES_URL } from "../URLs";
import { authenticationHeader } from "../utils/auth";
import httpClientFactory from "../utils/httpClientFactory";
import { phasePayload } from "./helpers";

const httpClient = httpClientFactory(PHASES_URL);

export const createPhaseWithOrganizaion = async () => {
  const authHeader = await authenticationHeader();
  const { organization, tournament } = await createTournamentWithOrganizaion();

  const payload = phasePayload(tournament.id);
  const { data: { data: phase } } = await httpClient.post(payload, { headers: authHeader });

  return { tournament, organization, phase };
};

export const deletePhaseAndOrganization = async (
  tournamentId: string,
  organizationId: string,
  phaseId: string,
) => {
  const authHeader = await authenticationHeader();
  await httpClient.delete(phaseId, { headers: authHeader });
  await deleteTournamentAndOrganization(tournamentId, organizationId);
};
