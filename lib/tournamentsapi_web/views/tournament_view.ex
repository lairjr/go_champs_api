defmodule TournamentsApiWeb.TournamentView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.TournamentView
  alias TournamentsApiWeb.TournamentTeamView
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
        team_stats_structure: tournament.team_stats_structure,
        groups: render_many(tournament.groups, TournamentGroupView, "tournament_group.json"),
        teams: render_many(tournament.teams, TournamentTeamView, "tournament_team.json")
      }
    }
  end

  def render("tournament.json", %{tournament: tournament}) do
    %{
      id: tournament.id,
      name: tournament.name,
      slug: tournament.slug,
      team_stats_structure: tournament.team_stats_structure
    }
  end
end
