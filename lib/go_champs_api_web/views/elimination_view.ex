defmodule GoChampsApiWeb.EliminationView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.EliminationView

  def render("index.json", %{eliminations: eliminations}) do
    %{data: render_many(eliminations, EliminationView, "elimination.json")}
  end

  def render("show.json", %{elimination: elimination}) do
    %{data: render_one(elimination, EliminationView, "elimination.json")}
  end

  def render("elimination.json", %{elimination: elimination}) do
    %{
      id: elimination.id,
      title: elimination.title,
      team_stats: render_many(elimination.team_stats, EliminationView, "team_stats.json")
    }
  end

  def render("team_stats.json", %{elimination: team_stats}) do
    %{
      id: team_stats.id,
      team_id: team_stats.team_id,
      stats: team_stats.stats
    }
  end
end
