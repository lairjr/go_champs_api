defmodule TournamentsApiWeb.PhaseStandingsView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.PhaseStandingsView

  def render("index.json", %{phase_standings: phase_standings}) do
    %{data: render_many(phase_standings, PhaseStandingsView, "phase_standings.json")}
  end

  def render("show.json", %{phase_standings: phase_standings}) do
    %{data: render_one(phase_standings, PhaseStandingsView, "phase_standings.json")}
  end

  def render("phase_standings.json", %{phase_standings: phase_standings}) do
    %{
      id: phase_standings.id,
      title: phase_standings.title,
      standings: render_many(phase_standings.standings, PhaseStandingsView, "team_standings.json")
    }
  end

  def render("team_standings.json", %{phase_standings: team_standings}) do
    %{
      id: team_standings.id,
      team_id: team_standings.team_id,
      stats: team_standings.stats
    }
  end
end
