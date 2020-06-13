import axios from "axios";
import { USERS_URL } from "../URLs";

const MOCK_USER = {
  email: "some@email.com",
  password: "password",
  username: "username",
};

let authenticationHeaderCache;

export const authenticationHeader = async () => {
  if (authenticationHeaderCache) {
    return authenticationHeaderCache;
  }

  try {
    const signUpResponse = await axios.post(`${USERS_URL}/signup`, { user: MOCK_USER });

    const signUpToken = signUpResponse.data.data.token;

    authenticationHeaderCache = buildHeader(signUpToken);

    return authenticationHeaderCache;
  } catch (err) {
    if (err.response.status === 422) {
      const signInResponse = await axios.post(`${USERS_URL}/signin`, MOCK_USER);

      const signInToken = signInResponse.data.data.token;

      authenticationHeaderCache = buildHeader(signInToken);

      return authenticationHeaderCache;
    }
  }
};

const buildHeader = (token: string) => ({
  authorization: `Bearer ${token}`,
});
