import { expect, tv4, use } from "chai";
import ChaiJsonSchema = require("chai-json-schema");
import { createTournamentWithOrganizaion, deleteTournamentAndOrganization } from "../tournaments/stubs";
import { PLAYERS_URL } from "../URLs";
import { authenticationHeader } from "../utils/auth";
import httpClientFactory from "../utils/httpClientFactory";
import { tournamentPlayerPayload } from "./helpers";
import schema from "./player_swagger.json";

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/Player", schema.definitions.Player);

const httpClient = httpClientFactory(PLAYERS_URL);

describe("Players", () => {
  describe("POST /", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const payload = tournamentPlayerPayload(tournament.id);
      const { status, data } = await httpClient.post(payload, { headers: authHeader });
      expect(payload).to.be.jsonSchema(schema.definitions.PlayerRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.PlayerResponse);

      await httpClient.delete(data.data.id, { headers: authHeader });
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("GET /:id", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const payload = tournamentPlayerPayload(tournament.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });

      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.PlayerResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id, { headers: authHeader });
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("PATCH /:id", () => {
    it("matchs schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const payload = tournamentPlayerPayload(tournament.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });

      const patchPayload = tournamentPlayerPayload(tournament.id);
      const { status, data: response } = await httpClient.patch(created.data.id, patchPayload, { headers: authHeader });
      expect(patchPayload).to.be.jsonSchema(schema.definitions.PlayerRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PlayerResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id, { headers: authHeader });
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("DELETE /", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const payload = tournamentPlayerPayload(tournament.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });
      const { status } = await httpClient.delete(created.data.id, { headers: authHeader });
      expect(status).to.be.equal(204);

      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });
});
