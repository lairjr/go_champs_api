import axios from "axios";
import { USERS_URL } from "../URLs";

const MOCK_USER = {
  email: "some@email.com",
  password: "password",
};

export const authenticationHeader = async () => {
  try {
    const signUpResponse = await axios.post(`${USERS_URL}/signup`, { user: MOCK_USER });

    const signUpToken = signUpResponse.data.data.token;

    return buildHeader(signUpToken);
  } catch (err) {
    if (err.response.status === 422) {
      const signInResponse = await axios.post(`${USERS_URL}/signin`, MOCK_USER);

      const signInToken = signInResponse.data.data.token;

      return buildHeader(signInToken);
    }
  }
};

const buildHeader = (token: string) => ({
  authorization: `Bearer ${token}`,
});
