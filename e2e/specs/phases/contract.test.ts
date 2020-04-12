import { expect, tv4, use } from "chai";
import ChaiJsonSchema = require("chai-json-schema");
import { createTournamentWithOrganizaion, deleteTournamentAndOrganization } from "../tournaments/stubs";
import { PHASES_URL } from "../URLs";
import { authenticationHeader } from "../utils/auth";
import httpClientFactory from "../utils/httpClientFactory";
import { phasePayload, phasesPatchPayload, phaseWithEliminationPayload } from "./helpers";
import schema from "./phase_swagger.json";

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/Phase", schema.definitions.Phase);

const httpClient = httpClientFactory(PHASES_URL);

describe("Phases", () => {
  describe("POST /", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const payload = phasePayload(tournament.id);
      const { status, data } = await httpClient.post(payload, { headers: authHeader });
      expect(payload).to.be.jsonSchema(schema.definitions.PhaseRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.PhaseResponse);

      await httpClient.delete(data.data.id, { headers: authHeader });
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("GET /:id", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const payload = phasePayload(tournament.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });

      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id, { headers: authHeader });
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });

    it("matches full schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const payload = phaseWithEliminationPayload(tournament.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });

      const { status, data: response } = await httpClient.get(created.data.id);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id, { headers: authHeader });
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("PATCH /", () => {
    it("matchs schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const firstPayload = phasePayload(tournament.id);
      const secondPayload = phasePayload(tournament.id);
      const { data: firstCreated } = await httpClient.post(firstPayload, { headers: authHeader });
      const { data: secondCreated } = await httpClient.post(secondPayload, { headers: authHeader });
      const firstPhaseToPatch = {
        ...firstCreated.data,
        tournament_id: tournament.id,
      };
      const secondPhaseToPatch = {
        ...secondCreated.data,
        tournament_id: tournament.id,
      };

      const patchBatchPayload = phasesPatchPayload([firstPhaseToPatch, secondPhaseToPatch]);
      const { status, data: response } = await httpClient.patchBatch(patchBatchPayload, { headers: authHeader });
      expect(patchBatchPayload).to.be.jsonSchema(schema.definitions.PhaseBatchRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PhasesBatchRespose);
      expect(status).to.be.equal(200);

      await httpClient.delete(firstCreated.data.id, { headers: authHeader });
      await httpClient.delete(secondCreated.data.id, { headers: authHeader });
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("PATCH /:id", () => {
    it("matchs schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const payload = phasePayload(tournament.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });

      const patchPayload = phasePayload(tournament.id);
      const { status, data: response } = await httpClient.patch(created.data.id, patchPayload, { headers: authHeader });
      expect(patchPayload).to.be.jsonSchema(schema.definitions.PhaseRequest);
      expect(response).to.be.jsonSchema(schema.definitions.PhaseResponse);
      expect(status).to.be.equal(200);

      await httpClient.delete(created.data.id, { headers: authHeader });
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  describe("DELETE /", () => {
    it("matches schema", async () => {
      const authHeader = await authenticationHeader();
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const payload = phasePayload(tournament.id);
      const { data: created } = await httpClient.post(payload, { headers: authHeader });
      const { status } = await httpClient.delete(created.data.id, { headers: authHeader });
      expect(status).to.be.equal(204);

      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });
});
