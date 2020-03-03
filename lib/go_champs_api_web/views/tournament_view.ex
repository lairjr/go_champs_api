defmodule GoChampsApiWeb.TournamentView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.OrganizationView
  alias GoChampsApiWeb.TournamentView
  alias GoChampsApiWeb.PhaseView
  alias GoChampsApiWeb.TeamView

  def render("index.json", %{tournaments: tournaments}) do
    %{data: render_many(tournaments, TournamentView, "tournament.json")}
  end

  def render("show.json", %{tournament: tournament}) do
    %{
      data: %{
        id: tournament.id,
        name: tournament.name,
        slug: tournament.slug,
        facebook: tournament.facebook,
        instagram: tournament.instagram,
        site_url: tournament.site_url,
        organization: render_one(tournament.organization, OrganizationView, "organization.json"),
        phases: render_many(tournament.phases, PhaseView, "phase.json"),
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
