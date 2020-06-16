defmodule GoChampsApiWeb.Plugs.AuthorizedTeam do
  import Phoenix.Controller
  import Plug.Conn

  alias GoChampsApi.Tournaments
  alias GoChampsApi.Teams

  def init(default), do: default

  def call(conn, :team) do
    {:ok, team} = Map.fetch(conn.params, "team")
    {:ok, tournament_id} = Map.fetch(team, "tournament_id")

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
    {:ok, team_id} = Map.fetch(conn.params, "id")

    organization = Teams.get_team_organization!(team_id)
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
