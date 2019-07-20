defmodule TournamentsApiWeb.TournamentTeamStatControllerTest do
  use TournamentsApiWeb.ConnCase

  alias TournamentsApi.Tournaments
  alias TournamentsApi.Organizations
  alias TournamentsApi.Tournaments.TournamentTeamStat

  @create_attrs %{
    value: "some value"
  }
  @update_attrs %{
    value: "some updated value"
  }
  @invalid_attrs %{value: nil}

  def map_tournament_team_id(attrs \\ %{}) do
    {:ok, organization} =
      Organizations.create_organization(%{name: "some organization", slug: "some-slug"})

    tournament_attrs = Map.merge(%{name: "some tournament"}, %{organization_id: organization.id})
    {:ok, tournament} = Tournaments.create_tournament(tournament_attrs)
    tournament_team_attrs = Map.merge(%{name: "some team"}, %{tournament_id: tournament.id})
    {:ok, tournament_team} = Tournaments.create_tournament_team(tournament_team_attrs)

    Map.merge(attrs, %{tournament_team_id: tournament_team.id})
  end

  def fixture(:tournament_team_stat) do
    attrs = map_tournament_team_id(@create_attrs)
    {:ok, tournament_team_stat} = Tournaments.create_tournament_team_stat(attrs)
    tournament_team_stat
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tournament_team_stats", %{conn: conn} do
      conn = get(conn, Routes.tournament_team_stat_path(conn, :index, "tournament-team-id"))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tournament_team_stat" do
    test "renders tournament_team_stat when data is valid", %{conn: conn} do
      attrs = map_tournament_team_id(@create_attrs)

      conn =
        post(conn, Routes.tournament_team_stat_path(conn, :create, attrs.tournament_team_id),
          tournament_team_stat: attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn =
        get(conn, Routes.tournament_team_stat_path(conn, :show, attrs.tournament_team_id, id))

      assert %{
               "id" => id,
               "value" => "some value"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      attrs = map_tournament_team_id(@invalid_attrs)

      conn =
        post(conn, Routes.tournament_team_stat_path(conn, :create, attrs.tournament_team_id),
          tournament_team_stat: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tournament_team_stat" do
    setup [:create_tournament_team_stat]

    test "renders tournament_team_stat when data is valid", %{
      conn: conn,
      tournament_team_stat:
        %TournamentTeamStat{id: id, tournament_team_id: tournament_team_id} = tournament_team_stat
    } do
      conn =
        put(
          conn,
          Routes.tournament_team_stat_path(
            conn,
            :update,
            tournament_team_id,
            tournament_team_stat
          ),
          tournament_team_stat: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.tournament_team_stat_path(conn, :show, tournament_team_id, id))

      assert %{
               "id" => id,
               "value" => "some updated value"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      tournament_team_stat: tournament_team_stat
    } do
      conn =
        put(
          conn,
          Routes.tournament_team_stat_path(
            conn,
            :update,
            tournament_team_stat.tournament_team_id,
            tournament_team_stat
          ),
          tournament_team_stat: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tournament_team_stat" do
    setup [:create_tournament_team_stat]

    test "deletes chosen tournament_team_stat", %{
      conn: conn,
      tournament_team_stat: tournament_team_stat
    } do
      conn =
        delete(
          conn,
          Routes.tournament_team_stat_path(
            conn,
            :delete,
            tournament_team_stat.tournament_team_id,
            tournament_team_stat
          )
        )

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(
          conn,
          Routes.tournament_team_stat_path(
            conn,
            :show,
            tournament_team_stat.tournament_team_id,
            tournament_team_stat
          )
        )
      end
    end
  end

  defp create_tournament_team_stat(_) do
    tournament_team_stat = fixture(:tournament_team_stat)
    {:ok, tournament_team_stat: tournament_team_stat}
  end
end
