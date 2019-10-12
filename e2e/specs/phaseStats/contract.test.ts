import { expect, tv4, use } from "chai";
import { createPhaseWithOrganizaion, deletePhaseAndOrganization } from "../phases/stubs";
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
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();

      const httpClient = httpClientFactory(phaseStatsURL(phase.id));

      const payload = tournamentStatPayload(phase.id);
      const { status, data } = await httpClient.post(payload);
      expect(payload).to.be.jsonSchema(schema.definitions.PhaseStatRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.PhaseStatResponse);

      await httpClient.delete(data.data.id);
      await deletePhaseAndOrganization(
        tournament.id,
        organization.id,
        phase.id,
      );
    });
  });

  describe("GET /", () => {
    it("matches schema", async () => {
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();

      const httpClient = httpClientFactory(phaseStatsURL(phase.id));

      const { status, data } = await httpClient.getAll();
      expect(data).to.be.jsonSchema(schema.definitions.PhaseStatsResponse);
      expect(status).to.be.equal(200);

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

      const httpClient = httpClientFactory(phaseStatsURL(phase.id));

      const payload = tournamentStatPayload(phase.id);
      const { data: created } = await httpClient.post(payload);

      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseStatResponse);
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

      const httpClient = httpClientFactory(phaseStatsURL(phase.id));

      const payload = tournamentStatPayload(phase.id);
      const { data: created } = await httpClient.post(payload);

      const patchPayload = tournamentStatPayload(phase.id);
      const { status, data: response } = await httpClient.patch(created.data.id, patchPayload);
      expect(patchPayload).to.be.jsonSchema(schema.definitions.PhaseStatRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseStatResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id);
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

      const httpClient = httpClientFactory(phaseStatsURL(phase.id));

      const payload = tournamentStatPayload(phase.id);
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
