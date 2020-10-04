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
    %{id: player_stats_log.id, stats: player_stats_log.stats}
  end
end
