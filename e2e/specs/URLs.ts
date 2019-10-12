const API_HOST = process.env.API_HOST || "http://localhost:4000/api";

export const ORGANIZATIONS_URL = `${API_HOST}/organizations`;
export const PHASES_URL = `${API_HOST}/phases`;
export const TOURNAMENTS_URL = `${API_HOST}/tournaments`;
export const TEAMS_URL = `${API_HOST}/teams`;
export const phaseGamesURL = (phaseId: string) => (
  `${API_HOST}/phases/${phaseId}/games`
);
export const phaseRoundsURL = (phaseId: string) => (
  `${API_HOST}/phases/${phaseId}/rounds`
);
export const phaseStandingsURL = (phaseId: string) => (
  `${API_HOST}/phases/${phaseId}/standings`
);
export const phaseStatsURL = (phaseId: string) => (
  `${API_HOST}/phases/${phaseId}/stats`
);
