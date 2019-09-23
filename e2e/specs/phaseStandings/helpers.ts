import { randomString } from "../utils/random";

const randomStandings = (tournamentPhaseId: string) => ({
  team_stats: [
    {
      stats: {
        some_stat_id: "stat value",
      },
      team_id: "some-team-ai",
    },
  ],
  title: randomString(),
  tournament_phase_id: tournamentPhaseId,
});

export const tournamentStandingsPayload = (tournamentPhaseId: string) => (
  {
    phase_standings: randomStandings(tournamentPhaseId),
  });
