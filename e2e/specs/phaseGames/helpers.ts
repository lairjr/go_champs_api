import { randomDate, randomString } from "../utils/random";

const randomGame = (tournamentPhaseId: string) => ({
  away_score: Math.round(Math.random() * 100),
  datetime: randomDate(),
  home_score: Math.round(Math.random() * 100),
  location: randomString(),
  tournament_phase_id: tournamentPhaseId,
});

export const tournamentGamePayload = (tournamentPhaseId: string) => (
  {
    tournament_game: randomGame(tournamentPhaseId),
  });
