import { expect, tv4, use } from "chai";
import ChaiJsonSchema = require("chai-json-schema");
import { createPhaseWithOrganizaion, deletePhaseAndOrganization } from "../phases/stubs";
import { createTeam, deleteTeam } from "../teams/stubs";
import { GAMES_URL } from "../URLs";
import { authenticationHeader } from "../utils/auth";
import httpClientFactory from "../utils/httpClientFactory";
import schema from "./game_swagger.json";
import { tournamentGamePayload, tournamentGameWithTeamsPayload } from "./helpers";

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/PhaseGame", schema.definitions.PhaseGame);

describe("Games", () => {
  describe("POST /", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();

      const httpClient = httpClientFactory(GAMES_URL);

      const payload = tournamentGamePayload(phase.id);
      const { status, data } = await httpClient.post(payload, { headers: authHeader });
      expect(payload).to.be.jsonSchema(schema.definitions.PhaseGameRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.PhaseGameResponse);

      await httpClient.delete(data.data.id, { headers: authHeader });
      await deletePhaseAndOrganization(
        tournament.id,
        organization.id,
        phase.id,
      );
    });

    it("matches schema with tournament team", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();
      const { team: awayTeam } = await createTeam(tournament.id);
      const { team: homeTeam } = await createTeam(tournament.id);

      const httpClient = httpClientFactory(GAMES_URL);

      const payload = tournamentGameWithTeamsPayload(phase.id, awayTeam.id, homeTeam.id);
      const { status, data } = await httpClient.post(payload, { headers: authHeader });
      expect(payload).to.be.jsonSchema(schema.definitions.PhaseGameRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.PhaseGameResponse);

      await httpClient.delete(data.data.id, { headers: authHeader });
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
      const authHeader = await authenticationHeader();
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();

      const httpClient = httpClientFactory(GAMES_URL);

      const payload = tournamentGamePayload(phase.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });

      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseGameResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id, { headers: authHeader });
      await deletePhaseAndOrganization(
        tournament.id,
        organization.id,
        phase.id,
      );
    });
  });

  describe("PATCH /:id", () => {
    it("matchs schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();

      const httpClient = httpClientFactory(GAMES_URL);

      const payload = tournamentGamePayload(phase.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });

      const patchPayload = tournamentGamePayload(phase.id);
      const { status, data: response } = await httpClient.patch(created.data.id, patchPayload, { headers: authHeader });
      expect(patchPayload).to.be.jsonSchema(schema.definitions.PhaseGameRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseGameResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id, { headers: authHeader });
      await deletePhaseAndOrganization(
        tournament.id,
        organization.id,
        phase.id,
      );
    });

    it("matchs schema with tournament team", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();

      const httpClient = httpClientFactory(GAMES_URL);

      const payload = tournamentGamePayload(phase.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });

      const { team: awayTeam } = await createTeam(tournament.id);
      const { team: homeTeam } = await createTeam(tournament.id);

      const patchPayload = tournamentGameWithTeamsPayload(phase.id, awayTeam.id, homeTeam.id);
      const { status, data: response } = await httpClient.patch(created.data.id, patchPayload, { headers: authHeader });
      expect(patchPayload).to.be.jsonSchema(schema.definitions.PhaseGameRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseGameResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id, { headers: authHeader });
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
      const authHeader = await authenticationHeader();
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();

      const httpClient = httpClientFactory(GAMES_URL);

      const payload = tournamentGamePayload(phase.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });
      const { status } = await httpClient.delete(created.data.id, { headers: authHeader });
      expect(status).to.be.equal(204);

      await deletePhaseAndOrganization(
        tournament.id,
        organization.id,
        phase.id,
      );
    });
  });
});
