import { expect, tv4, use } from "chai";
import { organizationPayload } from "../organizations/helpers";
import { ORGANIZATIONS_URL, TOURNAMENTS_URL } from "../URLs";
import httpClientFactory from "../utils/httpClientFactory";
import { tournamentPayload } from "./helpers";
import schema from "./tournament_swagger.json";
import ChaiJsonSchema = require("chai-json-schema");

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/Tournament", schema.definitions.Tournament);

const httpClient = httpClientFactory(TOURNAMENTS_URL);
const organizationClient = httpClientFactory(ORGANIZATIONS_URL);

describe("Tournaments", () => {
  const stubOrganization = async () => {
    const { data } = await organizationClient.post(organizationPayload());
    return data;
  };

  describe("POST /", () => {
    it("matches schema", async () => {
      const { data: organization } = await stubOrganization();

      const payload = tournamentPayload(organization.id);
      const { status, data } = await httpClient.post(payload);
      expect(payload).to.be.jsonSchema(schema.definitions.TournamentRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.TournamentResponse);

      await httpClient.delete(data.data.id);
      await organizationClient.delete(organization.id);
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
      const { data: organization } = await stubOrganization();

      const { data: created } = await httpClient.post(tournamentPayload(organization.id));
      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.TournamentResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id);
      await organizationClient.delete(organization.id);
    });
  });

  describe("PATCH /:id", () => {
    it("matchs schema", async () => {
      const { data: organization } = await stubOrganization();

      const { data: created } = await httpClient.post(tournamentPayload(organization.id));
      const payload = tournamentPayload(organization.id);
      const { status, data: response } = await httpClient.patch(created.data.id, payload);
      expect(payload).to.be.jsonSchema(schema.definitions.TournamentRequest);
      expect(response).to.be.jsonSchema(schema.definitions.TournamentResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id);
      await organizationClient.delete(organization.id);
    });
  });

  describe("DELETE /", () => {
    it("matches schema", async () => {
      const { data: organization } = await stubOrganization();

      const { data: created } = await httpClient.post(tournamentPayload(organization.id));
      const { status } = await httpClient.delete(created.data.id);
      expect(status).to.be.equal(204);

      await organizationClient.delete(organization.id);
    });
  });
});
