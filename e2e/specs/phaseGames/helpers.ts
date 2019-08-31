import { randomDate, randomString } from "../utils/random";

const randomGame = (tournamentPhaseId: string) => ({
  away_score: Math.round(Math.random() * 100),
  datetime: randomDate(),
  home_score: Math.round(Math.random() * 100),
  location: randomString(),
  tournament_phase_id: tournamentPhaseId,
});

const randomGameWithTeams = (tournamentPhaseId: string, awayTeamId: string, homeTeamId: string) => ({
  away_score: Math.round(Math.random() * 100),
  away_team_id: awayTeamId,
  datetime: randomDate(),
  home_score: Math.round(Math.random() * 100),
  home_team_id: homeTeamId,
  location: randomString(),
  tournament_phase_id: tournamentPhaseId,
});

export const tournamentGamePayload = (tournamentPhaseId: string) => (
  {
    tournament_game: randomGame(tournamentPhaseId),
  });

export const tournamentGameWithTeamsPayload = (tournamentPhaseId: string, awayTeamId: string, homeTeamId: string) => (
  {
    tournament_game: randomGameWithTeams(tournamentPhaseId, awayTeamId, homeTeamId),
  });
