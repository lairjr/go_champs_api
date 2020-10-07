import { PLAYERS_URL } from "../URLs";
import { authenticationHeader } from "../utils/auth";
import httpClientFactory from "../utils/httpClientFactory";
import { tournamentPlayerPayload } from "./helpers";

const httpClient = httpClientFactory(PLAYERS_URL);

export const createPlayer = async (tournamentId: string) => {
  const authHeader = await authenticationHeader();
  const payload = tournamentPlayerPayload(tournamentId);
  const { data: { data: player } } = await httpClient.post(payload, { headers: authHeader });

  return { player };
};

export const deletePlayer = async (
  playerId: string,
) => {
  const authHeader = await authenticationHeader();
  await httpClient.delete(playerId, { headers: authHeader });
};
