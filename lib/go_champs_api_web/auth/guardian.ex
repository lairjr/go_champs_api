defmodule GoChampsApiWeb.Auth.Guardian do
  use Guardian, otp_app: :go_champs_api

  alias GoChampsApi.Accounts

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Accounts.get_user!(id)
    {:ok, resource}
  end

  def authenticate(username, password) do
    with {:ok, user} <- Accounts.get_by_username!(username) do
      case validate_password(password, user.encrypted_password) do
        true ->
          create_token(user)

        false ->
          {:error, :unauthorized}
      end
    end
  end

  def authenticate_by_facebook(facebook_id) do
    case Accounts.get_by_facebook_id!(facebook_id) do
      {:ok, user} ->
        create_token(user)

      false ->
        {:error, :unauthorized}
    end
  end

  defp validate_password(password, encrypted_password) do
    Bcrypt.verify_pass(password, encrypted_password)
  end

  defp create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end
end
