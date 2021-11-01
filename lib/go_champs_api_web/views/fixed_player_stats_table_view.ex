defmodule GoChampsApiWeb.FixedPlayerStatsTableView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.FixedPlayerStatsTableView

  def render("index.json", %{fixed_player_stats_table: fixed_player_stats_table}) do
    %{
      data:
        render_many(
          fixed_player_stats_table,
          FixedPlayerStatsTableView,
          "fixed_player_stats_table.json"
        )
    }
  end

  def render("show.json", %{fixed_player_stats_table: fixed_player_stats_table}) do
    %{
      data:
        render_one(
          fixed_player_stats_table,
          FixedPlayerStatsTableView,
          "fixed_player_stats_table.json"
        )
    }
  end

  def render("fixed_player_stats_table.json", %{
        fixed_player_stats_table: fixed_player_stats_table
      }) do
    %{
      id: fixed_player_stats_table.id,
      player_stats:
        render_many(
          fixed_player_stats_table.player_stats,
          FixedPlayerStatsTableView,
          "player_stats.json"
        ),
      stat_id: fixed_player_stats_table.stat_id
    }
  end

  def render("player_stats.json", %{fixed_player_stats_table: player_stats}) do
    %{
      id: player_stats.id,
      player_id: player_stats.player_id,
      value: player_stats.value
    }
  end
end
