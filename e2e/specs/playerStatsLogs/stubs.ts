import { PLAYER_STATS_LOGS_URL } from "../URLs";
import { authenticationHeader } from "../utils/auth";
import httpClientFactory from "../utils/httpClientFactory";
import { playerStatsLogPostPayload } from "./helpers";

const httpClient = httpClientFactory(PLAYER_STATS_LOGS_URL);

export const createPlayerStatsLog = async (playerId: string, tournamentId: string) => {
  const authHeader = await authenticationHeader();
  const payload = playerStatsLogPostPayload(playerId, tournamentId);
  const { data: { data: playerStatsLog } } = await httpClient.post(payload, { headers: authHeader });

  return { playerStatsLog };
};

export const deletePlayerStatsLog = async (
  playerStatsLogId: string,
) => {
  const authHeader = await authenticationHeader();
  await httpClient.delete(playerStatsLogId, { headers: authHeader });
};
