defmodule GoChampsApiWeb.EliminationView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.EliminationView

  def render("index.json", %{eliminations: eliminations}) do
    %{data: render_many(eliminations, EliminationView, "elimination.json")}
  end

  def render("batch_list.json", %{eliminations: eliminations}) do
    eliminations_view =
      eliminations
      |> Map.keys()
      |> Enum.reduce(%{}, fn elimination_id, acc_eliminations ->
        Map.put(
          acc_eliminations,
          elimination_id,
          render_one(Map.get(eliminations, elimination_id), EliminationView, "elimination.json")
        )
      end)

    %{data: eliminations_view}
  end

  def render("show.json", %{elimination: elimination}) do
    %{data: render_one(elimination, EliminationView, "elimination.json")}
  end

  def render("elimination.json", %{elimination: elimination}) do
    %{
      id: elimination.id,
      info: elimination.info,
      order: elimination.order,
      title: elimination.title,
      team_stats: render_many(elimination.team_stats, EliminationView, "team_stats.json")
    }
  end

  def render("team_stats.json", %{elimination: team_stats}) do
    %{
      id: team_stats.id,
      placeholder: team_stats.placeholder,
      team_id: team_stats.team_id,
      stats: team_stats.stats
    }
  end
end
