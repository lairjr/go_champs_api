defmodule TournamentsApiWeb.TournamentGameController do
  use TournamentsApiWeb, :controller

  alias TournamentsApi.Tournaments
  alias TournamentsApi.Tournaments.TournamentGame

  action_fallback TournamentsApiWeb.FallbackController

  def index(conn, %{"tournament_id" => tournament_id}) do
    tournament_games = Tournaments.list_tournament_games(tournament_id)
    render(conn, "index.json", tournament_games: tournament_games)
  end

  def create(conn, %{
        "tournament_game" => tournament_game_params,
        "tournament_id" => tournament_id
      }) do
    tournament_game_params =
      Map.merge(tournament_game_params, %{"tournament_id" => tournament_id})

    with {:ok, %{tournament_game: created_tournament_game}} <-
           Tournaments.create_tournament_game(tournament_game_params) do
      tournament_game = Tournaments.get_tournament_game!(created_tournament_game.id, tournament_id)
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.tournament_game_path(conn, :show, tournament_id, tournament_game)
      )
      |> render("show.json", tournament_game: tournament_game)
    end
  end

  def show(conn, %{"id" => id, "tournament_id" => tournament_id}) do
    tournament_game = Tournaments.get_tournament_game!(id, tournament_id)
    render(conn, "show.json", tournament_game: tournament_game)
  end

  def update(conn, %{
        "id" => id,
        "tournament_game" => tournament_game_params,
        "tournament_id" => tournament_id
      }) do
    tournament_game = Tournaments.get_tournament_game!(id, tournament_id)

    with {:ok, %TournamentGame{} = tournament_game} <-
           Tournaments.update_tournament_game(tournament_game, tournament_game_params) do
      render(conn, "show.json", tournament_game: tournament_game)
    end
  end

  def delete(conn, %{"id" => id, "tournament_id" => tournament_id}) do
    tournament_game = Tournaments.get_tournament_game!(id, tournament_id)

    with {:ok, %TournamentGame{}} <- Tournaments.delete_tournament_game(tournament_game) do
      send_resp(conn, :no_content, "")
    end
  end
end
