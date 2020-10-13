import { expect, tv4, use } from "chai";
import ChaiJsonSchema = require("chai-json-schema");
import { createPlayer, deletePlayer } from "../players/stubs";
import { createTournamentWithOrganizaion, deleteTournamentAndOrganization } from "../tournaments/stubs";
import { PLAYER_STATS_LOGS_URL } from "../URLs";
import { authenticationHeader } from "../utils/auth";
import httpClientFactory from "../utils/httpClientFactory";
import { playerStatsLogPostPayload, playerStatsLogPatchayload } from "./helpers";
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

      const payload = playerStatsLogPostPayload(player.id, tournament.id);

      const { status, data } = await httpClient.post(payload, { headers: authHeader });

      expect(payload).to.be.jsonSchema(schema.definitions.PlayerStatsLogRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.PlayerStatsLogPostPatchResponse);
      const playerStatsLogId = data.data[Object.keys(data.data)[0]].id;

      await httpClient.delete(playerStatsLogId, { headers: authHeader });
      await deletePlayer(player.id);
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("GET /:id", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();
      const { player } = await createPlayer(tournament.id);

      const payload = playerStatsLogPostPayload(player.id, tournament.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });
      const playerStatsLogId = created.data[Object.keys(created.data)[0]].id;

      const { status, data: response } = await httpClient.get(playerStatsLogId);
      expect(response).to.be.jsonSchema(schema.definitions.PlayerStatsLogResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(playerStatsLogId, { headers: authHeader });
      await deletePlayer(player.id);
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("PATCH /:id", () => {
    it("matchs schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();
      const { player } = await createPlayer(tournament.id);

      const payload = playerStatsLogPostPayload(player.id, tournament.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });

      const playerStatsLogId = created.data[Object.keys(created.data)[0]].id;
      const patchPayload = playerStatsLogPatchayload(playerStatsLogId, player.id, tournament.id);
      const { status, data: response } =
        await httpClient.patchBatch(patchPayload, { headers: authHeader });
      expect(patchPayload).to.be.jsonSchema(schema.definitions.PlayerStatsLogRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PlayerStatsLogPostPatchResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(playerStatsLogId, { headers: authHeader });
      await deletePlayer(player.id);
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("DELETE /", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const { player } = await createPlayer(tournament.id);

      const payload = playerStatsLogPostPayload(player.id, tournament.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });

      const playerStatsLogId = created.data[Object.keys(created.data)[0]].id;

      const { status } = await httpClient.delete(playerStatsLogId, { headers: authHeader });
      expect(status).to.be.equal(204);

      await deletePlayer(player.id);
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });
});
