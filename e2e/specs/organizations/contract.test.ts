import { expect, tv4, use } from "chai";
import httpClient, { organizationPayload } from "./httpClient";
import schema from "./organization_swagger.json";
import ChaiJsonSchema = require("chai-json-schema");

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/Organization", schema.definitions.Organization);

describe("Organizations", () => {
  describe("POST /", () => {
    it("matches schema", async () => {
      const payload = organizationPayload();
      const { status, data } = await httpClient.post(payload);
      expect(payload).to.be.jsonSchema(schema.definitions.OrganizationRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.OrganizationResponse);
      await httpClient.delete(data.data.id);
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
      const { data: created } = await httpClient.post(organizationPayload());
      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.OrganizationResponse);
      expect(status).to.be.equal(200);
    });
  });

  describe("PATCH /:id", () => {
    it("matchs schema", async () => {
      const { data: created } = await httpClient.post(organizationPayload());
      const payload = organizationPayload();
      const { status, data: response } = await httpClient.patch(created.data.id, payload);
      expect(payload).to.be.jsonSchema(schema.definitions.OrganizationRequest);
      expect(response).to.be.jsonSchema(schema.definitions.OrganizationResponse);
      expect(status).to.be.equal(200);
      await httpClient.delete(created.data.id);
    });
  });

  describe("DELETE /", () => {
    it("matches schema", async () => {
      const { data: created } = await httpClient.post(organizationPayload());
      const { status } = await httpClient.delete(created.data.id);
      expect(status).to.be.equal(204);
    });
  });
});
