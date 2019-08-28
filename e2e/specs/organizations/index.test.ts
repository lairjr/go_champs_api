import axios from 'axios';
import { expect, tv4, use } from "chai";
import schema from "./organization_swagger.json";
import ChaiJsonSchema = require("chai-json-schema");

use(ChaiJsonSchema);

const ORGANIZATIONS_URL = "https://yochamps-api.herokuapp.com/api/organizations";

tv4.addSchema("#/definitions/Organization", schema.definitions.Organization);

describe("Organizations", () => {
  describe("/get", () => {
    it("matches schema", async () => {
      const { status, data } = await axios.get(ORGANIZATIONS_URL);
      expect(data).to.be.jsonSchema(schema.definitions.OrganizationsResponse);
      expect(status).to.be.equal(200);
    });
  });
});
