defmodule TournamentsApiWeb.TournamentGameControllerTest do
  use TournamentsApiWeb.ConnCase

  alias TournamentsApi.Tournaments
  alias TournamentsApi.Tournaments.TournamentGame

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:tournament_game) do
    {:ok, tournament_game} = Tournaments.create_tournament_game(@create_attrs)
    tournament_game
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tournament_games", %{conn: conn} do
      conn = get(conn, Routes.tournament_game_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tournament_game" do
    test "renders tournament_game when data is valid", %{conn: conn} do
      conn =
        post(conn, Routes.tournament_game_path(conn, :create), tournament_game: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tournament_game_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.tournament_game_path(conn, :create), tournament_game: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tournament_game" do
    setup [:create_tournament_game]

    test "renders tournament_game when data is valid", %{
      conn: conn,
      tournament_game: %TournamentGame{id: id} = tournament_game
    } do
      conn =
        put(conn, Routes.tournament_game_path(conn, :update, tournament_game),
          tournament_game: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.tournament_game_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tournament_game: tournament_game} do
      conn =
        put(conn, Routes.tournament_game_path(conn, :update, tournament_game),
          tournament_game: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tournament_game" do
    setup [:create_tournament_game]

    test "deletes chosen tournament_game", %{conn: conn, tournament_game: tournament_game} do
      conn = delete(conn, Routes.tournament_game_path(conn, :delete, tournament_game))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.tournament_game_path(conn, :show, tournament_game))
      end
    end
  end

  defp create_tournament_game(_) do
    tournament_game = fixture(:tournament_game)
    {:ok, tournament_game: tournament_game}
  end
end
