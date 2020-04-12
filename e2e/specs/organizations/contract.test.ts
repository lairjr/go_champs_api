import { expect, tv4, use } from "chai";
import ChaiJsonSchema = require("chai-json-schema");
import { ORGANIZATIONS_URL } from "../URLs";
import { authenticationHeader } from "../utils/auth";
import httpClientFactory from "../utils/httpClientFactory";
import { organizationPayload } from "./helpers";
import schema from "./organization_swagger.json";

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/Organization", schema.definitions.Organization);

const httpClient = httpClientFactory(ORGANIZATIONS_URL);

describe("Organizations", () => {
  describe("POST /", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const payload = organizationPayload();
      const { status, data } = await httpClient.post(payload, { headers: authHeader });
      expect(payload).to.be.jsonSchema(schema.definitions.OrganizationRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.OrganizationResponse);
      await httpClient.delete(data.data.id, { headers: authHeader });
    });
  });

  describe("GET /", () => {
    it("matches schema", async () => {
      const { status, data } = await httpClient.getAll();
      expect(data).to.be.jsonSchema(schema.definitions.OrganizationsResponse);
      expect(status).to.be.equal(200);
    });
  });

  describe("GET /:id", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { data: created } = await httpClient.post(organizationPayload(), { headers: authHeader });
      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.OrganizationResponse);
      expect(status).to.be.equal(200);
    });
  });

  describe("PATCH /:id", () => {
    it("matchs schema", async () => {
      const authHeader = await authenticationHeader();
      const { data: created } = await httpClient.post(organizationPayload(), { headers: authHeader });
      const payload = organizationPayload();
      const { status, data: response } = await httpClient.patch(created.data.id, payload, { headers: authHeader });
      expect(payload).to.be.jsonSchema(schema.definitions.OrganizationRequest);
      expect(response).to.be.jsonSchema(schema.definitions.OrganizationResponse);
      expect(status).to.be.equal(200);
      await httpClient.delete(created.data.id, { headers: authHeader });
    });
  });

  describe("DELETE /", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { data: created } = await httpClient.post(organizationPayload(), { headers: authHeader });
      const { status } = await httpClient.delete(created.data.id, { headers: authHeader });
      expect(status).to.be.equal(204);
    });
  });
});
