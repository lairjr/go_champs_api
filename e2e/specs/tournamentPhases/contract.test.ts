import { expect, tv4, use } from "chai";
import { createTournamentWithOrganizaion, deleteTournamentAndOrganization } from "../tournaments/stubs";
import { tournamentPhasesURL } from "../URLs";
import httpClientFactory from "../utils/httpClientFactory";
import { tournamentPhasePayload } from "./helpers";
import schema from "./tournament_phase_swagger.json";
import ChaiJsonSchema = require("chai-json-schema");

use(ChaiJsonSchema);

tv4.addSchema("#/definitions/TournamentPhase", schema.definitions.TournamentPhase);

describe("TournamentPhases", () => {
  describe("POST /", () => {
    it("matches schema", async () => {
      const { tournament, organization } = await createTournamentWithOrganizaion();

      const httpClient = httpClientFactory(tournamentPhasesURL(tournament.id));

      const payload = tournamentPhasePayload(tournament.id);
      const { status, data } = await httpClient.post(payload);
      expect(payload).to.be.jsonSchema(schema.definitions.TournamentPhaseRequest);
      expect(status).to.be.equal(201);
      expect(data).to.be.jsonSchema(schema.definitions.TournamentPhaseResponse);

      await httpClient.delete(data.data.id);
      await deleteTournamentAndOrganization(tournament.id, organization.id);
    });
  });

  // describe("GET /", () => {
  //   it("matches schema", async () => {
  //     const { status, data } = await httpClient.getAll();
  //     expect(data).to.be.jsonSchema(schema.definitions.TournamentPhasePhasesResponse);
  //     expect(status).to.be.equal(200);
  //   });
  // });

  // describe("GET /:id", () => {
  //   it("matches schema", async () => {
  //     const { data: organization } = await stubOrganization();

  //     const { data: created } = await httpClient.post(tournamentPayload(organization.id));
  //     const { status, data: response } = await httpClient.get(created.data.id);
  //     expect(response).to.be.jsonSchema(schema.definitions.TournamentPhaseResponse);
  //     expect(status).to.be.equal(200);

  //     await httpClient.delete(created.data.id);
  //     await organizationClient.delete(organization.id);
  //   });
  // });

  // describe("PATCH /:id", () => {
  //   it("matchs schema", async () => {
  //     const { data: organization } = await stubOrganization();

  //     const { data: created } = await httpClient.post(tournamentPayload(organization.id));
  //     const payload = tournamentPayload(organization.id);
  //     const { status, data: response } = await httpClient.patch(created.data.id, payload);
  //     expect(payload).to.be.jsonSchema(schema.definitions.TournamentPhaseRequest);
  //     expect(response).to.be.jsonSchema(schema.definitions.TournamentPhaseResponse);
  //     expect(status).to.be.equal(200);

  //     await httpClient.delete(created.data.id);
  //     await organizationClient.delete(organization.id);
  //   });
  // });

  // describe("DELETE /", () => {
  //   it("matches schema", async () => {
  //     const { data: organization } = await stubOrganization();

  //     const { data: created } = await httpClient.post(tournamentPayload(organization.id));
  //     const { status } = await httpClient.delete(created.data.id);
  //     expect(status).to.be.equal(204);

  //     await organizationClient.delete(organization.id);
  //   });
  // });
});
