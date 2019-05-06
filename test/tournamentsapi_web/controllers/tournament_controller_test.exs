defmodule TournamentsApiWeb.TournamentControllerTest do
  use TournamentsApiWeb.ConnCase

  alias TournamentsApi.Tournaments
  alias TournamentsApi.Tournaments.Tournament

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{}

  def fixture(:tournament) do
    {:ok, tournament} = Tournaments.create_tournament(@create_attrs)
    tournament
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tournaments", %{conn: conn} do
      conn = get(conn, Routes.tournament_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tournament" do
    test "renders tournament when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tournament_path(conn, :create), tournament: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tournament_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tournament_path(conn, :create), tournament: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tournament" do
    setup [:create_tournament]

    test "renders tournament when data is valid", %{
      conn: conn,
      tournament: %Tournament{id: id} = tournament
    } do
      conn =
        put(conn, Routes.tournament_path(conn, :update, tournament), tournament: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.tournament_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tournament: tournament} do
      conn =
        put(conn, Routes.tournament_path(conn, :update, tournament), tournament: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tournament" do
    setup [:create_tournament]

    test "deletes chosen tournament", %{conn: conn, tournament: tournament} do
      conn = delete(conn, Routes.tournament_path(conn, :delete, tournament))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.tournament_path(conn, :show, tournament))
      end
    end
  end

  defp create_tournament(_) do
    tournament = fixture(:tournament)
    {:ok, tournament: tournament}
  end
end
