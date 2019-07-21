defmodule TournamentsApiWeb.TournamentGameView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.TournamentGameView

  def render("index.json", %{tournament_games: tournament_games}) do
    %{data: render_many(tournament_games, TournamentGameView, "tournament_game.json")}
  end

  def render("show.json", %{tournament_game: tournament_game}) do
    %{data: render_one(tournament_game, TournamentGameView, "tournament_game.json")}
  end

  def render("tournament_game.json", %{tournament_game: tournament_game}) do
    IO.inspect(tournament_game)
    %{
      id: tournament_game.id,
      away_team: %{
        id: tournament_game.away_team.id,
        name: tournament_game.away_team.name
      },
      away_score: tournament_game.away_score,
      datetime: tournament_game.datetime,
      home_team: %{
        id: tournament_game.home_team.id,
        name: tournament_game.home_team.name
      },
      home_score: tournament_game.home_score,
      location: tournament_game.location
    }
  end
end
