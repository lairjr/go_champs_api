import { expect, tv4, use } from "chai";
import ChaiJsonSchema = require("chai-json-schema");
import { createPhaseWithOrganizaion, deletePhaseAndOrganization } from "../phases/stubs";
import { ELIMINATIONS_URL } from "../URLs";
import { authenticationHeader } from "../utils/auth";
import httpClientFactory from "../utils/httpClientFactory";
import schema from "./eliminations_swagger.json";
import { eliminationPayload, eliminationsPatchPayload } from "./helpers";

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/Elimination", schema.definitions.Elimination);

describe("Eliminations", () => {
  describe("POST /", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();

      const httpClient = httpClientFactory(ELIMINATIONS_URL);

      const payload = eliminationPayload(phase.id);
      const { status, data } = await httpClient.post(payload, { headers: authHeader });
      expect(payload).to.be.jsonSchema(schema.definitions.EliminationRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.EliminationResponse);

      await httpClient.delete(data.data.id, { headers: authHeader });
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

      const httpClient = httpClientFactory(ELIMINATIONS_URL);

      const payload = eliminationPayload(phase.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });

      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.EliminationResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id, { headers: authHeader });
      await deletePhaseAndOrganization(
        tournament.id,
        organization.id,
        phase.id,
      );
    });
  });

  describe("PATCH /", () => {
    it("matchs schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization, phase } = await createPhaseWithOrganizaion();

      const httpClient = httpClientFactory(ELIMINATIONS_URL);

      const firstPayload = eliminationPayload(phase.id);
      const secondPayload = eliminationPayload(phase.id);
      const { data: firstCreated } = await httpClient.post(firstPayload, { headers: authHeader });
      const { data: secondCreated } = await httpClient.post(secondPayload, { headers: authHeader });
      const firstEliminationToPatch = {
        ...firstCreated.data,
        phase_id: phase.id,
      };
      const secondEliminationToPatch = {
        ...secondCreated.data,
        phase_id: phase.id,
      };

      const patchBatchPayload = eliminationsPatchPayload([firstEliminationToPatch, secondEliminationToPatch]);
      const { status, data: response } = await httpClient.patchBatch(patchBatchPayload, { headers: authHeader });
      expect(patchBatchPayload).to.be.jsonSchema(schema.definitions.EliminationBatchRequest);
      expect(response).to.be.jsonSchema(schema.definitions.EliminationsBatchRespose);
      expect(status).to.be.equal(200);

      await httpClient.delete(firstCreated.data.id, { headers: authHeader });
      await httpClient.delete(secondCreated.data.id, { headers: authHeader });
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

      const httpClient = httpClientFactory(ELIMINATIONS_URL);

      const payload = eliminationPayload(phase.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });

      const patchPayload = eliminationPayload(phase.id);
      const { status, data: response } = await httpClient.patch(created.data.id, patchPayload, { headers: authHeader });
      expect(patchPayload).to.be.jsonSchema(schema.definitions.EliminationRequest);
      expect(response).to.be.jsonSchema(schema.definitions.EliminationResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id, { headers: authHeader });
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

      const httpClient = httpClientFactory(ELIMINATIONS_URL);

      const payload = eliminationPayload(phase.id);
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
