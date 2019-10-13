import { expect, tv4, use } from "chai";
import { createPhaseWithOrganizaion, deletePhaseAndOrganization } from "../phases/stubs";
import { createTeam, deleteTeam } from "../teams/stubs";
import { GAMES_URL } from "../URLs";
import httpClientFactory from "../utils/httpClientFactory";
import schema from "./game_swagger.json";
import { tournamentGamePayload, tournamentGameWithTeamsPayload } from "./helpers";
import ChaiJsonSchema = require("chai-json-schema");

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/PhaseGame", schema.definitions.PhaseGame);

describe("Games", () => {
  describe("POST /", () => {
    it("matches schema", async () => {
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();

      const httpClient = httpClientFactory(GAMES_URL);

      const payload = tournamentGamePayload(phase.id);
      const { status, data } = await httpClient.post(payload);
      expect(payload).to.be.jsonSchema(schema.definitions.PhaseGameRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.PhaseGameResponse);

      await httpClient.delete(data.data.id);
      await deletePhaseAndOrganization(
        tournament.id,
        organization.id,
        phase.id,
      );
    });

    it("matches schema with tournament team", async () => {
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();
      const { team: awayTeam } = await createTeam(tournament.id);
      const { team: homeTeam } = await createTeam(tournament.id);

      const httpClient = httpClientFactory(GAMES_URL);

      const payload = tournamentGameWithTeamsPayload(phase.id, awayTeam.id, homeTeam.id);
      const { status, data } = await httpClient.post(payload);
      expect(payload).to.be.jsonSchema(schema.definitions.PhaseGameRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.PhaseGameResponse);

      await httpClient.delete(data.data.id);
      await deleteTeam(tournament.id, awayTeam.id);
      await deleteTeam(tournament.id, homeTeam.id);
      await deletePhaseAndOrganization(
        tournament.id,
        organization.id,
        phase.id,
      );
    });
  });

  describe("GET /:id", () => {
    it("matches schema", async () => {
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();

      const httpClient = httpClientFactory(GAMES_URL);

      const payload = tournamentGamePayload(phase.id);
      const { data: created } = await httpClient.post(payload);

      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseGameResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id);
      await deletePhaseAndOrganization(
        tournament.id,
        organization.id,
        phase.id,
      );
    });
  });

  describe("PATCH /:id", () => {
    it("matchs schema", async () => {
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();

      const httpClient = httpClientFactory(GAMES_URL);

      const payload = tournamentGamePayload(phase.id);
      const { data: created } = await httpClient.post(payload);

      const patchPayload = tournamentGamePayload(phase.id);
      const { status, data: response } = await httpClient.patch(created.data.id, patchPayload);
      expect(patchPayload).to.be.jsonSchema(schema.definitions.PhaseGameRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseGameResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id);
      await deletePhaseAndOrganization(
        tournament.id,
        organization.id,
        phase.id,
      );
    });

    it("matchs schema with tournament team", async () => {
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();

      const httpClient = httpClientFactory(GAMES_URL);

      const payload = tournamentGamePayload(phase.id);
      const { data: created } = await httpClient.post(payload);

      const { team: awayTeam } = await createTeam(tournament.id);
      const { team: homeTeam } = await createTeam(tournament.id);

      const patchPayload = tournamentGameWithTeamsPayload(phase.id, awayTeam.id, homeTeam.id);
      const { status, data: response } = await httpClient.patch(created.data.id, patchPayload);
      expect(patchPayload).to.be.jsonSchema(schema.definitions.PhaseGameRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseGameResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id);
      await deleteTeam(tournament.id, awayTeam.id);
      await deleteTeam(tournament.id, homeTeam.id);
      await deletePhaseAndOrganization(
        tournament.id,
        organization.id,
        phase.id,
      );
    });
  });

  describe("DELETE /", () => {
    it("matches schema", async () => {
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();

      const httpClient = httpClientFactory(GAMES_URL);

      const payload = tournamentGamePayload(phase.id);
      const { data: created } = await httpClient.post(payload);
      const { status } = await httpClient.delete(created.data.id);
      expect(status).to.be.equal(204);

      await deletePhaseAndOrganization(
        tournament.id,
        organization.id,
        phase.id,
      );
    });
  });
});
