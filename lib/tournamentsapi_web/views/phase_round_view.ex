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
    %{id: phase_round.id, title: phase_round.title}
  end
end
