defmodule TournamentsApiWeb.TournamentStatView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.TournamentStatView

  def render("index.json", %{tournament_stats: tournament_stats}) do
    %{data: render_many(tournament_stats, TournamentStatView, "tournament_stat.json")}
  end

  def render("show.json", %{tournament_stat: tournament_stat}) do
    %{data: render_one(tournament_stat, TournamentStatView, "tournament_stat.json")}
  end

  def render("tournament_stat.json", %{tournament_stat: tournament_stat}) do
    %{id: tournament_stat.id, title: tournament_stat.title}
  end
end
