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
  const deleteOrganization = (organizationId: string) => {
    return axios.delete(`${ORGANIZATIONS_URL}/${organizationId}`);
  };

  const createOrganization = () => {
    const payload = {
      organization: createOrganizationPayload(),
    };
    return axios.post(ORGANIZATIONS_URL, payload);
  };

  describe("POST /", () => {
    it("matches schema", async () => {
      const payload = {
        organization: createOrganizationPayload(),
      };
      const { status, data } = await axios.post(ORGANIZATIONS_URL, payload);
      expect(payload).to.be.jsonSchema(schema.definitions.OrganizationRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.OrganizationResponse);
      await deleteOrganization(data.data.id);
    });
  });

  describe("GET /", () => {
    it("matches schema", async () => {
      const { status, data } = await axios.get(ORGANIZATIONS_URL);
      expect(data).to.be.jsonSchema(schema.definitions.OrganizationsResponse);
      expect(status).to.be.equal(200);
    });
  });

  describe("GET /:id", () => {
    it("matches schema", async () => {
      const { data } = await createOrganization();
      const { status, data: response } = await axios.get(`${ORGANIZATIONS_URL}/${data.data.id}`);
      expect(response).to.be.jsonSchema(schema.definitions.OrganizationResponse);
      expect(status).to.be.equal(200);
    });
  });

  describe("PATCH /:id", () => {
    it("matchs schema", async () => {
      const { data } = await createOrganization();
      const payload = {
        organization: createOrganizationPayload(),
      };
      const { status, data: response } =
        await axios.patch(`${ORGANIZATIONS_URL}/${data.data.id}`, payload);
      expect(payload).to.be.jsonSchema(schema.definitions.OrganizationRequest);
      expect(response).to.be.jsonSchema(schema.definitions.OrganizationResponse);
      expect(status).to.be.equal(200);
      await deleteOrganization(data.data.id);
    });
  });

  describe("DELETE /", () => {
    it("matches schema", async () => {
      const { data } = await createOrganization();
      const { status } = await axios.delete(`${ORGANIZATIONS_URL}/${data.data.id}`);
      expect(status).to.be.equal(204);
    });
  });
});
