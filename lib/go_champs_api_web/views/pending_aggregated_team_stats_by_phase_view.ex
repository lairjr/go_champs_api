defmodule GoChampsApiWeb.PendingAggregatedTeamStatsByPhaseView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.PendingAggregatedTeamStatsByPhaseView

  def render("index.json", %{
        pending_aggregated_team_stats_by_phase: pending_aggregated_team_stats_by_phase
      }) do
    %{
      data:
        render_many(
          pending_aggregated_team_stats_by_phase,
          PendingAggregatedTeamStatsByPhaseView,
          "pending_aggregated_team_stats_by_phase.json"
        )
    }
  end

  def render("show.json", %{
        pending_aggregated_team_stats_by_phase: pending_aggregated_team_stats_by_phase
      }) do
    %{
      data:
        render_one(
          pending_aggregated_team_stats_by_phase,
          PendingAggregatedTeamStatsByPhaseView,
          "pending_aggregated_team_stats_by_phase.json"
        )
    }
  end

  def render("pending_aggregated_team_stats_by_phase.json", %{
        pending_aggregated_team_stats_by_phase: pending_aggregated_team_stats_by_phase
      }) do
    %{
      id: pending_aggregated_team_stats_by_phase.id,
      tournament_id: pending_aggregated_team_stats_by_phase.tournament_id
    }
  end
end
