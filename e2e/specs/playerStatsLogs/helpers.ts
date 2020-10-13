import { randomString } from "../utils/random";

const randomPlayerStatsLog = (playerId: string, tournamentId: string) => ({
  player_id: playerId,
  stats: {
    some: randomString(),
  },
  tournament_id: tournamentId,
});

export const playerStatsLogPatchayload = (playerStatsLogId: string, playerId: string, tournamentId: string) => (
  {
    player_stats_logs: [
      {
        ...randomPlayerStatsLog(playerId, tournamentId),
        id: playerStatsLogId,
      },
    ],
  });

  export const playerStatsLogPostPayload = (playerId: string, tournamentId: string) => (
    {
      player_stats_logs: [
        randomPlayerStatsLog(playerId, tournamentId),
      ],
    });