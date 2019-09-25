defmodule TournamentsApiWeb.PhaseRoundView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.PhaseRoundView

  def render("index.json", %{phase_rounds: phase_rounds}) do
    %{data: render_many(phase_rounds, PhaseRoundView, "phase_round.json")}
  end

  def render("show.json", %{phase_round: phase_round}) do
    %{data: render_one(phase_round, PhaseRoundView, "phase_round.json")}
  end

  def render("phase_round.json", %{phase_round: phase_round}) do
    %{
      id: phase_round.id,
      matches: render_many(phase_round.matches, PhaseRoundView, "match.json"),
      order: phase_round.order,
      title: phase_round.title
    }
  end

  def render("match.json", %{phase_round: match}) do
    %{
      id: match.id,
      first_team_id: match.first_team_id,
      first_team_parent_id: match.first_team_parent_id,
      first_team_placeholder: match.first_team_placeholder,
      first_team_score: match.first_team_score,
      second_team_id: match.second_team_id,
      second_team_parent_id: match.second_team_parent_id,
      second_team_placeholder: match.second_team_placeholder,
      second_team_score: match.second_team_score
    }
  end
end
