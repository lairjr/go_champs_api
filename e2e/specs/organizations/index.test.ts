import axios from 'axios';
import { expect, tv4, use } from "chai";
import schema from "./organization_swagger.json";
import ChaiJsonSchema = require("chai-json-schema");

use(ChaiJsonSchema);

const ORGANIZATIONS_URL = "https://yochamps-api.herokuapp.com/api/organizations";

tv4.addSchema("#/definitions/Organization", schema.definitions.Organization);

const randomString = () => (
  Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15)
);

const createOrganizationPayload = () => ({
  name: randomString(),
  slug: randomString(),
});

describe("Organizations", () => {
  describe("GET /", () => {
    it("matches schema", async () => {
      const { status, data } = await axios.get(ORGANIZATIONS_URL);
      expect(data).to.be.jsonSchema(schema.definitions.OrganizationsResponse);
      expect(status).to.be.equal(200);
    });
  });

  describe("POST", () => {
    it("matches schema", async () => {
      const payload = {
        organization: createOrganizationPayload(),
      };
      const { status, data } = await axios.post(ORGANIZATIONS_URL, payload);
      expect(payload).to.be.jsonSchema(schema.definitions.OrganizationRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.OrganizationResponse);
    });
  });
});
