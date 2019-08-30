const API_HOST = "https://yochamps-api.herokuapp.com/api";
// const API_HOST = "http://localhost:4000/api";

export const ORGANIZATIONS_URL = `${API_HOST}/organizations`;
export const TOURNAMENTS_URL = `${API_HOST}/tournaments`;
export const tournamentPhasesURL = (tournamentId: string) => (
  `${API_HOST}/tournaments/${tournamentId}/phases`
);
export const tournamentTeamsURL = (tournamentId: string) => (
  `${API_HOST}/tournaments/${tournamentId}/teams`
);
export const phaseGroupsURL = (tournamentPhaseId: string) => (
  `${API_HOST}/phases/${tournamentPhaseId}/groups`
);
export const phaseStatsURL = (tournamentPhaseId: string) => (
  `${API_HOST}/phases/${tournamentPhaseId}/stats`
);
