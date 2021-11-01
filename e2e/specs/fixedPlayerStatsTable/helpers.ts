import { randomString } from "../utils/random";

const randomFixedPlayerStatsTable = (statId: string, tournamentId: string) => ({
  player_stats: [{
    player_id: "some-player-id",
    value: randomString(),
  }],
  stat_id: statId,
  tournament_id: tournamentId,
});

export const fixedPlayerStatsTablePayload = (statId: string, tournamentId: string) => (
  {
    fixed_player_stats_table: randomFixedPlayerStatsTable(statId, tournamentId),
  });
