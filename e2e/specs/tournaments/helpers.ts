import { randomString } from "../utils/random";

const randomTournament = (organizationId: string) => ({
  name: randomString(),
  organization_id: organizationId,
  slug: randomString(),
});

export const tournamentPayload = (organizationId: string) => (
  {
    tournament: randomTournament(organizationId),
  });
