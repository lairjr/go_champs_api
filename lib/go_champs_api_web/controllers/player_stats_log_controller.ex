defmodule GoChampsApiWeb.PlayerStatsLogController do
  use GoChampsApiWeb, :controller

  alias GoChampsApi.PlayerStatsLogs
  alias GoChampsApi.PlayerStatsLogs.PlayerStatsLog

  action_fallback GoChampsApiWeb.FallbackController

  plug GoChampsApiWeb.Plugs.AuthorizedPlayerStatsLog, :id when action in [:delete, :update]

  plug GoChampsApiWeb.Plugs.AuthorizedPlayerStatsLog,
       :update_player_stats_logs when action in [:batch_update]

  plug GoChampsApiWeb.Plugs.AuthorizedPlayerStatsLog,
       :create_player_stats_logs when action in [:create]

  def index(conn, _params) do
    player_stats_log = PlayerStatsLogs.list_player_stats_log()
    render(conn, "index.json", player_stats_log: player_stats_log)
  end

  def create(conn, %{"player_stats_logs" => player_stats_logs_params}) do
    case PlayerStatsLogs.create_player_stats_logs(player_stats_logs_params) do
      {:ok, player_stats_logs} ->
        conn
        |> put_status(:created)
        |> render("batch_list.json", player_stats_logs: player_stats_logs)

      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(GoChampsApiWeb.ErrorView)
        |> render(:"422")
    end
  end

  def show(conn, %{"id" => id}) do
    player_stats_log = PlayerStatsLogs.get_player_stats_log!(id)
    render(conn, "show.json", player_stats_log: player_stats_log)
  end

  def update(conn, %{"id" => id, "player_stats_log" => player_stats_log_params}) do
    player_stats_log = PlayerStatsLogs.get_player_stats_log!(id)

    with {:ok, %PlayerStatsLog{} = player_stats_log} <-
           PlayerStatsLogs.update_player_stats_log(player_stats_log, player_stats_log_params) do
      render(conn, "show.json", player_stats_log: player_stats_log)
    end
  end

  def batch_update(conn, %{"player_stats_logs" => player_stats_logs_param}) do
    with {:ok, player_stats_logs} <-
           PlayerStatsLogs.update_player_stats_logs(player_stats_logs_param) do
      render(conn, "batch_list.json", player_stats_logs: player_stats_logs)
    end
  end

  def delete(conn, %{"id" => id}) do
    player_stats_log = PlayerStatsLogs.get_player_stats_log!(id)

    with {:ok, %PlayerStatsLog{}} <- PlayerStatsLogs.delete_player_stats_log(player_stats_log) do
      send_resp(conn, :no_content, "")
    end
  end
end
