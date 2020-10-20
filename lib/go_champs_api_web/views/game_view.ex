defmodule GoChampsApiWeb.GameView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.GameView
  alias GoChampsApiWeb.TeamView

  def render("index.json", %{games: games}) do
    %{data: render_many(games, GameView, "game.json")}
  end

  def render("show.json", %{game: game}) do
    %{data: render_one(game, GameView, "game.json")}
  end

  def render("game.json", %{game: game}) do
    %{
      id: game.id,
      away_team: render_one(game.away_team, TeamView, "team.json"),
      away_score: game.away_score,
      datetime: game.datetime,
      phase_id: game.phase_id,
      home_team: render_one(game.home_team, TeamView, "team.json"),
      home_score: game.home_score,
      info: game.info,
      location: game.location
    }
  end
end
