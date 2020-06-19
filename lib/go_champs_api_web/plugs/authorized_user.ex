defmodule GoChampsApiWeb.Plugs.AuthorizedUser do
  import Phoenix.Controller
  import Plug.Conn

  def init(default), do: default

  def call(conn, _params) do
    {:ok, username} = Map.fetch(conn.params, "username")

    current_user = Guardian.Plug.current_resource(conn)

    if current_user.username == username do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> text("Forbidden")
      |> halt
    end
  end
end
