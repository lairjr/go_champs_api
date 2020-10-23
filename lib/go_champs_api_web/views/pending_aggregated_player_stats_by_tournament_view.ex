defmodule GoChampsApiWeb.PendingAggregatedPlayerStatsByTournamentView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.PendingAggregatedPlayerStatsByTournamentView

  def render("index.json", %{
        pending_aggregated_player_stats_by_tournament:
          pending_aggregated_player_stats_by_tournament
      }) do
    %{
      data:
        render_many(
          pending_aggregated_player_stats_by_tournament,
          PendingAggregatedPlayerStatsByTournamentView,
          "pending_aggregated_player_stats_by_tournament.json"
        )
    }
  end

  def render("show.json", %{
        pending_aggregated_player_stats_by_tournament:
          pending_aggregated_player_stats_by_tournament
      }) do
    %{
      data:
        render_one(
          pending_aggregated_player_stats_by_tournament,
          PendingAggregatedPlayerStatsByTournamentView,
          "pending_aggregated_player_stats_by_tournament.json"
        )
    }
  end

  def render("pending_aggregated_player_stats_by_tournament.json", %{
        pending_aggregated_player_stats_by_tournament:
          pending_aggregated_player_stats_by_tournament
      }) do
    %{
      id: pending_aggregated_player_stats_by_tournament.id,
      tournament_id: pending_aggregated_player_stats_by_tournament.tournament_id
    }
  end
end
