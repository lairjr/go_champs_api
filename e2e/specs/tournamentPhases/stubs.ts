
import { createTournamentWithOrganizaion, deleteTournamentAndOrganization } from "../tournaments/stubs";
import { tournamentPhasesURL } from "../URLs";
import httpClientFactory from "../utils/httpClientFactory";
import { tournamentPhasePayload } from "./helpers";

export const createTournamentPhaseWithOrganizaion = async () => {
  const { organization, tournament } = await createTournamentWithOrganizaion();

  const payload = tournamentPhasePayload(tournament.id);
  const httpClient = httpClientFactory(tournamentPhasesURL(tournament.id));
  const { data: { data: tournamentPhase } } = await httpClient.post(payload);

  return { tournament, organization, tournamentPhase };
};

export const deleteTournamentPhaseAndOrganization = async (
  tournamentId: string,
  organizationId: string,
  tournamentPhaseId: string,
) => {
  const httpClient = httpClientFactory(tournamentPhasesURL(tournamentId));
  await httpClient.delete(tournamentPhaseId);
  await deleteTournamentAndOrganization(tournamentId, organizationId);
};
