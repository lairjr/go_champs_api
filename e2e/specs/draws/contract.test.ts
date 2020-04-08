import { expect, tv4, use } from "chai";
import { createPhaseWithOrganizaion, deletePhaseAndOrganization } from "../phases/stubs";
import { DRAWS_URL } from "../URLs";
import httpClientFactory from "../utils/httpClientFactory";
import schema from "./draws_swagger.json";
import { drawPayload, drawsPatchPayload } from "./helpers";
import ChaiJsonSchema = require("chai-json-schema");

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/PhaseRounds", schema.definitions.PhaseRounds);

describe("Draws", () => {
  describe("POST /", () => {
    it("matches schema", async () => {
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();

      const httpClient = httpClientFactory(DRAWS_URL);

      const payload = drawPayload(phase.id);
      const { status, data } = await httpClient.post(payload);
      expect(payload).to.be.jsonSchema(schema.definitions.PhaseRoundsRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.PhaseRoundsResponse);

      await httpClient.delete(data.data.id);
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

      const httpClient = httpClientFactory(DRAWS_URL);

      const payload = drawPayload(phase.id);
      const { data: created } = await httpClient.post(payload);

      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseRoundsResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id);
      await deletePhaseAndOrganization(
        tournament.id,
        organization.id,
        phase.id,
      );
    });
  });

  describe("PATCH /", () => {
    it("matchs schema", async () => {
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();

      const httpClient = httpClientFactory(DRAWS_URL);

      const firstPayload = drawPayload(phase.id);
      const secondPayload = drawPayload(phase.id);
      const { data: firstCreated } = await httpClient.post(firstPayload);
      const { data: secondCreated } = await httpClient.post(secondPayload);
      const firstDrawToPatch = {
        ...firstCreated.data,
        phase_id: phase.id,
      };
      const secondDrawToPatch = {
        ...secondCreated.data,
        phase_id: phase.id,
      };

      const patchBatchPayload = drawsPatchPayload([firstDrawToPatch, secondDrawToPatch]);
      const { status, data: response } = await httpClient.patchBatch(patchBatchPayload);
      expect(patchBatchPayload).to.be.jsonSchema(schema.definitions.PhaseRoundsBatchRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseRoundsBatchRespose);
      expect(status).to.be.equal(200);

      await httpClient.delete(firstCreated.data.id);
      await httpClient.delete(secondCreated.data.id);
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

      const httpClient = httpClientFactory(DRAWS_URL);

      const payload = drawPayload(phase.id);
      const { data: created } = await httpClient.post(payload);

      const patchPayload = drawPayload(phase.id);
      const { status, data: response } = await httpClient.patch(created.data.id, patchPayload);
      expect(patchPayload).to.be.jsonSchema(schema.definitions.PhaseRoundsRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseRoundsResponse);
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

      const httpClient = httpClientFactory(DRAWS_URL);

      const payload = drawPayload(phase.id);
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
