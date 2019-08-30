import { expect, tv4, use } from "chai";
import { createTournamentPhaseWithOrganizaion, deleteTournamentPhaseAndOrganization } from "../tournamentPhases/stubs";
import { phaseStatsURL } from "../URLs";
import httpClientFactory from "../utils/httpClientFactory";
import { tournamentStatPayload } from "./helpers";
import schema from "./phase_stat_swagger.json";
import ChaiJsonSchema = require("chai-json-schema");

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/PhaseStat", schema.definitions.PhaseStat);

describe("PhasesStat", () => {
  describe("POST /", () => {
    it("matches schema", async () => {
      const { tournament, organization, tournamentPhase } = await createTournamentPhaseWithOrganizaion();

      const httpClient = httpClientFactory(phaseStatsURL(tournamentPhase.id));

      const payload = tournamentStatPayload(tournamentPhase.id);
      const { status, data } = await httpClient.post(payload);
      expect(payload).to.be.jsonSchema(schema.definitions.PhaseStatRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.PhaseStatResponse);

      await httpClient.delete(data.data.id);
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

      const httpClient = httpClientFactory(phaseStatsURL(tournamentPhase.id));

      const { status, data } = await httpClient.getAll();
      expect(data).to.be.jsonSchema(schema.definitions.PhaseStatsResponse);
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

      const httpClient = httpClientFactory(phaseStatsURL(tournamentPhase.id));

      const payload = tournamentStatPayload(tournamentPhase.id);
      const { data: created } = await httpClient.post(payload);

      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseStatResponse);
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

      const httpClient = httpClientFactory(phaseStatsURL(tournamentPhase.id));

      const payload = tournamentStatPayload(tournamentPhase.id);
      const { data: created } = await httpClient.post(payload);

      const patchPayload = tournamentStatPayload(tournamentPhase.id);
      const { status, data: response } = await httpClient.patch(created.data.id, patchPayload);
      expect(patchPayload).to.be.jsonSchema(schema.definitions.PhaseStatRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseStatResponse);
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

      const httpClient = httpClientFactory(phaseStatsURL(tournamentPhase.id));

      const payload = tournamentStatPayload(tournamentPhase.id);
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
