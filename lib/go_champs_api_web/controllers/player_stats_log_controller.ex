defmodule GoChampsApiWeb.PlayerStatsLogController do
  use GoChampsApiWeb, :controller

  alias GoChampsApi.PlayerStatsLogs
  alias GoChampsApi.PlayerStatsLogs.PlayerStatsLog

  action_fallback GoChampsApiWeb.FallbackController

  plug GoChampsApiWeb.Plugs.AuthorizedPlayerStatsLog, :id when action in [:delete, :update]
  plug GoChampsApiWeb.Plugs.AuthorizedPlayerStatsLog, :player_stats_log when action in [:create]

  def index(conn, _params) do
    player_stats_log = PlayerStatsLogs.list_player_stats_log()
    render(conn, "index.json", player_stats_log: player_stats_log)
  end

  def create(conn, %{"player_stats_log" => player_stats_log_params}) do
    with {:ok, %PlayerStatsLog{} = player_stats_log} <-
           PlayerStatsLogs.create_player_stats_log(player_stats_log_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.v1_player_stats_log_path(conn, :show, player_stats_log)
      )
      |> render("show.json", player_stats_log: player_stats_log)
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

  def delete(conn, %{"id" => id}) do
    player_stats_log = PlayerStatsLogs.get_player_stats_log!(id)

    with {:ok, %PlayerStatsLog{}} <- PlayerStatsLogs.delete_player_stats_log(player_stats_log) do
      send_resp(conn, :no_content, "")
    end
  end
end
