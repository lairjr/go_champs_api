defmodule GoChampsApiWeb.PlayerStatsLogView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.PlayerStatsLogView

  def render("index.json", %{player_stats_log: player_stats_log}) do
    %{data: render_many(player_stats_log, PlayerStatsLogView, "player_stats_log.json")}
  end

  def render("show.json", %{player_stats_log: player_stats_log}) do
    %{data: render_one(player_stats_log, PlayerStatsLogView, "player_stats_log.json")}
  end

  def render("player_stats_log.json", %{player_stats_log: player_stats_log}) do
    %{
      id: player_stats_log.id,
      stats: player_stats_log.stats,
      game_id: player_stats_log.game_id,
      phase_id: player_stats_log.phase_id,
      player_id: player_stats_log.player_id,
      team_id: player_stats_log.team_id,
      tournament_id: player_stats_log.tournament_id
    }
  end

  def render("batch_list.json", %{player_stats_logs: player_stats_logs}) do
    player_stats_logs_view =
      player_stats_logs
      |> Map.keys()
      |> Enum.reduce(%{}, fn player_stats_log_id, acc_player_stats_logs ->
        Map.put(
          acc_player_stats_logs,
          player_stats_log_id,
          render_one(
            Map.get(player_stats_logs, player_stats_log_id),
            PlayerStatsLogView,
            "player_stats_log.json"
          )
        )
      end)

    %{data: player_stats_logs_view}
  end
end
