defmodule TournamentsApiWeb.TeamControllerTest do
  use TournamentsApiWeb.ConnCase

  alias TournamentsApi.Organizations
  alias TournamentsApi.Teams
  alias TournamentsApi.Teams.Team
  alias TournamentsApi.Tournaments

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def map_tournament_id(attrs \\ %{}) do
    {:ok, organization} =
      Organizations.create_organization(%{name: "some organization", slug: "some-slug"})

    tournament_attrs = Map.merge(%{name: "some tournament"}, %{organization_id: organization.id})
    {:ok, tournament} = Tournaments.create_tournament(tournament_attrs)

    Map.merge(attrs, %{tournament_id: tournament.id})
  end

  def fixture(:team) do
    {:ok, team} =
      @create_attrs
      |> map_tournament_id()
      |> Teams.create_team()

    team
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create team" do
    test "renders team when data is valid", %{conn: conn} do
      create_attrs = map_tournament_id(@create_attrs)
      conn = post(conn, Routes.team_path(conn, :create), team: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.team_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.team_path(conn, :create), team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team" do
    setup [:create_team]

    test "renders team when data is valid", %{conn: conn, team: %Team{id: id} = team} do
      conn = put(conn, Routes.team_path(conn, :update, team), team: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.team_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, team: team} do
      conn = put(conn, Routes.team_path(conn, :update, team), team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team" do
    setup [:create_team]

    test "deletes chosen team", %{conn: conn, team: team} do
      conn = delete(conn, Routes.team_path(conn, :delete, team))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.team_path(conn, :show, team))
      end
    end
  end

  defp create_team(_) do
    team = fixture(:team)
    {:ok, team: team}
  end
end
