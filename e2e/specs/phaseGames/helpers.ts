import { randomDate, randomString } from "../utils/random";

const randomGame = (phaseId: string) => ({
  away_score: Math.round(Math.random() * 100),
  datetime: randomDate(),
  home_score: Math.round(Math.random() * 100),
  location: randomString(),
  phase_id: phaseId,
});

const randomGameWithTeams = (phaseId: string, awayTeamId: string, homeTeamId: string) => ({
  away_score: Math.round(Math.random() * 100),
  away_team_id: awayTeamId,
  datetime: randomDate(),
  home_score: Math.round(Math.random() * 100),
  home_team_id: homeTeamId,
  location: randomString(),
  phase_id: phaseId,
});

export const tournamentGamePayload = (phaseId: string) => (
  {
    tournament_game: randomGame(phaseId),
  });

export const tournamentGameWithTeamsPayload = (phaseId: string, awayTeamId: string, homeTeamId: string) => (
  {
    tournament_game: randomGameWithTeams(phaseId, awayTeamId, homeTeamId),
  });
