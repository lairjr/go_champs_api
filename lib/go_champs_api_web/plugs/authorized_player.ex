defmodule GoChampsApiWeb.Plugs.AuthorizedPlayer do
  import Phoenix.Controller
  import Plug.Conn

  alias GoChampsApi.Tournaments
  alias GoChampsApi.Players

  def init(default), do: default

  def call(conn, :player) do
    {:ok, player} = Map.fetch(conn.params, "player")
    {:ok, tournament_id} = Map.fetch(player, "tournament_id")

    organization = Tournaments.get_tournament_organization!(tournament_id)
    current_user = Guardian.Plug.current_resource(conn)

    if Enum.any?(organization.members, fn member -> member.username == current_user.username end) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> text("Forbidden")
      |> halt
    end
  end

  def call(conn, :id) do
    {:ok, player_id} = Map.fetch(conn.params, "id")

    organization = Players.get_player_organization!(player_id)
    current_user = Guardian.Plug.current_resource(conn)

    if Enum.any?(organization.members, fn member -> member.username == current_user.username end) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> text("Forbidden")
      |> halt
    end
  end
end
