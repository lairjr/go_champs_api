defmodule TournamentsApiWeb.PhaseView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.PhaseRoundView
  alias TournamentsApiWeb.PhaseStandingsView
  alias TournamentsApiWeb.PhaseView
  alias TournamentsApiWeb.TournamentStatView

  def render("index.json", %{phases: phases}) do
    %{data: render_many(phases, PhaseView, "phase.json")}
  end

  def render("show.json", %{phase: phase}) do
    %{
      data: %{
        id: phase.id,
        order: phase.order,
        rounds: render_many(phase.rounds, PhaseRoundView, "phase_round.json"),
        standings: render_many(phase.standings, PhaseStandingsView, "phase_standings.json"),
        stats: render_many(phase.stats, TournamentStatView, "tournament_stat.json"),
        title: phase.title,
        type: phase.type
      }
    }
  end

  def render("phase.json", %{phase: phase}) do
    %{
      id: phase.id,
      order: phase.order,
      title: phase.title,
      type: phase.type
    }
  end
end
