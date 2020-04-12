const API_HOST = process.env.API_HOST || "http://localhost:4000/api";
const API_V1_HOST = "http://phoenix:4000/v1";

export const DRAWS_URL = `${API_V1_HOST}/draws`;
export const ELIMINATIONS_URL = `${API_V1_HOST}/eliminations`;
export const GAMES_URL = `${API_HOST}/games`;
export const ORGANIZATIONS_URL = `${API_V1_HOST}/organizations`;
export const PHASES_URL = `${API_V1_HOST}/phases`;
export const TEAMS_URL = `${API_HOST}/teams`;
export const TOURNAMENTS_URL = `${API_V1_HOST}/tournaments`;
export const USERS_URL = `${API_HOST}/users`;
