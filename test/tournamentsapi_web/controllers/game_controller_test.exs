defmodule TournamentsApiWeb.GameControllerTest do
  use TournamentsApiWeb.ConnCase

  alias TournamentsApi.Helpers.PhaseHelpers
  alias TournamentsApi.Games
  alias TournamentsApi.Games.Game

  @create_attrs %{
    away_score: 10,
    datetime: "2019-08-25T16:59:27.116Z",
    home_score: 20,
    location: "some location"
  }
  @update_attrs %{
    away_score: 20,
    datetime: "2019-08-25T16:59:27.116Z",
    home_score: 30,
    location: "another location"
  }
  @invalid_attrs %{phase_id: nil}

  def fixture(:game) do
    {:ok, game} =
      @create_attrs
      |> PhaseHelpers.map_phase_id()
      |> Games.create_game()

    game
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create game" do
    test "renders game when data is valid", %{conn: conn} do
      create_attrs = PhaseHelpers.map_phase_id(@create_attrs)
      conn = post(conn, Routes.game_path(conn, :create), game: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.game_path(conn, :show, id))

      assert %{
               "away_score" => 10,
               "away_team" => nil,
               "datetime" => "2019-08-25T16:59:27Z",
               "home_score" => 20,
               "home_team" => nil,
               "id" => id,
               "location" => "some location"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.game_path(conn, :create), game: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update game" do
    setup [:create_game]

    test "renders game when data is valid", %{conn: conn, game: %Game{id: id} = game} do
      conn = put(conn, Routes.game_path(conn, :update, game), game: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.game_path(conn, :show, id))

      assert %{
               "away_score" => 20,
               "away_team" => nil,
               "datetime" => "2019-08-25T16:59:27Z",
               "home_score" => 30,
               "home_team" => nil,
               "id" => id,
               "location" => "another location"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, game: game} do
      conn = put(conn, Routes.game_path(conn, :update, game), game: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete game" do
    setup [:create_game]

    test "deletes chosen game", %{conn: conn, game: game} do
      conn = delete(conn, Routes.game_path(conn, :delete, game))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.game_path(conn, :show, game))
      end
    end
  end

  defp create_game(_) do
    game = fixture(:game)
    {:ok, game: game}
  end
end
