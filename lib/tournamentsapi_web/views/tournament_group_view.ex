defmodule TournamentsApiWeb.TournamentGroupView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.TournamentGroupView

  def render("index.json", %{tournament_groups: tournament_groups}) do
    %{data: render_many(tournament_groups, TournamentGroupView, "tournament_group.json")}
  end

  def render("show.json", %{tournament_group: tournament_group}) do
    %{data: render_one(tournament_group, TournamentGroupView, "tournament_group.json")}
  end

  def render("tournament_group.json", %{tournament_group: tournament_group}) do
    %{id: tournament_group.id, name: tournament_group.name}
  end
end
