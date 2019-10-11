import { tournamentTeamsURL } from "../URLs";
import httpClientFactory from "../utils/httpClientFactory";
import { tournamentTeamPayload } from "./helpers";

export const createTeam = async (tournamentId: string) => {
  const payload = tournamentTeamPayload(tournamentId);
  const httpClient = httpClientFactory(tournamentTeamsURL(tournamentId));
  const { data: { data: tournamentTeam } } = await httpClient.post(payload);

  return { tournamentTeam };
};

export const deleteTeam = async (
  tournamentId: string,
  tournamentTeamId: string,
) => {
  const httpClient = httpClientFactory(tournamentTeamsURL(tournamentId));
  await httpClient.delete(tournamentTeamId);
};
