import { expect, use } from "chai";
import schema from "./organization_swagger.json";
import ChaiJsonSchema = require("chai-json-schema");

use(ChaiJsonSchema);

describe("Organizations", () => {
  it("matchs hardcoded respose", () => {
    const organization = schema.definitions.OrganizationRequest.example.organization;
    expect(organization).to.be.jsonSchema(schema.definitions.Organization);
  });
});
