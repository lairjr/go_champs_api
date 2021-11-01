import { expect, tv4, use } from "chai";
import ChaiJsonSchema = require("chai-json-schema");
import { createTournamentWithOrganizaion, deleteTournamentAndOrganization } from "../tournaments/stubs";
import { FIXED_PLAYER_STATS_TABLES_URL } from "../URLs";
import { authenticationHeader } from "../utils/auth";
import httpClientFactory from "../utils/httpClientFactory";
import schema from "./fixed_player_stats_table_swagger.json";
import { fixedPlayerStatsTablePayload } from "./helpers";

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/FixedPlayerStatsTable", schema.definitions.FixedPlayerStatsTable);

describe("FixedPlayerStatsTables", () => {
  describe("POST /", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { organization, tournament } = await createTournamentWithOrganizaion();

      const httpClient = httpClientFactory(FIXED_PLAYER_STATS_TABLES_URL);

      const payload = fixedPlayerStatsTablePayload(tournament.player_stats[0].id, tournament.id);
      const { status, data } = await httpClient.post(payload, { headers: authHeader });

      expect(payload).to.be.jsonSchema(schema.definitions.FixedPlayerStatsTableRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.FixedPlayerStatsTableResponse);

      await httpClient.delete(data.data.id, { headers: authHeader });
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("GET /:id", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { organization, tournament } = await createTournamentWithOrganizaion();

      const httpClient = httpClientFactory(FIXED_PLAYER_STATS_TABLES_URL);

      const payload = fixedPlayerStatsTablePayload(tournament.player_stats[0].id, tournament.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });

      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.FixedPlayerStatsTableResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id, { headers: authHeader });
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("PATCH /:id", () => {
    it("matchs schema", async () => {
      const authHeader = await authenticationHeader();
      const { organization, tournament } = await createTournamentWithOrganizaion();

      const httpClient = httpClientFactory(FIXED_PLAYER_STATS_TABLES_URL);

      const payload = fixedPlayerStatsTablePayload(tournament.player_stats[0].id, tournament.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });

      const patchPayload = fixedPlayerStatsTablePayload(tournament.player_stats[0].id, tournament.id);
      const { status, data: response } = await httpClient.patch(created.data.id, patchPayload, { headers: authHeader });
      expect(patchPayload).to.be.jsonSchema(schema.definitions.FixedPlayerStatsTableRequest);
      expect(response).to.be.jsonSchema(schema.definitions.FixedPlayerStatsTableResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id, { headers: authHeader });
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("DELETE /", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { organization, tournament } = await createTournamentWithOrganizaion();

      const httpClient = httpClientFactory(FIXED_PLAYER_STATS_TABLES_URL);

      const payload = fixedPlayerStatsTablePayload(tournament.player_stats[0].id, tournament.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });
      const { status } = await httpClient.delete(created.data.id, { headers: authHeader });
      expect(status).to.be.equal(204);

      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });
});
