defmodule GoChampsApiWeb.DrawView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.DrawView

  def render("index.json", %{draws: draws}) do
    %{data: render_many(draws, DrawView, "draw.json")}
  end

  def render("batch_list.json", %{draws: draws}) do
    draws_view =
      draws
      |> Map.keys()
      |> Enum.reduce(%{}, fn draw_id, acc_draws ->
        Map.put(
          acc_draws,
          draw_id,
          render_one(Map.get(draws, draw_id), DrawView, "draw.json")
        )
      end)

    %{data: draws_view}
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
      info: match.info,
      name: match.name,
      second_team_id: match.second_team_id,
      second_team_parent_id: match.second_team_parent_id,
      second_team_placeholder: match.second_team_placeholder,
      second_team_score: match.second_team_score
    }
  end
end
