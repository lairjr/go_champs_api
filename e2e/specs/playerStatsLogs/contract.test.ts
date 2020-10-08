import { expect, tv4, use } from "chai";
import ChaiJsonSchema = require("chai-json-schema");
import { createPlayer, deletePlayer } from "../players/stubs";
import { createTournamentWithOrganizaion, deleteTournamentAndOrganization } from "../tournaments/stubs";
import { PLAYER_STATS_LOGS_URL } from "../URLs";
import { authenticationHeader } from "../utils/auth";
import httpClientFactory from "../utils/httpClientFactory";
import { playerStatsLogPayload } from "./helpers";
import schema from "./player_stats_log_swagger.json";

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/PlayerStatsLog", schema.definitions.PlayerStatsLog);

const httpClient = httpClientFactory(PLAYER_STATS_LOGS_URL);

describe("PlayerStatsLogs", () => {
  describe("POST /", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const { player } = await createPlayer(tournament.id);

      const payload = playerStatsLogPayload(player.id, tournament.id);

      const { status, data } = await httpClient.post(payload, { headers: authHeader });

      expect(payload).to.be.jsonSchema(schema.definitions.PlayerStatsLogRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.PlayerStatsLogResponse);

      await httpClient.delete(data.data.id, { headers: authHeader });
      await deletePlayer(player.id);
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("GET /:id", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();
      const { player } = await createPlayer(tournament.id);

      const payload = playerStatsLogPayload(player.id, tournament.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });

      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.PlayerStatsLogResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id, { headers: authHeader });
      await deletePlayer(player.id);
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("PATCH /:id", () => {
    it("matchs schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();
      const { player } = await createPlayer(tournament.id);

      const payload = playerStatsLogPayload(player.id, tournament.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });

      const patchPayload = playerStatsLogPayload(player.id, tournament.id);
      const { status, data: response } = await httpClient.patch(created.data.id, patchPayload, { headers: authHeader });
      expect(patchPayload).to.be.jsonSchema(schema.definitions.PlayerStatsLogRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PlayerStatsLogResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id, { headers: authHeader });
      await deletePlayer(player.id);
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("DELETE /", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const { player } = await createPlayer(tournament.id);

      const payload = playerStatsLogPayload(player.id, tournament.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });
      const { status } = await httpClient.delete(created.data.id, { headers: authHeader });
      expect(status).to.be.equal(204);

      await deletePlayer(player.id);
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });
});
