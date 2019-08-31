import { expect, tv4, use } from "chai";
import { createTournamentPhaseWithOrganizaion, deleteTournamentPhaseAndOrganization } from "../tournamentPhases/stubs";
import { createTournamentTeam, deleteTournamentTeam } from "../tournamentTeams/stubs";
import { phaseGamesURL } from "../URLs";
import httpClientFactory from "../utils/httpClientFactory";
import { tournamentGamePayload, tournamentGameWithTeamsPayload } from "./helpers";
import schema from "./phase_game_swagger.json";
import ChaiJsonSchema = require("chai-json-schema");

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/PhaseGame", schema.definitions.PhaseGame);

describe("PhasesGame", () => {
  describe("POST /", () => {
    it("matches schema", async () => {
      const { tournament, organization, tournamentPhase } = await createTournamentPhaseWithOrganizaion();

      const httpClient = httpClientFactory(phaseGamesURL(tournamentPhase.id));

      const payload = tournamentGamePayload(tournamentPhase.id);
      const { status, data } = await httpClient.post(payload);
      console.log(data);
      expect(payload).to.be.jsonSchema(schema.definitions.PhaseGameRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.PhaseGameResponse);

      await httpClient.delete(data.data.id);
      await deleteTournamentPhaseAndOrganization(
        tournament.id,
        organization.id,
        tournamentPhase.id,
      );
    });

    it("matches schema with tournament team", async () => {
      const { tournament, organization, tournamentPhase } = await createTournamentPhaseWithOrganizaion();
      const { tournamentTeam: awayTeam } = await createTournamentTeam(tournament.id);
      const { tournamentTeam: homeTeam } = await createTournamentTeam(tournament.id);

      const httpClient = httpClientFactory(phaseGamesURL(tournamentPhase.id));

      const payload = tournamentGameWithTeamsPayload(tournamentPhase.id, awayTeam.id, homeTeam.id);
      const { status, data } = await httpClient.post(payload);
      expect(payload).to.be.jsonSchema(schema.definitions.PhaseGameRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.PhaseGameResponse);

      await httpClient.delete(data.data.id);
      await deleteTournamentTeam(tournament.id, awayTeam.id);
      await deleteTournamentTeam(tournament.id, homeTeam.id);
      await deleteTournamentPhaseAndOrganization(
        tournament.id,
        organization.id,
        tournamentPhase.id,
      );
    });
  });

  describe("GET /", () => {
    it("matches schema", async () => {
      const { tournament, organization, tournamentPhase } = await createTournamentPhaseWithOrganizaion();

      const httpClient = httpClientFactory(phaseGamesURL(tournamentPhase.id));

      const { status, data } = await httpClient.getAll();
      expect(data).to.be.jsonSchema(schema.definitions.PhaseGamesResponse);
      expect(status).to.be.equal(200);

      await deleteTournamentPhaseAndOrganization(
        tournament.id,
        organization.id,
        tournamentPhase.id,
      );
    });
  });

  describe("GET /:id", () => {
    it("matches schema", async () => {
      const { tournament, organization, tournamentPhase } = await createTournamentPhaseWithOrganizaion();

      const httpClient = httpClientFactory(phaseGamesURL(tournamentPhase.id));

      const payload = tournamentGamePayload(tournamentPhase.id);
      const { data: created } = await httpClient.post(payload);

      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseGameResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id);
      await deleteTournamentPhaseAndOrganization(
        tournament.id,
        organization.id,
        tournamentPhase.id,
      );
    });
  });

  describe("PATCH /:id", () => {
    it("matchs schema", async () => {
      const { tournament, organization, tournamentPhase } = await createTournamentPhaseWithOrganizaion();

      const httpClient = httpClientFactory(phaseGamesURL(tournamentPhase.id));

      const payload = tournamentGamePayload(tournamentPhase.id);
      const { data: created } = await httpClient.post(payload);

      const patchPayload = tournamentGamePayload(tournamentPhase.id);
      const { status, data: response } = await httpClient.patch(created.data.id, patchPayload);
      expect(patchPayload).to.be.jsonSchema(schema.definitions.PhaseGameRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseGameResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id);
      await deleteTournamentPhaseAndOrganization(
        tournament.id,
        organization.id,
        tournamentPhase.id,
      );
    });
  });

  describe("DELETE /", () => {
    it("matches schema", async () => {
      const { tournament, organization, tournamentPhase } = await createTournamentPhaseWithOrganizaion();

      const httpClient = httpClientFactory(phaseGamesURL(tournamentPhase.id));

      const payload = tournamentGamePayload(tournamentPhase.id);
      const { data: created } = await httpClient.post(payload);
      const { status } = await httpClient.delete(created.data.id);
      expect(status).to.be.equal(204);

      await deleteTournamentPhaseAndOrganization(
        tournament.id,
        organization.id,
        tournamentPhase.id,
      );
    });
  });
});
