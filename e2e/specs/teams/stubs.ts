import { TEAMS_URL } from "../URLs";
import httpClientFactory from "../utils/httpClientFactory";
import { tournamentTeamPayload } from "./helpers";

export const createTeam = async (tournamentId: string) => {
  const payload = tournamentTeamPayload(tournamentId);
  const httpClient = httpClientFactory(TEAMS_URL);
  const { data: { data: team } } = await httpClient.post(payload);

  return { team };
};

export const deleteTeam = async (
  tournamentId: string,
  tournamentTeamId: string,
) => {
  const httpClient = httpClientFactory(TEAMS_URL);
  await httpClient.delete(tournamentTeamId);
};
