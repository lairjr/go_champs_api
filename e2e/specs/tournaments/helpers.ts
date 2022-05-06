import { randomString } from "../utils/random";

const randomTournament = (organizationId: string) => ({
  facebook: randomString(),
  instagram: randomString(),
  name: randomString(),
  organization_id: organizationId,
  player_stats: [{
    title: "Stat one",
  }],
  site_url: randomString(),
  slug: randomString(),
  twitter: randomString(),
  team_stats: [{
    title: "Team stat one",
    source: "player-stat-id"
  }],
});

export const tournamentPayload = (organizationId: string) => (
  {
    tournament: randomTournament(organizationId),
  });
