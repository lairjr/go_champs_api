defmodule GoChampsApiWeb.UserController do
  use GoChampsApiWeb, :controller

  alias GoChampsApi.Accounts
  alias GoChampsApi.Accounts.User
  alias GoChampsApiWeb.Auth.Guardian

  action_fallback GoChampsApiWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, _response} <- Recaptcha.verify(user_params["recaptcha"]) do
      with {:ok, %User{} = user} <- Accounts.create_user(user_params),
           {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
        conn
        |> put_status(:created)
        |> render("user.json", %{user: user, token: token})
      end
    end
  end

  def update(conn, %{"user" => user_params}) do
    if user_params["email"] != nil and user_params["password"] != nil do
      {:ok, current_user} = Accounts.get_by_username(user_params["username"])

      with {:ok, _response} <- Recaptcha.verify(user_params["recaptcha"]) do
        with {:ok, %User{} = user} <- Accounts.update_user(current_user, user_params),
             {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
          conn
          |> put_status(:ok)
          |> render("user.json", %{user: user, token: token})
        end
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{email: "invalid email"})
    end
  end

  def signin(conn, %{"username" => username, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(username, password) do
      conn
      |> render("user.json", %{user: user, token: token})
    end
  end
end
