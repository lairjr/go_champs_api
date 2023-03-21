defmodule GoChampsApiWeb.Plugs.AuthorizedTeamStatsLog do
  import Phoenix.Controller
  import Plug.Conn

  alias GoChampsApi.Tournaments
  alias GoChampsApi.TeamStatsLogs

  def init(default), do: default

  def call(conn, :team_stats_log) do
    {:ok, team_stats_log} = Map.fetch(conn.params, "team_stats_log")
    {:ok, tournament_id} = Map.fetch(team_stats_log, "tournament_id")

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
    {:ok, team_stats_log_id} = Map.fetch(conn.params, "id")

    organization = TeamStatsLogs.get_team_stats_log_organization!(team_stats_log_id)
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
