import { randomString } from "../utils/random";

const randomPlayer = (tournamentId: string) => ({
  facebook: randomString(),
  instagram: randomString(),
  name: randomString(),
  tournament_id: tournamentId,
  twitter: randomString(),
  username: randomString(),
});

const randomPlayerWithTeam = (tournamentId: string, teamId: string) => ({
  facebook: randomString(),
  instagram: randomString(),
  name: randomString(),
  team_id: teamId,
  tournament_id: tournamentId,
  twitter: randomString(),
  username: randomString(),
});

export const tournamentPlayerPayload = (tournamentId: string) => (
  {
    player: randomPlayer(tournamentId),
  });

export const tournamentPlayerWithTeamPayload = (tournamentId: string, teamId: string) => (
  {
    player: randomPlayerWithTeam(tournamentId, teamId),
  });
  