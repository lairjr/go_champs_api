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

      const first_payload = phasePayload(tournament.id);
      const second_payload = phasePayload(tournament.id);
      const { data: first_created } = await httpClient.post(first_payload);
      const { data: second_created } = await httpClient.post(second_payload);
      const first_phase_to_patch = {
        ...first_created.data,
        tournament_id: tournament.id,
      };
      const second_phase_to_patch = {
        ...second_created.data,
        tournament_id: tournament.id,
      };
      
      const patchBatchPayload = phasesPatchPayload([first_phase_to_patch, second_phase_to_patch]);
      const { status, data: response } = await httpClient.patchBatch(patchBatchPayload);
      expect(patchBatchPayload).to.be.jsonSchema(schema.definitions.PhaseBatchRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PhasesBatchRespose);
      expect(status).to.be.equal(200);

      await httpClient.delete(first_created.data.id);
      await httpClient.delete(second_created.data.id);
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
