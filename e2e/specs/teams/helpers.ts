import { randomString } from "../utils/random";

const randomTeam = (tournamentId: string) => ({
  name: randomString(),
  tournament_id: tournamentId,
});

export const tournamentTeamPayload = (tournamentId: string) => (
  {
    team: randomTeam(tournamentId),
  });
