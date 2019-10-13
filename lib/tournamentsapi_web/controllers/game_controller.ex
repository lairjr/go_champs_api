defmodule TournamentsApiWeb.GameController do
  use TournamentsApiWeb, :controller

  alias TournamentsApi.Games
  alias TournamentsApi.Games.Game

  action_fallback TournamentsApiWeb.FallbackController

  def create(conn, %{"game" => game_params}) do
    with {:ok, %Game{} = created_game} <- Games.create_game(game_params) do
      game = Games.get_game!(created_game.id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.game_path(conn, :show, game))
      |> render("show.json", game: game)
    end
  end

  def show(conn, %{"id" => id}) do
    game = Games.get_game!(id)
    render(conn, "show.json", game: game)
  end

  def update(conn, %{"id" => id, "game" => game_params}) do
    game = Games.get_game!(id)

    with {:ok, %Game{} = game} <- Games.update_game(game, game_params) do
      render(conn, "show.json", game: game)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = Games.get_game!(id)

    with {:ok, %Game{}} <- Games.delete_game(game) do
      send_resp(conn, :no_content, "")
    end
  end
end
