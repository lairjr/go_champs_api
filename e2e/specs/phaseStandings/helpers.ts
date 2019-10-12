import { randomString } from "../utils/random";

const randomStandings = (phaseId: string) => ({
  team_stats: [
    {
      stats: {
        some_stat_id: "stat value",
      },
      team_id: "some-team-ai",
    },
  ],
  title: randomString(),
  phase_id: phaseId,
});

export const tournamentStandingsPayload = (phaseId: string) => (
  {
    phase_standings: randomStandings(phaseId),
  });
