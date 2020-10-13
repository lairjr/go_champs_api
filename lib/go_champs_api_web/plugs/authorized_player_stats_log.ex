defmodule GoChampsApiWeb.Plugs.AuthorizedPlayerStatsLog do
  import Phoenix.Controller
  import Plug.Conn

  alias GoChampsApi.Tournaments
  alias GoChampsApi.PlayerStatsLogs

  def init(default), do: default

  def call(conn, :create_player_stats_logs) do
    {:ok, player_stats_logs} = Map.fetch(conn.params, "player_stats_logs")

    tournament_ids =
      player_stats_logs
      |> Enum.reduce(MapSet.new(), fn player_stats_log, map ->
        {:ok, tournament_id} = Map.fetch(player_stats_log, "tournament_id")
        MapSet.put(map, tournament_id)
      end)

    case MapSet.size(tournament_ids) do
      1 ->
        [tournament_id] = MapSet.to_list(tournament_ids)
        organization = Tournaments.get_tournament_organization!(tournament_id)
        current_user = Guardian.Plug.current_resource(conn)

        if Enum.any?(organization.members, fn member ->
             member.username == current_user.username
           end) do
          conn
        else
          conn
          |> put_status(:forbidden)
          |> text("Forbidden")
          |> halt
        end

      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> text("Only allow to create for one tournament")
        |> halt
    end
  end

  def call(conn, :update_player_stats_logs) do
    {:ok, player_stats_logs} = Map.fetch(conn.params, "player_stats_logs")

    case PlayerStatsLogs.get_player_stats_logs_tournament_id(player_stats_logs) do
      {:ok, tournament_id} ->
        organization = Tournaments.get_tournament_organization!(tournament_id)
        current_user = Guardian.Plug.current_resource(conn)

        if Enum.any?(organization.members, fn member ->
             member.username == current_user.username
           end) do
          conn
        else
          conn
          |> put_status(:forbidden)
          |> text("Forbidden")
          |> halt
        end

      {:error, message} ->
        conn
        |> put_status(:unprocessable_entity)
        |> text(message)
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
