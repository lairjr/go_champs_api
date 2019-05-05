defmodule TournamentsApiWeb.TournamentView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.TournamentView

  def render("index.json", %{tournaments: tournaments}) do
    %{data: render_many(tournaments, TournamentView, "tournament.json")}
  end

  def render("show.json", %{tournament: tournament}) do
    %{data: render_one(tournament, TournamentView, "tournament.json")}
  end

  def render("tournament.json", %{tournament: tournament}) do
    %{
      id: tournament.id,
      name: tournament.name,
      link: tournament.link,
      team_stats_structure: tournament.team_stats_structure
    }
  end
end
