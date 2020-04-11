defmodule GoChampsApiWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  alias GoChampsApi.Accounts

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias GoChampsApiWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint GoChampsApiWeb.Endpoint
    end
  end

  @user_attrs %{
    email: "some@email.com",
    password: "some password"
  }

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GoChampsApi.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(GoChampsApi.Repo, {:shared, self()})
    end

    {conn, user} =
      if tags[:authenticated] do
        {:ok, user} = create_user()

        {:ok, user, token} = GoChampsApiWeb.Auth.Guardian.authenticate(user.email, user.password)

        conn =
          Phoenix.ConnTest.build_conn()
          |> Plug.Conn.put_req_header("authorization", "Bearer #{token}")

        {conn, user}
      else
        {Phoenix.ConnTest.build_conn(), nil}
      end

    {:ok, conn: conn, user: user}
  end

  def create_user() do
    @user_attrs
    |> Accounts.create_user()
  end
end
