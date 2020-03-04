import { randomString } from "../utils/random";

const randomTournament = (organizationId: string) => ({
  name: randomString(),
  organization_id: organizationId,
  slug: randomString(),
  facebook: randomString(),
  instagram: randomString(),
  site_url: randomString(),
  twitter: randomString(),
});

export const tournamentPayload = (organizationId: string) => (
  {
    tournament: randomTournament(organizationId),
  });
