import { expect, tv4, use } from "chai";
import ChaiJsonSchema = require("chai-json-schema");
import { deleteStubOrganization, stubOrganization } from "../organizations/stubs";
import { TOURNAMENTS_URL } from "../URLs";
import { authenticationHeader } from "../utils/auth";
import httpClientFactory from "../utils/httpClientFactory";
import { tournamentPayload } from "./helpers";
import schema from "./tournament_swagger.json";

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/Tournament", schema.definitions.Tournament);

const httpClient = httpClientFactory(TOURNAMENTS_URL);

describe("Tournaments", () => {
  describe("POST /", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { data: organization } = await stubOrganization();

      const payload = tournamentPayload(organization.id);
      const { status, data } = await httpClient.post(payload, { headers: authHeader });
      expect(payload).to.be.jsonSchema(schema.definitions.TournamentRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.TournamentResponse);

      await httpClient.delete(data.data.id, { headers: authHeader });
      await deleteStubOrganization(organization.id);
    });
  });

  describe("GET /", () => {
    it("matches schema", async () => {
      const { status, data } = await httpClient.getAll();
      expect(data).to.be.jsonSchema(schema.definitions.TournamentsResponse);
      expect(status).to.be.equal(200);
    });
  });

  describe("GET /:id", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { data: organization } = await stubOrganization();

      const { data: created } = await httpClient.post(tournamentPayload(organization.id), { headers: authHeader });
      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.TournamentResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id, { headers: authHeader });
      await deleteStubOrganization(organization.id);
    });
  });

  describe("PATCH /:id", () => {
    it("matchs schema", async () => {
      const authHeader = await authenticationHeader();
      const { data: organization } = await stubOrganization();

      const { data: created } = await httpClient.post(tournamentPayload(organization.id), { headers: authHeader });
      const payload = tournamentPayload(organization.id);
      const { status, data: response } = await httpClient.patch(created.data.id, payload, { headers: authHeader });
      expect(payload).to.be.jsonSchema(schema.definitions.TournamentRequest);
      expect(response).to.be.jsonSchema(schema.definitions.TournamentResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id, { headers: authHeader });
      await deleteStubOrganization(organization.id);
    });
  });

  describe("DELETE /", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { data: organization } = await stubOrganization();

      const { data: created } = await httpClient.post(tournamentPayload(organization.id), { headers: authHeader });
      const { status } = await httpClient.delete(created.data.id, { headers: authHeader });
      expect(status).to.be.equal(204);

      await deleteStubOrganization(organization.id);
    });
  });
});
