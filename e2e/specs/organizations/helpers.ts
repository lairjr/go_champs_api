import { randomString } from "../utils/random";

const randomOrganization = () => ({
  name: randomString(),
  slug: randomString(),
});

export const organizationPayload = () => (
  {
    organization: randomOrganization(),
  });
