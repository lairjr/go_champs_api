defmodule GoChampsApiWeb.Plugs.AuthorizedFixedPlayerStatsTable do
  import Phoenix.Controller
  import Plug.Conn

  alias GoChampsApi.Tournaments
  alias GoChampsApi.FixedPlayerStatsTables

  def init(default), do: default

  def call(conn, :fixed_player_stats_table) do
    {:ok, fixed_player_stats_table} = Map.fetch(conn.params, "fixed_player_stats_table")
    {:ok, tournament_id} = Map.fetch(fixed_player_stats_table, "tournament_id")

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
    {:ok, fixed_player_stats_table_id} = Map.fetch(conn.params, "id")

    organization =
      FixedPlayerStatsTables.get_fixed_player_stats_table_organization!(
        fixed_player_stats_table_id
      )

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
