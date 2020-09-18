import { randomString } from "../utils/random";

const randomPlayer = (tournamentId: string) => ({
  facebook: randomString(),
  instagram: randomString(),
  name: randomString(),
  tournament_id: tournamentId,
  twitter: randomString(),
  username: randomString(),
});

export const tournamentPlayerPayload = (tournamentId: string) => (
  {
    player: randomPlayer(tournamentId),
  });
