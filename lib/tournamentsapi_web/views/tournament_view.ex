defmodule TournamentsApiWeb.TournamentView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.OrganizationView
  alias TournamentsApiWeb.TournamentView
  alias TournamentsApiWeb.TournamentGroupView
  alias TournamentsApiWeb.TournamentPhaseView
  alias TournamentsApiWeb.TournamentStatView
  alias TournamentsApiWeb.TournamentTeamView

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
        phases: render_many(tournament.phases, TournamentView, "tournament_phase.json"),
        teams: render_many(tournament.teams, TournamentTeamView, "tournament_team.json")
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

  def render("tournament_phase.json", %{tournament_phase: tournament_phase}) do
    %{
      id: tournament_phase.id,
      order: tournament_phase.order,
      title: tournament_phase.title,
      type: tournament_phase.type
    }
  end
end
