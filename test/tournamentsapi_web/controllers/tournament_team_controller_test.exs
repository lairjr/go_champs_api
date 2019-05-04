defmodule TournamentsApiWeb.TournamentTeamControllerTest do
  use TournamentsApiWeb.ConnCase

  alias TournamentsApi.Tournaments
  alias TournamentsApi.Tournaments.TournamentTeam

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:tournament_team) do
    {:ok, tournament_team} = Tournaments.create_tournament_team(@create_attrs)
    tournament_team
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tournament_teams", %{conn: conn} do
      conn = get(conn, Routes.tournament_team_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tournament_team" do
    test "renders tournament_team when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tournament_team_path(conn, :create), tournament_team: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tournament_team_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tournament_team_path(conn, :create), tournament_team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tournament_team" do
    setup [:create_tournament_team]

    test "renders tournament_team when data is valid", %{conn: conn, tournament_team: %TournamentTeam{id: id} = tournament_team} do
      conn = put(conn, Routes.tournament_team_path(conn, :update, tournament_team), tournament_team: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.tournament_team_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tournament_team: tournament_team} do
      conn = put(conn, Routes.tournament_team_path(conn, :update, tournament_team), tournament_team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tournament_team" do
    setup [:create_tournament_team]

    test "deletes chosen tournament_team", %{conn: conn, tournament_team: tournament_team} do
      conn = delete(conn, Routes.tournament_team_path(conn, :delete, tournament_team))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.tournament_team_path(conn, :show, tournament_team))
      end
    end
  end

  defp create_tournament_team(_) do
    tournament_team = fixture(:tournament_team)
    {:ok, tournament_team: tournament_team}
  end
end
