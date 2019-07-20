defmodule TournamentsApiWeb.TournamentTeamStatView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.TournamentTeamStatView

  def render("index.json", %{tournament_team_stats: tournament_team_stats}) do
    %{
      data:
        render_many(tournament_team_stats, TournamentTeamStatView, "tournament_team_stat.json")
    }
  end

  def render("show.json", %{tournament_team_stat: tournament_team_stat}) do
    %{data: render_one(tournament_team_stat, TournamentTeamStatView, "tournament_team_stat.json")}
  end

  def render("tournament_team_stat.json", %{tournament_team_stat: tournament_team_stat}) do
    %{id: tournament_team_stat.id, value: tournament_team_stat.value}
  end
end
