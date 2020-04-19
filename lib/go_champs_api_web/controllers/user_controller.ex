defmodule GoChampsApiWeb.UserController do
  use GoChampsApiWeb, :controller

  alias GoChampsApi.Accounts
  alias GoChampsApi.Accounts.User
  alias GoChampsApiWeb.Auth.Guardian

  action_fallback GoChampsApiWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    case Recaptcha.verify(user_params["recaptcha"]) do
      {:ok, _response} ->
        with {:ok, %User{} = user} <- Accounts.create_user(user_params),
             {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
          conn
          |> put_status(:created)
          |> render("user.json", %{user: user, token: token})
        end

      {:error, response} ->
        IO.inspect(response)

        conn
        |> render("user.json", %{user: %{email: "bafuncio"}, token: "invalid"})
    end
  end

  def signin(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(email, password) do
      conn
      |> render("user.json", %{user: user, token: token})
    end
  end
end
