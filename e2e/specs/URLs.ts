const API_HOST = process.env.API_HOST || "http://localhost:4000/api";

export const ORGANIZATIONS_URL = `${API_HOST}/organizations`;
export const TOURNAMENTS_URL = `${API_HOST}/tournaments`;
export const TEAMS_URL = `${API_HOST}/teams`;
export const tournamentPhasesURL = (tournamentId: string) => (
  `${API_HOST}/tournaments/${tournamentId}/phases`
);
export const phaseGamesURL = (tournamentPhaseId: string) => (
  `${API_HOST}/phases/${tournamentPhaseId}/games`
);
export const phaseRoundsURL = (tournamentPhaseId: string) => (
  `${API_HOST}/phases/${tournamentPhaseId}/rounds`
);
export const phaseStandingsURL = (tournamentPhaseId: string) => (
  `${API_HOST}/phases/${tournamentPhaseId}/standings`
);
export const phaseStatsURL = (tournamentPhaseId: string) => (
  `${API_HOST}/phases/${tournamentPhaseId}/stats`
);
