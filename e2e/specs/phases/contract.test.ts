import { expect, tv4, use } from "chai";
import { createTournamentWithOrganizaion, deleteTournamentAndOrganization } from "../tournaments/stubs";
import { PHASES_URL } from "../URLs";
import httpClientFactory from "../utils/httpClientFactory";
import { phasePayload, phaseWithEliminationPayload, phasesPatchPayload } from "./helpers";
import schema from "./phase_swagger.json";
import ChaiJsonSchema = require("chai-json-schema");

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/Phase", schema.definitions.Phase);

describe("Phases", () => {
  describe("POST /", () => {
    it("matches schema", async () => {
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const httpClient = httpClientFactory(PHASES_URL);

      const payload = phasePayload(tournament.id);
      const { status, data } = await httpClient.post(payload);
      expect(payload).to.be.jsonSchema(schema.definitions.PhaseRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.PhaseResponse);

      await httpClient.delete(data.data.id);
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("GET /:id", () => {
    it("matches schema", async () => {
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const httpClient = httpClientFactory(PHASES_URL);

      const payload = phasePayload(tournament.id);
      const { data: created } = await httpClient.post(payload);

      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id);
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });

    it("matches full schema", async () => {
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const httpClient = httpClientFactory(PHASES_URL);

      const payload = phaseWithEliminationPayload(tournament.id);
      const { data: created } = await httpClient.post(payload);

      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id);
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("PATCH /", () => {
    it("matchs schema", async () => {
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const httpClient = httpClientFactory(PHASES_URL);

      const firstPayload = phasePayload(tournament.id);
      const secondPayload = phasePayload(tournament.id);
      const { data: firstCreated } = await httpClient.post(firstPayload);
      const { data: secondCreated } = await httpClient.post(secondPayload);
      const firstPhaseToPatch = {
        ...firstCreated.data,
        tournament_id: tournament.id,
      };
      const secondPhaseToPatch = {
        ...secondCreated.data,
        tournament_id: tournament.id,
      };

      const patchBatchPayload = phasesPatchPayload([firstPhaseToPatch, secondPhaseToPatch]);
      const { status, data: response } = await httpClient.patchBatch(patchBatchPayload);
      expect(patchBatchPayload).to.be.jsonSchema(schema.definitions.PhaseBatchRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PhasesBatchRespose);
      expect(status).to.be.equal(200);

      await httpClient.delete(firstCreated.data.id);
      await httpClient.delete(secondCreated.data.id);
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("PATCH /:id", () => {
    it("matchs schema", async () => {
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const httpClient = httpClientFactory(PHASES_URL);

      const payload = phasePayload(tournament.id);
      const { data: created } = await httpClient.post(payload);

      const patchPayload = phasePayload(tournament.id);
      const { status, data: response } = await httpClient.patch(created.data.id, patchPayload);
      expect(patchPayload).to.be.jsonSchema(schema.definitions.PhaseRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id);
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("DELETE /", () => {
    it("matches schema", async () => {
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const httpClient = httpClientFactory(PHASES_URL);

      const payload = phasePayload(tournament.id);
      const { data: created } = await httpClient.post(payload);
      const { status } = await httpClient.delete(created.data.id);
      expect(status).to.be.equal(204);

      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });
});
