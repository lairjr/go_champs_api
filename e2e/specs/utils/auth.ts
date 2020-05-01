import axios from "axios";
import { USERS_URL } from "../URLs";

const MOCK_USER = {
  email: "some@email.com",
  password: "password",
  username: "username",
};

let authenticationHeaderChace;

export const authenticationHeader = async () => {
  if (authenticationHeaderChace) {
    return authenticationHeaderChace;
  }

  try {
    const signUpResponse = await axios.post(`${USERS_URL}/signup`, { user: MOCK_USER });

    const signUpToken = signUpResponse.data.data.token;

    authenticationHeaderChace = buildHeader(signUpToken);

    return authenticationHeaderChace;
  } catch (err) {
    if (err.response.status === 422) {
      const signInResponse = await axios.post(`${USERS_URL}/signin`, MOCK_USER);

      const signInToken = signInResponse.data.data.token;

      authenticationHeaderChace = buildHeader(signInToken);

      return authenticationHeaderChace;
    }
  }
};

const buildHeader = (token: string) => ({
  authorization: `Bearer ${token}`,
});
