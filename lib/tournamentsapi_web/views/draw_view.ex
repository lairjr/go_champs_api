defmodule TournamentsApiWeb.DrawView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.DrawView

  def render("index.json", %{draws: draws}) do
    %{data: render_many(draws, DrawView, "draw.json")}
  end

  def render("show.json", %{draw: draw}) do
    %{data: render_one(draw, DrawView, "draw.json")}
  end

  def render("draw.json", %{draw: draw}) do
    %{
      id: draw.id,
      matches: render_many(draw.matches, DrawView, "match.json"),
      order: draw.order,
      title: draw.title
    }
  end

  def render("match.json", %{draw: match}) do
    %{
      id: match.id,
      first_team_id: match.first_team_id,
      first_team_parent_id: match.first_team_parent_id,
      first_team_placeholder: match.first_team_placeholder,
      first_team_score: match.first_team_score,
      second_team_id: match.second_team_id,
      second_team_parent_id: match.second_team_parent_id,
      second_team_placeholder: match.second_team_placeholder,
      second_team_score: match.second_team_score
    }
  end
end
