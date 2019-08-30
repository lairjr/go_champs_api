defmodule TournamentsApiWeb.TournamentPhaseView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.TournamentGroupView
  alias TournamentsApiWeb.TournamentPhaseView
  alias TournamentsApiWeb.TournamentStatView

  def render("index.json", %{tournament_phases: tournament_phases}) do
    %{data: render_many(tournament_phases, TournamentPhaseView, "tournament_phase.json")}
  end

  def render("show.json", %{tournament_phase: tournament_phase}) do
    %{
      data: %{
        id: tournament_phase.id,
        order: tournament_phase.order,
        title: tournament_phase.title,
        type: tournament_phase.type,
        groups: render_many(tournament_phase.groups, TournamentGroupView, "tournament_group.json"),
        stats: render_many(tournament_phase.stats, TournamentStatView, "tournament_stat.json")
      }
    }
  end

  def render("tournament_phase.json", %{tournament_phase: tournament_phase}) do
    %{
      id: tournament_phase.id,
      order: tournament_phase.order,
      title: tournament_phase.title,
      type: tournament_phase.type
    }
  end
end
