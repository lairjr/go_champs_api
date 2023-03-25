defmodule GoChampsApiWeb.AggregatedTeamStatsByPhaseView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.AggregatedTeamStatsByPhaseView

  def render("index.json", %{aggregated_team_stats_by_phase: aggregated_team_stats_by_phase}) do
    %{
      data:
        render_many(
          aggregated_team_stats_by_phase,
          AggregatedTeamStatsByPhaseView,
          "aggregated_team_stats_by_phase.json"
        )
    }
  end

  def render("show.json", %{aggregated_team_stats_by_phase: aggregated_team_stats_by_phase}) do
    %{
      data:
        render_one(
          aggregated_team_stats_by_phase,
          AggregatedTeamStatsByPhaseView,
          "aggregated_team_stats_by_phase.json"
        )
    }
  end

  def render("aggregated_team_stats_by_phase.json", %{
        aggregated_team_stats_by_phase: aggregated_team_stats_by_phase
      }) do
    %{id: aggregated_team_stats_by_phase.id, stats: aggregated_team_stats_by_phase.stats}
  end
end
