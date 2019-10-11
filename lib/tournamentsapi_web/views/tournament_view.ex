defmodule TournamentsApiWeb.TournamentView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.OrganizationView
  alias TournamentsApiWeb.TournamentView
  alias TournamentsApiWeb.TournamentPhaseView
  alias TournamentsApiWeb.TeamView

  def render("index.json", %{tournaments: tournaments}) do
    %{data: render_many(tournaments, TournamentView, "tournament.json")}
  end

  def render("show.json", %{tournament: tournament}) do
    %{
      data: %{
        id: tournament.id,
        name: tournament.name,
        slug: tournament.slug,
        organization: render_one(tournament.organization, OrganizationView, "organization.json"),
        phases: render_many(tournament.phases, TournamentPhaseView, "tournament_phase.json"),
        teams: render_many(tournament.teams, TeamView, "team.json")
      }
    }
  end

  def render("tournament.json", %{tournament: tournament}) do
    %{
      id: tournament.id,
      name: tournament.name,
      slug: tournament.slug
    }
  end
end
