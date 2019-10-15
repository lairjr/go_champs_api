defmodule TournamentsApiWeb.PhaseView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.DrawView
  alias TournamentsApiWeb.EliminationView
  alias TournamentsApiWeb.PhaseView

  def render("index.json", %{phases: phases}) do
    %{data: render_many(phases, PhaseView, "phase.json")}
  end

  def render("show.json", %{phase: phase}) do
    %{
      data: %{
        id: phase.id,
        order: phase.order,
        draws: render_many(phase.draws, DrawView, "draw.json"),
        eliminations: render_many(phase.eliminations, EliminationView, "elimination.json"),
        elimination_stats:
          render_many(phase.elimination_stats, PhaseView, "elimination_stats.json"),
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

  def render("elimination_stats.json", %{phase: elimination_stats}) do
    %{
      id: elimination_stats.id,
      title: elimination_stats.title
    }
  end
end
