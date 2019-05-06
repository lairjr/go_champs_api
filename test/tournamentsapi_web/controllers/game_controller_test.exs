defmodule TournamentsApiWeb.GameControllerTest do
  use TournamentsApiWeb.ConnCase

  alias TournamentsApi.Games
  alias TournamentsApi.Games.Game

  @create_attrs %{
    away_score: 42,
    away_team_name: "some away team name",
    datetime: "2010-04-17T14:00:00Z",
    home_score: 42,
    home_team_name: "some home team name",
    location: "some location"
  }
  @update_attrs %{
    away_score: 43,
    away_team_name: "some updated away team name",
    datetime: "2011-05-18T15:01:01Z",
    home_score: 43,
    home_team_name: "some updated home team name",
    location: "some updated location"
  }
  @invalid_attrs %{away_score: nil, datetime: nil, home_score: nil, location: nil}

  def fixture(:game) do
    {:ok, game} = Games.create_game(@create_attrs)
    game
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all games", %{conn: conn} do
      conn = get(conn, Routes.game_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create game" do
    test "renders game when data is valid", %{conn: conn} do
      conn = post(conn, Routes.game_path(conn, :create), game: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.game_path(conn, :show, id))

      assert %{
               "id" => id,
               "away_score" => 42,
               "datetime" => "2010-04-17T14:00:00Z",
               "home_score" => 42,
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
               "id" => id,
               "away_score" => 43,
               "datetime" => "2011-05-18T15:01:01Z",
               "home_score" => 43,
               "location" => "some updated location"
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
