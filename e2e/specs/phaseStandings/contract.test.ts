import { expect, tv4, use } from "chai";
import { createTournamentPhaseWithOrganizaion, deleteTournamentPhaseAndOrganization } from "../tournamentPhases/stubs";
import { phaseStandingsURL } from "../URLs";
import httpClientFactory from "../utils/httpClientFactory";
import { tournamentStandingsPayload } from "./helpers";
import schema from "./phase_standings_swagger.json";
import ChaiJsonSchema = require("chai-json-schema");

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/PhaseStandings", schema.definitions.PhaseStandings);

describe("PhasesStandings", () => {
  describe("POST /", () => {
    it("matches schema", async () => {
      const { tournament, organization, tournamentPhase } = await createTournamentPhaseWithOrganizaion();

      const httpClient = httpClientFactory(phaseStandingsURL(tournamentPhase.id));

      const payload = tournamentStandingsPayload(tournamentPhase.id);
      const { status, data } = await httpClient.post(payload);
      expect(payload).to.be.jsonSchema(schema.definitions.PhaseStandingsRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.PhaseStandingsResponse);

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

      const httpClient = httpClientFactory(phaseStandingsURL(tournamentPhase.id));

      const { status, data } = await httpClient.getAll();
      expect(data).to.be.jsonSchema(schema.definitions.PhaseStandingsListResponse);
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

      const httpClient = httpClientFactory(phaseStandingsURL(tournamentPhase.id));

      const payload = tournamentStandingsPayload(tournamentPhase.id);
      const { data: created } = await httpClient.post(payload);

      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseStandingsResponse);
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

      const httpClient = httpClientFactory(phaseStandingsURL(tournamentPhase.id));

      const payload = tournamentStandingsPayload(tournamentPhase.id);
      const { data: created } = await httpClient.post(payload);

      const patchPayload = tournamentStandingsPayload(tournamentPhase.id);
      const { status, data: response } = await httpClient.patch(created.data.id, patchPayload);
      expect(patchPayload).to.be.jsonSchema(schema.definitions.PhaseStandingsRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseStandingsResponse);
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

      const httpClient = httpClientFactory(phaseStandingsURL(tournamentPhase.id));

      const payload = tournamentStandingsPayload(tournamentPhase.id);
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
