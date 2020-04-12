import { TEAMS_URL } from "../URLs";
import { authenticationHeader } from "../utils/auth";
import httpClientFactory from "../utils/httpClientFactory";
import { tournamentTeamPayload } from "./helpers";

const httpClient = httpClientFactory(TEAMS_URL);

export const createTeam = async (tournamentId: string) => {
  const authHeader = await authenticationHeader();
  const payload = tournamentTeamPayload(tournamentId);
  const { data: { data: team } } = await httpClient.post(payload, { headers: authHeader });

  return { team };
};

export const deleteTeam = async (
  tournamentTeamId: string,
) => {
  const authHeader = await authenticationHeader();
  await httpClient.delete(tournamentTeamId, { headers: authHeader });
};
