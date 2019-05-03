defmodule TournamentsApiWeb.GameView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.GameView
  alias TournamentsApiWeb.TeamView

  def render("index.json", %{games: games}) do
    %{data: render_many(games, GameView, "game.json")}
  end

  def render("show.json", %{game: game}) do
    %{
      data: %{
        id: game.id,
        home_score: game.home_score,
        home_team: render_one(game.home_team, TeamView, "team.json"),
        home_team_name: game.home_team_name,
        away_score: game.away_score,
        away_team: render_one(game.away_team, TeamView, "team.json"),
        away_team_name: game.away_team_name,
        location: game.location,
        datetime: game.datetime
      }
    }
  end

  def render("game.json", %{game: game}) do
    %{
      id: game.id,
      home_score: game.home_score,
      home_team_name: game.home_team_name,
      away_score: game.away_score,
      away_team_name: game.away_team_name,
      location: game.location,
      datetime: game.datetime
    }
  end
end
