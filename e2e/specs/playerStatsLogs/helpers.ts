import { randomString } from "../utils/random";

const randomPlayerStatsLog = (playerId: string, tournamentId: string) => ({
  player_id: playerId,
  stats: {
    some: randomString(),
  },
  tournament_id: tournamentId,
});

export const playerStatsLogPayload = (playerId: string, tournamentId: string) => (
  {
    player_stats_log: randomPlayerStatsLog(playerId, tournamentId),
  });
