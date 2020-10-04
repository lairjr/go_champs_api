defmodule GoChampsApiWeb.Plugs.AuthorizedPlayerStatsLog do
  import Phoenix.Controller
  import Plug.Conn

  alias GoChampsApi.Tournaments
  alias GoChampsApi.PlayerStatsLogs

  def init(default), do: default

  def call(conn, :player_stats_log) do
    {:ok, player_stats_log} = Map.fetch(conn.params, "player_stats_log")
    {:ok, tournament_id} = Map.fetch(player_stats_log, "tournament_id")

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
    {:ok, player_stats_log_id} = Map.fetch(conn.params, "id")

    organization = PlayerStatsLogs.get_player_stats_log_organization!(player_stats_log_id)
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
