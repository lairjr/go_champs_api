import { randomString } from "../utils/random";

const randomOrganization = () => ({
  members: [
    {
      username: "username",
    },
  ],
  name: randomString(),
  slug: randomString(),
});

export const organizationPayload = () => (
  {
    organization: randomOrganization(),
  });
