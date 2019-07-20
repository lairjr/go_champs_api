defmodule TournamentsApiWeb.TournamentView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.OrganizationView
  alias TournamentsApiWeb.TournamentView
  alias TournamentsApiWeb.TournamentTeamView
  alias TournamentsApiWeb.TournamentStatView
  alias TournamentsApiWeb.TournamentGroupView

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
        groups: render_many(tournament.groups, TournamentGroupView, "tournament_group.json"),
        teams: render_many(tournament.teams, TournamentTeamView, "tournament_team.json"),
        stats: render_many(tournament.stats, TournamentStatView, "tournament_stat.json")
      }
    }
  end

  def render("tournament.json", %{tournament: tournament}) do
    %{
      id: tournament.id,
      name: tournament.name,
      slug: tournament.slug,
    }
  end
end
