defmodule GoChampsApiWeb.TournamentView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.OrganizationView
  alias GoChampsApiWeb.TournamentView
  alias GoChampsApiWeb.PhaseView
  alias GoChampsApiWeb.PlayerView
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
        twitter: tournament.twitter,
        organization: render_one(tournament.organization, OrganizationView, "organization.json"),
        phases: render_many(tournament.phases, PhaseView, "phase.json"),
        players: render_many(tournament.players, PlayerView, "player.json"),
        player_stats: render_many(tournament.player_stats, TournamentView, "player_stats.json"),
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

  def render("player_stats.json", %{tournament: player_stats}) do
    %{
      id: player_stats.id,
      title: player_stats.title,
      aggregation_type: player_stats.aggregation_type
    }
  end
end
