defmodule GoChampsApiWeb.AggregatedPlayerStatsByTournamentView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.AggregatedPlayerStatsByTournamentView

  def render("index.json", %{
        aggregated_player_stats_by_tournament: aggregated_player_stats_by_tournament
      }) do
    %{
      data:
        render_many(
          aggregated_player_stats_by_tournament,
          AggregatedPlayerStatsByTournamentView,
          "aggregated_player_stats_by_tournament.json"
        )
    }
  end

  def render("show.json", %{
        aggregated_player_stats_by_tournament: aggregated_player_stats_by_tournament
      }) do
    %{
      data:
        render_one(
          aggregated_player_stats_by_tournament,
          AggregatedPlayerStatsByTournamentView,
          "aggregated_player_stats_by_tournament.json"
        )
    }
  end

  def render("aggregated_player_stats_by_tournament.json", %{
        aggregated_player_stats_by_tournament: aggregated_player_stats_by_tournament
      }) do
    %{
      id: aggregated_player_stats_by_tournament.id,
      tournament_id: aggregated_player_stats_by_tournament.tournament_id,
      player_id: aggregated_player_stats_by_tournament.player_id,
      stats: aggregated_player_stats_by_tournament.stats
    }
  end
end
