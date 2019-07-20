defmodule TournamentsApiWeb.TournamentTeamView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.TournamentTeamView
  alias TournamentsApiWeb.TournamentTeamStatView

  def render("index.json", %{tournament_teams: tournament_teams}) do
    %{data: render_many(tournament_teams, TournamentTeamView, "tournament_team.json")}
  end

  def render("show.json", %{tournament_team: tournament_team}) do
    %{data: render_one(tournament_team, TournamentTeamView, "tournament_team.json")}
  end

  def render("tournament_team.json", %{tournament_team: tournament_team}) do
    %{id: tournament_team.id, name: tournament_team.name, stats: render_many(tournament_team.stats, TournamentTeamStatView, "tournament_stat.json")}
  end
end
