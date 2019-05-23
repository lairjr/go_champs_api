defmodule TournamentsApiWeb.TournamentGameView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.GameView
  alias TournamentsApiWeb.TournamentGameView

  def render("index.json", %{tournament_games: tournament_games}) do
    %{data: render_many(tournament_games, TournamentGameView, "tournament_game.json")}
  end

  def render("show.json", %{tournament_game: tournament_game}) do
    %{data: render_one(tournament_game, TournamentGameView, "tournament_game.json")}
  end

  def render("tournament_game.json", %{tournament_game: tournament_game}) do
    %{id: tournament_game.id,
      game: render_one(tournament_game.game, GameView, "game.json")
    }
  end
end
